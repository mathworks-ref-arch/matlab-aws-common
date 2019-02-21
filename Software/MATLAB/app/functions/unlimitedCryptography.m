function tf = unlimitedCryptography()
% UNLIMITEDCRYPTOGRAPHY Returns true if unlimited cryptography is installed
% Otherwise false is returned.
% Tests using the AES algorithm for greater than 128 bits if true then this
% indicates that the policy files have been changed to enabled unlimited
% strength cryptography.

% Copyright 2018 The MathWorks, Inc.

import javax.crypto.Cipher

maxVal = Cipher.getMaxAllowedKeyLength(string('AES')); %#ok<STRQUOT>

if maxVal > 128
  tf = true;
else
  tf = false;
end

end
