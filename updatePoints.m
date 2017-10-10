function newPointStruct = updatePoints(oldPointStruct,frame,Params)
    
    [sizeY,sizeX] = size(frame);
    newPointStruct = struct('coordinates',[],...
                            'isTracked',  [],...
                            'ID',         []);

    roiSizeX = floor(sizeX/Params.nRois(2));
    roiSizeY = floor(sizeY/Params.nRois(1));
    
    coordinatesArray  = oldPointStruct.coordinates;
    isTracked         = oldPointStruct.isTracked;
    idArray           = oldPointStruct.ID;
    if Params.trackMargin
        isMargin      = oldPointStruct.isMargin;
    end

    trackedCoordinatesArray =  coordinatesArray(isTracked,:);
    
    %Generate an alpha shape for the margin points in this frame.
    if Params.trackMargin
        marginShape = alphaShape(coordinatesArray(isMargin,:),...
                                 Params.alphaRadius);
    end
    %{
    %Update allismargin to include points that may now be on the margin
    isMargin = inShape(marginShape,coordinatesArray);
    end
    %}
    

    %Compute point density by dividing by the bin area (in pixels)
    pointDensityPerRoi = calculatePointDensityInGrid(trackedCoordinatesArray,...
                                                     size(frame),...
                                                     [roiSizeY,roiSizeX]);
    
    %Identify which ROIs need more points generated
    needMorePoints  = find(pointDensityPerRoi < Params.pointDensityThreshold);
    %%
    for k = 1:numel(needMorePoints);
        coordinatesArrayNewPoints = detectNewPointsInRoi(frame,              ...
                                                         needMorePoints(k),  ...
                                                         Params);
        if ~isempty(coordinatesArrayNewPoints) %Some points must have been generated first!
            assert(isa(coordinatesArrayNewPoints,'double'),...
                   sprintf('newpts is of type %s',...
                           class(coordinatesArrayNewPoints)));

            [nNewPoints, ~]  = size(coordinatesArrayNewPoints);
            idArrayNewPoints = generateNewPointIds(max(idArray),nNewPoints);
            %Append new point info to existing arrays
            coordinatesArray = [coordinatesArray ; coordinatesArrayNewPoints];
            %All new points are tracked initially
            isTracked        = [isTracked ;        true(nNewPoints,1)];
            idArray          = [idArray ;          idArrayNewPoints];
            %Check if points are in the margin
            if Params.trackMargin
                isMarginNewPoints = inShape(marginShape,...
                                            coordinatesArrayNewPoints);
                isMargin     = [isMargin ;         isMarginNewPoints];
            end
        end
    end
    
    [coordinatesArrayInBounds,...
     isTrackedInBounds]           = correctOutOfBoundPts(coordinatesArray,...
                                                         isTracked,       ...
                                                         size(frame));
    newPointStruct.coordinates  = coordinatesArrayInBounds;
    newPointStruct.isTracked    = isTrackedInBounds;
    newPointStruct.ID           = idArray;
    %Update is_margin (once is_margin is implemented)
    if Params.trackMargin
        newPointStruct.isMargin = isMargin;
    end
end    