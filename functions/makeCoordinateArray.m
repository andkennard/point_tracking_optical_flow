function coordinateArray = makeCoordinateArray(TrackedPointStruct)
% makeCoordinateArray - convert coordinate data into an array of
% coordinates
% From a movie with N frames and M points tracked in at least one frame
% throughout the movie, this generates an M x 2N matrix of x-y coordinates
% of the points, i.e. each row has the coordinates for a point, in the
% form [x1,y1,x2,y2,...,xN,yN]. Times at which the points were not tracked
% are designated with NaN.

[nTrajectories, nFrames] = findCoordinateArrayDimensions(TrackedPointStruct);

coordinateArray          = nan(nTrajectories,2*nFrames);

for iT = 1:nFrames
    trackedPointIDs      = TrackedPointStruct(iT).ID(                  ...
                           TrackedPointStruct(iT).isTracked    );
                     
    trackedCoordinates   = TrackedPointStruct(iT).coordinates(         ...
                           TrackedPointStruct(iT).isTracked, : );
    coordinateArray(                                                   ...
        trackedPointIDs,                                               ...
        (2*iT-1):(2*iT)) = trackedCoordinates;
end

%Clean up data, Find trajectories that are 1 timepoint or less

noTrajectory =  find(sum(~isnan(coordinateArray),2) <= 2);
coordinateArray(noTrajectory,:) = [];
