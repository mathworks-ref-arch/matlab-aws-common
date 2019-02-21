classdef Object < handle
    % OBJECT Root object for all the AWS SDK objects

    % Copyright 2018 The MathWorks, Inc.

    properties(Hidden)
        Handle
    end

    methods
        %% Constructor
        function obj = Object(~, varargin)
           % logObj = Logger.getLogger();
           % write(logObj,'debug','Creating root object');
        end
    end

end %class
