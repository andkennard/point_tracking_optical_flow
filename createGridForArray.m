function [EdgePositionArray,...
          RoiSizeArray,     ...
          nRoisAlongDimension]  = createGridForArray(roiSize,arraySize)
% createGridForArray: Figure out coordinates and size of ROIs that split an
%                     an array of given size into a specific grid
assert(numel(roiSize) == numel(arraySize),...
       'Number of dimensions of ROIs and the array must be equal');
   
EdgePositionArray   = cell( numel(roiSize),1);
RoiSizeArray        = cell( numel(roiSize),1);
nRoisAlongDimension = zeros(numel(roiSize),1);

%Loop through dimensions of array
for dim = 1:numel(roiSize)
    edgePositionList = 0:roiSize(dim):arraySize(dim);
    %In the case that roiSize does not divide arraySize, make sure the last
    %edge includes everything in the domain.
    edgePositionList(1)   = 0;
    edgePositionList(end) = arraySize(dim);
    roiSizeList           = edgePositionList(2:end) - ...
                            edgePositionList(1:end-1);
    
    EdgePositionArray{dim}   = edgePositionList;
    RoiSizeArray{dim}        = roiSizeList;
    nRoisAlongDimension(dim) = length(roiSizeList);
end

end
    