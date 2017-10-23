function [interiorCoordinateArray,                                     ...
          marginCoordinateArray   ] = makeCoordinateArrayWithMargin(   ...
                                                  TrackedPointStruct)
% makeCoordinateArrayWithMargin - convert coordinate data into an array of
% coordinates (interior and margin points separate)
% From a movie with N frames and M points tracked in at least one frame
% throughout the movie, this generates an M x 2N matrix of x-y coordinates
% of the points, i.e. each row has the coordinates for a point, in the
% form [x1,y1,x2,y2,...,xN,yN]. Times at which the points were not tracked
% are designated with NaN.
% Make separate arrays for interior points and points on the margin.

assert(isfield(TrackedPointStruct,'isMargin'),...
      ['Error: trying to create coordinateArray for margin points but '...
       'margin was not tracked for this TrackedPointStruct object']);
    
[nTrajectories, nFrames] = findCoordinateArrayDimensions(TrackedPointStruct);

coordinateArrayList      = {nan(nTrajectories,2*nFrames),              ...
                            nan(nTrajectories,2*nFrames)};
for k = 1:2 % Loop over interior vs margin
    for iT = 1:nFrames
        switch k
            case 1 % interior points
                selectionCriteria = TrackedPointStruct(iT).isTracked & ...
                                   ~TrackedPointStruct(iT).isMargin;
            case 2 % margin points
                selectionCriteria = TrackedPointStruct(iT).isTracked & ...
                                    TrackedPointStruct(iT).isMargin;
        end
        
        trackedPointIDs      = TrackedPointStruct(iT).ID(selectionCriteria);

        trackedCoordinates   = TrackedPointStruct(iT).coordinates(     ...
                               selectionCriteria, : );
        coordinateArrayList{k}(                                                   ...
            trackedPointIDs,                                           ...
            (2*iT-1):(2*iT)) = trackedCoordinates;
    end
end

%Clean up data, Find trajectories that are 1 timepoint or less

for k = 1:2
    noTrajectory =  find(sum(~isnan(coordinateArrayList{k}),2) <= 2);
    coordinateArrayList{k}(noTrajectory,:) = [];
end

interiorCoordinateArray = coordinateArrayList{1};
marginCoordinateArray   = coordinateArrayList{2};

end