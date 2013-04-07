#include <cv.h>
#include <highgui.h>
const int windowSize=2;
//Mat allOnes=Mat::ones(windowSize+1,windowSize+1,CV_32FC1);
using namespace cv;
Mat belongIndex;

Point pts[4];
Point origin;
bool selectObject;
bool hasSelection=false;
Rect selection;
int selectedID;
bool editGrid;
Mat image;

bool hasBelongIndex;
bool isInside(Point &p1,Point &p2,Point &p3,Point &p4,Point &p);

int pixelNum[windowSize*windowSize];
float prob[windowSize*windowSize];


void getDensityBelongIndex(Mat &b_index,Point *p,int splitNum)
{
	int startX,endX,startY,endY;
	startX=startY=10000;
	endX=endY=0;
	for (int i=0;i<4;i++)
	{
		if (startX>p[i].x)
		{
			startX=p[i].x;
		}
		if (startY>p[i].y)
		{
			startY=p[i].y;
		}
		if (endX<p[i].x)
		{
			endX=p[i].x;
		}
		if (endY<p[i].y)
		{
			endY=p[i].y;
		}
	}

	b_index*=0;
	b_index-=-1;

	for (int i=0;i<windowSize*windowSize;i++)
	{
		pixelNum[i]=0;
	}
	for (int i=0;i<b_index.rows;i++)
	{
		for (int j=0;j<b_index.cols;j++)
		{
			if (i<startY||i>endY||j<startX||j>endX)
			{
				b_index.at<float>(i,j)=-1;
			}
			else
			{
				for (int m=0;m<splitNum*splitNum;m++)
				{
					int crow=m/splitNum;int ccol=m%splitNum;
					float cLeft[2],cRight[2],cUp[2],cLow[2];
					float cLeftLow[2],cRightLow[2],cUpRight[2],cLowRight[2];
					//for (int kk=0;kk<2;kk++)
					{
						cLeft[0]=p[0].x+(float)(p[3].x-p[0].x)/splitNum*crow;
						cLeft[1]=p[0].y+(float)(p[3].y-p[0].y)/splitNum*crow;

						cRight[0]=p[1].x+(float)(p[2].x-p[1].x)/splitNum*crow;
						cRight[1]=p[1].y+(float)(p[2].y-p[1].y)/splitNum*crow;

						cLeftLow[0]=p[0].x+(float)(p[3].x-p[0].x)/splitNum*(crow+1);
						cLeftLow[1]=p[0].y+(float)(p[3].y-p[0].y)/splitNum*(crow+1);

						cRightLow[0]=p[1].x+(float)(p[2].x-p[1].x)/splitNum*(crow+1);
						cRightLow[1]=p[1].y+(float)(p[2].y-p[1].y)/splitNum*(crow+1);

						cUp[0]=p[0].x+(float)(p[1].x-p[0].x)/splitNum*ccol;
						cUp[1]=p[0].y+(float)(p[1].y-p[0].y)/splitNum*ccol;

						cLow[0]=p[3].x+(float)(p[2].x-p[3].x)/splitNum*ccol;
						cLow[1]=p[3].y+(float)(p[2].y-p[3].y)/splitNum*ccol;

						cUpRight[0]=p[0].x+(float)(p[1].x-p[0].x)/splitNum*(ccol+1);
						cUpRight[1]=p[0].y+(float)(p[1].y-p[0].y)/splitNum*(ccol+1);

						cLowRight[0]=p[3].x+(float)(p[2].x-p[3].x)/splitNum*(ccol+1);
						cLowRight[1]=p[3].y+(float)(p[2].y-p[3].y)/splitNum*(ccol+1);
					}

					Point p1=Point(cLeft[0]+ccol*(cRight[0]-cLeft[0])/splitNum,cUp[1]+crow*(cLow[1]-cUp[1])/splitNum);
					Point p2=Point(cLeft[0]+(ccol+1)*(cRight[0]-cLeft[0])/splitNum,cUpRight[1]+crow*(cLowRight[1]-cUpRight[1])/splitNum);
					Point p3=Point(cLeftLow[0]+(ccol+1)*(cRightLow[0]-cLeftLow[0])/splitNum,cUpRight[1]+(crow+1)*(cLowRight[1]-cUpRight[1])/splitNum);
					Point p4=Point(cLeftLow[0]+(ccol)*(cRightLow[0]-cLeftLow[0])/splitNum,cUp[1]+(crow+1)*(cLow[1]-cUp[1])/splitNum);

					bool isIn=isInside(p1,p2,p3,p4,Point(j,i));
					if (isIn)
					{
						b_index.at<float>(i,j)=m;
						pixelNum[m]++;
						break;
					}

				}
			}
		}
	}
}



