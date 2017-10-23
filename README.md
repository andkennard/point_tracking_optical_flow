## Description

This code is a tool to track flow in microscopy movies via optical flow, specifically using the 
Lucas-Kanade algorithm. This algorithm is good at detecting flow that is locally uniform, i.e. 
vectors in a region tend to point in the same direction. It is not good for tracking diffusive-like 
motion where points move substantially in random directions from frame to frame.

I also put some work into making the algorithm generate good logs/documentation to ensure reproducible 
results. This requires a few simple steps to set up organization of your data, but will hopefully pay off later on.

## Requirements

* MATLAB with the Image Processing Toolbox: it runs fine on 2014b. I haven't tested on older versions 
but I think it should be compatible with a few previous versions as well.
* Bio-Formats plugin for MATLAB (`bfmatlab`): Can be downloaded from 
[here](https://www.openmicroscopy.org/bio-formats/downloads/).
The image movies that you use should also be compatible with being imported using Bio-Formats.

## Installation

1. Clone the repository or download all the files into the directory of choice

2. Move into the directory and run `installTracking.m`. This will check for the 
required programs and add the relevant folders to your MATLAB path.

3. The tracking should be ready to use!


## Basic Usage

1. Set up a CSV file of your parameters and the filenames of the files you want to track. 
Check out
[this page on the wiki](https://github.com/andkennard/point_tracking_optical_flow/wiki/Parameter-Descriptions)
to see descriptions for each of the parameters.

    There is an example CSV file in the `parameter_files` directory of this repository, which will work 
for the example movie in the `input` folder.


2. Check the settings for running the algorithm. These are defined in the `initializeSettings.m` file 
in the main directory of the repository. This includes stuff like the filepath to the parameters CSV file 
you just set up, as well as things like customizing the plotting of tracking results etc. 

    A lot of these settings you can comment out for now; to get started with the example 
    dataset just leave it as-is.

    When you have edited initializeSettings.m to your liking you can run it in MATLAB, e.g.
    
        trackingSettings = initializeSettings();
        
    This creates a cell array `trackingSettings` with all the necessary settings.

3. Run the tracking algorithm like so:

        trackingResultArray = runTrackPoints(trackingSettings{:});
        
    The `trackingResultArray` is a cell array containing a `trackingResult` for each movie you ran the algorithm on. 
    To get the coordinates for the 1st movie that you chose to track, type 
    
        coordinateArray = trackingResultArray{1}.coordinateArray; 
    
    The coordinateArray is a _M x 2N_ matrix, where _M_ is the number of points that 
    were tracked at some point and _N_ is the number of frames in the movie. Each row contains the 
    coordinates for a specific point _x1, y1, x2, y2, ..., xN, yN_. If a point was not tracked in a 
    particular frame its coordinates in that frame are `NaN`. The units of the coordinate positions are pixels.

4. Downstream analysis can then be performed on this `coordinateArray`.
