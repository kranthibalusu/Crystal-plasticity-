%profile analysis EBSD data read

%% Read EBSD data
 % crystal symmetry
CS =crystalSymmetry('m-3m', [3.5451 3.5451 3.5451], 'mineral', 'Ni', 'color', 'light blue');

% plotting convention
setMTEXpref('xAxisDirection','north');
setMTEXpref('zAxisDirection','outOfPlane');

%% Specify File Names

% path to files
pname = 'C:\Users\kxb3553\Dropbox\PhD_stuff\2018 results & code\ProfileAnalysisV2';

% which files to be imported
fname1 = [pname '\Base(1).ANG'];
fname2 = [pname '\Base(2).ANG'];
fname3 = [pname '\Base(3).ANG'];

%% Import the Data

% create an EBSD variable containing the data
ebsd1 = loadEBSD(fname1,CS,'interface','ang','convertEuler2SpatialReferenceFrame');
ebsd2 = loadEBSD(fname2,CS,'interface','ang','convertEuler2SpatialReferenceFrame');
ebsd3 = loadEBSD(fname3,CS,'interface','ang','convertEuler2SpatialReferenceFrame');


%% plotting
% grain plots section 1
figebsd1=figure;
oM1 = ipdfHSVOrientationMapping(ebsd1);
plot(ebsd1,oM1.orientation2color(ebsd1.orientations))
set(gca, 'Ydir', 'reverse')
%set(gca, 'Xdir', 'reverse')
saveas(figebsd1,[pname,'\figebsd1.png'])
saveas(figebsd1,[pname,'\figebsd1.fig'])

% close(figebsd1)





% grain plots section 2
figebsd2=figure;
oM2 = ipdfHSVOrientationMapping(ebsd2);
plot(ebsd2,oM2.orientation2color(ebsd2.orientations))
set(gca, 'Ydir', 'reverse')
%set(gca, 'Xdir', 'reverse')
saveas(figebsd2,[pname,'\figebsd2.png'])
saveas(figebsd2,[pname,'\figebsd2.fig'])
% close(figebsd2)



% grain plots section 3
figebsd3=figure;
oM3 = ipdfHSVOrientationMapping(ebsd3);
plot(ebsd3,oM3.orientation2color(ebsd3.orientations))
set(gca, 'Ydir', 'reverse')
%set(gca, 'Xdir', 'reverse')
saveas(figebsd3,[pname,'\figebsd3.png'])
saveas(figebsd3,[pname,'\figebsd3.fig'])

% close(figebsd3)




%% grain boundaries 

% figure 1 
ebsd = ebsd1('indexed');
[grains,ebsd.grainId] = calcGrains(ebsd);
% remove very small grains
ebsd(grains(grains.grainSize<=5)) = [];
% and recompute grains
[grains,ebsd.grainId] = calcGrains(ebsd);
grains1 = grains; 
gB1 = grains.boundary;
grainsId1 = grains1.id;

figgrains1=figure;
hold on 
plot(grains1,grainsId1)
set(gca, 'Ydir', 'reverse')
noGrains1= size(grainsId1, 1);
%text with grain IDs
for i = 1:noGrains1
    x1 = mean(grains1(i).x);
    y1 = mean(grains1(i).y);
    txt1 = int2str(grainsId1(i));
    text(x1,y1,txt1)
end
saveas(figgrains1,[pname,'\figIdGrains1.png'])
saveas(figgrains1,[pname,'\figIdGrains1.fig'])
hold off


%% figure 2
ebsd = ebsd2('indexed');
[grains,ebsd.grainId] = calcGrains(ebsd);
% remove very small grains
ebsd(grains(grains.grainSize<=5)) = [];
% and recompute grains
[grains,ebsd.grainId] = calcGrains(ebsd);
grains2 = grains; 
gB2 = grains2.boundary;
grainsId2 = grains2.id;

figgrains2=figure;
hold on 
plot(grains2,grainsId2)
set(gca, 'Ydir', 'reverse')
noGrains2= size(grainsId2, 1);
%text with grain IDs
for i = 1:noGrains2
    x1 = mean(grains2(i).x);
    y1 = mean(grains2(i).y);
    txt2 = int2str(grainsId2(i));
    text(x1,y1,txt2)
end
saveas(figgrains2,[pname,'\figIdGrains2.png'])
saveas(figgrains2,[pname,'\figIdGrains2.fig'])
hold off
%% figure 3
ebsd = ebsd3('indexed');
[grains,ebsd.grainId] = calcGrains(ebsd);
% remove very small grains
ebsd(grains(grains.grainSize<=5)) = [];
% and recompute grains
[grains,ebsd.grainId] = calcGrains(ebsd);
grains3 = grains; 
gB3 = grains3.boundary;
grainsId3 = grains3.id;

figgrains3=figure;
hold on 
plot(grains3,grainsId3)
set(gca, 'Ydir', 'reverse')
noGrains3= size(grainsId3, 1);
%text with grain IDs
for i = 1:noGrains3
    x1 = mean(grains3(i).x);
    y1 = mean(grains3(i).y);
    txt3 = int2str(grainsId3(i));
    text(x1,y1,txt3)
end
saveas(figgrains3,[pname,'\figIdGrains3.png'])
saveas(figgrains3,[pname,'\figIdGrains3.fig'])
hold off
%%


%% determine grain orientation in the identified grains 

grain_oris1 = [grains1.meanOrientation.phi1, grains1.meanOrientation.Phi, grains1.meanOrientation.phi2]; 
grain_oris2 = [grains2.meanOrientation.phi1, grains2.meanOrientation.Phi, grains2.meanOrientation.phi2]; 
grain_oris3 = [grains3.meanOrientation.phi1, grains3.meanOrientation.Phi, grains3.meanOrientation.phi2]; 

grain_areas1 = grains1.grainSize;
grain_areas2 = grains2.grainSize;
grain_areas3 = grains3.grainSize;



