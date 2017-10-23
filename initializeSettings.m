function trackingSettings = initializeSettings()
% initializeSettings: initialize the settings for runTrackPoints. Edit this
% function before running runTrackPoints!

%% Required arguments

% movieDatabase: path to the csv file containing the parameters for your
% experiments
movieDatabase = ['/Users/andrewkennard/Code/'...
                 'point_tracking_optical_flow/parameter_files/'...
                 'point_tracking_parameters.csv'];

% movieKeyArray: A cell array of strings or a vector of indexes of which
% movies in the movieDatabase file should be run through the algorithm
% E.g. movieKeyArray = [1:5 7 10]; or 
% movieKeyArray = {'WT','blebbistatin'};
movieKeyArray = 1;

%% Optional Name-Value pairs

trackingSettings = {movieDatabase;...
                    movieKeyArray;...                
% finalFrame: if you want to stop tracking at an earlier frame (for testing
% purposes)
                   %'finalFrame';5;...
%
% incrementSaveNames: default tracking data will auto-increment the
% filename each time the algorithm is run (saving different runs on the
% same data, with different parameters
                   'incrementSaveNames';1;...
%
% plotFormatSpecs: formatting options for plotting the tracking result.
% Based on formatting for the insertMarker command
                   'plotFormatSpecs';{'+','Color','Green'};...
%
% plotMarginFormatSpecs: same as above, but will allow formatting the
% margin points differently than the other points (only use if you are
% actually tracking the wound margin!
                   'plotMarginFormatSpecs';{'+','Color','Blue'};...
%
                    };
    
end