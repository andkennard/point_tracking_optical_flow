function pointDensityPerRoi = calculatePointDensityInGrid(coordinatesArray,...
                                                    imageSize,...
                                                    roiSize)        
% calculatePointDensity - Find density of points locally in sub-regions
%
% Break the image into a grid of ROIs. 
% Generate an array in the same indexing system of the image (i.e.
% [row,col]), that gives the number of points in the corresponding ROI.
%   Inputs:
%   - trackedCoordinatesArray : Nx2 coordinate list (x,y)
%   - imageSize               : size of the image points were detected in 
%                               [row_size,col_size]
%   - roiSize                 : Target size of the ROIs to locally check
%                               density (in pixels, [row,col] format)

[EdgePositionsAlongDimension,...
 RoiLengthsAlongDimension,...
 nRoisAlongDimension]            = createGridForArray(roiSize,imageSize);

%Compute number of pixels in each bin by an outer product 
%(remember row-col orientation vs xy orientation)
nPixelsPerRoi = RoiLengthsAlongDimension{1}' * RoiLengthsAlongDimension{2};


% Determine which ROI each point falls into based on which bin its X and Y
% coordinates fall into.
[~,~,roiRowIndexArray]    = histcounts(coordinatesArray(:,2),...
                                       EdgePositionsAlongDimension{1});
[~,~,roiColumnIndexArray] = histcounts(coordinatesArray(:,1),...
                                       EdgePositionsAlongDimension{2});

%Get the number of points in each spot in the 2D binned area (with row-col
%indexing rather than xy indexing)
nPointsPerRoi = accumarray([roiRowIndexArray,roiColumnIndexArray],...
                           ones(size(roiRowIndexArray)),          ...
                           [nRoisAlongDimension(1),nRoisAlongDimension(2)]);
pointDensityPerRoi = nPointsPerRoi ./ nPixelsPerRoi;
end