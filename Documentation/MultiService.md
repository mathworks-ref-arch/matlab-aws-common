# Using multiple AWS packages at the same time

The available support packages for using AWS services within MATLAB are each
designed to be usable in isolation while sharing some common code. However it is
also multiple packages at the same time, e.g. triggering notifications via SNS
based on data stored in S3.

Two things are required to enable this:
1. A jar file which includes the necessary elements of the AWS SDK
2. The MATLAB path and Java class path settings for the respective packages

In the case of individual packages, once built, the jar file is stored in:
`package-name/Software/MATLAB/lib/jar` and paths are configured using:
`package-name/Software/MATLAB/startup.m`. The path settings can be applied as
permanent amendments to the MATLAB path and Java class path in the normal way
(see `addpath` etc.).

Where the requirement is to use multiple services this package, `matlab-aws-common`,
provides a pom file in `/Software/Java` which when used with maven in the normal
way `mvn clean package` builds a single jar files that supports the DynamoDB, SNS,
SQS, S3 and SSM packages. This is stored in `matlab-aws-common/Software/MATLAB/lib/jar`
Also provided is a startup script `matlab-aws-common/Software/MATLAB/startupAll.m`
which configures paths for the aforementioned packages. This script is easily
modified to include only the subset of packages required. If support for Amazon
Athena alongside these packages is required please contact MathWorks.


[//]: #  (Copyright 2021 The MathWorks, Inc.)
