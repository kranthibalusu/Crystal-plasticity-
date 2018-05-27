% grain detection 
%grain detection SLWI and EBSD


%% path to files
%filtered SWLi data
fname = 'C:\Users\kxb3553\Dropbox\PhD_stuff\2018 results & code\ProfileAnalysisV2';
% 
% % EBSD files to be imported
fnameall = [fname '\BasesFlatReg.mat'];
load(fnameall)

%extract orienation data 
fnameOris = [fname '\oris1.xlsx'];
oriData = xlsread(fnameOris);
oriDataFilt=[];
sizeCutoff = 0; 

for i=1:size(oriData,1)
    if oriData(i,8)>sizeCutoff
        oriDataFilt=[oriDataFilt;oriData(i,5:7)];
    end
end


%% plto data from SWLi 

%70 figure 
fig70=figure;
clims=[-7,7];
SWLI1=B70FlatReg(253:1453,72:790);
imagesc(SWLI1,clims)
hold on
% scatter(markers(:,1),markers(:,2))% actually for the streched image below 
axis image
hold off
size1 = 5 ; %pixels per micrometer

%% import outline B70 
outlineName = [fname '\FinalFigures\Outline1.png'];
outline=imread(outlineName);
outlineBW = im2bw(outline(:,:,3),0.5); %extract the grain outline 

% final outline of the SWLi figure 
outlineBin = bwlabel(outlineBW);
%labels for each closed figure
s = regionprops(outlineBin,'centroid');
pixels = regionprops(outlineBin,'PixelList');
areas=regionprops(outlineBin,'Area');
areasA= cat(1, areas.Area);
centroids = cat(1, s.Centroid);
noOfGrains=size(areasA,1);

%% plot and save the grain outlines with their labels 
figOutline=figure;
image(outlineBin)
hold on
for i=1:size(centroids,1)
text(centroids(i,1),centroids(i,2), num2str(i))
plot(centroids(i,1),centroids(i,2),'-s') 
end
axis image
hold off
saveas(figOutline,[fname,'\figOutline1.png'])
saveas(figOutline,[fname,'\figOutline1.fig'])

%% interpose images
% matach the size of SLWI to outlineBW/outlineBin

%streching 

outsize1=size(outlineBW,1);
outsize2=size(outlineBW,2);

% area missed out in the SWLI image 
extraX=600;
extraY=34;
sy=outsize1+extraY;
sx=outsize2+extraX;

% profile scaled to be used for data now 
profile1Scaled=imresize(SWLI1,[sy,sx]);
%size in teh streched figure 
size1 = 5 ; %pixels per micrometer(approx)
areasAinMm = areasA/(size1^2);

outlined1Frame=ones(sy,sx);
outlined1Frame((extraY+1):sy,(extraX+1):sx)=outlineBW;


% FOR PLOTTING boundaries and profile
outlined1Frame2(:,:)=abs((outlined1Frame(:,:)-1)*20);
Myinter=outlined1Frame2+profile1Scaled;
% 
% intepolate and show 
figInter0=figure;
hold on 
clims=[-5,5];
imagesc(Myinter,clims);
axis image
saveas(figInter0,[fname,'\figInter1.png'])
hold off 
% 
%{
%% filtering to remove noise 
mean(profile1Scaled(:));
std(profile1Scaled(:));

profile1Filter = wiener2(profile1Scaled,[5 5]);

profile1Filter = medfilt2(profile1Scaled);

% [profile1Filter]=kraFilt(profile1Scaled,5);
imagesc(profile1Filter,[-25,-10]);

% my own filter 

% histogram(profile1Scaled)
%}
%% extract just the grains and find ave height
for i=1:noOfGrains
    pixeli=pixels(i).PixelList;
    Frame2=zeros(sy,sx);
    max=-10000;
    min=10000;
    for j=1:size(pixeli,1)
        d1=(pixeli(j,2)+sy-outsize1);
        d2=(pixeli(j,1)+sx-outsize2);
        Frame2(d1,d2)=1;
        if profile1Scaled(d1,d2)~=0
        if profile1Scaled(d1,d2)<min
            min=profile1Scaled(d1,d2);   
            pointmin=[d1,d2];
        end
        if profile1Scaled(d1,d2)>max
            max=profile1Scaled(d1,d2); 
            pointmax=[d1,d2];
        end        
        end
    end
