function [framePreprocessed,...
          frameBinaryMask] = preprocessImageWithBackgroundSubtraction(frame)
%%% Pre-process images with background subtraction
%%% Filter images to enhance contrast, and also remove the background
%%% (which includes small features that can screw up the point detector).
%%% Background subtraction is done by splitting the image into blocks and
%%% identifying blocks with low variance. The 99th percentile of grayscale
%%% intensity in these 'background blocks' is used as a background value.
BLOCK_SIZE = 64;
STD_THRESH = 200;
MEAN_THRESH = min(frame(:)); %im2col zero-pads, which can affect the mean and variance within a block
BKGD_QUANTILE = 0.99;
GAMMA_SCALE = 0.5; %Should be less than 1
SMALL_REGION_CUTOFF = 10^4;

frame = double(frame);

%Median filter to remove hot spots
frameMedianFiltered = medfilt2(frame,[3,3],'symmetric');

%Identify background level
frameInColumns = im2col(frameMedianFiltered,[BLOCK_SIZE,BLOCK_SIZE],'distinct');
blockStDev     = std(frameInColumns);
blockMean      = mean(frameInColumns);

isBackground                   = blockStDev < STD_THRESH & ...
                                 blockMean >= MEAN_THRESH;
backgroundBlocks               = frameInColumns(:,isBackground);
backgroundGrayscaleThreshold   = quantile(backgroundBlocks(:),BKGD_QUANTILE);

%Background subtract
frameBackgroundSubtracted = frame - backgroundGrayscaleThreshold;
frameBackgroundSubtracted(frameBackgroundSubtracted < 0) = 0;
%Convert back to 16-bit
frameForeground16bit = uint16((65535/max(frameBackgroundSubtracted(:))) *...
                              frameBackgroundSubtracted);
%Gamma-adjustment condenses the foreground pixels and spreads out the
%remaining background pixels for better thresholding with Otsu's method
frameForegroundGammaCorrected = imadjust(frameForeground16bit,...
                                         [0,1],...
                                         [0,1],...
                                         GAMMA_SCALE);

%Threshold the image (Otsu) and clean up the mask
frameBinaryMask = im2bw(frameForegroundGammaCorrected,...
                        graythresh(frameForegroundGammaCorrected));
%Remove holes inside the mask             
frameBinaryMask = imfill(frameBinaryMask,'holes'); 
%Clean the edge
frameBinaryMask = imopen(frameBinaryMask,strel('disk',3)); 
%Remove any small spurious regions
frameBinaryMask = bwareaopen(frameBinaryMask,SMALL_REGION_CUTOFF); 
%Mask the processed 16-bit image
frameForegroundMasked = frameForeground16bit;
frameForegroundMasked(~frameBinaryMask) = 0;

%Adaptive histogram equalization to increase contrast within the foreground
framePreprocessed = adapthisteq(frameForegroundMasked);
%Apparently adapthisteq also will move 0 values upwards. Correct for this
%again...
framePreprocessed(~frameBinaryMask) = 0;

end