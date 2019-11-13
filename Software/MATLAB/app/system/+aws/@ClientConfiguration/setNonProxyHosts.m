function setNonProxyHosts(obj, nonProxyHosts)
% SETNONPROXYHOSTS Sets optional hosts accessed without going through the proxy
% Hosts should be specified as a character vector.

% Copyright 2019 The MathWorks, Inc.

% Imports
import com.amazonaws.ClientConfiguration

if ischar(nonProxyHosts)
    obj.Handle.setNonProxyHosts(nonProxyHosts);
else
    logObj = Logger.getLogger();
    write(logObj,'error','Expected nonProxyHosts of type character vector');
end

end %function
