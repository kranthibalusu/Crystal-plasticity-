% my own filter 
%not implemented yet
%1) identify values lying outside a specif range 
%2) replace them by a value average of its sorrounding. 

function [imageFilt]=kraFilt(image,stds)
% image shoudl be having only one channel 
%stds is the numbed of std deviations that have to be removed 
%from image
[sizeC,sizeR]=size(image);

meanData=mean(image(:));
stdDevData=std(image(:));

lowLimit= meanData - stds*stdDevData;
highLimit= meanData + stds*stdDevData;


for iC=1:sizeC %cycle columns
    for iR=1:sizeR %cycle rows
        if image(iC,iR)<lowLimit || image(iC,iR)<highLimit 
            
            
        else
            
        end
            
    end
end
