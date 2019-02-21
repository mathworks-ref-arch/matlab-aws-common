function varargout = aws(varargin)
% AWS, a wrapper to the AWS CLI utility
%
% The function assumes AWS CLI is installed and configured with authentication
% details. This wrapper allows use of the AWS CLI within the
% MATLAB environment.
%
% Examples:
%    aws('s3api list-buckets')
%
% Alternatively:
%    aws s3api list-buckets
%
% If no output is specified, the command will echo this to the MATLAB
% command window. If the output variable is provided it will convert the
% output to a MATLAB object.
%
%   [status, output] = aws('s3api','list-buckets');
%
%     output =
%
%       struct with fields:
%
%           Owner: [1x1 struct]
%         Buckets: [15x1 struct]
%
% By default a struct is produced from the JSON format output.
% If the --output [text|table] flag is set a char vector is produced.
%

% Copyright 2018 The MathWorks, Inc.

% Assumes that the CLI is installed and setup correctly
cliCmd = 'aws';

% Ensure that selection of the proper version of pyexpat
ldPath = getenv('LD_LIBRARY_PATH');

% Try to invoke the CLI safely
try
    % Pass through and check if user wants a display
    if nargout==0
        echoFlag = '-echo';
    else
        echoFlag ='';
    end

    % Call with the appropriate flag
    [varargout{1},varargout{2}] = system([cliCmd,' ',strjoin(varargin)], echoFlag);

    splitargs = strsplit(strjoin(varargin));
    % Check for specified output arg
    % if table or text output is requested and and output variable is
    % provided then a char object if an output type is not provided JSON
    % is the default which is decoded to a struct if an output variable is
    % provided
    if length(splitargs) > 1
        if strcmpi(splitargs{end-1},'--output')
            % if json argout provided decode it else
            % just leave varargout{2} as is
            if strcmpi(splitargs{end},'json')
                % Decode the output
                if nargout==2
                    varargout{2} = jsondecode(varargout{2});
                end
            end
        else
            % no --output argument provided, thus json by default
            % Decode the output


            if nargout==2
                varargout{2} = jsondecode(varargout{2});
            end
        end
    end
catch ME
    setenv('LD_LIBRARY_PATH',ldPath);
    rethrow(ME);
end

end % function
