function startup(varargin)
% STARTUP - Script to add paths to MATLAB path
% This script will add the paths below the root directory into the MATLAB
% path. It will omit the SVN and other undesirable paths.  Modify undesired path
% filter as desired.

% Copyright 2018-2021 The MathWorks, Inc.

if ~isdeployed()
appStr = 'Adding Interface for AWS Common Paths';
disp(appStr);
disp(repmat('-',1,numel(appStr)));

%% Set up the paths to add to the MATLAB path
% This should be the only section of the code that needs modification
% The second argument specifies whether the given directory should be
% scanned recursively
here = fileparts(mfilename('fullpath'));

% Add the appropriate architecture binaries
archDir = iGetArchSuffix(); %#ok<NASGU>

rootDirs={fullfile(here,'app'),true;...
    fullfile(here,'config'),false;...
    fullfile(here,'sys','modules'),true;...
    fullfile(here,'public'),true;...
    };

%% Add the framework to the path
iAddFilteredFolders(rootDirs);

%% Handle the modules for the project.
disp('Initializing all modules');
modRoot = fullfile(here,'sys','modules');

% Get a list of all modules
mList = dir(fullfile(modRoot,'*.'));
for mCount = 1:numel(mList)
    % Only add proper folders
    dName = mList(mCount).name;
    if ~strcmpi(dName(1),'.')
        % Valid Module name
        candidateStartup = fullfile(modRoot,dName,'startup.m');
        if exist(candidateStartup,'file')
            % A module with a startup
            run(candidateStartup);
        else
            % Create a cell and add it recursively to the path
            iAddFilteredFolders({fullfile(modRoot,dName), true});
        end
    end
end

%% Post path-setup operations
% Add post-setup operations here.
disp('Running post setup operations');
disp('Updating the Java classpath:');
jarPath = fullfile(here,'lib','jar');
tmp = fullfile(jarPath,'aws-sdk-0.1.0.jar');
jarFiles = dir(tmp);

for jCount = 1:numel(jarFiles)
    iSafeAddToJavaPath(fullfile(jarPath,jarFiles(jCount).name));
end

%% Create the logger
% Get the logger object - a singleton (one logger per MATLAB session)
logObj = Logger.getLogger;
% Adjust the log levels
logObj.LogFileLevel = 'warning';
logObj.DisplayLevel = 'debug';
end
end

%% iAddFilteredFolders Helper function to add all folders to the path
function iAddFilteredFolders(rootDirs)
% Loop through the paths and add the necessary subfolders to the MATLAB path
for pCount = 1:size(rootDirs,1)

    rootDir=rootDirs{pCount,1};
    if rootDirs{pCount,2}
        % recursively add all paths
        rawPath=genpath(rootDir);

        if ~isempty(rawPath)
            rawPathCell=textscan(rawPath,'%s','delimiter',pathsep);
            rawPathCell=rawPathCell{1};
        end

    else
        % Add only that particular directory
        rawPath = rootDir;
        rawPathCell = {rawPath};
    end

    % if rawPath is empty then we have an entry in rootDir that does not
    % exist on the path so we should not try to add an entry for them
    if ~isempty(rawPath)

        % remove undesired paths
        svnFilteredPath=strfind(rawPathCell,'.svn');
        gitFilteredPath=strfind(rawPathCell,'.git');
        slprjFilteredPath=strfind(rawPathCell,'slprj');
        sfprjFilteredPath=strfind(rawPathCell,'sfprj');
        rtwFilteredPath=strfind(rawPathCell,'_ert_rtw');

        % loop through path and remove all the .svn entries
        if ~isempty(svnFilteredPath)
            for pCount=1:length(svnFilteredPath) %#ok<FXSET>
                filterCheck=[svnFilteredPath{pCount},...
                    gitFilteredPath{pCount},...
                    slprjFilteredPath{pCount},...
                    sfprjFilteredPath{pCount},...
                    rtwFilteredPath{pCount}];
                if isempty(filterCheck)
                    iSafeAddToPath(rawPathCell{pCount});
                else
                    % ignore
                end
            end
        else
            iSafeAddToPath(rawPathCell{pCount});
        end
    end
end

end

%% Helper function to add to MATLAB path.
function iSafeAddToPath(pathStr)

% Add to path if the file exists
if exist(pathStr,'dir')
    disp(['Adding ',pathStr]);
    addpath(pathStr);
else
    disp(['Skipping ',pathStr]);
end

end

%% Helper function to add to the Dynamic Java classpath
function iSafeAddToJavaPath(pathStr)

% Check the current java path
jPaths = javaclasspath('-dynamic');

% Add to path if the file exists
% TODO: Check if the file is already on the path
if exist(pathStr,'dir')||exist(pathStr,'file')
    disp(['Adding ',pathStr]);
    javaaddpath(pathStr);
else
    disp(['Skipping ',pathStr]);
end

end

%% Helper function to add arch specific suffix
function binDirName = iGetArchSuffix()

switch computer
    case 'PCWIN'
        binDirName = 'win32';
    case 'PCWIN64'
        binDirName = 'win64';
    case 'GLNX86'
        binDirName = 'glnx86';
    case 'GLNXA64'
        binDirName = 'glnxa64';
    case 'MACI64'
        binDirName = 'maci64';
    otherwise
        error('FW:Unsupported','The framework is not supported on this platform');
end
end
