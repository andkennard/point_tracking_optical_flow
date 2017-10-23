function I = bf_getFrame(bfReader,iZ_in,iC,iT,varargin)
%%%Handler to grab frames in Bio-Formats style.
%%% Z,C,T indexes are 1-indexed.
%%%Optional argument: a num_z x num_t lookup table to account for
%%%z-registration.
numT = bfReader.getSizeT();
if isempty(varargin)
    iZ = iZ_in;
elseif length(varargin) == 1 %zlookup table provided
    zlookup = varargin{1};
    iZ = zlookup(iZ_in,numT);
end

if iZ>0 %standard case
    iPlane = bfReader.getIndex(iZ-1,iC-1,iT-1)+1;
    I = bfGetPlane(bfReader,iPlane);
    
elseif iZ==0 %Edge cases due to image registration
    sizeX = bfReader.getSizeX();
    sizeY = bfReader.getSizeY();
    bits  = bfReader.getBitsPerPixel();
    switch bits
        case 8
            dtypestr = 'uint8';
        case 16
            dtypestr = 'uint16';
        case 32
            dtypestr = 'uint32';
        otherwise
            warning('Unexpected number of bits per pixel');
    end
    I = zeros(sizeY,sizeX,dtypestr);
end
end
    
