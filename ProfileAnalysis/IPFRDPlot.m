% function to plot points on the IPF 

function [plotnameFig] = IPFRDPlot(points,idx,labels)

%labels - array with labels for points 
noPoints=size(points,1);

 if ~exist('labels','var')
     % third parameter does not exist, so default it to something
      labels = [1:noPoints]';
 end

%% RD location determination 
ND=[0,0,1];
RD=[1,0,0];
RDSt=[];
NDSt=[];
for j=1:noPoints
% lattice orientation ( euler angles xzx; same as in DAMASK 'math_EulerToR(Euler)' )
alpha=points(j,1);
beta=points(j,2);
gamma=points(j,3);

Euler=[alpha,beta,gamma]*pi/180;
% EulerCol=[alpha,beta,gamma]./90;
 C1 = cos(Euler(1));
 C  = cos(Euler(2));
 C2 = cos(Euler(3));
 S1 = sin(Euler(1));
 S  = sin(Euler(2));
 S2 = sin(Euler(3));
% conversion matrix rotate lattice coords to global coords system 
 math_EulerToR(1,1)=C1*C2-S1*S2*C;
 math_EulerToR(1,2)=-C1*S2-S1*C2*C;
 math_EulerToR(1,3)=S1*S;
 math_EulerToR(2,1)=S1*C2+C1*S2*C;
 math_EulerToR(2,2)=-S1*S2+C1*C2*C;
 math_EulerToR(2,3)=-C1*S;
 math_EulerToR(3,1)=S2*S;
 math_EulerToR(3,2)=C2*S;
 math_EulerToR(3,3)=C;
 
% RD; transpose is correct, check visEuler.m
RDStN=abs((math_EulerToR'*RD')');
%

% RD swapping 
 xSt=RDStN(1);
 ySt=RDStN(2);
 zSt=RDStN(3);
if xSt>zSt
    temp=xSt;
    xSt=zSt;
    zSt=temp;
end
if ySt>zSt
    temp=ySt;
    ySt=zSt;
    zSt=temp;
end

if ySt>xSt
    temp=ySt;
    ySt=xSt;
    xSt=temp;
end

RDSt=[RDSt;xSt/(zSt+1),ySt/(zSt+1)]; 
  
 % plotting 
     

NDStN=abs(math_EulerToR'*ND');

% ND swapping 
 xSt=NDStN(1);
 ySt=NDStN(2);
 zSt=NDStN(3);

if xSt>zSt
    temp=xSt;
    xSt=zSt;
    zSt=temp;
end
if ySt>zSt
    temp=ySt;
    ySt=zSt;
    zSt=temp;
end

if ySt>xSt
    temp=ySt;
    ySt=xSt;
    xSt=temp;
end

 
 NDSt=[NDSt;xSt/(zSt+1),ySt/(zSt+1)]; 

end

%% plotting outline of the IPF
ND=[0,0,1];
RD=[1,0,0];
N=10; % number of divisions on each side of the traingle like shape 
% line 1
L1=zeros((N+1),3);
L1(:,3)=1;
L1(:,1)=[0:N]/N;

% line 2
L2=zeros((N+1),3);
L2(:,3)=1;
L2(:,1)=1;
L2(:,2)=[0:N]/N;
% line 3
L3=zeros((N+1),3);
L3(:,3)=1;
L3(:,1)=[N:-1:0]/N;
L3(:,2)=[N:-1:0]/N;
L=[L1;L2;L3];

for i=1:(3*N+3)
    L(i,:)=L(i,:)/norm(L(i,:));
end

% stereographic projection 
LSt=[L(:,1)./(L(:,3)+1),L(:,2)./(L(:,3)+1)];

%% plot outline
plotnameFig=figure;
hold on;
plot(LSt(:,1),LSt(:,2),'LineWidth',2,'Color',[0 0 0])
xlim([-0.05 0.5])
ylim([-0.05 0.4])
title('RD');
%% plot points
for Gn=1:noPoints
    if idx(Gn) ~= 0
        txt = int2str(labels(Gn));
        pCol = [1,0,0]*(1+idx(Gn))/2 + [0,0,1]*(1-idx(Gn))/2; %red for rising blue for sinking
        scatter(RDSt(Gn,1),RDSt(Gn,2),'MarkerFaceColor',pCol,'MarkerEdgeColor',pCol,'LineWidth',1);
        text(RDSt(Gn,1)+0.001,RDSt(Gn,2)+0.001,txt,'FontSize',14,'FontName','Times New Roman');
    end 
end

hold off;

 