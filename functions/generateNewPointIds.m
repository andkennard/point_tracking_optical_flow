function idArrayNewPoints = generateNewPointIds(oldMaxId,nNewPoints)
% updatePointIds - generate a range of new point IDs given last old ID

firstNewId = oldMaxId + 1;
lastNewId  = firstNewId + nNewPoints - 1;
idArrayNewPoints = uint32((firstNewId:lastNewId)');
end
