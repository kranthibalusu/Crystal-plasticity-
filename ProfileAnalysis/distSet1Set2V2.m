%function to determine the index of point in set 1 
%closest to every point in set 2
%also compare one other parsameter 
function [idSet, distSet] = distSet1Set2V2(set1,set2, set12, set22, par1by2)

% set1 and set12 are expected to be of the same size, describing the same thing 
%par1by2 pareameter describes the relative importance of each data type 

%size of set1 
set1S=size(set1,1);

%size of set2 
set2S=size(set2,1);

idDiff = set1S - set2S;

%idSet allocatoipn 
idSet = zeros(set2S,1);
distSet =  zeros(set2S,1);

% loop through every point in set 2 to find its nearrest neightbor in Set1
for iS2=1:set2S
    point2 = set2(iS2,:);
    point22 = set22(iS2,:);
    
    minDist = 10^6; %something really large
    id = [];
    %loop through each point in set1 
    %not each point but similar IDs
    st1 = iS2 - idDiff; %min iD
    st2 = iS2 + idDiff; %max iD

    if st1<1
        st1 = 1;
    end
    temp = st2;
    if st2 > set1S
        temp = set1S;
    end
    st2 =temp; 
    
    for iS1 = st1:st2
        point1 = set1(iS1,:);
        point12 = set12(iS1,:);
        
        %dist a combination of both the parameters 
        dist = norm(point1-point2)*par1by2 + norm(point12-point22);
        
        if dist < minDist
           id = iS1;
           minDist = dist;
        end
    end
    idSet(iS2) = id;  
    distSet(iS2) = minDist;
   
end 


