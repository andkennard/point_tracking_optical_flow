%function saveTrackingData(trackingResult,csvFileName)

% Unpack trackingResult
TrackedPointStruct = trackingResult.TrackedPointStruct;
Params             = trackingResult.Params;
reader             = trackingResult.Reader;
finalFrame         = trackingResult.finalFrame;

saveDirectory      = Params.outputPathName;

%% Save a human-readable form of the Params
fileId               = fopen(csvFileName);
headerLine           = textscan(fileId,'%s',1,'delimiter','\n');
fclose(fileId);

originalFieldNames   = strsplit(headerLine{1}{1},',');
currentFieldNames    = fieldnames(Params);
addedFieldNames      = setdiff(currentFieldNames,originalFieldNames);

ParamsForWriting     = rmfield(Params,addedFieldNames);
fieldNamesForWriting = fieldnames(ParamsForWriting);
% Find the largest string length
fieldNameLength      = max(cellfun(@(a)numel(a),...
                           fieldNamesForWriting)) + 3;
fid = fopen('testWrite.txt','w');
for k = 1:numel(fieldNamesForWriting)
    valueToWrite = Params.(fieldNamesForWriting{k});
    dataType = class(valueToWrite);
    
    switch dataType
        case 'char'
            formatSpecifier = 's';
        case 'datetime'
            formatSpecifier = 's';
            valueToWrite      = datestr(valueToWrite,'yyyy-mm-dd');
        otherwise
            formatSpecifier = 'd';
    end
    
    formatString = sprintf('%%-%is%%%s\n',fieldNameLength,formatSpecifier);
    %lineToWrite  = sprintf(formatString,fieldNamesForWriting{k},valueToWrite);
    fprintf(fid,formatString,fieldNamesForWriting{k},valueToWrite);
end
formatString = sprintf('%%-%is%%d',fieldNameLength);
fprintf(fid,formatString,'finalFrame',finalFrame);
fclose(fid);
