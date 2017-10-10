function [Params,reader] = loadData()
%Load data for test movie. Copy this function and modify for other
%datasets. Data parameters can be changed from defaults if necessary.

Params = Defaults();

%% Basic movie information
%Path to movie location
Params.pathName = 'input';
Params.fileName = '20x_1xopt_Wounding_fish_2_Max.tif';

%Specify a Bio-formats reader for the data and some metadata
reader                      = bfGetReader(fullfile(Params.pathName,...
                                                   Params.fileName));
omeMetadata                 = reader.getMetadataStore();
Params.PixelSizeMicrons     = omeMetadata.getPixelsPhysicalSizeX(0)...
                                         .value()...
                                         .doubleValue();
Params.MovieTimestepSeconds = omeMetadata.getPixelsTimeIncrement(0)...
                                         .value()...
                                         .doubleValue();
% Specify the margin mask file
if Params.trackMargin
    Params.initialMarginMask = imread(fullfile(Params.pathName,...
                                  'Margin_Mask.tif'));
end