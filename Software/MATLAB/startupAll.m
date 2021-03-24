function startupAll(varargin)
    %% STARTUPALL - Script to add my paths to MATLAB path
    % This script will add the paths below the root directory into the MATLAB
    % path.

    % Copyright 2021 The MathWorks, Inc.
    
    % Don't run the startup file if executed from within a deployed function (CTF)
    if ~isdeployed()
        
        %% Check where this tooling exists and compute paths
        % Get the root path for this repo - you will need to modify this if you
        % move this startup file w.r.t. its location in the repo.
        here = fileparts(fileparts(fileparts(fileparts(mfilename('fullpath')))));
        % List of packages to enable excl. Athena
        pkgNames = {'matlab-aws-s3', 'matlab-aws-sns', 'matlab-aws-ssm', 'matlab-aws-sqs', 'matlab-aws-dynamodb', 'matlab-aws-s3'};

        %% Add a banner to the top
        iDisplayBanner('MATLAB Interface for AWS');
        
        %% Check if the dependencies are in place
        iDisplayBanner('Checking if dependencies are met');
        iCheckCommonDependencies(here);
        for n = 1:length(pkgNames)
            iCheckPackageDependencies(here, pkgNames{n});
        end

        %% Update MATLAB paths
        iDisplayBanner('Adding MATLAB Paths');
        
        %% Add the common utilities to the path
        iAddCommonUtilities(here);
        
        %% Add the package interfaces to the path
        for n = 1:length(pkgNames)
            iAddPkg(here, pkgNames{n});
        end

        %% Update the Java class paths, should be added by common's startup
        % iSafeAddToJavaPath(fullfile(here,'matlab-aws-common','Software','MATLAB','lib','jar','aws-sdk-0.1.0.jar'));

        %% Create logger singleton
        iCreateLoggerSingleton();
    end
    
end


function iCheckPackageDependencies(rootDir, pkgName)
    % Check if the pkgName exists otherwise raise and error and stop
    % pkgName has the form matlab-aws-s3 or matlab-aws-sqs etc.
    depDir = fullfile(rootDir,pkgName);
    if ~exist(depDir, 'dir')
        % Cannot find the dependencies
        error('AWS:COMMON','Could not locate %s at: %s', pkgName, depDir);
    end
end


function iCheckCommonDependencies(rootDir)
    % Check if the common utilities exists otherwise raise and error and stop
    depDir = fullfile(rootDir,'matlab-aws-common');
    if ~exist(depDir, 'dir')
        % Cannot find the dependencies
        error('AWS:COMMON','Could not locate common utilities at: %s', depDir);
    end
    
    % Check if the common JAR file exists
    jarPath = fullfile(rootDir,'matlab-aws-common','Software','MATLAB','lib','jar','aws-sdk-0.1.0.jar');
    if ~exist(jarPath,'file')
        error('AWS:COMMON', 'Could not locate jar file at: %s', jarPath);
    end
end


function iAddCommonUtilities(rootDir)   
    % Check if the common utilities exist otherwise raise and error and stop
    commonDir = fullfile(rootDir,'matlab-aws-common');
    startUpFile = fullfile(commonDir,'Software','MATLAB','startup.m');
    
    run(startUpFile);
end


function iAddPkg(rootDir, pkgName)
    % pkgName has the form matlab-aws-s3 or matlab-aws-sqs etc.
    iDisplayBanner(['Adding MATLAB interface paths for ', char(pkgName)]);
    
    pkgDir = fullfile(rootDir, pkgName, 'Software','MATLAB');
    rootDirs={fullfile(pkgDir,'app'),true;...
        fullfile(pkgDir,'lib'),false;...
        fullfile(pkgDir,'sys','modules'),true;...
        fullfile(pkgDir,'public'),true;...
        };
    
    %% Add the tooling to the path
    iAddFilteredFolders(rootDirs);
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
    if exist(pathStr,'dir') || exist(pathStr,'file')
        jarFound = any(strcmpi(pathStr, jPaths));
        if isempty(jarFound)
            jarFound = false;
        end
        
        if ~jarFound
            disp(['Adding ',pathStr]);
            javaaddpath(pathStr);
        else
            disp(['Path already set - Skipping: ',pathStr]);
        end
    else
        disp(['Path not found - Skipping ',pathStr]);
    end   
end


%% HELPER function to create a banner
function iDisplayBanner(appStr)
    disp(appStr);
    disp(repmat('-',1,numel(appStr)));
end


function iCreateLoggerSingleton()
    %% Create the logger
    % Get the logger object - a singleton (one logger per MATLAB session)
    logObj = Logger.getLogger;
    % Adjust the log levels
    logObj.LogFileLevel = 'warning';
    logObj.DisplayLevel = 'debug';
end
