Params = loadTestMovie_20170707_fish_2();
%%

trackedPointStruct = trackPoints(reader,Params);
disp(sum(trackedPointStruct(40).isTracked))
%%
save(fullfile(params.dataPath,'tracking_data'),'all_points','params');
disp('Saving tracking movie...')
im_filename = initAppendFile(fullfile(params.dataPath,'im_tracked.tif'));
sizeT = reader.getSizeT();
for iT = 1:sizeT
    im = bf_getFrame(reader,1,1,iT);
    im = double(trackingImPreprocessBackgroundSub(im));
    im = uint8((255/(max(im(:)) - min(im(:)))) * (im - min(im(:))));
    goodpts_interior = trackedPointStruct(iT).coords(trackedPointStruct(iT).validity & ~trackedPointStruct(iT).is_margin,:);
    goodpts_margin   = trackedPointStruct(iT).coords(trackedPointStruct(iT).validity &  trackedPointStruct(iT).is_margin,:);
    im_marked = insertMarker(im,goodpts_interior,'+','Color','Green');
    im_marked = insertMarker(im_marked,goodpts_margin,'+','Color','Blue');
    imwritemulti(im_marked,im_filename);
end

%%
im_tracked_filename = initAppendFile('im_tracked.tif');
for iT = 1:50
    im = bf_getFrame(reader,1,1,iT);
    im = double(trackingImPreprocess(im));
    im = uint8((255/(max(im(:)) - min(im(:)))) * (im - min(im(:))));
    goodpts = trackedPointStruct(iT).coords(trackedPointStruct(iT).validity,:);
    im_marked = insertMarker(im,goodpts,'+','Color','Yellow');
    imwritemulti(im_marked,im_tracked_filename);
end