classdef progress_test < matlab.unittest.TestCase
    %PROGRESS_TEST Unit test for progress.m
    % -------------------------------------------------------------------------
    % Run it by calling 'runtests()'
    %   or specifically 'runtests('progress_test')'
    %
    % Author :  J.-A. Adrian (JA) <jensalrik.adrian AT gmail.com>
    %
    
    
    properties (Constant)
        DEFAULT_SEED = 123;
    end
    
    properties (Access = public)
        Seed;
    end
    
    
    
    methods (TestClassSetup)
        function setClassRng(testCase)
            testCase.Seed = rng();
            testCase.addTeardown(@rng, testCase.Seed);
            
            rng(testCase.DEFAULT_SEED);
        end
        
        function addPath(testCase)
            defaultPath = matlabpath();
            
            myLocation = fileparts(mfilename('fullpath'));
            addpath(fullfile(myLocation, '..'));
            
            testCase.addTeardown(@() matlabpath(defaultPath));
        end
    end
    
    methods (TestMethodSetup)
        function setMethodRng(testCase)
            rng(testCase.DEFAULT_SEED);
        end
    end
    
    methods (TestMethodTeardown)
        function deleteRogueTimers(~)
            delete(timerfindall('Tag', ProgressBar.TIMER_TAG_NAME));
        end
    end
    
    
    
    methods (Test)
        function earlyExit(testCase)
            obj = progress();
            
            testCase.verifyClass(obj, 'progress');
            testCase.verifyEmpty(properties(obj));
            
            methodsAreImplemented = contains(methods(obj), {'progress', 'size', 'subsref'});
            testCase.verifyEqual(sum(methodsAreImplemented), 3);
        end
        
        
        function simpleCall(testCase)
            str = evalc('for k = progress(1); end;');
            
            testCase.verifyTrue(contains(str, '100%'));
            testCase.verifyTrue(contains(str, '1/1it'));
        end
    end
    
end
