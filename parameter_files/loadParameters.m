function [ Params, reader ] = loadParameters( csvFileName )
%loadParameters: Load parameters for point tracking, perform some
%consistency checking
Params = loadParametersFromCsv(csvFileName);

paramNameArray = fieldnames(Params);

end

