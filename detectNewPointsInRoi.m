function detectedPointArray = detectNewPointsInRoi(frame,roiIndex,Params)
%%% GENERATENEWPOINTS detect new feature points in a specified image
%%% sub-region.
%%% Given an image im, which has been split into a grid with edges given by
%%% the vector edges (N x 2, edges_x,edges_y), generate more feature points
%%% in the bin specified by the linear index bin_idx (i.e. referring to a
%%% particular bin).

imageSize = size(frame);
gridSize  = Params.nRois;
roiSize   = floor(imageSize./gridSize);
EdgePositionsAlongDimension = createGridForArray(roiSize,imageSize);

%Generate crop window from bin coordinates
cropWindow = convertRoiIndexToCropWindow(gridSize,                       ...
                                         EdgePositionsAlongDimension{2},...
                                         EdgePositionsAlongDimension{1},...
                                         roiIndex);

%Crop image
frameCropped = imcrop(frame,cropWindow);

%Only detect points if the ROI is not blank (all zeros)
if ~isempty(find(frameCropped,1))
    %Detect points in the cropped image
    detectedPointObject  = Params.detectPoints(frameCropped);
    detectedPointArray = double(detectedPointObject.Location);

    %Translate the point coordinates based on the location of the crop window
    [nNewPoints,~] = size(detectedPointArray);
    iX = cropWindow(1);
    iY = cropWindow(2);
    offset = [iX-1, iY-1];

    detectedPointArray = detectedPointArray + repmat(offset,nNewPoints,1);
else
    detectedPointArray = [];
end
end