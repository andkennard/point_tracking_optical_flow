function saveTrackingData(TrackingResult,csvFileName,movieKey,varargin)
parser = inputParser;
addParameter(parser,'incrementSaveNames',1,...
             @(x)validateattributes(x,{'numeric','logical'},{'binary'}));
parse(parser,varargin{:});
incrementSaveNames = parser.Results.incrementSaveNames;

% Unpack trackingResult
TrackedPointStruct = TrackingResult.TrackedPointStruct;
Params             = TrackingResult.Params;
finalFrame         = TrackingResult.finalFrame;

saveDirectory      = Params.outputPathName;
if incrementSaveNames
    moviePrefix = generateSaveNamePrefix(saveDirectory,...
                                         movieKey);
else
    moviePrefix = movieKey;
end

%% Save the tracking data itself
dataSaveName = fullfile(saveDirectory,...
                        sprintf('%s_trackingData.mat',moviePrefix));
save(dataSaveName,'TrackingResult');

%% Save a human-readable form of the Params
paramsSaveName = fullfile(saveDirectory,...
                          sprintf('%s_parameterValues.csv',moviePrefix));
saveParameterValues(paramsSaveName,Params,finalFrame,csvFileName);

%% Save a frame-by-frame summary of the tracking data
summarySaveName = fullfile(saveDirectory,...
                           sprintf('%s_trackingSummary.csv',moviePrefix));
saveTrackingSummary(summarySaveName,TrackedPointStruct);

%% Save a movie of the tracking results
disp('plotting tracking data...')
plottingSaveName = fullfile(saveDirectory,...
                            sprintf('%s_plotTrackingResult.tif',moviePrefix));
plotTrackedPoints(plottingSaveName,TrackingResult);

end
