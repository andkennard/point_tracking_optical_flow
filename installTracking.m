function installTracking()
% installTracking: check for required components and add the tracking
% folder to your path

% Ensure you are in the directory of the install file.
homePath = fileparts(which(mfilename));

oldPath  = path;
%Check for Bioformats
if isempty(strfind(oldPath,'bfmatlab'))
    error(['Error: Bioformats MATLAB Toolbox (bfmatlab) was not found in the path. '...
           'Please add the Bioformats MATLAB Toolbox to the path or download '...
           'bfmatlab.zip from http://downloads.openmicroscopy.org/bio-formats/'...
           'and add it to your path.']);
end

if isempty(strfind(oldPath,homePath))
    disp('Adding point tracking directory to MATLAB path...')
    addpath(homePath);
    addpath(fullfile(homePath,'functions'));
end
savepath
disp('done!')


           