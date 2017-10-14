function movieSaveNamePrefix = generateSaveNamePrefix(outputDirectory, ...
                                                      movieId,varargin)
% generateSaveNamePrefix: create unique prefix for output files
parser = inputParser;
% outputDirectory
existsAsDirectory = @(x) logical(exist(x,'dir'));
addRequired(parser,'outputDirectory',existsAsDirectory);
% runDescriptor: Way of describing different runs of the tracking algorithm
% in the filename
addParameter(parser,'runDescriptor','trackingRun',...
             @(x)ischar(x));

parse(parser,outputDirectory,varargin{:});

outputDirectory      = parser.Results.outputDirectory;
runDescriptor        = parser.Results.runDescriptor;

%Parse movieId in a different way
if isnumeric(movieId)
    movieName        = sprintf('movie_%03g',movieId);
elseif ischar(movieId)
    movieName        = movieId;
elseif isdatetime(movieId)
    movieName        = sprintf('movie_%s',datestr(movieId,'yyyy-mm-dd'));
else
    error('movieId must be numeric or string!');
end

fileList             = dir(outputDirectory);
fileNameList         = {fileList.name};
trackingRunIndex     = 0;
candidatePrefix      = sprintf('%s_%s%03i',movieName,                  ...
                                           runDescriptor,              ...
                                           trackingRunIndex);
                                  
fileHasPrefix        = checkPrefixForMatches(candidatePrefix,fileNameList);

while any(fileHasPrefix)
    trackingRunIndex = trackingRunIndex + 1;
    candidatePrefix  = sprintf('%s_%s%03i',movieName,                  ...
                                           runDescriptor,              ...
                                           trackingRunIndex);
                                       
    fileHasPrefix    = checkPrefixForMatches(candidatePrefix,fileNameList);
end

movieSaveNamePrefix  = candidatePrefix;
end

function hasPrefix = checkPrefixForMatches(candidatePrefix,fileNameList)
% checkPrefixForMatches: Check a test prefix against the list of files in
% the target directory to see if any files with that prefix already exists.
% Return a Nx1 logical array (for N files in the target directory) 
% 1 if that file has the same prefix
% 0 if that files prefix doesn't match

%Look only from start of filename
candidatePrefixRegExp = sprintf('^%s',candidatePrefix);

namesMatchingPrefix   = regexp(fileNameList,candidatePrefixRegExp);

hasPrefix             = cellfun(@(x) ~isempty(x),namesMatchingPrefix);

end


 


