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
% - finalFrame: the final analyzed frame of the movie

fileId               = fopen(csvFileName);
headerLines          = textscan(fileId,'%s',2,'delimiter','\n');
fclose(fileId);

originalFieldNames   = strsplit(headerLines{1}{1},',');
originalDataTypes    = strsplit(headerLines{1}{2},',');
currentFieldNames    = fieldnames(Params);
addedFieldNames      = setdiff(currentFieldNames,originalFieldNames);

ParamsForWriting     = rmfield(Params,addedFieldNames);
fieldNamesForWriting = fieldnames(ParamsForWriting);
dataTypesForWriting  = cell(size(fieldNamesForWriting));

% Get the data type for each parameter in the reduced list
for n = 1:numel(fieldNamesForWriting)
    index                  = find(strcmp(fieldNamesForWriting{n},...
                                         originalFieldNames),1);
    dataTypesForWriting{n} = originalDataTypes{index};
end

fid = fopen(saveName,'w');
lineFormat = [repmat('%s,',1,numel(fieldNamesForWriting)),'%s,%s\n'];
%Write the field names
fprintf(fid,lineFormat,fieldNamesForWriting{:},'finalFrame','parameter_file');
%Write the datatypes
fprintf(fid,lineFormat,dataTypesForWriting{:},'f','s');

%Get the format specifier for all the parameter values
lineFormat = [];
for n = 1:numel(fieldNamesForWriting)
    valueToWrite = ParamsForWriting.(fieldNamesForWriting{n});
    dataType     = class(valueToWrite);
    switch dataType
        case 'char'
            nextSpecifier = '%s,';
        case 'datetime'
            nextSpecifier = '%s,';
            ParamsForWriting...
             .(fieldNamesForWriting{n})  = datestr(valueToWrite,'yyyy-mm-dd');
        otherwise
            nextSpecifier = '%d,';
    end
    lineFormat  = [lineFormat nextSpecifier];
end
lineFormat      = [lineFormat '%d,%s']; %add finalFrame and %parameter file at the end
paramValues     = struct2cell(ParamsForWriting);
%Print the parameter values
fprintf(fid,lineFormat,paramValues{:},finalFrame,csvFileName);

fclose(fid);
end
