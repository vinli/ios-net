Pod::Spec.new do |s|
  s.name         = "VinliNet"
  s.version      = "2.0.0"
  s.summary      = "Framework for accessing Vinli services."

  s.description  = <<-DESC
                   Framework for accessing Vinli services for developers
                   DESC

  s.homepage     = "https://github.com/vinli/ios-net"

  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author       = { "Vinli Devs" => "dev@vin.li" }

  s.platform     = :ios, "12.0"

  s.source       = { :git => "https://github.com/vinli/ios-net.git", :tag => "2.0.0" }

  s.ios.deployment_target = '13.0'

  s.source_files = 'VinliSDK/*.{h,m}'
  s.resources    = 'VinliSDK/*.{js}'
end
