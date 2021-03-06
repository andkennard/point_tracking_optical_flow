function trackingResult = trackPoints(reader,Params,varargin)
%%% Track points

%Initialize stuff
sizeT         = reader.getSizeT();
waitbarHandle = waitbar(0,'Initializing tracking...');

[tracker,TrackedPointStruct] = initializePointTracking(reader,Params);
%%
%For testing purposes, choose an earlier point than the end of the movie to
%stop.
parser = inputParser;
addOptional(parser,'finalFrame',sizeT,...
            @(x)validateattributes(x,{'numeric'},...
                                     {'nonnegative','integer','scalar'}));
parse(parser,varargin{:});
finalFrame = parser.Results.finalFrame;
if finalFrame == 0;
    finalFrame = sizeT;
elseif finalFrame >= sizeT
    warning(['finalFrame was larger than the movie length; '...
             'using movie length instead']);
    finalFrame = sizeT;
end


%LOOP THROUGH MOVIE
for iT = 2:finalFrame
    try
    progress = iT / finalFrame;
    waitbar(progress,waitbarHandle,...
            sprintf('Tracking frames, %d%% completed...',progress*100));
    [tracker,...
     TrackedPointStruct,...
     thisFramePreprocessed] = performPointTracking(tracker,           ...
                                                   TrackedPointStruct,...
                                                   reader,            ...
                                                   Params,            ...
                                                   iT);
        
    %Update the list of points periodically (but wait a bit to avoid very
    %high point densities that confuse tracking)
    updateRequired =    (iT > Params.pointUpdateDelay) && ...
                     mod(iT,Params.pointUpdateInterval) == 0;
    if updateRequired       
       TrackedPointStruct(iT) = updatePoints(TrackedPointStruct(iT),  ...
                                thisFramePreprocessed,Params);
       setPoints(tracker,single(TrackedPointStruct(iT).coordinates),  ...
                                TrackedPointStruct(iT).isTracked);
    end
    
    catch errorMessage
        close(waitbarHandle)
        rethrow(errorMessage)
        
    end
end
close(waitbarHandle)

trackingResult.TrackedPointStruct = TrackedPointStruct;
trackingResult.Params             = Params;
trackingResult.reader             = reader;
trackingResult.finalFrame         = finalFrame;

if Params.trackMargin
    [interiorCoordinateArray,...
     marginCoordinateArray] = makeCoordinateArrayWithMargin(TrackedPointStruct);
    trackingResult.coordinateArray       = interiorCoordinateArray;
    trackingResult.marginCoordinateArray = marginCoordinateArray;
else
    trackingResult.coordinateArray = makeCoordinateArray(TrackedPointStruct);
end

end
       
        
    