void onMouse( int event, int x, int y, int, void* )
{
	if( selectObject )
	{
		
		selection.x = MIN(x, origin.x);
				selection.y = MIN(y, origin.y);
				selection.width = std::abs(x - origin.x);
				selection.height = std::abs(y - origin.y);

				/*sx.x = selection.x;
				sx.y = selection.y;
				ex.x = selection.x+selection.width-1;
				ex.y = selection.y+selection.height-1;*/

		selection &= Rect(0, 0, image.cols, image.rows);

		pts[0].x=selection.x;
		pts[0].y=selection.y;
		pts[1].x=selection.x+selection.width-1;
		pts[1].y=selection.y;
		pts[2].x=selection.x+selection.width-1;
		pts[2].y=selection.y+selection.height-1;
		pts[3].x=selection.x;
		pts[3].y=selection.y+selection.height-1;

		
	}

	switch( event )
	{
	case CV_EVENT_LBUTTONDOWN:
		origin = Point(x,y);
		selection = Rect(x,y,0,0);
		selectObject = true;
		break;
	case CV_EVENT_LBUTTONUP:
		selectObject = false;
		hasSelection=true;
		/*if( selection.width > 0 && selection.height > 0 )
			trackObject = -1;*/
		break;
	case CV_EVENT_RBUTTONDOWN:
		{
			selectedID=0;
			float dis=100000;
			float cdis;
			for (int i=0;i<4;i++)
			{
				cdis=sqrtf((pts[i].x-x)*(pts[i].x-x)+
					(pts[i].y-y)*(pts[i].y-y));
				if (cdis<dis)
				{
					dis=cdis;
					selectedID=i;
				}
			}
			pts[selectedID]=Point(x,y);
			editGrid=true;
		}
		break;
	case CV_EVENT_MOUSEMOVE:
		if (!selectObject&&editGrid)
		{
			pts[selectedID]=Point(x,y);

		}
		//
		break;
	case CV_EVENT_RBUTTONUP:
		{
			editGrid=false;
			getDensityBelongIndex(belongIndex,pts,windowSize);

			//Mat tmp=image.clone();

			//for (int ll=0;ll<windowSize*windowSize;ll++)
			//{
			//	//tmp*=0;
			//		for (int i=0;i<tmp.rows;i++)
			//		{
			//			for (int j=0;j<tmp.cols;j++)
			//			{
			//				if (belongIndex.at<float>(i,j)==ll)
			//				{
			//					tmp.at<Vec3b>(i,j).val[0]=255;
			//				}
			//			}
			//		}
			//		namedWindow("lala");
			//		imshow("lala",tmp);
			//		waitKey();
			//}
		
		}
	
		break;
	}
}

void drawDotLine(Mat &img,Point p1,Point p2)
{
	LineIterator it(img, p1, p2, 8);            // get a line iterator
	for(int i = 0; i < it.count; i++,it++)
		if ( i%5!=0 ) {(*it)[1] = 255;}  
}

int leftOrRight(Point &p1,Point &p2,Point &p)
{
	float xa=p1.x;
	float xb=p2.x;
	float ya=p1.y;
	float yb=p2.y;
	float xc=p.x;float yc=p.y;

	float f=(xb-xa)*(yc-ya)-(xc-xa)*(yb-ya);

	if (f>0)
	{
		return 1;
	}
	else if (f<0)
	{
		return -1;
	}
	else
		return 0;
}

