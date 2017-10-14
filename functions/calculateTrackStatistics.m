function trackStatistics = calculateTrackStatistics(TrackedPointStruct)
% calculateTrackStatistics: calculate statistics for tracking including:
% - detectedPoints:              how many points were detected
% - trackedPoints :              how many points were tracked
% - avgTrackLengthAllPoints:     average track length at that frame over all
%                                 detected points in that frame
% - avgTrackLengthTrackedPoints: average track length at that frame over
%                                 all points currently tracked in that frame

nFrames = numel(TrackedPointStruct);
trackStatistics = struct('frame',                      (1:nFrames)',    ...
                         'detectedPoints',             zeros(nFrames,1),...
                         'trackedPoints',              zeros(nFrames,1),...
                         'avgTrackLengthAllPoints',    zeros(nFrames,1),...
                         'avgTrackLengthTrackedPoints',zeros(nFrames,1));
%Keep track of track lengths
trackLength = zeros(numel(TrackedPointStruct(end).ID),1);
for iT = 1:nFrames
    %detectedPoints
    trackStatistics.detectedPoints(iT) = size(TrackedPointStruct(iT).coordinates,1);
    %trackedPoints
    trackStatistics.trackedPoints(iT)  = sum(TrackedPointStruct(iT).isTracked);
    %avgTrackLength
    currentTracks                      = TrackedPointStruct(iT)         ...
                                         .ID(TrackedPointStruct(iT).isTracked);
    trackLength(currentTracks)         = trackLength(currentTracks) + 1;
    
    totalTrackLengthAllPoints          = sum(trackLength(               ...
                                             TrackedPointStruct(iT).ID));
    totalTrackLengthTrackedPoints      = sum(trackLength(               ...
                                             currentTracks));
    
    trackStatistics                                                     ...
        .avgTrackLengthAllPoints(iT)     = totalTrackLengthAllPoints     / ...
                                           trackStatistics.detectedPoints(iT);
    trackStatistics                                                     ...
        .avgTrackLengthTrackedPoints(iT) = totalTrackLengthTrackedPoints / ...
                                           trackStatistics.trackedPoints(iT);

end