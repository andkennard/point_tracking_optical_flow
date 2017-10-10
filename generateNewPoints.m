function newpts = generateNewPoints(frame,roiIndex,roiSize,Params)
%%% GENERATENEWPOINTS detect new feature points in a specified image
%%% sub-region.
%%% Given an image im, which has been split into a grid with edges given by
%%% the vector edges (N x 2, edges_x,edges_y), generate more feature points
%%% in the bin specified by the linear index bin_idx (i.e. referring to a
%%% particular bin).

imageSize = size(frame);
[EdgePositionsAlongDimension,...
 RoiLengthsAlongDimension,...
 nRoisAlongDimension]            = createGridForArray(roiSize,imageSize);

%Generate crop window from bin coordinates
cropWindow = convertRoiIndexToCropWindow(roiSize,                       ...
                                         EdgePositionsAlongDimension{2},...
                                         EdgePositionsAlongDimension{1},...
                                         roiIndex);
iX = cropWindow(1);
iY = cropWindow(2);

%Crop image
im_cropped = imcrop(frame,cropWindow);
%Test if the region is all 0s, in which case no new points should be
%generated
if ~isempty(find(im_cropped,1))
%Detect points in the cropped image
newptsobj  = detectMinEigenFeatures(im_cropped);
newpts = double(newptsobj.Location);

%Translate the point coordinates based on the location of the crop window
[num_newpts,~] = size(newpts);
offset = [iX-1, iY-1];
offset_vec = repmat(offset,num_newpts,1);
newpts = newpts + offset_vec;
else
    newpts = [];
end
end