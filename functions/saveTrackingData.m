function plotFormatSpecs = saveTrackingData(TrackingResult,csvFileName,movieKey,varargin)
parser = inputParser;
addParameter(parser,'incrementSaveNames',     1,                       ...
             @(x)validateattributes(x,{'numeric','logical'},           ...
                                      {'binary'}));
                                  
addParameter(parser,'plotFormatSpecs',       {},                       ...
             @(x)iscell(x));
         
addParameter(parser,'plotMarginFormatSpecs', {},                       ...
             @(x)iscell(x));
         
parse(parser,varargin{:});
incrementSaveNames    = parser.Results.incrementSaveNames;
plotFormatSpecs       = parser.Results.plotFormatSpecs;
plotMarginFormatSpecs = parser.Results.plotMarginFormatSpecs;

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

%% Save a matrix of the coordinates
coordinateArraySaveName = fullfile(saveDirectory,...
                           sprintf('%s_coordinateArray.mat',moviePrefix));
coordinateArray         = TrackingResult.coordinateArray;
if Params.trackMargin
    marginCoordinateArray   = TrackingResult.marginCoordinateArray;
    save(coordinateArraySaveName,'coordinateArray','marginCoordinateArray');
else
    save(coordinateArraySaveName,'coordinateArray');
end

%% Save a movie of the tracking results
disp('plotting tracking data...')
plottingSaveName = fullfile(saveDirectory,...
                            sprintf('%s_plotTrackingResult.tif',moviePrefix));
if Params.trackMargin
    plotTrackedPointsWithMargin(plottingSaveName,TrackingResult,        ...
                                'plotFormatSpecs',      plotFormatSpecs,...
                                'plotMarginFormatSpecs',plotMarginFormatSpecs);
else
    plotTrackedPoints(plottingSaveName,TrackingResult,...
                      'plotFormatSpecs',plotFormatSpecs);


end
