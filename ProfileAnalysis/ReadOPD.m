function [array,wavelength,aspect,pxlsize] = ReadOPD(filename,badpixelvalue,scaleByWavelength)
%READOPD Reads WYKO OPD file 
%
% [array,wavelength,aspect,pxlsize] = READOPD(filename,badpixelvalue,scaleByWavelength)
% returns array of RAW phase data, wavelength and aspect ratio stored in the 
% opd file with 'filename'.  Data is stored in 'waves' and must be multiplied by the
% wavelength to get nanometers (unless the scaleByWavelength flag is set to 1)
%
% INPUT VALUES:
% filename - name of the file to open
% badpixelvalue - optional value - value to substitude for invalid data (def=NaN)
%               - you may use NaN here. *** default used to be 0 ***
% scaleByWavelength - optional value - if set to 1, will scale the opd by the wavelength
%                   - (def=0)
%
% RETURN VALUES:
% raw - raw data array
% wavelength - in nanometers
% aspect - aspect ratio of the data set
% pxlsize - pixel size in x direction
% 
% SEE ALSO: ReadValueopd -- to read specific value from the opd file
%           readopdBPF -- to read opd file and leave BPF values

% $Revision: 1.10 $ Last Modified July 2010
% Copyright (c) 2001-2010 Veeco Instruments Inc. All Rights Reserved.

% VEECO MAKES NO REPRESENTATIONS OR WARRANTIES ABOUT THE SUITABILITY OF THIS SOFTWARE 
% FOR ANY PURPOSE. THE SOFTWARE IS PROVIDED "AS IS" WITHOUT EXPRESS OR IMPLIED WARRANTIES,
% INCLUDING WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE OR 
% NONINFRINGEMENT.  VEECO SHALL NOT BE LIABLE UNDER ANY THEORY OR ANY DAMAGES SUFFERED 
% BY YOU OR ANY USER OF THE SOFTWARE

% check number of input parameters
if ( nargin == 1 )
  badpixelvalue = NaN;
  scaleByWavelength = 0;
  rotate = 1;
elseif (nargin == 2)
  scaleByWavelength = 0;
  rotate = 1;
elseif (nargin ~= 3)
  error ('Wrong number of input parameters, use HELP READOPD');
end