%     sizeGr(i)=size(pixeli,1);
    distminMax(i)=norm(pointmax-pointmin);
    pointmaxA(i,1:2)=pointmax;
    pointminA(i,1:2)=pointmin;
    Rt(i)=max-min;
    HeightAve(i)=sum(sum(Frame2.*profile1Scaled))/size(pixeli,1);
    Rrms(i)=sqrt(sum(sum((Frame2.*profile1Scaled).^2))/size(pixeli,1));
    grainData=Frame2.*profile1Scaled;
end

%% figure of grains and boundaries and some of the profile parameters 
figOutline2=figure;
imagesc(Myinter,clims);
hold on
for i=1:size(centroids,1)
    if areas(i).Area>10
        x=(centroids(i,1)+sx-outsize2);
        y=(centroids(i,2)+sy-outsize1);
        text(x,y, ['Gr', num2str(i),':',num2str(HeightAve(i))])
%           text((x),(y), ['No.:',num2str(i)],'FontSize',14,'FontName','Times New Roman')
%           ,',Ave.H:',num2str(HeightAve(i))
%         plot(pointmaxA(i,2),pointmaxA(i,1),'-d') 
%         plot(pointminA(i,2),pointminA(i,1),'-p') 
        % a line connecting min and max 
%         plot([pointmaxA(i,2),pointminA(i,2)],[pointmaxA(i,1),pointminA(i,1)])
%         plot(x,y,'-s') 
    end
end
axis image
% saveas(figOutline2,[fname,'\figHeightsInter1.png'])
saveas(figOutline2,[fname,'\figHeightsInter1.fig'])
% num2str(HeightAve(i)),'-'
hold off

%% profile analysis 




%% Neighborhood detection 

RorS=zeros(size(centroids,1),1);
Niegh=zeros(size(centroids,1),1);
stdGrHt = std(HeightAve);
riseNo = 0;
sinkNo = 0;
%extract just the grains
for i=1:size(centroids,1)
    pixeli=pixels(i).PixelList;
    centroidi= s(i).Centroid;
    dia=sqrt(areas(i).Area);
    Frame2=zeros(sy,sx);
    y1=centroidi(2)+sy-outsize1-1.5*dia;
    if y1<1
        y1=1;
    end
    x1=centroidi(1)+sx-outsize2-1.5*dia;
    if x1<1
        x1=1;
    end    
    y2=centroidi(2)+sy-outsize1+1.5*dia;
    if y2>sy
        y2=sy;
    end       
    x2=centroidi(1)+sx-outsize2+1.5*dia;    
    if x2>sx
        x2=sx;
    end       
    Frame2(y1:y2,x1:x2)=1;
    enclArea=(y2-y1)*(x2-x1);
    Niegh(i)=sum(sum(Frame2.*profile1Scaled))/enclArea;
    if Niegh(i)>(stdGrHt + HeightAve(i))
        RorS(i)=-1;
        sinkNo = sinkNo+1;
    end
    if Niegh(i)<(- stdGrHt + HeightAve(i))
        RorS(i)=1;
        riseNo = riseNo+1;
    end

end



%% other analysis

%% figure of grains and boundaries and some of the profile parameters 
figOutline3=figure;
imagesc(Myinter,clims);
hold on
for i=1:size(centroids,1)
    if areas(i).Area>10
        x=(centroids(i,1)+sx-outsize2);
        y=(centroids(i,2)+sy-outsize1);
        
        if RorS(i)==1
            text(x,y+10,'Rise')
            text(x,y, ['Gr', num2str(i),':',num2str(HeightAve(i))])
        end 
        if RorS(i)==-1
            text(x,y+10,'Sink')
            text(x,y, ['Gr', num2str(i),':',num2str(HeightAve(i))])
        end         

    end
end
axis image
% saveas(figOutline2,[fname,'\figHeightsInter1.png'])
saveas(figOutline3,[fname,'\figHeightsInter2.fig'])
% num2str(HeightAve(i)),'-'
hold off

diff = Niegh - HeightAve';


%% plot the Rising and sinking behavior on the IPF 
[plotnameFig] = IPFRDPlot(oriDataFilt,RorS); 

