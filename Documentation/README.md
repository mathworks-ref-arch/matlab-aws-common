# MATLAB Interface *for AWS* Common Package
The code in this repository serves as common utilities for authentication and
other functionality across AWS services.

## Credentials handling
Many AWS packages, e.g. the Amazon S3 support package, can use the AWS credential
provider chain as documented here:
[https://docs.aws.amazon.com/sdk-for-java/v1/developer-guide/credentials.html](https://docs.aws.amazon.com/sdk-for-java/v1/developer-guide/credentials.html)
in addition to local static credentials. The ```Software/MATLAB/config/credentials.json.template```
provides a starting point for using file based credentials to authenticate
against AWS services. The various service support packages each have specific documentation relating to authentication.

## Using Multiple AWS services
If multiple AWS service support packages are to be used at the same time, this package provides the necessary .pom build file and path configuration script to do so.
For more details see: [Using Multiple AWS services](MultiService.md).

## Command Line Interface (CLI)
The AWS Command Line Interface (AWS CLI) provides a high-level interface to many
AWS services a light-weight wrapper is provided as part of this package to simplify
its use from within MATLAB, making it convenient and more easily used programmatically.
For more details see: [AWS Command Line Interface](AWSCLI.md).


[//]: #  (Copyright 2018-2021 The MathWorks, Inc.)
