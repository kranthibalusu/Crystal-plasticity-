%visualize euler angles and crystal FCC
%runge-kutta euler angles rotation of the global coords to form the crystal
%coords %zxz 


%euler angle; specify in degrees
alpha=90;
beta=135;
gamma=90;

x0= [1,0,0];
y0 = [0,1,0];
z0 = [0,0,1];

% FCC 
a1 = [0,0,0];
a2 = [1,0,0];
a3 = [1,1,0];
a4 = [0,1,0];

a5 = [0,0,1];
a6 = [1,0,1];
a7 = [1,1,1];
a8 = [0,1,1];

a9 = (a1+a2+a3+a4)/4;
a10 = (a5+a6+a7+a8)/4;
a11 = (a1+a4+a5+a8)/4;
a12 = (a2+a3+a6+a7)/4;
a13 = (a1+a2+a5+a6)/4;
a14 = (a3+a4+a7+a8)/4;

figureRot = figure;
hold on
limits = [-1.5 1.5 -1.5 1.5 -1.5 1.5]; 
axis(limits); 
%plot globsal coords 
plot3([0,1],[0,0],[0,0],'r')
text(x0(1),x0(2),x0(3),' x0')
plot3([0,0],[0,1],[0,0],'g')
text(y0(1),y0(2),y0(3),' y0')
plot3([0,0],[0,0],[0,1],'b')
text(z0(1),z0(2),z0(3),' z0')

%%
% % basic rotation, step1 about z axis 
% rot1 = [cosd(alpha),-sind(alpha), 0;
%         sind(alpha),cosd(alpha),0;
%         0 ,0, 1];
% %coords after step1    
% x1 = rot1 * x0';  
% y1 = rot1 * y0';     
% z1 = rot1 * z0';     
% 
% % plot3([0,x1(1)],[0,x1(2)],[0,x1(3)],'--r')
% % % text(x1(1),x1(2),x1(3),' x1')
% % plot3([0,y1(1)],[0,y1(2)],[0,y1(3)],'--g')
% % % text(y1(1),y1(2),y1(3),' y1')
% % plot3([0,z1(1)],[0,z1(2)],[0,z1(3)],'--b')
% % % text(z1(1),z1(2),z1(3),' z1')
% 
% 
% 
% %%
% %step2 about x axis 
% rot2 = [1, 0 , 0; 
%         0, cosd(beta),-sind(beta);
%         0, sind(beta),cosd(beta);];
% %coords after step2   
% x2 = rot2 * x1;  
% y2 = rot2 * y1;     
% z2 = rot2 * z1;     
% % plot3([0,x2(1)],[0,x2(2)],[0,x2(3)],':r')
% % % text(x2(1),x2(2),x2(3),' x2')
% % plot3([0,y2(1)],[0,y2(2)],[0,y2(3)],':g')
% % % text(y2(1),y2(2),y2(3),' y2')
% % plot3([0,z2(1)],[0,z2(2)],[0,z2(3)],':b')
% % % text(z2(1),z2(2),z2(3),' z2')
% %%
% %step3 about z axis 
% rot3 = [ cosd(gamma),-sind(gamma), 0;
%         sind(gamma),cosd(gamma), 0;
%         0 ,0 ,1];
% %coords after step3   
% x3 = rot3 * x2;  
% y3 = rot3 * y2;     
% z3 = rot3 * z2;     
% 
% 
% %total rotation 
% rTot = rot3*rot2*rot1; 

%alternative formual 
 C1 = cosd(alpha);
 C  = cosd(beta);
 C2 = cosd(gamma);
 S1 = sind(alpha);
 S  = sind(beta);
 S2 = sind(gamma);
 %http://eps.berkeley.edu/~wenk/TexturePage/Publications/TexRevRPP.pdf
 rTot = [C1*C2-S1*S2*C, S1*C2+C1*S2*C, S2*S;
        -C1*S2-S1*C2*C, -S1*S2+C1*C2*C, C2*S; 
        S1*S, -C1*S, C];
% extra rotation 
phi = 45; 
rotE = [1, 0 , 0; 
        0, cosd(phi),-sind(phi);
        0, sind(phi),cosd(phi);];
rTot =   rotE*rTot;  

