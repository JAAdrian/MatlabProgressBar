ProgressBar
=======================

Should look like [TQDM](https://github.com/tqdm/tqdm) and uses [left blocks](http://www.w3schools.com/charsets/ref_utf_block.asp)

How to set [static "properties"](http://stackoverflow.com/a/14571266) in MATLAB. This could be useful for the handling of multiple, global ProgressBar objects and the global timer.


Feature Request
----------------------

- [ ] TQDM blocks
- [ ] Time estimate
    - [ ] over all last iterations
    - [ ] running mean/median
- [ ] Section names etc.
- [ ] nesting with global ProgressBar list
- [ ] visual update interval
- [ ] printInfo() method for debug printing (or similar)
- [ ] when no `numIterations` is passed we state the ET and number of iterations, maybe also it/s
- [ ] we can support another meaningful 'total of something' measure where the number of items is less meaningful (for example non-uniform processing time) such as total file size (processing multiple files with different file size)
