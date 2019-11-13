# MATLAB Interface *for AWS* Common Package
The code in this repository serves as common utilities for authentication and
other functionality across AWS services.

Many AWS packages, e.g. the AWS S3 support package, can use the AWS credential provider chain
as documented here:
[https://docs.aws.amazon.com/sdk-for-java/v1/developer-guide/credentials.html](https://docs.aws.amazon.com/sdk-for-java/v1/developer-guide/credentials.html)
in addition to local static credentials. The ```Software/MATLAB/config/credentials.json.template``` provides a
starting point for using file based credentials to authenticate against AWS services.

## Contents
1. [AWS Command Line Interface](AWSCLI.md)

[//]: #  (Copyright 2018 The MathWorks, Inc.)
