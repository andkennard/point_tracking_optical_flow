function [nTrajectories, ...
          nFrames]          = findCoordinateArrayDimensions(TrackedPointStruct)
      
    nTrajectories = max(   TrackedPointStruct(end).ID);
    nFrames       = length(TrackedPointStruct        );
end