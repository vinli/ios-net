
Pod::Spec.new do |s|


  s.name         = "VinliNet"
  s.version      = "1.9.5"
  s.summary      = "Framework for accessing Vinli services."

  s.description  = <<-DESC
                   Framework for accessing Vinli services for developers
                   DESC

  s.homepage     = "https://github.com/vinli/ios-net"

  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author       = { "Vinli Devs" => "dev@vin.li" }

  s.platform     = :ios, "12.0"

  s.source       = { :git => "https://github.com/vinli/ios-net.git", :tag => "1.9.5" }

  s.dependency 'jetfire', '~>0.1.5'
  s.dependency 'CocoaAsyncSocket', '~>7.4.3'

  s.source_files = 'VinliSDK/*.{h,m}'
  s.resources    = 'VinliSDK/*.{js}'
  #s.resources    = 'VinliSDK/*.{storyboard}'

  s.requires_arc = true

end
