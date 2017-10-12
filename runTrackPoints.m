function trackingResult = runTrackPoints(movieDatabase,...
                                         movieSelectionKey,...
                                         varargin)

if ~(isnumeric(movieSelectionKey) || iscellstr(movieSelectionKey))
    error('movieSelectionKey must be numeric or a cell array of strings');
end

ParamsArray = loadParameters(movieDatabase,movieSelectionKey);
%initialize struct (has to be in weird hacky way)
trackingResult = struct('reader',            [],...
                        'Params',            [],...
                        'TrackedPointStruct',[],...
                        'finalFrame',        []);
trackingResult(numel(ParamsArray)).finalFrame = 0;
     
for m = 1:numel(ParamsArray)
    
    Params = ParamsArray{m};
    reader = bfGetReader(fullfile(Params.inputPathName,...
                                  Params.inputFileName));
    
    trackingResult(m) = trackPoints(reader,Params);
    %%% Save the output somehow!!! %%%
    %Plot tracking Data
    disp('Plotting tracked points...')
    movieSavePrefix = createMovieSavePrefix(movieSelectionKey,m);
    movieSaveName   = sprintf('%s_tracked.tif',movieSavePrefix);
    plotTrackedPoints(trackingResult(m),movieSaveName);
    disp('done!')
end

