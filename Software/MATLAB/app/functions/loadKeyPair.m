function keyPair = loadKeyPair(publicKeyFileName, varargin)
% LOADKEYPAIR2CERT Reads public and private key files and returns a key pair
% The key pair returned is of type java.security.KeyPair
% Algorithms supported by the underlying java.security.KeyFactory library
% are: DiffieHellman, DSA & RSA.
% However S3 only supports RSA at this point.
% If only the public key is a available e.g. the private key belongs to
% somebody else then we can still create a keypair to encrypt data only
% they can decrypt. To do this we replace the private key file argument
% with 'null'.
%
% Example:
%  myKeyPair = loadKeyPair('c:\Temp\mypublickey.key', 'c:\Temp\myprivatekey.key')
%
%  encryptOnlyPair = loadKeyPair('c:\Temp\mypublickey.key')
%
%

% Copyright 2018 The MathWorks, Inc.

%% Imports
import java.io.File
import java.io.FileInputStream
import java.io.IOException
import java.security.KeyFactory
import java.security.KeyPair
import java.security.NoSuchAlgorithmException
import java.security.PrivateKey
import java.security.PublicKey
import java.security.spec.InvalidKeySpecException
import java.security.spec.PKCS8EncodedKeySpec
import java.security.spec.X509EncodedKeySpec
import java.util.Arrays
import org.apache.commons.io.IOUtils

logObj = Logger.getLogger();

% validate input
p = inputParser;
p.CaseSensitive = false;
p.FunctionName = 'loadKeyPair';
addRequired(p,'publicKeyFileName',@ischar);
defaultNull = [];
addOptional(p,'privateKeyFileName',defaultNull,@ischar);

% validate the input, public key is required but private one
% is optional
parse(p,publicKeyFileName,varargin{:})
privateKeyFileName = p.Results.privateKeyFileName;
algorithm = 'RSA';

% read in the public key
publicKeyFile = File(string(publicKeyFileName));
fis = FileInputStream(publicKeyFile);
publicLength =  publicKeyFile.length();
encodedPublicKey = IOUtils.toByteArray(fis,publicLength);
fis.close();

% read in the private key
if isempty(privateKeyFileName)
    write(logObj,'debug','No private key provided, generating a public key only pair');
else
    privateKeyFile = File(string(privateKeyFileName));
    fis = FileInputStream(privateKeyFile);
    privateLength =  privateKeyFile.length();
    encodedPrivateKey = IOUtils.toByteArray(fis,privateLength);
    fis.close();
end

% merge into a key pair
keyFactory = KeyFactory.getInstance(string(algorithm));  %#ok<STRQUOT>
publicKeySpec = X509EncodedKeySpec(encodedPublicKey);
publicKey = keyFactory.generatePublic(publicKeySpec);

if isempty(privateKeyFileName)
    % set to an empty matrix which will be mapped to null in the JAVA
    % KeyPair() call
    privateKey = defaultNull;
else
    privateKeySpec = PKCS8EncodedKeySpec(encodedPrivateKey);
    privateKey = keyFactory.generatePrivate(privateKeySpec);
end

keyPair = KeyPair(publicKey, privateKey);

end % function
