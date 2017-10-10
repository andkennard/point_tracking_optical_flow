function [TrackedPointStructure,thisFramePreprocessed] = performPointTracking( ...
                                                         TrackedPointStructure,...
                                                         reader,               ...
                                                         Params,               ...
                                                         iT)
% performPointTracking - track points in a frame in the middle of the movie

sizeX = reader.getSizeX();
sizeY = reader.getSizeY();

%Preprocess image
thisFrame = bf_getFrame(reader,1,1,iT);
thisFramePreprocessed = Params.preprocessImage(thisFrame);

%Track points
[detectedPointArray, isTracked] = step(tracker,thisFramePreprocessed);

%Some points may have been "tracked" to locations outside the image.
%Mark those as no longer valid and change the location so that they
%do not interfere with the tracker
[detectedPointArrayInBounds, ...
 isTrackedInBounds] = correctOutOfBoundPoints(detectedPointArray,...
                                              isTracked,         ...
                                              [sizeY,sizeX]);

TrackedPointStructure(iT).coordinates  = double(detectedPointArrayInBounds);
TrackedPointStructure(iT).isTracked    = logical(isTrackedInBounds);
TrackedPointStructure(iT).ID           = TrackedPointStructure(iT-1).ID; %no points have been updated yet
if Params.trackMargin
    TrackedPointStructure(iT).isMargin = TrackedPointStructure(iT-1).isMargin;
end
