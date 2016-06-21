ProgressBar
=======================

Should look like [TQDM](https://github.com/tqdm/tqdm) and uses [left blocks](http://www.w3schools.com/charsets/ref_utf_block.asp)

How to set [static "properties"](http://stackoverflow.com/a/14571266) in MATLAB. This could be useful for the handling of multiple, global ProgressBar objects and the global timer.


Feature Request
----------------------

- [x] TQDM blocks
- [ ] Time estimate
    - [x] over all last iterations
    - [ ] running mean/median
- [ ] after x seconds without update (e.g. the processing step takes a lot of time) we show an idle icon
- [x] Section names etc.
- [ ] nesting with global ProgressBar list
- [ ] visual update interval
- [ ] printMessage() method for debug printing (or similar)
- [ ] when no `numIterations` is passed we state the ET and number of iterations and it/s
- [ ] we can support another meaningful 'total of something' measure where the number of items is less meaningful (for example non-uniform processing time) such as total file size (processing multiple files with different file size)
- [ ] get width of the command window to adjust the prog. bar width
