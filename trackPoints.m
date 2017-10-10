function TrackedPointStruct = trackPoints(reader,Params)
%%% Track points

%Initialize stuff
sizeT         = reader.getSizeT();
waitbarHandle = waitbar(0,'Initializing...');

[tracker,TrackedPointStruct] = initializePointTracking(reader,Params);
%%
%For testing purposes, choose an earlier point than the end of the movie to
%stop.
if (Params.finalFrameForTesting > 0)
    finalFrame = Params.finalFrameForTesting;
else
    finalFrame = sizeT;
end

%LOOP THROUGH MOVIE
for iT = 2:finalFrame
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
       disp(iT)       
       TrackedPointStruct(iT) = updatePoints(TrackedPointStruct(iT),...
                                thisFramePreprocessed,Params);
       setPoints(tracker,single(TrackedPointStruct(iT).coordinates),...
                                TrackedPointStruct(iT).isTracked);
    end
end
close(waitbarHandle)
end
       
        
    

