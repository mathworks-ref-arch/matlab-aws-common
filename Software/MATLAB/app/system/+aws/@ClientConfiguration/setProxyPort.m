function setProxyPort(obj, varargin)
% SETPROXYPORT Sets the optional proxy port the client will connect through
% This is normally based on the setting in the MATLAB preferences panel. If the
% port is not set there on Windows then the Windows system preferences will be
% used. Though it is not normally the case proxy settings may vary based on the
% destination URL, if this is the case a URL should be provided for a specific
% service. If a URL is not provided then https://s3.amazonaws.com is used as
% a default and is likely to match the relevant proxy selection rules for AWS
% traffic.
%
% Examples:
%
%   To have the port automatically set based on the default URL of
%   https://s3.amazonaws.com:
%       clientConfig.setProxyPort();
%
%   To have the port automatically set based on the given URL:
%       clientConfig.setProxyPort('https://examplebucket.amazonaws.com');
%
%   To force the value of the port to a given value, e.g. 8080:
%       clientConfig.setProxyPort(8080);
%   Note this does not alter the value held set in the preferences panel.
%
% The client initialization call will invoke setProxyPort() to set a value based
% on the MATLAB preference if the proxy port value is not an empty value.
%

% Copyright 2018 The MathWorks, Inc.

% Note: This is derived from matlab.net.http.internal.HTTPConnector code.

% Imports
import com.amazonaws.ClientConfiguration

logObj = Logger.getLogger();

if length(varargin) > 1
    write(logObj,'error','Too many arguments');
end

% if a numeric value is provided just use that, otherwise if a URL is
% provided use that to request the appropriate proxy, if a URL is not
% provided default to using the AWS one listed as that should return the
% correct proxy settings to also use with S3

if isempty(varargin)
    url = 'https://s3.amazonaws.com';
    % Read the port values from the MATLAB preferences using
    % getProxySettings in matlab.internal.webservices.HTTPConnector
    % approach
    % Get the proxy information using the MATLAB proxy API.
    % Ensure the Java proxy settings are set.
    com.mathworks.mlwidgets.html.HTMLPrefs.setProxySettings

    % Obtain the proxy information.
    url = java.net.URL(url);
    % This function goes to MATLAB's preference panel or (if not set and on
    % Windows) the system preferences.
    javaProxy = com.mathworks.webproxy.WebproxyFactory.findProxyForURL(url);
    if ~isempty(javaProxy)
        address = javaProxy.address;
        port = address.getPort();
    else
        port = [];
    end
elseif ischar(varargin{1})
    % as above but with the url that has been passed in rather than the
    % default
    url = varargin{1};
    com.mathworks.mlwidgets.html.HTMLPrefs.setProxySettings
    url = java.net.URL(url);
    javaProxy = com.mathworks.webproxy.WebproxyFactory.findProxyForURL(url);
    if ~isempty(javaProxy)
        address = javaProxy.address;
        port = address.getPort();
    else
        port = [];
    end
elseif isnumeric(varargin{1}) && isscalar(varargin{1})
    % The user has specified a port value so use that regardless of the
    % preference provided via the built in dialogue box
    port = varargin{1};
else
    % an error state, use an empty value
    port = [];
    write(logObj,'error','Invalid argument(s)');
end


if ~isempty(port)
    write(logObj,'verbose',['Setting proxy port to: ',num2str(port)]);

    % First set the underlying Java object port based on the argument provided
    obj.Handle.setProxyPort(port);
    % Then using the Java object get method retrieve the value and set the MATLAB
    % object property based on this to ensure direct correspondence
    obj.proxyPort = obj.Handle.getProxyPort();
else
    % write(logObj,'verbose','Setting proxy port to an empty value');
    obj.proxyPort = [];
end

end %function
