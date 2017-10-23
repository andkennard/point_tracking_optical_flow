function plotFormatSpecs=plotTrackedPointsWithMargin(saveMovieFileName,...
                                     trackingResult,...
                                     varargin)
% plotTrackedPointsWithMargin: overlay points from point tracking onto the 
% movie they were tracked from, distinguishing margin and interior points.
%
% Input:
% - trackingResult: output from trackPoints. Structure with three fields:
%                   * reader: Bio-Formats reader for I/O of input file
%                   * Params: struct of parameters for the particular movie
%                   * finalFrame: last frame that was used for tracking in
%                                 the movie
%                   * TrackedPointStruct: Tracking data for the points 
%                                          across the whole movie
%
% - movieFileName : savename for the resulting output movie. Will be saved
%                   in the output directory specified in Params.
% 
% - plotFormatSpecs: (optional) Provide formatting instructions to the
%                   insertMarker command used to generate each frame of the
%                   movie. Include a cell array of the arguments that would
%                   be passed in to format insertMarker 
%                   (e.g. {'+','Color','Green','Size',10})
% - plotMarginFormatSpecs: (optional) Like plotFormatSpecs, but provides
%                   instructions on how to plot the margin points

%Unpack trackingResult
reader              = trackingResult.reader;
Params              = trackingResult.Params;
finalFrame          = trackingResult.finalFrame;
TrackedPointStruct  = trackingResult.TrackedPointStruct;

assert(logical(Params.trackMargin),['Error: this function requires that ',...
'margin tracking was turned on for this dataset.'])

%Get optional specifications for formatting the markers
parser         = inputParser;
addParameter(parser,'plotFormatSpecs',      {'Color','Green'},@(x)iscell(x));
addParameter(parser,'plotMarginFormatSpecs',{'Color','Blue'} ,@(x)iscell(x));
parse(parser,varargin{:});
plotFormatSpecs       = parser.Results.plotFormatSpecs;
plotMarginFormatSpecs = parser.Results.plotMarginFormatSpecs;

for iT = 1:finalFrame
    frame = bf_getFrame(reader,1,1,iT);
    frame = double(Params.preprocessImage(frame));
    frame = uint8((255/(max(frame(:)) - min(frame(:)))) * (frame - min(frame(:))));
    
    trackedInteriorPointArray = TrackedPointStruct(iT).coordinates(...
                                TrackedPointStruct(iT).isTracked & ...
                               ~TrackedPointStruct(iT).isMargin, : );
                           
    trackedMarginPointArray   = TrackedPointStruct(iT).coordinates(...
                                TrackedPointStruct(iT).isTracked & ...
                                TrackedPointStruct(iT).isMargin, : );
                         
    frameMarked = insertMarker(frame,                              ...
                               trackedInteriorPointArray,          ...
                               plotFormatSpecs{:});
                           
    frameMarked = insertMarker(frameMarked,                        ...
                               trackedMarginPointArray,            ...
                               plotMarginFormatSpecs{:});
                           
    imwritemulti(frameMarked,saveMovieFileName);
end