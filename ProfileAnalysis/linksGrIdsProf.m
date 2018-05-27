% linking the ID in all 3 profiles 
%check out the results in oriLinks.xlsx fiel in the same folder

%% path to files
fname = 'C:\Users\kxb3553\Dropbox\PhD_stuff\2018 results & code\ProfileAnalysisV2';
%prof 1 
%areas
fnameall = [fname '\areasProf1.mat'];
load(fnameall)
areasProf1 = areasA; 
%centroids 
fnameall = [fname '\centroidsProf1.mat'];
load(fnameall)
centroidsProf1 = centroids; 
%prof 2 
%areas
fnameall = [fname '\areasProf2.mat'];
load(fnameall)
areasProf2 = areasA; 
%centroids 
fnameall = [fname '\centroidsProf2.mat'];
load(fnameall)
centroidsProf2 = centroids; 
%prof 3
%areas
fnameall = [fname '\areasProf3.mat'];
load(fnameall)
areasProf3 = areasA; 
%centroids 
fnameall = [fname '\centroidsProf3.mat'];
load(fnameall)
centroidsProf3 = centroids; 

% load outline also 
%prof 1
fnameall = [fname '\grOutlineProf1.mat'];
load(fnameall)
outline1 = outlineBin; 
%prof 2
fnameall = [fname '\grOutlineProf2.mat'];
load(fnameall)
outline2 = outlineBin; 
%prof 3
fnameall = [fname '\grOutlineProf3.mat'];
load(fnameall)
outline3 = outlineBin; 

noGrsProf1 = size(centroidsProf1,1);
noGrsProf2 = size(centroidsProf2,1);
noGrsProf3 = size(centroidsProf3,1);


%% determination for prof2 to prof 1
[idSet, distSet] = distSet1Set2V2(areasProf1,areasProf2,centroidsProf1,centroidsProf2,0.01);

[idSetAreas, distSetAreas] = distSet1Set2(areasProf1,areasProf2);
[idSetCent, distSetCent] = distSet1Set2(centroidsProf1,centroidsProf2);

[C,idx]=unique(idSet,'stable');%don't sort
idx=setxor(idx,1:numel(idSet));
repeating_values=idSet(idx);

% some are wrong 

% determination for prof3 to prof 1
%scale appropraitely for the missing y section in prof3 
centroidsProf3Scale=centroidsProf3;
centroidsProf3Scale(:,2)= (centroidsProf3Scale(:,2)+406)*5567/(5567+406);

[idSet3, distSet3] = distSet1Set2V2(areasProf1,areasProf3,centroidsProf1,centroidsProf3Scale,0.01);

[idSetAreas3, distSetAreas3] = distSet1Set2(areasProf1,areasProf3);
[idSetCent3, distSetCent3] = distSet1Set2(centroidsProf1,centroidsProf3Scale);
% some are wrong 
[C,idx]=unique(idSet3,'stable');%don't sort
idx=setxor(idx,1:numel(idSet3));
repeating_values=idSet3(idx);

%% Draw diagrams and verify which of them are wrong 
% prof1 
figOutline1=figure;
image(outline1)
hold on
for i=1:noGrsProf1
text(centroidsProf1(i,1),centroidsProf1(i,2), num2str(i))
plot(centroidsProf1(i,1),centroidsProf1(i,2),'-s') 
end
axis image
hold off

%prof2 
figOutline2=figure;
image(outline2)
hold on
for i=1:noGrsProf2
text(centroidsProf2(i,1),centroidsProf2(i,2), num2str(idSet(i)))
plot(centroidsProf2(i,1),centroidsProf2(i,2),'-s') 
end
axis image
hold off

%prof3
figOutline3=figure;
image(outline3)
hold on
for i=1:noGrsProf3
text(centroidsProf3(i,1),centroidsProf3(i,2), num2str(idSet3(i)))
plot(centroidsProf3(i,1),centroidsProf3(i,2),'-s') 
end
axis image
hold off

