function result = getNonProxyHosts(obj)
% GETNONPROXYHOSTS Sets optional hosts accessed without going through the proxy
% Returns either the nonProxyHosts set on this object, or if not provided,
% returns the value of the Java system property http.nonProxyHosts.
% Result is returned as a character vector.
%
% Note the following caveat from the Amazon DynamoDB documentation:
%
% We still honor this property even when getProtocol() is https, see
% http://docs.oracle.com/javase/7/docs/api/java/net/doc-files/net-properties.html
% This property is expected to be set as a pipe separated list. If neither are
% set, returns the value of the environment variable NO_PROXY/no_proxy.
% This environment variable is expected to be set as a comma separated list.


% Copyright 2019-2021 The MathWorks, Inc.

% Imports
import com.amazonaws.ClientConfiguration

result = char(obj.Handle.getNonProxyHosts());

end %function
