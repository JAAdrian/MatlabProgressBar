# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]
### Added
- Optional switch to override default MATLAB font in Windows by `OverrideDefaultFont` property. If `true` and while the bar is not released, MATLAB's code font will be changed programmatically to `Courier New`
- Proper unit testing as a test-case class

### Changed
- Demos should now be a bit prettier


## [3.1.1] - 2019-11-26
### Fixed
- Updated CHANGELOG

### Added
- MATHWORKS FileExchange banner in the README

## [3.1.0] - 2019-11-03
### Changed
- Made some properties constant and method static
- Cleaned up comments
- Updated README and CHANGELOG

## [3.0.0] - 2017-05-02
### Changed
The whole class has been re-factored to be a **MATLAB System Object**
- Since updating a progress bar is an iterative process with a setup/reset/release paradigm, this object type fits the purpose best
- Due to the System Object class structure, multiple methods have been renamed and optional input arguments for the `step()` (formerly `update()`) method are now mandatory. See the example in `README.md`.
- The bar's **title** is now mandatory and has a default string: `'Processing'`. Notable change is that if the title exceeds the length of 20 characters the title will act like a banner and cycle with a shift of 3 characters each time the bar is updated. This way, the progress bar can have a constant width (for now, 90 characters seem to fit many screens).

## [3.1.0] - 2019-11-03
### Fixed
- Moved setup-related method-calls to the setup phase of the object. In v3.0.0, the timer object was initialized in the constructor, leading to potential issues in computing the elapsed time and estimated time until completion. Also, user-set properties (like, e.g., the bar's title) could have had no influence while calling the step function due to the same reason.

### Changed
- Renamed private properties
- The class' version is now stated as a constant property