$iOSVersion = '12.0'

platform :ios, $iOSVersion

target 'VinliSDK' do
end

target 'VinliSDKTests' do
pod 'OCMock'
end

# ignore all warnings from all pods
inhibit_all_warnings!

post_install do |installer|
  # Change project settings
  installer.pods_project.build_configurations.each do |config|
    config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = $iOSVersion
    config.build_settings['EXCLUDED_ARCHS'] = 'x86_64'
    config.build_settings['EXCLUDED_ARCHS[sdk=iphonesimulator*]'] = 'arm64 arm64e'
  end

  # Change target settings
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = $iOSVersion
    end
  end
end