%extract previosuly simulated heights
fname = 'C:\Users\kxb3553\Dropbox\PhD_stuff\2018 results & code\ProfileAnalysisV2';
fnameSheet = [fname '\FilesFromV1\MyDiscrep2.xlsx'];
simuData = xlsread(fnameSheet);

%extract links between profv1 IDS and prof1 V2 ids 
fnamelinks = [fname '\oriLinks.xlsx'];
linksData = xlsread(fnamelinks,'Prof1toV1');

noGra = size(linksData,1);


simuHeights = zeros(noGra,1); 
oriV1 = zeros(noGra,3); % simu height data exists 
oriV2 = zeros(noGra,3); % V2 ori data
simuDataIds = simuData(:,1);
no=0;
relaYorN = zeros(noGra,1); 

%extract orienation data 
fnameOris = [fname '\oris1.xlsx'];
oriData = xlsread(fnameOris);
sizeCutoff = 0; 

for i=1:size(oriData,1)
    if oriData(i,8)>sizeCutoff
        oriV2(i,1:3)=oriData(i,5:7);
    end
end

%determine grain orientation 
for iGr = 1:noGra
   V1Id =  linksData(iGr,2); 
   if V1Id~=0 
       simuId = find(simuDataIds == V1Id); 
       if simuId~=0
           oriV1(iGr,1:3) = simuData(simuId, 2:4); 
           simuHeights(iGr) = simuData(simuId, 6); 
           no=no +1;
           relaYorN(iGr) = 1;
       end
   end
end

%
diff =(oriV1-oriV2)'; 
normDiff = sqrt(sum(diff.*diff)).*relaYorN';


