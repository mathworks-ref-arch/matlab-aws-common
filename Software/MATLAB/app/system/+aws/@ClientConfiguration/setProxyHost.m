function setProxyHost(obj, varargin)
% SETPROXYHOST Sets the optional proxy host the client will connect through
% This is based on the setting in the MATLAB preferences panel. If the host
% is not set there on Windows then the Windows system preferences will be
% used. Though it is not normally the case proxy settings may vary based on the
% destination URL, if this is the case a URL should be provided for a specific
% service. If a URL is not provided then https://s3.amazonaws.com is used as
% a default and is likely to match the relevant proxy selection rules for AWS
% traffic.
%
% Examples:
%
%   To have the proxy host automatically set based on the MATLAB preferences
%   panel using the default URL of 'https://s3.amazonaws.com:'
%       clientConfig.setProxyHost();
%
%   To have the proxy host automatically set based on the given URL:
%       clientConfig.setProxyHost('autoURL','https://examplebucket.amazonaws.com');
%
%   To force the value of the proxy host to a given value, e.g. myproxy.example.com:
%       clientConfig.setProxyHost('proxyHost','myproxy.example.com');
%   Note this does not overwrite the value set in the preferences panel.
%
% The client initialization call will invoke setProxyHost() to set a value based
% on the MATLAB preference if the proxyHost value is not to an empty value.
%

% Copyright 2018-2021 The MathWorks, Inc.

% Imports
import com.amazonaws.ClientConfiguration

logObj = Logger.getLogger();

% validate input
if length(varargin) > 2
    write(logObj,'error','Too many arguments');
end

p = inputParser;
p.CaseSensitive = false;
p.FunctionName = 'setProxyHost';
validationFcn = @(x) validateattributes(x,{'char'},{'nonempty'});
% if an autoURL is not specified assume Amazon S3 as this is where we are most
% likely to connect to
addParameter(p,'autoURL','https://s3.amazonaws.com',validationFcn);
addParameter(p,'proxyHost','',validationFcn);

parse(p,varargin{:});
autoURL = p.Results.autoURL;
proxyHost = p.Results.proxyHost;

% If a proxy host name is provided use it otherwise use the value given in
% the MATLAB preferences, if a URL is provided to allow selection of the proxy
% use that
if ~isempty(proxyHost)
    % the user has specified a host value so use that regardless of the
    % preference provided via the built in dialogue box
    host = proxyHost;
else
    % Read the host values from the MATLAB preferences using
    % getProxySettings in matlab.internal.webservices.HTTPConnector
    % approach
    % Get the proxy information using the MATLAB proxy API.
    % Ensure the Java proxy settings are set.
    com.mathworks.mlwidgets.html.HTMLPrefs.setProxySettings

    % Obtain the proxy information.
    url = java.net.URL(autoURL);
    % This function goes to MATLAB's preference panel or if not set and on
    % Windows the system preferences.
    javaProxy = com.mathworks.webproxy.WebproxyFactory.findProxyForURL(url);
    if ~isempty(javaProxy)
        address = javaProxy.address;
        if isa(address,'java.net.InetSocketAddress') && ...
                javaProxy.type == javaMethod('valueOf','java.net.Proxy$Type','HTTP')
            host = char(address.getHostName());
        else
            % no proxy host could be determined from MATLAB preferences or OS (Windows)
            host = '';
        end
    else
        % no proxy host could be determined from MATLAB preferences or OS (Windows)
        host = '';
    end
end


if ~isempty(host)
    write(logObj,'verbose',['Setting proxy host to: ',host]);

    % First set the underlying Java object host based on the argument provided
    obj.Handle.setProxyHost(string(host));
    % Then using the Java object get method retrieve the Id and set the MATLAB
    % object property based on this to ensure direct correspondence
    obj.proxyHost = char(obj.Handle.getProxyHost());
else
    % write(logObj,'verbose','Setting proxy host to an empty value');
    obj.proxyHost = '';
end

end %function
