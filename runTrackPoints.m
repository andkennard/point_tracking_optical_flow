function TrackingResultArray = runTrackPoints(movieDatabase,...
                                         movieKeyArray,...
                                         varargin)
parser = inputParser;
addRequired(parser,'movieKeyArray',...
    @(x)validateattributes(x,{'numeric','cell'},{'nonempty'}));
addParameter(parser,'finalFrame',0,...
    @(x)validateattributes(x,{'numeric'},{'scalar','nonnegative','integer'}));
parse(parser,movieKeyArray,varargin{:});
finalFrame = parser.Results.finalFrame;


ParamsArray = loadParameters(movieDatabase,movieKeyArray);

trackingResultBlank      = struct('reader',            [],...
                                  'Params',            [],...
                                  'TrackedPointStruct',[],...
                                  'finalFrame',        []);
% initialize container for tracking results
TrackingResultArray      = cell(numel(ParamsArray),1);
[TrackingResultArray{:}] = deal(trackingResultBlank);
     
for m = 1:numel(ParamsArray)
    displayStringForTracking = sprintf('Tracking data set %i',m);
    disp(displayStringForTracking);
    
    Params                   = ParamsArray{m};
    reader                   = bfGetReader(fullfile(Params.inputPathName,...
                                                    Params.inputFileName));
    
    TrackingResultArray{m}   = trackPoints(reader,Params,finalFrame);
    % Save data
    movieKey                 = getSingleMovieKey(movieKeyArray,m);
    disp('Saving data...')
    saveTrackingData(TrackingResultArray{m},movieDatabase,movieKey);
    
    % Plot result of tracking data
    disp('done!')
end

