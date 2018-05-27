%playing with stufff 
%run GrainDetection3 first 
[B] = bwboundaries(outlineBW);

siB = size(B,1);

Frame2=ones(outsize1,outsize2);
hold on 

for i = 2

Btemp = B(i);
Btemp2= Btemp{1};
iR = Btemp2(:,1);
iC = Btemp2(:,2);
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
    
    wrongId = find((iR>outsize1)| (iR<1) ); 
    iRT(wrongId) = [];
    iCT(wrongId) = [];
    wrongId = find((iC>outsize2)| (iC<1) ); 
    iRT(wrongId) = [];
    iCT(wrongId) = [];
    
Index=sub2ind(size(Frame2),iRT,iCT);
IndexU = unique(Index);
Frame2(IndexU) = 0;
imshow(Frame2)

end
