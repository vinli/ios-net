# How to Release Podspec

- Update all the files needed
- Bump the pod version in the `VinliNet.podspec`:
    - s.version

          s.version      = "1.4.0"

    - s.source

          s.source       = { :git => "https://github.com/vinli/ios-net.git", :tag => "1.4.0" }

- Test to make sure there will be no errors:

      pod lib lint

- Push the podspec to the Cocoapod trunk. If there are warnings, it should be safe to disable them:

      pod trunk push VinliNet.podspec --allow-warnings