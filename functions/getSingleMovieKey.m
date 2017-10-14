function movieSavePrefix = getSingleMovieKey(movieSelectionKeyArray,m)

if isnumeric(movieSelectionKeyArray)
    
    movieName     = movieSelectionKeyArray(m);
    movieSavePrefix = sprintf('movie_%02i',movieName);
    
elseif iscellstr(movieSelectionKeyArray)
    
    movieSavePrefix     = movieSelectionKeyArray{m};
    
else
    
    error('movieSelectionKey must be numeric or a cell array of strings');
    
end