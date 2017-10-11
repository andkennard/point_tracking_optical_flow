function DefaultParams = defaultTrackingParameters()
%defaultTrackingParameters: load default parameters (defined in this file)

DefaultParams.preprocessImage       = @(x) x;
DefaultParams.detectPoints          = @detectMinEigenFeatures;
DefaultParams...
    .trackingMaxBidirectionalError  = uint8(     1);
DefaultParams.trackingBlockSizeVal  = uint32(   31);
DefaultParams.pointDensityThreshold = double(0.008);
DefaultParams.nRoisRows             = uint32(    8);
DefaultParams.nRoisColumns          = uint32(    8);
DefaultParams.pointUpdateDelay      = uint32(    5);
DefaultParams.pointUpdateInterval   = uint32(    4);
DefaultParams.trackMargin           = uint8(     0);
DefaultParams.alphaRadius           = double(   20);


end