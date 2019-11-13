function setProxyUsername(obj, varargin)
% SETPROXYUSERNAME Sets the optional proxy username
% This is based on the setting in the MATLAB preferences panel. If the username
% is not set there on Windows then the Windows system preferences will be
% used.
%
% Examples:
%
%    To set the username to a given value:
%        clientConfig.setProxyUsername('myProxyUsername');
%    Note this does not overwrite the value set in the preferences panel.
%
%    To set the password automatically based on provided preferences:
%        clientConfig.setProxyUsername();
%
% The client initialization call will invoke setProxyUsername();
% to set preference based on the MATLAB preference if the proxyUsername value is
% not an empty value.
%
% Note it is bad practice to store credentials in code, ideally this value
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

% if a username is provided use that otherwise read the preferences value
% if set and use it

if isempty(varargin)
    % Read the username values from the MATLAB preferences using
    % getProxySettings in matlab.internal.webservices.HTTPConnector
    % approach
    % Get the proxy information using the MATLAB proxy API.
    % Ensure the Java proxy settings are set.
    com.mathworks.mlwidgets.html.HTMLPrefs.setProxySettings

    mwt = com.mathworks.net.transport.MWTransportClientPropertiesFactory.create();
    if ~isempty(mwt.getProxyHost())
      username = char(mwt.getProxyUser());
    else
      username = '';
    end
elseif ischar(varargin{1})
    username = varargin{1};
else
    % an error state, use an empty value
    username = '';
    write(logObj,'error','Invalid argument(s)');
end


if ~isempty(username)
    write(logObj,'verbose',['Setting proxy username to: ',username]);

    % First set the underlying Java object username based on the argument provided
    obj.Handle.setProxyUsername(username);
    % Then using the Java object get method retrieve the value and set the MATLAB
    % object property based on this to ensure direct correspondence
    obj.proxyUsername = char(obj.Handle.getProxyUsername());
else
    % write(logObj,'verbose','Setting proxy username to an empty value');
    obj.proxyUsername = '';
end

end %function
