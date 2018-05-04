%select 13 grains out of 150 grains 
%150 oris from the file 
% 60 configurations in total

%% read oris from the file 
filename=['C:\Users\kxb3553\Dropbox\PhD_stuff\2018 results & code\neighbors\Euler.txt'];
Euler = csvread(filename);
TotalOris = size(Euler,1);
  
%% start assiginig combinations 
noCombos = 60 ; % as in teh french paper 
combo = zeros(noCombos,13,3); % file with ori data for combos
comboIds = zeros(60,13); % files with labels for ori data 
for iComb = 1:noCombos
   oriIds = datasample([1:TotalOris],13);
   combo(iComb,:,:) = Euler(oriIds,:); 
   comboIds(iComb,:) = oriIds; 
end

%% output as
dlmwrite('comboIds.csv',comboIds); 
