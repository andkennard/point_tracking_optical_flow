[Params,reader] = loadTestMovie_20170707_fish_2();


trackedPointStruct = trackPoints(reader,Params);
disp(sum(trackedPointStruct(40).isTracked))
%%
%save(fullfile(params.dataPath,'tracking_data'),'all_points','params');
%disp('Saving tracking movie...')
saveMovieFilename = initAppendFile(fullfile('output','im_tracked_keeptooclosepoints.tif'));
sizeT = reader.getSizeT();
for iT = 1:sizeT
    frame = bf_getFrame(reader,1,1,iT);
    frame = double(preprocessImageWithBackgroundSubtraction(frame));
    frame = uint8((255/(max(frame(:)) - min(frame(:)))) * (frame - min(frame(:))));
    
    trackedInteriorPointArray = trackedPointStruct(iT).coordinates(...
                                trackedPointStruct(iT).isTracked & ...
                               ~trackedPointStruct(iT).isMargin,:);
                  
    trackedMarginPointArray   = trackedPointStruct(iT).coordinates(...
                                trackedPointStruct(iT).isTracked &...
                                trackedPointStruct(iT).isMargin,:);
                            
    frameMarked = insertMarker(frame,                    ...
                               trackedInteriorPointArray,...
                               '+',                      ...
                               'Color','Green');
    frameMarked = insertMarker(frameMarked,              ...
                               trackedMarginPointArray,  ...
                               '+',                      ...
                               'Color','Blue');
    imwritemulti(frameMarked,saveMovieFilename);
end

%%
im_tracked_filename = initAppendFile('im_tracked.tif');
for iT = 1:50
    frame = bf_getFrame(reader,1,1,iT);
    frame = double(trackingImPreprocess(frame));
    frame = uint8((255/(max(frame(:)) - min(frame(:)))) * (frame - min(frame(:))));
    goodpts = trackedPointStruct(iT).coords(trackedPointStruct(iT).validity,:);
    frameMarked = insertMarker(frame,goodpts,'+','Color','Yellow');
    imwritemulti(frameMarked,im_tracked_filename);
end