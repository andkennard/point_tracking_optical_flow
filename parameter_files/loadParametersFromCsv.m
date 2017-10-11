function Params = loadParametersFromCsv(csvFilename)
% loadParametersFromCsv: Get tracking parameters from CSV database
% Conver the header names of the CSV into field names of a struct array.
% Header fields are dynamically grabbed from the CSV file. 
% CSV file format:
% - The first row of the CSV contains the header names which will become 
%   the field names. 
% - The second row contains the string of the format specified (e.g. s or u
%   for the data in that column, which will be parsed by textscan)

fileId = fopen(csvFilename);

% Read the first line to get the field names
headerLines            = textscan(fileId,'%s',2,'delimiter','\n');
fieldNameArray         = strsplit(headerLines{1}{1},',');
formatSpecifierArray   = strsplit(headerLines{1}{2},',');
formattingString       = '';

for k = 1:numel(formatSpecifierArray)
    formattingString   = [formattingString, ...
                          sprintf('%%%s',formatSpecifierArray{k})];
end

% Read the rest of the data with the formatting string
csvData = textscan(fileId,formattingString,'delimiter',',');

% Some entries may be regular arrays here, convert all to cell arrays to
% facilitate conversion to struct later.
for k = 1:numel(csvData)
    if ~iscell(csvData{k})
        csvData{k}     = num2cell(csvData{k});
    end
end
%Expand from 1xM cell array of cell arrays to NxM cell array
csvDataExpanded = [csvData{:}];
Params          = cell2struct(csvDataExpanded,fieldNameArray,2);