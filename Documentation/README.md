# MATLAB Interface *for AWS* Common Package
The code in this repository serves as common utilities for authentication and
other functionality across AWS services.

In particular, the *Software/MATLAB/config/credentials.json.template* provides a
starting point for using file based credentials to authenticate against AWS services.

Certain packages like the AWS S3 support package leverage the default credential provider chain
as documented at:
https://docs.aws.amazon.com/sdk-for-java/v1/developer-guide/credentials.html

## Contents
1. [AWS Command Line Interface](AWSCLI.md)

[//]: #  (Copyright 2018 The MathWorks, Inc.)
