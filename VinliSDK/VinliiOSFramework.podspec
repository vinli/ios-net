Pod::Spec.new do |s|
  s.name             = "VinliiOSFramework"
  s.version          = "1.0.0"
  s.summary          = "Private Vinli iOS Framework."
  s.homepage         = "https://github.com/vinli/vinli-ios-framework"
  s.author           = { "Bryan" => "bryan@vin.li" }
  s.source           = { :git => "https://github.com/vinli/vinli-ios-framework.git", :branch => "develop" } #, :tag => s.version }

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'VinliUIKit/VinliUIKit'
  s.resources = 'VinliUIKit/Resources/*'

  s.frameworks = 'UIKit'
  s.module_name = 'VinliUIKit'
end
