function saveKeyPair(keyPair, publicKeyFileName, privateKeyFileName)
% SAVEKEYPAIR Writes a key pair to two files for the public and private keys
% The key pair should be of type java.security.KeyPair
%
% Example:
%   saveKeyPair(myKeyPair, 'c:\Temp\mypublickey.key', 'c:\Temp\myprivatekey.key')
%

% Copyright 2018 The MathWorks, Inc.

%% Imports
import java.io.File
import java.io.FileOutputStream
import java.io.IOException
import java.security.KeyPair
import java.security.PrivateKey
import java.security.PublicKey
import java.security.spec.PKCS8EncodedKeySpec
import java.security.spec.X509EncodedKeySpec

% split the pair
privateKey = keyPair.getPrivate();
publicKey = keyPair.getPublic();

% write out the public key
x509EncodedKeySpec = X509EncodedKeySpec(publicKey.getEncoded());
fos = FileOutputStream(string(publicKeyFileName));
fos.write(x509EncodedKeySpec.getEncoded());
fos.close();

% write out the private key
pkcs8EncodedKeySpec = PKCS8EncodedKeySpec(privateKey.getEncoded());
fos = FileOutputStream(string(privateKeyFileName));
fos.write(pkcs8EncodedKeySpec.getEncoded());
fos.close();

end % function
