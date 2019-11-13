classdef ClientConfiguration < aws.Object
    % CLIENTCONFIGURATION creates a client network configuration object
    % This class can be used to control client behavior such as:
    %  * Connect to the Internet through proxy
    %  * Change HTTP transport settings, such as connection timeout and request retries
    %  * Specify TCP socket buffer size hints
    % (Only limited proxy related methods are currently available)
    %
    % Example, in this case using an s3 client:
    %   s3 = aws.s3.Client();
    %   s3.clientConfiguration.setProxyHost('proxyHost','myproxy.example.com');
    %   s3.clientConfiguration.setProxyPort(8080);
    %   s3.initialize();
    %

    % Copyright 2018 The MathWorks, Inc.

    properties
        proxyHost = '';
        proxyPort = [];
        proxyUsername = '';
        proxyPassword = '';
    end

    methods
        %% Constructor
        function obj = ClientConfiguration()
            import com.amazonaws.ClientConfiguration

            obj.Handle = com.amazonaws.ClientConfiguration();
            obj.proxyHost = '';
            obj.proxyPort = [];
            obj.proxyUsername = '';
            obj.proxyPassword = '';
        end
    end
end % Class
