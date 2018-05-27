% grain detection for loading 2 
%grain detection SLWI and EBSD


%% path to files
%filtered
fname = 'C:\Users\kxb3553\Dropbox\PhD_stuff\2018 results & code\ProfileAnalysisV2';
fnameall = [fname '\BasesFlatReg.mat'];
load(fnameall)

%extract orienation data 
%base data in profile 1 
fnameOris = [fname '\oris1.xlsx'];
oriData = xlsread(fnameOris);
oriDataBase=[];
sizeCutoff = 0; 

for i=1:size(oriData,1)
    if oriData(i,8)>sizeCutoff
        oriDataBase=[oriDataBase;oriData(i,5:7)];
    end
end
%extract indices 
fnameLinks = [fname '\oriLinks.xlsx'];
linksData = xlsread(fnameLinks,'Prof2toProf1');
oriDataFilt = zeros(size(linksData,1),3);

for i=1:size(linksData,1)
    oriDataFilt(i,1:3)= oriDataBase(linksData(i,3),1:3);
end

idSet2 = linksData(:,3); % CONVERSION FROM SET2 IDS TO SET 1    
%% plot data from SWLi 

%70 figure 
clims=[-10,7];
% imagesc(B80Flat,clims)
% axis image

% color image 
SWLI2=B80Flat(201:1407,58:1002);
fig80=figure;
imagesc(SWLI2,clims)
hold on
axis image
hold off
size1 = 5 ; %pixels per micrometer

%BW image 
SWLI2BW = mat2gray(SWLI2,clims); 
figure
imshow(SWLI2BW)
axis image


%% export outline B70 
outlineName = [fname '\outline2.png'];
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
saveas(figOutline,[fname,'\figOutline2.png'])
saveas(figOutline,[fname,'\figOutline2.fig'])


%% interpose images
% matach the size of SLWI to outlineBW/outlineBin

%streching 

outsize1=size(outlineBW,1);
outsize2=size(outlineBW,2);

% area missed out in the SWLI image 
extraX1=139;
extraY1=61;
% area missed out on the other side
extraX2=203;
extraY2=0;
sy=outsize1+extraY1+extraY2;
sx=outsize2+extraX1+extraX2;
x2 = (size(SWLI2,2)-extraX2);
SWLI2Crop=SWLI2(extraY1:end ,extraX1:x2);

% profile scaled to be used for data now 
profile1Scaled=imresize(SWLI2Crop,[outsize1,outsize2]);
%size in teh streched figure 
size1 = 5 ; %pixels per micrometer(approx)
areasAinMm = areasA/(size1^2);

outlined1Frame=outlineBW;


% FOR PLOTTING boundaries and profile
outlined1Frame2(:,:)=abs((outlined1Frame(:,:)-1)*20);
Myinter=outlined1Frame2+profile1Scaled;
% 
% intepolate and show 
figInter0=figure;
hold on 
imagesc(Myinter,clims);
axis image
saveas(figInter0,[fname,'\figInter2.png'])
saveas(figInter0,[fname,'\figInter2.fig'])
hold off 
%% extract just the grains and find ave height
for i=1:noOfGrains
    pixeli=pixels(i).PixelList;
    clear max
    max(pixeli(:,2));
    max(pixeli(:,1)) ;  
    Frame2=zeros(outsize1,outsize2);
    maxP=-10000;
    minP=10000;
    for j=1:size(pixeli,1)
        d1=(pixeli(j,2));
        d2=(pixeli(j,1));
        Frame2(d1,d2)=1;
        if profile1Scaled(d1,d2)~=0
        if profile1Scaled(d1,d2)<minP
            minP=profile1Scaled(d1,d2);   
            pointmin=[d1,d2];
        end
        if profile1Scaled(d1,d2)>maxP
            maxP=profile1Scaled(d1,d2); 
            pointmax=[d1,d2];
        end        
        end
    end
%     sizeGr(i)=size(pixeli,1);
    distminMax(i)=norm(pointmax-pointmin);
    pointmaxA(i,1:2)=pointmax;
    pointminA(i,1:2)=pointmin;
    Rt(i)=maxP-minP;
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
        x=(centroids(i,1));
        y=(centroids(i,2));
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
saveas(figOutline2,[fname,'\figHeightsInter2.fig'])
% num2str(HeightAve(i)),'-'
hold off

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
    Frame2=zeros(outsize1,outsize2);
    y1=centroidi(2)-1.5*dia;
    if y1<1
        y1=1;
    end
    x1=centroidi(1)-1.5*dia;
    if x1<1
        x1=1;
    end    
    y2=centroidi(2)+1.5*dia;
    if y2>outsize1
        y2=outsize1;
    end       
    x2=centroidi(1)+1.5*dia;    
    if x2>outsize2
        x2=outsize2;
    end    
    enclArea=(y2-y1)*(x2-x1);
    y1=round(y1);
    x1=round(x1);
    y2=round(y2);
    x2=round(x2);
    Frame2(y1:y2,x1:x2)=1; 
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

%% figure of grains and boundaries and some of the profile parameters 
figOutline3=figure;
imagesc(Myinter,clims);
hold on
for i=1:size(centroids,1)
    if areas(i).Area>10
        x=(centroids(i,1));
        y=(centroids(i,2));
        
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
saveas(figOutline3,[fname,'\figHeightsInter3.fig'])
% num2str(HeightAve(i)),'-'
hold off

diff = Niegh - HeightAve';

%% plot the Rising and sinking behavior on the IPF 
[plotnameFig] = IPFRDPlot(oriDataFilt,RorS,idSet2); 