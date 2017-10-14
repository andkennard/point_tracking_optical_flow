function TrackingResultArray = runTrackPoints(movieDatabase,...
                                         movieKeyArray,...
                                         varargin)
parser = inputParser;
addRequired(parser,'movieKeyArray',...
    @(x)validateattributes(x,{'numeric','cell'},{'nonempty'}));
addParameter(parser,'finalFrame',0,...
    @(x)validateattributes(x,{'numeric'},{'scalar','nonnegative'}));
parse(parser,movieKeyArray,varargin{:});
finalFrame = parser.Results.finalFrame;
if ~(isnumeric(movieKeyArray) || iscellstr(movieKeyArray))
    error('movieSelectionKey must be numeric or a cell array of strings');
end

ParamsArray = loadParameters(movieDatabase,movieKeyArray);

trackingResultBlank      = struct('reader',            [],...
                                  'Params',            [],...
                                  'TrackedPointStruct',[],...
                                  'finalFrame',        []);
TrackingResultArray = cell(numel(ParamsArray),1);
[TrackingResultArray{:}] = deal(trackingResultBlank);
     
for m = 1:numel(ParamsArray)
    displayStringForTracking = sprintf('Tracking data set %i',m);
    disp(displayStringForTracking);
    
    Params = ParamsArray{m};
    reader = bfGetReader(fullfile(Params.inputPathName,...
                                  Params.inputFileName));
    
    TrackingResultArray{m}  = trackPoints(reader,Params,finalFrame);
    %Save data
    movieKey = getSingleMovieKey(movieKeyArray,m);
    disp('Saving data...')
    saveTrackingData(TrackingResultArray{m},movieDatabase,movieKey);
    
    %Plot result of tracking data
    disp('Plotting tracked points...')
    plotTrackedPoints(TrackingResultArray{m},movieKey);
    disp('done!')
end

