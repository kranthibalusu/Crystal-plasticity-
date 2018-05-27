% grain detection for loading 3
%grain detection from SLWI and EBSD
%and analysis


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
linksData = xlsread(fnameLinks,'Prof3toProf1');
oriDataFilt = zeros(size(linksData,1),3);

for i=1:size(linksData,1)
    oriDataFilt(i,1:3)= oriDataBase(linksData(i,3),1:3);
end

idSet3 = linksData(:,3); % CONVERSION FROM SET2 IDS TO SET 1    
%% plot data from SWLi 

%120 figure 

fig120=figure;
clims=[-25,25];
% color image 
SWLI3=B120FlatReg(354:1447,194:807);
imagesc(SWLI3,clims)
hold on
axis image
hold off
size1 = 5 ; %pixels per micrometer

%BW image 
SWLI3BW = mat2gray(SWLI3,clims); 
figure
imshow(SWLI3BW)
axis image


%% export outline B70 
outlineName = [fname '\outline3.png'];
outline=imread(outlineName);
outlineBW = im2bw(outline(:,:,3),0.5); %extract the grain outline 

% final outline of the SWLi figure 
outlineBin = bwlabel(outlineBW);
%labels for each closed figure
s = regionprops(outlineBin,'centroid');
pixels = regionprops(outlineBin,'PixelList');
areas=regionprops(outlineBin,'Area');
areasA= cat(1, areas.Area);
solidPara=regionprops(outlineBin,'Solidity');
solidParas= cat(1,solidPara.Solidity);
centroids = cat(1, s.Centroid);
noOfGrains=size(areasA,1);
[bounds] = bwboundaries(outlineBW); %extract locatiojn of the grains edges 


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
saveas(figOutline,[fname,'\figOutline3.png'])
saveas(figOutline,[fname,'\figOutline3.fig'])


%% interpose images
% matach the size of SLWI to outlineBW/outlineBin

%streching 

outsize1=size(outlineBW,1);
outsize2=size(outlineBW,2);

%no cropping at all 
SWLI3Crop=SWLI3;

% profile scaled to be used for data now 
profile3Scaled=imresize(SWLI3Crop,[outsize1,outsize2]);
%size in teh streched figure 
size1 = 5 ; %pixels per micrometer(approx)
areasAinMm = areasA/(size1^2);

outlined3Frame=outlineBW;


% FOR PLOTTING boundaries and profile
outlined3Frame2(:,:)=abs((outlined3Frame(:,:)-1)*20);
Myinter=outlined3Frame2+profile3Scaled;
% 
% intepolate and show 
figInter0=figure;
hold on 
imagesc(Myinter,clims);
axis image
saveas(figInter0,[fname,'\figInter3.png'])
saveas(figInter0,[fname,'\figInter3.fig'])
hold off 
%% extract just the grains and find ave height
%setup parameters 
distminMax = zeros(noOfGrains,1);
Rt = zeros(noOfGrains,1);
HeightAve = zeros(noOfGrains,1);
Rrms = zeros(noOfGrains,1);
periHeightAve = zeros(noOfGrains,1);
pointmaxA = zeros(noOfGrains,2);
pointminA = zeros(noOfGrains,2);

for i=1:noOfGrains
    pixeli=pixels(i).PixelList;
    clear max
    max(pixeli(:,2));
    max(pixeli(:,1)) ;  
    Frame2=zeros(outsize1,outsize2);
    Frame4 = zeros(outsize1,outsize2);
    maxP=-10000;
    minP=10000;
    for j=1:size(pixeli,1)
        d1=(pixeli(j,2));
        d2=(pixeli(j,1));
        Frame2(d1,d2)=1;
        if profile3Scaled(d1,d2)~=0
        if profile3Scaled(d1,d2)<minP
            minP=profile3Scaled(d1,d2);   
            pointmin=[d1,d2];
        end
        if profile3Scaled(d1,d2)>maxP
            maxP=profile3Scaled(d1,d2); 
            pointmax=[d1,d2];
        end        
        end
    end