fileIndex = 0; % this will be used if we need to read our data last
% initialize the variable for exception handling
fid=-1;
try 
  % open the file for reading
  fid=fopen (filename, 'rb', 'ieee-le');
  
  % if opening failed abort
  if fid==-1 
    msg=sprintf ('can not open file: %s', filename);
    error (msg); 
  end;
  
  % **************read the block file****************
  % first read the signature
  tmp=fread(fid, 2, 'char');
  %if tmp!='' error ('Not an Vision OPD file, aborting...'); end
  
  % read directory 
  BLCK_SIZE = 24;
  BPF = 1e+38;
  directory = read_blk(fid);
  
  if strcmp(directory.name,'Directory')==0 
    error ('Unable to read Directory entry, aborting...'); 
  end;
  
  %calculate number of directory entries
  num_blcks=directory.len/BLCK_SIZE;
  
  counter=1;
  mult_offset = 0;
  offset = 0;
  
  %read all directory entries
  for i=1:num_blcks-1
    blocks(i) =  read_blk(fid);
    
    if blocks(i).len>0
      counter = counter+1;
    end;
  end;
  phaseSize = 4;
  mult = 1;
  
  % read the data from data blocks
  for i=1:num_blcks-1
    if (blocks(i).len > 0)
      
      % remove blanks from the name
      deblank(blocks(i).name);
      
      switch blocks(i).name;
        
      case 'RAW DATA'
        rows=fread(fid,1,'ushort');
        cols=fread(fid,1,'ushort');
        [prec,phaseSize] = get_prec(fid);
        if ( cols * rows > 1000 * 1000 )
          fileIndex = ftell(fid); % use optimized code below for large arrays
          rows1=rows; cols1=cols; prec1=prec;
        else
          arrayTmp=fread(fid,[cols rows],prec);
        end
        
      case 'Raw'
        rows=fread(fid,1,'ushort');
        cols=fread(fid,1,'ushort');
        [prec,phaseSize] = get_prec(fid);
        if ( cols * rows > 1000 * 1000 )
          fileIndex = ftell(fid); % use optimized code below for large arrays
          rows1=rows; cols1=cols; prec1=prec;
        else
          arrayTmp=fread(fid,[cols rows],prec);
        end
        
        
      case 'SAMPLE_DATA'
        rows=fread(fid,1,'ushort');
        cols=fread(fid,1,'ushort');
        [prec,phaseSize] = get_prec(fid);
        if ( cols * rows > 1000*1000 )
          fileIndex = ftell(fid); % use optimized code below for large arrays
          rows1=rows; cols1=cols; prec1=prec;
        else
          arrayTmp=fread(fid,[cols rows],prec);
        end
        
      case 'OPD'
        rows=fread(fid,1,'ushort');
        cols=fread(fid,1,'ushort');
        [prec,phaseSize] = get_prec(fid);
        if ( cols * rows > 1000*1000 )
          fileIndex = ftell(fid); % use optimized code below for large arrays
          rows1=rows; cols1=cols; prec1=prec;
        else
          arrayTmp=fread(fid,[cols rows],prec);
        end
        
      case 'Wavelength'
        wavelength=fread(fid,1,'float');
        
      case 'Mult'
        mult = fread(fid,1,'short');
        
      case 'Aspect'
        aspect=fread(fid,1,'float');
        
      case 'Pixel_size'
        pxlsize=fread(fid,1,'float');
        
      otherwise
        % use conversion depending on the data type 
        switch blocks(i).type;
        case 12
          fseek(fid,blocks(i).len,'cof'); % long
        case 8
          fseek(fid,blocks(i).len,'cof'); % double
        case 7
          fseek(fid,blocks(i).len,'cof'); % float
        case 6
          fseek(fid,blocks(i).len,'cof'); % short
        case 5
          fseek(fid,blocks(i).len,'cof'); % string
        case 3
          rows=fread(fid,1,'ushort');
          cols=fread(fid,1,'ushort');
          elsize=fread(fid,1,'short');
          fseek(fid,rows*cols*elsize,'cof');
        otherwise
          fseek(fid,blocks(i).len,'cof'); % anything else
        end;
      end;
    end;
  end;
  
  % get our scale - note mult is 1 for float data so we can use it here for all cases.
  if ( scaleByWavelength == 1 )
    scale = wavelength / mult;
  else
    scale = 1/mult;
  end
  % we must substitute for the bad pixels and swap in Y, and integer data convert to waves.
%   [m n]=size(arrayTmp);
%   if ( phaseSize == 2)
%     % substitute BPSs with 0
%     for i=1:m
%       for j=1:n
%         if arrayTmp(i,j)>32766
%           array(m+1-i,j)=badpixelvalue;
%         else
%           % apply mult to scale the data back to waves.
%           array(m+1-i,j)=arrayTmp(i,j) * scale;
%         end
%       end
%     end
%   else
%     % substitute BPFs with 0
%     for i=1:m
%       for j=1:n
%         if arrayTmp(i,j)>BPF
%           array(m+1-i,j)=badpixelvalue;
%         else
%           array(m+1-i,j)=arrayTmp(i,j) * scale;
%         end
%       end
%     end
%   end

  % optimized code
  if ( phaseSize == 2)
    badValue = 32766;
  else
    badValue = BPF;
  end

  if ( fileIndex > 0 )
    % we will read a col at a time and transfer it to a col in new matrix
    if ( 0 == fseek(fid, fileIndex, 'bof') )
      % create our array
      array = ones(cols1, rows1) * badpixelvalue;
      for i=1:rows1
        col = flipdim(fread(fid, [cols1,1], prec1),1);
        indexGood = find(col < badValue);
        array(indexGood,i) = col(indexGood) * scale;
      end
    end
  else
    indexGood = find(arrayTmp < badValue);
    arrayTmp(indexGood) = arrayTmp(indexGood) * scale;
    arrayTmp(find(arrayTmp > badValue)) = badpixelvalue;
    array = flipdim(arrayTmp,1);
  end
  % close the file
  fclose(fid);
catch 
  if fid >= 0
    fclose(fid);
  end
end



