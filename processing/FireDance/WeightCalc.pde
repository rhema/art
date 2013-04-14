//import Math;
void setupWeight()
{
  weight=new Vector<Float>();
  for(int i=0;i<windowSize*windowSize*4;i++)
  {
    weight.add(new Float(0));
  }
  Float e=2.7183;
 //w=e(-x^2/2/sigma^2),where sigma=2
  for(int i=0;i<windowSize*2-1;i++)
  {
    for(int j=0;j<windowSize*2-1;j++)
    {
      Float distanceSquare=(float)(i-windowSize)*(i-windowSize)+(j-windowSize)*(j-windowSize);
      weight.set(i*windowSize*2+j,pow(e,(-distanceSquare/8)));
    }
  }
  crowdSquares_added = new Vector<Float>();
  for(int i=0;i<windowSize*windowSize;i++)
  {
    crowdSquares_added.add(new Float(0));
  }
}

void calculateWeight()
{
  int curI,curJ;
  for(int i=0;i<windowSize*windowSize;i++)
  {
    curI=i/windowSize;
    curJ=i%windowSize;
    Float curSum=0.0;
//  Float curWeight;
//  curWeight=crowdSquares.get(i);
  
   // if(curWeight>0)
    {
     for(int j=0;j<windowSize;j++)
     {
       for(int k=0;k<windowSize;k++)
       {
        curSum=curSum+weight.get((windowSize+j-curI)*windowSize*2+windowSize+k-curJ)*crowdSquares.get(j*windowSize+k);
       // crowdSquares_added.set(j*windowSize+k,crowdSquares_added.get(j*windowSize+k))
         
      
        //curSum=curSum+weight.get(2);
        // Float curWeight=;//[windowSize+j-curI][windowSize+k-curJ];
        // crowdSquares_added.set(i,crowdSquares.get(i)*weight.get((windowSize+j-curI)*windowSize*2+windowSize+k-curJ));
         
       }
     }
       // String message = "The value of w is: " + curSum;
       // println(message);
    }
      crowdSquares_added.set(i,curSum);
  }
}

