function testKNN(direct,indirect,both,windowSize)
indInd=[1:20];
% indInd=[3 5 6:12];
% indInd=[6]; %3 4 5 9
%indInd=[3 ];
% indInd=6;

ind=[];
for i=1:length(indInd)
    ind=[ind (indInd(i)-1)*3+5:(indInd(i))*3+4];
end


% %centerlize
tmpC=repmat(direct(:,6:8),1,length(indInd));
direct(:,ind)=direct(:,ind)-tmpC;
% 
 tmpC=repmat(indirect(:,6:8),1,length(indInd));
indirect(:,ind)=indirect(:,ind)-tmpC;
% 
tmpC=repmat(both(:,6:8),1,length(indInd));
both(:,ind)=both(:,ind)-tmpC;
% 
dt=generateTimeSeries(direct(:,ind),windowSize);
indt=generateTimeSeries(indirect(:,ind),windowSize);

botht=generateTimeSeries(both(:,ind),windowSize);

tmp=botht;
for i=1:size(tmp,1)
    dis1=calculateDis(tmp(i,:),dt);
    dis2=calculateDis(tmp(i,:),indt);
    
    tmin1=min(dis1);
    tmin2=min(dis2);
    
%        [tmin1 tmin2 tmin2/(tmin1+tmin2)]
    prob=tmin2/(tmin1+tmin2)*5-2;
    if prob<0
        prob=0;
    elseif prob>1
        prob=1;
    end
 
% %     min(dis1)+min(dis2)
%     pause
    result(i)=prob;
end

figure
plot(result)

function z=generateTimeSeries(data,windowSize)
z=[];





for i=1:windowSize
    z=[z data([i:end 1:i-1],:)];
end

z=z(1:end-windowSize,:);

% %centrolize
% for i=1:size(data,2)
%     tmp(:,i)=mean(z(:,i:size(data,2):end),2);
% end
% tmp=repmat(tmp,1,windowSize);
% z=z-tmp;

function dis=calculateDis(x,data)
xnew=repmat(x,size(data,1),1);
cdif=xnew-data;

dis=sqrt(sum(cdif.*cdif,2));