pathname = 'input';
filename = '20x_1xopt_Wounding_fish_2_Max.tif';
%[filename,pathname] = uigetfile('*.tif','Tiff Files');

fname = fullfile(pathname,filename);

reader = bfGetReader(fname);

%%
params.num_bins = [8,8];
params.preprocess_func = @trackingImPreprocessBackgroundSub;
params.MaxBidirectionalError = 1;
params.BlockSize = [41,41];
params.track_margin = 1;
params.init_margin_mask = imread(fullfile(pathname,'Margin_Mask.tif'));
params.testing_stop_frame = 0;
params.point_update_delay = 4;
params.point_density_thresh = 0.008;
params.point_update_interval = 4;
params.alphaParam = 20;
params.pixelSize = 0.7; %in µm
params.timeStep = 30; %in seconds
params.dataPath = pathname;
params.dataFile = filename;

all_points = trackPoints(reader,params);
disp(sum(all_points(40).validity))
%%
save(fullfile(params.dataPath,'tracking_data'),'all_points','params');
disp('Saving tracking movie...')
im_filename = initAppendFile(fullfile(params.dataPath,'im_tracked.tif'));
sizeT = reader.getSizeT();
for iT = 1:sizeT
    im = bf_getFrame(reader,1,1,iT);
    im = double(trackingImPreprocessBackgroundSub(im));
    im = uint8((255/(max(im(:)) - min(im(:)))) * (im - min(im(:))));
    goodpts_interior = all_points(iT).coords(all_points(iT).validity & ~all_points(iT).is_margin,:);
    goodpts_margin   = all_points(iT).coords(all_points(iT).validity &  all_points(iT).is_margin,:);
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
    goodpts = all_points(iT).coords(all_points(iT).validity,:);
    im_marked = insertMarker(im,goodpts,'+','Color','Yellow');
    imwritemulti(im_marked,im_tracked_filename);
end