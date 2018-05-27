%rising falling classification from simulation height 

%extract simualtion height data 
fname = 'C:\Users\kxb3553\Dropbox\PhD_stuff\2018 results & code\ProfileAnalysisV2';
fnameSheet = [fname '\FilesFromV1\MyDiscrep2.xlsx'];
simuData = xlsread(fnameSheet);
simuIds = simuData(:,1); 


%extract links between profv1 IDS and prof1 V2 ids 
fnamelinks = [fname '\oriLinks.xlsx'];
linksData = xlsread(fnamelinks,'Prof1toV1');
noGrs = size(linksData,1); 
linksData3to1 = xlsread(fnamelinks,'Prof3toProf1');


%height data ids idprof1 
heightsSimu = zeros(noGrs,1); 

for iGr = 1: noGrs
   idV1 =  linksData(iGr, 2);
   if idV1 ~= 0 
       loc = find(simuIds == idV1);
       if isempty(loc) 
       else
           heightsSimu(iGr) = simuData(loc, 6); 
       end
   end
end

% extrac pixels of each grain from Prof1 
%prof 1 
%areas
fnameall = [fname '\areasProf1.mat'];
load(fnameall)
areasProf1 = areasA; 
%centroids 
fnameall = [fname '\centroidsProf1.mat'];
load(fnameall)
centroidsProf1 = centroids; 
%pixels 
fnameall = [fname '\prof1Pixels.mat'];
load(fnameall)
pixelsProf1 = pixels; 
%outline 
fnameall = [fname '\grOutlineProf1.mat'];
load(fnameall)
outline1 = outlineBin; 
[frameD1,frameD2]= size(outline1); 

%% put the height data in to the frame from prof1 
simuFrame = zeros(frameD1,frameD2);
idOris = 0; 
for iGr = 1:noGrs
    if heightsSimu(iGr)~= 0
        pixeli=pixelsProf1(iGr).PixelList;
        iR = pixeli(:,2);
        iC = pixeli(:,1);
        Index=sub2ind(size(simuFrame),iR,iC);
        simuFrame(Index) = heightsSimu(iGr);
        idOris = idOris +1; 
    end
end

%% Nieghborhood analysis for simulated grain heights 
RorS=zeros(size(centroids,1),1);
RorS2=zeros(size(centroids,1),1);
Niegh=zeros(size(centroids,1),1);
stdGrHt = 0.2*std(heightsSimu);
riseNo = 0;
sinkNo = 0;
%extract just the grains
for i=1:noGrs
% for i=2    
    if heightsSimu(i)~= 0
        pixeli=pixels(i).PixelList;
        
        %create a bounding area around the grain
        centroidi= centroidsProf1(i,:);
        dia=sqrt(areasProf1(i));
        y1=centroidi(2)-1.5*dia;
        if y1<1
            y1=1;
        end
        x1=centroidi(1)-1.5*dia;
        if x1<1
            x1=1;
        end
        y2=centroidi(2)+1.5*dia;
        if y2>frameD1
            y2=frameD1;
        end
        x2=centroidi(1)+1.5*dia;
        if x2>frameD2
            x2=frameD2;
        end
 
        enclArea=(y2-y1)*(x2-x1);
        y1=round(y1);
        x1=round(x1);
        y2=round(y2);
        x2=round(x2);
        totPix = (y2-y1+1)*(x2-x1+1);
        mat = zeros(totPix,2);
        iy = (y1:y2);
        ix = (x1:x2)';
        

        B = repmat(iy,1,(x2-x1+1));
        
        idX = zeros(totPix,1);
        idY = zeros(totPix,1);
        
        idX(:) = (B(:,:));
        
        B = repmat(ix,1,(y2-y1+1));
        idY(:) = (B(:,:))';   
        
        i
        IndexGr=sub2ind(size(simuFrame),idX,idY);
        neighFrame = simuFrame(IndexGr); 
        
        zeroIds = find(neighFrame == 0);
        nonZerosNo = totPix - size(zeroIds,1);
        
        Niegh(i)=sum(sum(neighFrame))/nonZerosNo;
        
        if Niegh(i)>(stdGrHt + heightsSimu(i))
            RorS(i)=-1;
            sinkNo = sinkNo+1;
        end
        if Niegh(i)<(- stdGrHt + heightsSimu(i))
            RorS(i)=1;
            riseNo = riseNo+1;
        end
        
        if heightsSimu(i)<0 
            RorS2(i)=-1;
        end
        if heightsSimu(i)>0 
            RorS2(i)=1;
        end        
    end
end

frameTest=zeros(frameD1,frameD2);
frameTest(IndexGr)=20; 
frame = simuFrame + frameTest; 
RorSSimu=RorS;

RorSSimu2=RorS2;


%% convert RS from profile3 data into profile1 data 
fnameall = [fname '\RSProf3.mat'];
load(fnameall)
RorSProf3 = RorS; 
RorSProf3to1 = zeros(noGrs,1); 
linksData3 = linksData3to1(:,3);

for iGr=1:noGrs
    Id=find(linksData3==iGr);
    if Id~=0
        RorSProf3to1(iGr)= RorSProf3(Id(1));
    end
end



fnameOris = [fname '\oris1.xlsx'];
oriData = xlsread(fnameOris);
oriDataBase=[];
sizeCutoff = 0; 

for i=1:size(oriData,1)
    if oriData(i,8)>sizeCutoff
        oriDataBase=[oriDataBase;oriData(i,5:7)];
    end
end
%% plot
[plotnameFigSimu] = IPFRDPlot(oriDataBase,RorSSimu2); 

% plot 
[plotnameFigExp] = IPFRDPlot(oriDataBase,RorSProf3to1); 