void checkGrid(Mat &img,Point *p,int splitNum)
{
	for (int m=0;m<splitNum*splitNum;m++)
	{
		int crow=m/splitNum;int ccol=m%splitNum;
		float cLeft[2],cRight[2],cUp[2],cLow[2];
		float cLeftLow[2],cRightLow[2],cUpRight[2],cLowRight[2];
		//for (int kk=0;kk<2;kk++)
		{
			cLeft[0]=p[0].x+(int)(p[3].x-p[0].x)/splitNum*crow;
			cLeft[1]=p[0].y+(int)(p[3].y-p[0].y)/splitNum*crow;

			cRight[0]=p[1].x+(int)(p[2].x-p[1].x)/splitNum*crow;
			cRight[1]=p[1].y+(int)(p[2].y-p[1].y)/splitNum*crow;

			cLeftLow[0]=p[0].x+(int)(p[3].x-p[0].x)/splitNum*(crow+1);
			cLeftLow[1]=p[0].y+(int)(p[3].y-p[0].y)/splitNum*(crow+1);

			cRightLow[0]=p[1].x+(int)(p[2].x-p[1].x)/splitNum*(crow+1);
			cRightLow[1]=p[1].y+(int)(p[2].y-p[1].y)/splitNum*(crow+1);

			cUp[0]=p[0].x+(int)(p[1].x-p[0].x)/splitNum*ccol;
			cUp[1]=p[0].y+(int)(p[1].y-p[0].y)/splitNum*ccol;

			cLow[0]=p[3].x+(int)(p[2].x-p[3].x)/splitNum*ccol;
			cLow[1]=p[3].y+(int)(p[2].y-p[3].y)/splitNum*ccol;

			cUpRight[0]=p[0].x+(int)(p[1].x-p[0].x)/splitNum*(ccol+1);
			cUpRight[1]=p[0].y+(int)(p[1].y-p[0].y)/splitNum*(ccol+1);

			cLowRight[0]=p[3].x+(int)(p[2].x-p[3].x)/splitNum*(ccol+1);
			cLowRight[1]=p[3].y+(int)(p[2].y-p[3].y)/splitNum*(ccol+1);
		}

		Point p1=Point(cLeft[0]+ccol*(cRight[0]-cLeft[0])/splitNum,cUp[1]+crow*(cLow[1]-cUp[1])/splitNum);
		Point p2=Point(cLeft[0]+(ccol+1)*(cRight[0]-cLeft[0])/splitNum,cUpRight[1]+crow*(cLowRight[1]-cUpRight[1])/splitNum);
		Point p3=Point(cLeftLow[0]+(ccol+1)*(cRightLow[0]-cLeftLow[0])/splitNum,cUpRight[1]+(crow+1)*(cLowRight[1]-cUpRight[1])/splitNum);
		Point p4=Point(cLeftLow[0]+(ccol)*(cRightLow[0]-cLeftLow[0])/splitNum,cUp[1]+(crow+1)*(cLow[1]-cUp[1])/splitNum);

		Mat tmp=img.clone();
		//tmp*=0;
		line(tmp,p1,p2,255);line(tmp,p2,p3,255);line(tmp,p3,p4,255);line(tmp,p4,p1,255);

		/*circle(tmp,Point(cLeft[0],cLeft[1]),2,255);
		circle(tmp,Point(cRight[0],cRight[1]),2,255);
		circle(tmp,Point(cLeftLow[0],cLeftLow[1]),2,255);
		circle(tmp,Point(cRightLow[0],cRightLow[1]),2,255);
		circle(tmp,Point(cUp[0],cUp[1]),2,255);
		circle(tmp,Point(cLow[0],cLow[1]),2,255);
		circle(tmp,Point(cUpRight[0],cUpRight[1]),2,255);
		circle(tmp,Point(cLowRight[0],cLowRight[1]),2,255);*/
		namedWindow("curSubWindow");
		imshow("curSubWindow",tmp);
		waitKey();
	}
}

bool isInside(Point &p1,Point &p2,Point &p3,Point &p4,Point &p)
{
	int j1=leftOrRight(p2,p1,p);
	int j2=leftOrRight(p3,p2,p);
	int j3=leftOrRight(p4,p3,p);
	int j4=leftOrRight(p1,p4,p);

	if (j1<=0&&j2<=0&&j3<=0&&j4<=0)
	{
		return 1;
	}
	else
		return 0;
}


