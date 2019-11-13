function setProxyPassword(obj, varargin)
% SETPROXYPASSWORD Sets the optional proxy password
% This is based on the setting in the MATLAB preferences panel. If the password
% is not set there on Windows then the Windows system preferences will be
% used.
%
% Examples:
%
%   To set the password to a given value:
%       clientConfig.setProxyPassword('myProxyPassword');
%   Note this does not overwrite the value set in the preferences panel.
%
%   To set the password automatically based on provided preferences:
%       clientConfig.setProxyPassword();
%
% The client initialization call will invoke setProxyPassword() to set
% a value based on the MATLAB preference if the proxy password value is set.
%
% Note, it is bad practice to store credentials in code, ideally this value
% should be read from a permission controlled file or other secure source
% as required.
%

% Copyright 2018 The MathWorks, Inc.

% Note: This is derived from matlab.net.http.internal.HTTPConnector code.

% Imports
import com.amazonaws.ClientConfiguration

logObj = Logger.getLogger();

if length(varargin) > 1
    write(logObj,'error','Too many of arguments');
end


if isempty(varargin)
    % Read the password values from the MATLAB preferences using
    % getProxySettings in matlab.internal.webservices.HTTPConnector
    % approach
    % Get the proxy information using the MATLAB proxy API.
    % Ensure the Java proxy settings are set.
    com.mathworks.mlwidgets.html.HTMLPrefs.setProxySettings

    mwt = com.mathworks.net.transport.MWTransportClientPropertiesFactory.create();
    if ~isempty(mwt.getProxyHost())
      password = char(mwt.getProxyPassword());
    else
      password = '';
    end
elseif ischar(varargin{1})
    password = varargin{1};
else
    % an error state, use an empty value
    password = '';
    write(logObj,'error','Invalid argument(s)');
end


if ~isempty(password)
    % Don't log the the password value itself
    write(logObj,'verbose','Setting proxy password');

    % First set the underlying Java object password based on the argument provided
    obj.Handle.setProxyPassword(password);
    % Then using the Java object get method retrieve the value and set the MATLAB
    % object property based on this to ensure direct correspondence
    obj.proxyPassword = char(obj.Handle.getProxyPassword());
else
    % write(logObj,'verbose','Setting proxy password to an empty value');
    obj.proxyPassword = '';
end %function
