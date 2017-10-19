function plotTrackedPoints(saveMovieFileName,...
                           trackingResult,...
                           varargin)
% plotTrackedPoints: overlay points from point tracking onto the movie that
% they were tracked from. 
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
% - FormattingSpec: (optional) Provide formatting instructions to the
%                   insertMarker command used to generate each frame of the
%                   movie. Include a cell array of the arguments that would
%                   be passed in to format insertMarker 
%                   (e.g. {'+','Color','Green','Size',10})

%Unpack trackingResult
reader              = trackingResult.reader;
Params              = trackingResult.Params;
finalFrame          = trackingResult.finalFrame;
TrackedPointStruct  = trackingResult.TrackedPointStruct;

if numel(varargin)>0
    plotFormatSpecs = varargin{1};
else %default formatting of markers
    plotFormatSpecs = {'+','Color','Green'};
end

for iT = 1:finalFrame
    frame = bf_getFrame(reader,1,1,iT);
    frame = double(Params.preprocessImage(frame));
    frame = uint8((255/(max(frame(:)) - min(frame(:)))) * (frame - min(frame(:))));
    
    if isfield(TrackedPointStruct,'isMargin')
        trackedPointArray = TrackedPointStruct(iT).coordinates(...
                            TrackedPointStruct(iT).isTracked & ...
                           ~TrackedPointStruct(iT).isMargin,:);
    else
        trackedPointArray = TrackedPointStruct(iT).coordinates(...
                            TrackedPointStruct(iT).isTracked,:);
    end
                         
    frameMarked = insertMarker(frame,                    ...
                               trackedPointArray,...
                               plotFormatSpecs{:});
                           
    imwritemulti(frameMarked,saveMovieFileName);
end