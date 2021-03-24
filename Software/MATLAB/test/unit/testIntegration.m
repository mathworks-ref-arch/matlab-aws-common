classdef testIntegration < matlab.unittest.TestCase
    % TESTINTEGRATION Test multiple services in one pass
    
    % Copyright 2021 The MathWorks, Inc.
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Please add test cases below
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    properties
        %Create logger reference
        logObj = Logger.getLogger();
        commonUnitTestDir
        awsRootDir
    end
    
    
    methods (TestClassSetup)
        function testClassSetup(testCase)
            testCase.logObj = Logger.getLogger();
            testCase.logObj.DisplayLevel = 'verbose';
            
            testCase.commonUnitTestDir = pwd;
            testCase.awsRootDir = fileparts(fileparts(fileparts(fileparts(fileparts(testCase.commonUnitTestDir)))));
            
        end
    end
    
    
    methods (TestClassTeardown)
        function testClassTearDown(testCase) %#ok<MANU>
        end
    end
    
    
    methods (TestMethodSetup)
        function testMethodSetup(testCase) %#ok<MANU>
        end
    end
    
    
    methods (TestMethodTeardown)
        function testMethodTearDown(testCase) %#ok<MANU>
        end
    end
    
    
    methods (Test)
        % Disabled pending investigation of SDK v2 usage
        % function testAthena(testCase)
        %     packageTest(testCase, 'matlab-aws-athena');
        % end
        
        function testS3(testCase)
            packageTest(testCase, 'matlab-aws-s3');
        end
        
        % Disabled for now
        % function testIAM(testCase)
        %     packageTest(testCase, 'matlab-aws-iam');
        % end

        function testSQS(testCase)
            packageTest(testCase, 'matlab-aws-sqs');
        end

        function testSNS(testCase)
            packageTest(testCase, 'matlab-aws-sns');
        end

        function testDynamoDB(testCase)
            packageTest(testCase, 'matlab-aws-dynamodb');
        end

        function testSSM(testCase)
            packageTest(testCase, 'matlab-aws-ssm');
        end
    end


    methods
        function packageTest(testCase, packageName)
            packageRootDir = fullfile(testCase.awsRootDir, packageName);
            % run(fullfile(packageRootDir,'Software', 'MATLAB', 'startup'));
            
            packageUnitTestDir = fullfile(packageRootDir, 'Software', 'MATLAB', 'test', 'unit');
            suite =  matlab.unittest.TestSuite.fromFolder(packageUnitTestDir);
            result = run(suite);
            if any([result.Failed]) || any([result.Incomplete])
                disp(result)
                error('AWS:TEST', '%s failed',packageName);
            end
        end
    end
    
end
