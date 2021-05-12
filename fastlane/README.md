fastlane documentation
================
# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```
xcode-select --install
```

Install _fastlane_ using
```
[sudo] gem install fastlane -NV
```
or alternatively using `brew install fastlane`

# Available Actions
## iOS
### ios swiftlint
```
fastlane ios swiftlint
```
Run SwiftLint
### ios build_for_testing
```
fastlane ios build_for_testing
```
Build project to folder
### ios test_run
```
fastlane ios test_run
```
Testing folder from folder
### ios build_and_test
```
fastlane ios build_and_test
```
Build and test

----

This README.md is auto-generated and will be re-generated every time [fastlane](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