void main()
{



//声明IplImage指针  
IplImage* pFrame = NULL;   
IplImage* pFrImg = NULL;  
IplImage* pBkImg = NULL;  
CvMat* pFrameMat = NULL;  
CvMat* pFrMat = NULL;  
CvMat* pBkMat = NULL;  
CvCapture* pCapture = NULL;  
int nFrmNum = 0;  

Mat density;

Mat density_visualization;
//创建窗口  
namedWindow("video");  
setMouseCallback( "video", onMouse, 0 );
cvNamedWindow("background");  
cvNamedWindow("foreground");  
//使窗口有序排列  
cvMoveWindow("video", 30, 0);  
cvMoveWindow("background", 360, 0);  
cvMoveWindow("foreground", 690, 0);  

Scalar lowDensityColor(255,0,0);
Scalar highDeisityColor(0,0,255);
//pCapture = cvCaptureFromAVI("2.avi");   //读入已有视频用此句  
//pCapture = cvCaptureFromCAM(0);           //从摄像头读入视频用此  

VideoCapture cap;
cap.open(0);
while(1)  
{  
	cap>>image;
	IplImage tmp=image;
	pFrame=&tmp;
	nFrmNum++;  
	//如果是第一帧，需要申请内存，并初始化  
	if(nFrmNum == 1)  
	{  
		pBkImg = cvCreateImage(cvSize(pFrame->width, pFrame->height),IPL_DEPTH_8U,1);  
		pFrImg = cvCreateImage(cvSize(pFrame->width, pFrame->height), IPL_DEPTH_8U,1);  
		pBkMat = cvCreateMat(pFrame->height, pFrame->width, CV_32FC1);  
		pFrMat = cvCreateMat(pFrame->height, pFrame->width, CV_32FC1);  
		pFrameMat = cvCreateMat(pFrame->height, pFrame->width, CV_32FC1);
		

		density=Mat::zeros(pFrame->height,pFrame->width,CV_32FC1);
		belongIndex=density.clone();
		density_visualization=Mat::zeros(density.rows,density.cols,CV_8UC3);
		//转化成单通道图像再处理  
		cvCvtColor(pFrame, pBkImg, CV_BGR2GRAY);  
		cvCvtColor(pFrame, pFrImg, CV_BGR2GRAY);  
		cvConvert(pFrImg, pFrameMat);  
		cvConvert(pFrImg, pFrMat);  
		cvConvert(pFrImg, pBkMat);  
	}  
	else  
	{  
		cvCvtColor(pFrame, pFrImg, CV_BGR2GRAY);  
		cvConvert(pFrImg, pFrameMat);  
		//先做高斯滤波，以平滑图像  
		cvSmooth(pFrameMat, pFrameMat, CV_GAUSSIAN, 3, 0, 0);  
		//当前帧跟背景图相减  
		cvAbsDiff(pFrameMat, pBkMat, pFrMat);
		//cvSmooth(pFrMat, pFrMat, CV_GAUSSIAN, 5, 0, 0); 
		//二值化前景图  
		cvThreshold(pFrMat, pFrImg, 10, 255.0, CV_THRESH_BINARY);  
		//更新背景  
		cvRunningAvg(pFrameMat, pBkMat, 0.003, 0);  
		//将背景转化为图像格式，用以显示  
		cvConvert(pBkMat, pBkImg);  
		pFrame->origin = IPL_ORIGIN_BL;  
		pFrImg->origin = IPL_ORIGIN_BL;  
		pBkImg->origin = IPL_ORIGIN_BL;  
		
		//int windowSize=20;
		Mat cdiff=cvarrToMat(pFrImg);
		density*=0;
		density_visualization*=0;

		int WindiwSizeX=cdiff.cols/windowSize;
		int windowSizeY=cdiff.rows/windowSize;
		//filter2D(cdiff,cdiff);
		//for (int i=windowSizeY/2-1;i<density.rows-windowSizeY/2;i+=windowSizeY)
		//{
		//	for (int j=WindiwSizeX/2-1;j<density.cols-WindiwSizeX/2;j+=WindiwSizeX)
		//	{
		//		float tmpProb=0;
		//		for (int k=i-windowSizeY/2+1;k<i+windowSizeY/2;k++)
		//		{
		//			for (int l=j-WindiwSizeX/2+1;l<j+WindiwSizeX/2;l++)
		//			{
		//				tmpProb+=cdiff.at<uchar>(k,l)>0;
		//			}
		//		}
		//		tmpProb/=WindiwSizeX*windowSizeY;

		//	/*	if (i==windowSizeY/2-1||j==WindiwSizeX/2-1)
		//		{
		//			tmpProb=1;
		//		}
		//		else
		//			tmpProb=0;*/

		//		density(Range(i-windowSizeY/2+1,i+windowSizeY/2+1),Range(j-WindiwSizeX/2+1,j+WindiwSizeX/2+1))+=tmpProb;
		//		
		//	}
		//}
		//for (int i=0;i<density_visualization.rows;i++)
		//{
		//	for (int j=0;j<density_visualization.cols;j++)
		//	{
		//		float tProb=density.at<float>(i,j);
		//		density_visualization.at<Vec3b>(i,j).val[0]=tProb*highDeisityColor.val[0]+(1-tProb)*lowDensityColor.val[0];
		//		density_visualization.at<Vec3b>(i,j).val[1]=tProb*highDeisityColor.val[1]+(1-tProb)*lowDensityColor.val[1];
		//		density_visualization.at<Vec3b>(i,j).val[2]=tProb*highDeisityColor.val[2]+(1-tProb)*lowDensityColor.val[2];

		//	}
		//}

		density*=0;
		for (int i=0;i<windowSize*windowSize;i++)
		{
			prob[i]=0;
		}
		//get the prob
		for (int i=0;i<image.rows;i++)
		{
			for (int j=0;j<image.cols;j++)
			{
				int curInd=belongIndex.at<float>(i,j);
				if (curInd!=-1)
				{
					prob[curInd]+=cdiff.at<uchar>(i,j)>0;
				}
			}
		}

		for (int i=0;i<windowSize*windowSize;i++)
		{
			prob[i]/=pixelNum[i];
		}

		for (int i=0;i<density_visualization.rows;i++)
		{
			for (int j=0;j<density_visualization.cols;j++)
			{
				int cind=i/windowSizeY*windowSize+j/WindiwSizeX;
				float tProb=prob[cind];
				density_visualization.at<Vec3b>(i,j).val[0]=tProb*highDeisityColor.val[0]+(1-tProb)*lowDensityColor.val[0];
				density_visualization.at<Vec3b>(i,j).val[1]=tProb*highDeisityColor.val[1]+(1-tProb)*lowDensityColor.val[1];
				density_visualization.at<Vec3b>(i,j).val[2]=tProb*highDeisityColor.val[2]+(1-tProb)*lowDensityColor.val[2];

			}
		}

		
		cvShowImage("foreground", pFrImg);  

		namedWindow("visualization");
		imshow("visualization",density_visualization);
		

		cvCvtColor(pFrame, pBkImg, CV_BGR2GRAY);  
		cvCvtColor(pFrame, pFrImg, CV_BGR2GRAY);  
		cvConvert(pFrImg, pFrameMat);  
		cvConvert(pFrImg, pFrMat);  
		cvConvert(pFrImg, pBkMat); 

		Mat showImg=image;
		if(hasSelection)
		{
			//rectangle(showImg,selection,Scalar(0,255,0));
			line(showImg,pts[0],pts[1],Scalar(0,255,0),2,CV_AA);
			line(showImg,pts[1],pts[2],Scalar(0,255,0),2,CV_AA);
			line(showImg,pts[2],pts[3],Scalar(0,255,0),2,CV_AA);
			line(showImg,pts[3],pts[0],Scalar(0,255,0),2,CV_AA);
			Point stepXU=(pts[1]-pts[0]);Point stepXL=(pts[2]-pts[3]);
			Point stepYR=(pts[2]-pts[1]);Point stepYL=(pts[3]-pts[0]);
	/*		float xDevide=showImg.cols/windowSize;
			float yDevide=showImg.rows/windowSize*/
			stepXU.x=(float)stepXU.x/windowSize;stepXU.y=(float)stepXU.y/windowSize;
			stepXL.x=(float)stepXL.x/windowSize;stepXL.y=(float)stepXL.y/windowSize;
			stepYR.x=(float)stepYR.x/windowSize;stepYR.y=(float)stepYR.y/windowSize;
			stepYL.x=(float)stepYL.x/windowSize;stepYL.y=(float)stepYL.y/windowSize;
			for (int k=1;k<windowSize;k++)
			{
				line(showImg,Point(pts[0].x+k*stepXU.x,pts[0].y+k*stepXU.y),Point(pts[3].x+k*stepXL.x,pts[3].y+k*stepXL.y),Scalar(0,255,0),1,CV_AA);
				line(showImg,Point(pts[0].x+k*stepYL.x,pts[0].y+k*stepYL.y),Point(pts[1].x+k*stepYR.x,pts[1].y+k*stepYR.y),Scalar(0,255,0),1,CV_AA);
			}

			//getDensityBelongIndex(belongIndex,pts,windowSize);
		
			
		}
			
		imshow("video", showImg);  
		//cvShowImage("background", pBkImg);  
		
		//如果有按键事件，则跳出循环  
		//此等待也为cvShowImage函数提供时间完成显示  
		//等待时间可以根据CPU速度调整  
		if( cvWaitKey(2) >= 0 )  
			break;  
	}  
}  
//销毁窗口  
cvDestroyWindow("video");  
cvDestroyWindow("background");  
cvDestroyWindow("foreground");  
//释放图像和矩阵  
cvReleaseImage(&pFrImg);  
cvReleaseImage(&pBkImg);  
cvReleaseMat(&pFrameMat);  
cvReleaseMat(&pFrMat);  
cvReleaseMat(&pBkMat);  
cvReleaseCapture(&pCapture);  

}
