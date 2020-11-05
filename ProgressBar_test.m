classdef ProgressBar_test < matlab.unittest.TestCase
%PROGRESSBAR_TEST Unit test for ProgressBar.m
% -------------------------------------------------------------------------
% Run it by calling 'runtests()'
%   or specifically 'runtests('ProgressBar_test')'
%
% Author :  J.-A. Adrian (JA) <jensalrik.adrian AT gmail.com>
% Date   :  05-Nov-2020 19:26:43
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
end

methods (TestMethodSetup)
	function setMethodRng(testCase)
		rng(testCase.DEFAULT_SEED);
    end
end



methods (Test)
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
end



methods
    function [unit] = getUnit(testCase, len)
        if nargin < 2 || isempty(len)
            len = [];
        end
        
        unitHandle = str2func(testCase.UnitName);
        unit = unitHandle(len);
    end
end


end
