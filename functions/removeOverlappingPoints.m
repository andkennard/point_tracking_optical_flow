function coordinatesFiltered = removeOverlappingPoints(newCoordinates,oldCoordinates)
%removeOverlappingPoints - filter a set of new points that are too close to
%existing points. New points that are less than 1 pixel away from old
%points can be discarded.
[~,nearestNeighborDist] = knnsearch(oldCoordinates,newCoordinates);
coordinatesFiltered = newCoordinates(nearestNeighborDist>1,:);
end