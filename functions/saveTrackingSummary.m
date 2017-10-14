function saveTrackingSummary(saveName,TrackedPointStruct)
% saveTrackingSummary: save a table summarizing tracking data for each frame: 
% - detectedPoints:              how many points were detected
% - trackedPoints :              how many points were tracked
% - avgTrackLengthAllPoints:     average track length at that frame over all
%                                 detected points in that frame
% - avgTrackLengthTrackedPoints: average track length at that frame over
%                                 all points currently tracked in that frame

trackStatistics = calculateTrackStatistics(TrackedPointStruct);

statsTable      = struct2table(trackStatistics);
writetable(statsTable,saveName);
end