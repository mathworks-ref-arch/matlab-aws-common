function tf = writeSTSCredentialsFile(tokenCode, serialNumber, region)
% WRITESTSCREDENTIALSFILE write an STS based credentials file
% 
% Write an STS based credential file
% 
%   tokenCode is the 2 factor authentication code of choice e.g. from Google
%   authenticator. Note the command must be issued quickly as this value will
%   expire in a number of seconds
% 
%   serialNumber is the AWS 'arn value' e.g. arn:aws:iam::741<REDACTED>02:mfa/joe.blog
%   this can be obtained from the AWS IAM portal interface
% 
%   region is the AWS region of choice e.g. us-west-1
%
% The following AWS command line interface (CLI) command will return STS
% credentials in json format as follows, Note the required multi-factor (mfa)
% auth version of the arn:
%
% aws sts get-session-token --token-code 631446 --serial-number arn:aws:iam::741<REDACTED>02:mfa/joe.blog
%
% {
%     "Credentials": {
%         "SecretAccessKey": "J9Y<REDACTED>BaJXEv",
%         "SessionToken": "FQoDYX<REDACTED>KL7kw88F",
%         "Expiration": "2017-10-26T08:21:18Z",
%         "AccessKeyId": "AS<REDACTED>UYA"
%     }
% }
%
% This needs to be rewritten differently to match the expected format
% below:
%
% {
%     "aws_access_key_id": "AS<REDACTED>UYA",
%     "secret_access_key" : "J9Y<REDACTED>BaJXEv",
%     "region" : "us-west-1",
%     "session_token" : "FQoDYX<REDACTED>KL7kw88F"
% }

% Copyright 2018 The MathWorks, Inc.


logObj = Logger.getLogger();

% do a simple check on arguments
if ~ischar(tokenCode) || ~ischar(serialNumber) || ~ischar(region)
    write(logObj,'error','All input arguments must be of type char');
    tf = false;
    return;
end

% json output will be provided by default
[status, cliJson] = aws( 'sts', 'get-session-token', '--token-code', tokenCode, '--serial-number', serialNumber);
if (status ~= 0)
    write(logObj,'error','Expected aws command to return 0');
    tf = false;
    return;
end

% look for the normal credentials.json file location and put the file there

[pathName,~,~] = fileparts(which('credentials.json'));
if isempty(pathName)
    write(logObj,'error','Could not find output file location');
    tf = false;
    return;
end

fidName = [pathName,filesep,'credentials.json_sts'];
[fid, ferrmsg] = fopen(fidName,'w');
if fid == -1
    write(logObj,'error',['Unable to open file: ',fidName]);
    write(logObj,'error',['fopen error message: ',ferrmsg]);
    tf = false;
    return;
end

fprintf(fid,'{\n');
fprintf(fid,['\t"aws_access_key_id" : "' cliJson.Credentials.AccessKeyId '",\n']);
fprintf(fid,['\t"secret_access_key" : "' cliJson.Credentials.SecretAccessKey '",\n']);
fprintf(fid,['\t"region" : "' region '",\n']);
fprintf(fid,['\t"session_token" : "' cliJson.Credentials.SessionToken '"\n']);
fprintf(fid,'}\n');

fclose(fid);

write(logObj,'debug',['Wrote STS Credentials file: ',fidName]);
tf = true;

end