%     sizeGr(i)=size(pixeli,1);
    distminMax(i)=norm(pointmax-pointmin);
    pointmaxA(i,1:2)=pointmax;
    pointminA(i,1:2)=pointmin;
    Rt(i)=maxP-minP;
    HeightAve(i)=sum(sum(Frame2.*profile3Scaled))/size(pixeli,1);
    Rrms(i)=sqrt(sum(sum((Frame2.*profile3Scaled).^2))/size(pixeli,1));
    grainData=Frame2.*profile3Scaled;
    
    %determining average hieght of the boundaries of the grain 
    boundsitemp = bounds(i);
    boundsi= boundsitemp{1};
    iR = boundsi(:,1);
    iC = boundsi(:,2);
    % pad the perimeter 
    % pad each pixel by 3x3 
    iR1=iR - 1;
    iC1=iC - 1;
    
    iR2=iR - 1;
    iC2=iC;
    
    iR3=iR - 1;
    iC3=iC + 1;
    
    iR4=iR;
    iC4=iC + 1;
    
    iR5=iR + 1;
    iC5=iC + 1;
    
    iR6=iR + 1;
    iC6=iC;
    
    iR7=iR + 1;
    iC7=iC - 1;
    
    iR8=iR;
    iC8=iC - 1;
    
    iRT = [iR;iR1;iR2;iR3;iR4;iR5;iR6;iR7;iR8];
    iCT = [iC;iC1;iC2;iC3;iC4;iC5;iC6;iC7;iC8];
    
    wrongId = find((iRT>outsize1)| (iRT<1) ); 
    iRT(wrongId) = [];
    iCT(wrongId) = [];
    wrongId = find((iCT>outsize2)| (iCT<1) ); 
    iRT(wrongId) = [];
    iCT(wrongId) = [];

    Index=sub2ind(size(Frame4),iRT,iCT);
    IndexU = unique(Index);

    periL = size(IndexU,1);
    Frame4(IndexU) = 1;
    periHeightAve(i) = sum(sum(Frame4.*profile3Scaled))/periL;
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
% 
% RorS=zeros(size(centroids,1),1);
% Niegh=zeros(size(centroids,1),1);
% stdGrHt = 0.1*std(HeightAve);
% riseNo = 0;
% sinkNo = 0;
% %extract just the grains
% for i=1:size(centroids,1)
% % for i=2
%     pixeli=pixels(i).PixelList;
%     centroidi= s(i).Centroid;
%     dia=sqrt(areas(i).Area);
%     Frame2=zeros(outsize1,outsize2);
%     y1=centroidi(2)-1.5*dia;
%     if y1<1
%         y1=1;
%     end
%     x1=centroidi(1)-1.5*dia;
%     if x1<1
%         x1=1;
%     end    
%     y2=centroidi(2)+1.5*dia;
%     if y2>outsize1
%         y2=outsize1;
%     end       
%     x2=centroidi(1)+1.5*dia;    
%     if x2>outsize2
%         x2=outsize2;
%     end    
%     enclArea=(y2-y1)*(x2-x1);
%     y1=round(y1);
%     x1=round(x1);
%     y2=round(y2);
%     x2=round(x2);
%     Frame2(y1:y2,x1:x2)=1; 
%     Niegh(i)=sum(sum(Frame2.*profile3Scaled))/enclArea;
%     if Niegh(i)>(stdGrHt + HeightAve(i))
%         RorS(i)=-1;
%         sinkNo = sinkNo+1;
%     end
%     if Niegh(i)<(- stdGrHt + HeightAve(i))
%         RorS(i)=1;
%         riseNo = riseNo+1;
%     end
% 
% end

%% other analysis 
%1) some area around the center of the grain 
nearCent = zeros(size(centroids,1),1);
enclArea = zeros(size(centroids,1),1);
RorS=zeros(size(centroids,1),1);
areaCutoff = 20000;
frameRad = 0.1; %frame around the centroid
stdGrHt = 0.2*std(HeightAve);
sinkNo = 0; 
riseNo = 0; 
%extract data for each grain
for i=1:size(centroids,1)
% for i=2
if areasA(i)>areaCutoff
    pixeli=pixels(i).PixelList;
    centroidi= s(i).Centroid;
    dia=sqrt(areas(i).Area);
    Frame2=zeros(outsize1,outsize2);
    
    y1=centroidi(2)-frameRad*dia;
    if y1<1
        y1=1;
    end
    x1=centroidi(1)-frameRad*dia;
    if x1<1
        x1=1;
    end    
    y2=centroidi(2)+frameRad*dia;
    if y2>outsize1
        y2=outsize1;
    end       
    x2=centroidi(1)+frameRad*dia;    
    if x2>outsize2
        x2=outsize2;
    end    
    enclArea(i)=(y2-y1)*(x2-x1); 
    y1=round(y1);
    x1=round(x1);
    y2=round(y2);
    x2=round(x2);
    Frame2(y1:y2,x1:x2)=1; 
    nearCent(i)=(sum(sum(Frame2.*profile3Scaled)))/enclArea(i);
    if nearCent(i)<(- stdGrHt + HeightAve(i))
        RorS(i)=-1;
        sinkNo = sinkNo+1;
    end
    if nearCent(i)>(stdGrHt + HeightAve(i))
        RorS(i)=1;
        riseNo = riseNo+1;
    end
end
end

%% figure of grains and boundaries and some of the profile parameters 
figOutline3=figure;
Myinter2 = Myinter + 20*Frame2; 
imagesc(Myinter2,clims);
hold on
for i=1:size(centroids,1)
% for i=2
    if areas(i).Area>10
        x=(centroids(i,1));
        y=(centroids(i,2));
        
        if RorS(i)==1
%             text(x,y+10,'Rise')
            text(x,y, ['Gr', num2str(i),':',num2str(HeightAve(i))])
        end 
        if RorS(i)==-1
%             text(x,y+10,'Sink')
            text(x,y, ['Gr', num2str(i),':',num2str(HeightAve(i))])
        end         

    end
end
axis image
% saveas(figOutline2,[fname,'\figHeightsInter1.png'])
saveas(figOutline3,[fname,'\figHeightsInter3.fig'])
% num2str(HeightAve(i)),'-'
hold off

diff = abs(nearCent - HeightAve);

%% plot the Rising and sinking behavior on the IPF 
;
[plotnameFig] = IPFRDPlot(oriDataFilt,RorS,idSet3); 