function [tracker,TrackedPointStruct] = initializePointTracking(reader,Params)
% initializepointtracking: Set up point tracking in the first frame

initialImage = bf_getFrame(reader,1,1,1);
initialImage_preprocessed = Params.preprocessImage(initialImage);

detectedInitialPointObject = Params.detectPoints(initialImage_preprocessed);
detectedInitialPointArray  = detectedInitialPointObject.Location;
[nPoints,~]                = size(detectedInitialPointArray);

%Initialize a tracker for these points
tracker                       = vision.PointTracker();
tracker.MaxBidirectionalError = Params.trackingMaxBidirectionalError;
tracker.BlockSize             = Params.trackingBlockSize;
initialize(tracker,detectedInitialPointArray,initialImage);

% Initialize a structure to keep track of all the points. 
% Include: 
% coordinates - [x,y] locations
% isTracked   - whether or not they are successfully tracked in that frame
% ID          - a unique ID (persistent even if points are added/lost)
% isMargin    - (only if tracking margin) if the point is on the woun
%               margin or not
TrackedPointStruct = struct('coordinates', [],...
                            'isTracked',   [],...
                            'ID',          []);
%Initialize (at the beginning all points are valid)
TrackedPointStruct(1).coordinates = double(detectedInitialPointArray);
TrackedPointStruct(1).isTracked   = true(nPoints,1);
TrackedPointStruct(1).ID          = uint32(1:nPoints)';

if Params.trackMargin 
    [indexMarginY,indexMarginX] = find(Params.initialMarginMask);
    initialMarginShape          = alphaShape(indexMarginX,indexMarginY,...
                                  Params.alphaRadius);
                                                   
    TrackedPointStruct(1).isMargin = inShape(initialMarginShape,...
                                     TrackedPointStruct(1).coordinates);
end