x3 = rTot*(x0');
y3 = rTot*(y0');
z3 = rTot*(z0');


a1c = rTot*a1';
a2c = rTot*a2';
a3c = rTot*a3';
a4c = rTot*a4';
a5c = rTot*a5';
a6c = rTot*a6';
a7c = rTot*a7';
a8c = rTot*a8';
a9c = rTot*a9';
a10c = rTot*a10';
a11c = rTot*a11';
a12c = rTot*a12';
a13c = rTot*a13';
a14c = rTot*a14';

%crystal coords 
xc = x3';
yc = y3';
zc = z3';

plot3(3*[0,xc(1)],3*[0,xc(2)],3*[0,xc(3)],'-.r')
text(xc(1),xc(2),xc(3),' xc','FontSize',14)
plot3(3*[0,yc(1)],3*[0,yc(2)],3*[0,yc(3)],'-.g')
text(yc(1),yc(2),yc(3),' yc','FontSize',14)
plot3(3*[0,zc(1)],3*[0,zc(2)],3*[0,zc(3)],'-.b')
text(zc(1),zc(2),zc(3),' zc','FontSize',14)

scatter3(a1c(1),a1c(2),a1c(3),100,'k','filled')
scatter3(a2c(1),a2c(2),a2c(3),100,'k','filled')
scatter3(a3c(1),a3c(2),a3c(3),100,'k','filled')
scatter3(a4c(1),a4c(2),a4c(3),100,'k','filled')
scatter3(a5c(1),a5c(2),a5c(3),100,'k','filled')
scatter3(a6c(1),a6c(2),a6c(3),100,'k','filled')
scatter3(a7c(1),a7c(2),a7c(3),100,'k','filled')
scatter3(a8c(1),a8c(2),a8c(3),100,'k','filled')
scatter3(a9c(1),a9c(2),a9c(3),60,'k')
scatter3(a10c(1),a10c(2),a10c(3),60,'k')
scatter3(a11c(1),a11c(2),a11c(3),60,'k')
scatter3(a12c(1),a12c(2),a12c(3),60,'k')
scatter3(a13c(1),a13c(2),a13c(3),60,'k')
scatter3(a14c(1),a14c(2),a14c(3),60,'k')

%% transformation of slipsytems 
SlipSys=[1,1,1,0,-1,1
    1,1,1,1,0,-1
    1,1,1,-1,1,0
    
    -1,-1,1,0,1,1
    -1,-1,1,-1,0,-1
    -1,-1,1,1,-1,0
    
    -1,1,1,0,-1,1
    -1,1,1,-1,0,-1
    -1,1,1,1,1,0
    
    1,-1,1,0,1,1
    1,-1,1,1,0,-1
    1,-1,1,-1,-1,0]; 

SlipSysR = zeros(12,6);
schmid=zeros(12,1);
%atoms correspoding to plane one 
planes = [2,4,5;
         4,2,7;
        1, 3, 6;
        1,3,8];

for i = 1:12;
    %slip plane 
    m = SlipSys(i,1:3);
    %slip direction 
    n = SlipSys(i,4:6);
    m = m/norm(m);
    n = n/norm(n);
    mr = (rTot*m');
    nr = (rTot*n');
    SlipSysR(i,1:3) = mr'; 
    SlipSysR(i,4:6) = nr'; 
    
    mat = 0.5*(nr*(mr') + mr*(nr')); 
    schmid(i) = mat(1);
end
aSchmid = floor(abs(schmid*1000))/1000;
SchVal = max(aSchmid); 
Id = find(aSchmid == SchVal);
noOfActSS = size(Id,1); 
sumN = 0 ; 
for i=1:noOfActSS
    ic = Id(i);
     m = SlipSysR(ic,1:3);
     if schmid(ic) < 0
         n = -SlipSysR(ic,4:6);
     else
         n = SlipSysR(ic,4:6);
     end
%      ic
%      sumN= sumN+ n
     planeId = 1 + floor((ic-0.1)/3);
     %1st atom in oplane 
     ap1Id = planes(planeId,1);
     ap2Id = planes(planeId,2);
     ap3Id = planes(planeId,3);
     atom1name = ['a',int2str(ap1Id),'c'];
     atom2name = ['a',int2str(ap2Id),'c'];
     atom3name = ['a',int2str(ap3Id),'c'];
     ap1 = eval(atom1name);
     ap2 = eval(atom2name);
     ap3 = eval(atom3name);
     %plot the plane 
     patch([ap1(1),ap2(1),ap3(1)],[ap1(2),ap2(2),ap3(2)],[ap1(3),ap2(3),ap3(3)],0.1)   
     %plot the slip directions 
     center = (ap1+ap2+ap3)/3;
     p1  = center' + n/2 ; 
     p2  = center' - n/2 ; 
     quiver3(center(1),center(2),center(3),n(1),n(2),n(3));
     
end



