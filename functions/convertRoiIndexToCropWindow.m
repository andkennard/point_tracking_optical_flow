function cropWindow = convertRoiIndexToCropWindow(gridSize,edgesX,edgesY,roiLinearIndex)
%%% BININD2PIXELcrop Get Pixel crop window (xy) from linear bin index.
%%% Similar to ind2sub, convert from the linear index of a
%%% binned image into the XY pixel coordinates of the image. 
%%% Further convert that to a crop window [x y width height] used by
%%% imcrop.
%%% Inputs
%%% bin_sz: [bin_siz_y bin_sz_x] 1x2 vector indicating the dimensions of
%%% the bin grid
%%% edges: vectors of the starting coordinates of the bins (NB: they may start
%%% at 0); the last entry is the ending coordinate of the last bin
%%% iB: the linear bin index (row-column style) that needs to be converted
%%% to two bin indices.

% Error handling
assert(roiLinearIndex<=gridSize(1) * gridSize(2),'bin index lies outside bin_size range');


%edges are for assuming continuous space values ranging from e.g. 0 to
%sizeX-1, while for imcropping you need discrete 1-based indexing. This
%requires some transformation of the edges: everything increases by 1
%except the last index.

edgesX(1:end-1) = edgesX(1:end-1) + 1;

edgesY(1:end-1) = edgesY(1:end-1) + 1;


%Convert linear index into subscripts (for the bins)
[roiIndexY,roiIndexX] = ind2sub(gridSize,roiLinearIndex);

%Get the dimensions of the crop window from the edge lines (remember
%bin k goes from edge(k)<= bin(k) < edge(k+1)
iX     = edgesX(roiIndexX    );
width  = edgesX(roiIndexX + 1) - iX - 1;
iY     = edgesY(roiIndexY    );
height = edgesY(roiIndexY + 1) - iY - 1;

cropWindow = [iX iY width height];
