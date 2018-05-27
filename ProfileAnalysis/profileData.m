%analysis of raw SWLi profile data 

%loading condition 2 
folderName = 'C:\Users\kxb3553\Dropbox\PhD_stuff\2018 results & code\ProfileAnalysisV2\';
fileName = [folderName,'Profile2.OPD'] ;
 [array,wavelength,aspect,pxlsize] = ReadOPD(fileName);