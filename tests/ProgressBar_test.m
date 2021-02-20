classdef ProgressBar_test < matlab.unittest.TestCase
    %PROGRESSBAR_TEST Unit test for ProgressBar.m
    % -------------------------------------------------------------------------
    % Run it by calling 'runtests()'
    %   or specifically 'runtests('ProgressBar_test')'
    %
    % Author :  J.-A. Adrian (JA) <jensalrik.adrian AT gmail.com>
    %
    
    
    properties (Constant)
        DEFAULT_SEED = 123;
    end
    
    properties
        UnitName = "ProgressBar";
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
    
    
    
    methods (Test, TestTags = {'NonParallel'})
        function testTimerDeletion(testCase)
            unit = testCase.getUnit();
            
            tagName = unit.TIMER_TAG_NAME;
            timer('Tag', tagName);
            testCase.verifyNotEmpty(timerfindall('Tag', tagName));
            
            unit.deleteAllTimers();
            testCase.verifyEmpty(timerfindall('Tag', tagName));
        end
        
        
        function testUnicodeBlocks(testCase)
            unit = testCase.getUnit();
            
            blocks = unit.getUnicodeSubBlocks();
            testCase.verifyEqual(blocks, '▏▎▍▌▋▊▉█');
        end
        
        
        function testAsciiBlocks(testCase)
            unit = testCase.getUnit();
            
            blocks = unit.getAsciiSubBlocks();
            testCase.verifyEqual(blocks, '########');
        end
        
        
        function testBackspaces(testCase)
            unit = testCase.getUnit();
            
            backspaces = unit.backspace(3);
            testCase.verifyEqual(backspaces, sprintf('\b\b\b'));
        end
        
        
        function testTimeConversion(testCase)
            unit = testCase.getUnit();
            
            testCase.verifyEqual(unit.convertTime(0), [0, 0, 0]);
            testCase.verifyEqual(unit.convertTime(30), [0, 0, 30]);
            testCase.verifyEqual(unit.convertTime(60), [0, 1, 0]);
            testCase.verifyEqual(unit.convertTime(60*60), [1, 0, 0]);
        end
        
        
        function checkBarLengthInput(testCase)
            unit = testCase.getUnit();
            
            testCase.verifyEqual(unit.checkInputOfTotal([]), true);
            testCase.verifyEqual(unit.checkInputOfTotal(10), true);
            
            testCase.verifyError(@() unit.checkInputOfTotal('char'), 'MATLAB:invalidType');
            testCase.verifyError(@() unit.checkInputOfTotal(-1), 'MATLAB:expectedPositive');
            testCase.verifyError(@() unit.checkInputOfTotal([1, 1]), 'MATLAB:expectedScalar');
            testCase.verifyError(@() unit.checkInputOfTotal(1j), 'MATLAB:expectedInteger');
            testCase.verifyError(@() unit.checkInputOfTotal(1.5), 'MATLAB:expectedInteger');
            testCase.verifyError(@() unit.checkInputOfTotal(inf), 'MATLAB:expectedInteger');
            testCase.verifyError(@() unit.checkInputOfTotal(nan), 'MATLAB:expectedInteger');
        end
        
        
        function findWorkerFiles(testCase)
            unit = testCase.getUnit();
            
            pattern = updateParallel();
            testCase.assertEmpty(dir(pattern));
            
            workerFilename = [pattern(1:end-1), 'test'];
            fid = fopen(workerFilename, 'w');
            fclose(fid);
            
            foundFiles = unit.findWorkerFiles(pwd());
            testCase.verifyEqual(length(foundFiles), 1);
            testCase.verifyEqual(foundFiles, {fullfile(pwd(), workerFilename)});
            
            delete(workerFilename);
        end
        
        
        function barHasDefaults(testCase)
            unit = testCase.getUnit();
            
            testCase.verifyEqual(unit.TIMER_TAG_NAME, 'ProgressBar');
            testCase.verifyEmpty(unit.Total);
            testCase.verifyEqual(unit.UpdateRate, 5);
            testCase.verifyEqual(unit.Unit, 'Iterations');
            testCase.verifyTrue(unit.UseUnicode);
            testCase.verifyFalse(unit.IsParallel);
            testCase.verifyFalse(unit.OverrideDefaultFont);
        end
        
        
        function canSetBarTotal(testCase)
            unit = testCase.getUnit(10);
            
            testCase.verifyEqual(unit.Total, 10);
        end
        
        
        function canPrintSimpleBar(testCase)
            unit = testCase.getUnit();
            
            firstBar = evalc('unit([], [], [])');
            pause(0.2);
            secondBar = evalc('unit([], [], [])');
            
            testCase.verifyTrue(contains(firstBar, 'Processing'));
            testCase.verifyTrue(contains(firstBar, '1it'));
            
            testCase.verifyTrue(contains(secondBar, '2it'));
            unit.release();
        end
        
        
        function canPrintBarWithTotal(testCase)
            unit = testCase.getUnit(2);
            
            firstBar = evalc('unit([], [], [])');
            testCase.verifyTrue(contains(firstBar, 'Processing'));
            testCase.verifyTrue(contains(firstBar, '050%'));
            testCase.verifyTrue(contains(firstBar, '1/2'));
            
            secondBar = evalc('unit([], [], [])');
            testCase.verifyTrue(contains(secondBar, '100%'));
            testCase.verifyTrue(contains(secondBar, '2/2'));
            
            unit.release();
        end
        
        
        function canPrintLongTitle(testCase)
            unit = testCase.getUnit(2);
            unit.Title = 'This is a long title string';
            
            firstBar = evalc('unit([], [], [])');
            secondBar = evalc('unit([], [], [])');
            unit.release();
            
            testCase.verifyNotEqual(firstBar, secondBar);
        end
        
        
        function canRunWithoutUpdateTimer(testCase)
            unit = testCase.getUnit(2, 'UpdateRate', inf);
            
            firstBar = evalc('unit([], [], [])');
            secondBar = evalc('unit([], [], [])');
            unit.release();
            
            testCase.verifyTrue(contains(firstBar, '1/2it'));
            testCase.verifyTrue(contains(secondBar, '2/2it'));
        end
        
        
        function canBeDisabled(testCase)
            unit = testCase.getUnit(2, 'IsActive', false);
            
            firstBar = evalc('unit([], [], [])');
            secondBar = evalc('unit([], [], [])');
            unit.release();
            
            testCase.verifyEmpty(firstBar);
            testCase.verifyEmpty(secondBar);
        end
    end
    
    
    methods (Test, TestTags = {'Parallel'})
        function canRunInParallel(testCase)
            numIterations = 100;
            
            unit = testCase.getUnit(numIterations, ...
                'IsParallel', true, ...
                'WorkerDirectory', pwd() ...
                );
            
            init = evalc('unit.setup([], [], []);');
            parfor iIteration = 1:numIterations
                pause(0.1);
                updateParallel([], pwd());
            end
            unit.release();
            
            testCase.verifyTrue(contains(init, '000%'));
            testCase.verifyTrue(contains(init, sprintf('0/%dit', numIterations)));
            testCase.verifyEmpty(timerfindall('Tag', 'ProgressBar'));
            
            pause(0.5);
            files = unit.findWorkerFiles(pwd());
            testCase.verifyEmpty(files);
        end
    end
    
    
    
    methods
        function [unit] = getUnit(testCase, total, varargin)
            % Factory to get a bar object with desired 'total'
            
            if nargin < 2
                total = [];
            end
            
            unitHandle = str2func(testCase.UnitName);
            unit = unitHandle(total, varargin{:});
        end
    end
    
    
end
