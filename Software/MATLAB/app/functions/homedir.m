function [homeDir] = homedir(varargin) %#ok<STOUT>
% HOMEDIR Function to return the home directory
% This function will return the users home directory.

% Copyright 2018 The MathWorks, Inc.

if ispc
    homeDir = [getenv('HOMEDRIVE') getenv('HOMEPATH')];
else
    homeDir = getenv('HOME');
end

end %function
