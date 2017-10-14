function saveParameterValues(saveName,Params,finalFrame,csvFileName)
% saveParameterValues: save the parameter values for the current run in a
% human-readable format. Exclude parameters that are directly inferrable
% from simpler ones (e.g. don't save nRois since you're saving nRoisRows
% and nRoisColumns already)
% Input:
% - Params: a valid Params struct
% - csvFileName: Path to the database where all the params are stored (used
%                to get headers
% - saveName: filename (with appropriate path) to save the data

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

fid = fopen(saveName,'w');
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

    fprintf(fid,formatString,fieldNamesForWriting{k},valueToWrite);
end
formatString = sprintf('%%-%is%%d',fieldNameLength);
fprintf(fid,formatString,'finalFrame',finalFrame);
fclose(fid);
end
