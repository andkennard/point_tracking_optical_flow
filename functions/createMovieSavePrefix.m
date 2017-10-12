function movieSavePrefix = createMovieSavePrefix(movieSelectionKey,m)

if isnumeric(movieSelectionKey)
    
    movieName     = movieSelectionKey(m);
    movieSavePrefix = sprintf('movie_%02i',movieName);
    
elseif iscellstr(movieSelectionKey)
    
    movieSavePrefix     = movieSelectionKey{m};
    
else
    
    error('movieSelectionKey must be numeric or a cell array of strings');
    
end