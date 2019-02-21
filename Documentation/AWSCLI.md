# AWS Command Line Interface from within MATLAB

The AWS Command Line Interface (AWS CLI) is a utility that provides a consistent command line based interface for interacting with all parts of AWS.
AWS CLI commands for different services are covered in the AWS user guide, including descriptions, syntax, and usage examples.
[AWS CLI User Guide and Documentation](https://aws.amazon.com/documentation/cli/)

The function allows easy access to the AWS CLI from the MATLAB command prompt. It assumes the CLI is installed and can be found on the path.


## Examples:
```
aws('s3api list-buckets')
```

This can also be expressed as:
```
aws s3api list-buckets
```

If no output arguments are specified, the command will echo this to the MATLAB command window. If the output variable is provided it will convert the output to a MATLAB object.
```
[status, output] = aws('s3api','list-buckets');

  output =

    struct with fields:

      Owner: [1x1 struct]
      Buckets: [15x1 struct]
```
By default a struct is produced from the JSON format output. If the `--output [text|table]` flag is set a char vector is produced. Where derived from the JSON the output will be structured, thus simplifying programmatic use of the output.


[//]: #  (Copyright 2018 The MathWorks, Inc.)    
