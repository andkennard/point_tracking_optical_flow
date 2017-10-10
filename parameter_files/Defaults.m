%PARAMETERS FOR POINT TRACKING BY OPTICAL FLOW
function Params = Defaults()
%% Basic information

Params.finalFrameForTesting = 0;

%% Point Detection
% Choose which point detection algorithm to use. Output of the function
% must include a Location method or field to be able to return the Mx2
% vector of point locations
Params.detectPoints = @detectMinEigenFeatures;

%% Tracking by Optical Flow (Lucas-Kanade method)
% Details of the algorithm and its parameters can be found at 
% https://www.mathworks.com/help/vision/ref/vision.pointtracker-system-object.html

%Preprocess images with this function (in path) prior to tracking
Params.preprocessImage = @preprocessImageWithBackgroundSubtraction;

Params.trackingMaxBidirectionalError = 1;
Params.trackingBlockSize              = [41,41];


%% Adding more points
% Over time as points move or stop being tracked you may wish to add more
% points to track. This is done by looking at the density of points locally
% in sub-regions (or bins) of the image and adding more points in that region
% if the density is too low. These parameters cover that process.

% Determine how many ROIs to split the image into in each direction for
% calculating local point density. Format [row, columns]
Params.nRois = [8,8];

% It can be helpful to delay a certain number of frames before adding any
% new points, and then update points at a specified interval of frames 
% thereafter.
Params.pointUpdateDelay    = 5; %Make this big to skip updating altogether
Params.pointUpdateInterval = 4;

% Density of points (points per pixel) needed to trigger adding more points
% in a region
Params.pointDensityThreshold = 0.008;

%% Margin Tracking
% Determine whether a wound margin should be tracked or not. The wound
% margin is defined in the first movie frame by a manually determined mask.

% Turn margin tracking on/off
Params.trackMargin = 1;

if Params.trackMargin == 1
    % Specify the radius of the alpha-shape used to geometrically define
    % the margin in subsequent frames
    Params.alphaRadius = 20;
end