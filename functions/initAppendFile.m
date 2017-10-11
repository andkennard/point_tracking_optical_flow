function fname = initAppendFile(fstr)
%%% Initialize a file that will be written by appending

if exist(fstr,'file')
    delete(fstr)
end
fname = fstr;
end