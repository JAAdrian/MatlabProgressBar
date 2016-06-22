ProgressBar
=======================

Should look like [TQDM](https://github.com/tqdm/tqdm) and uses [left blocks](http://www.w3schools.com/charsets/ref_utf_block.asp)


Dependencies
-------------------------

No dependencies to toolboxes. The code has been tested with MATLAB r2016a.


Installation
-------------------------


Usage
-------------------------








How to set [static "properties"](http://stackoverflow.com/a/14571266) in MATLAB. This could be useful for the handling of multiple, global ProgressBar objects and the global timer.


Feature Request
----------------------

- [x] TQDM blocks
- [x] Section names etc.
- [x] visual update interval
- [x] when no `numIterations` is passed we state the ET and number of iterations and it/s
- [x] nested bars
- [ ] Time estimate
    - [x] over all last iterations
    - [ ] running mean/median
- [ ] after x seconds without update (e.g. the processing step takes a lot of time) we show an idle icon
- [ ] printMessage() method for debug printing (or similar)
- [ ] we can support another meaningful 'total of something' measure where the number of items is less meaningful (for example non-uniform processing time) such as total file size (processing multiple files with different file size)
