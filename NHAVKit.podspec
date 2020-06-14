Pod::Spec.new do |spec|

  spec.name         = "NHAVKit"
  spec.version      = "0.0.1"
  spec.summary      = "基于苹果原生的框架编写的 iOS视频播放、编辑、采集的库"
  spec.description  = <<-DESC
  基于苹果原生的AVFoundation框架编写的 iOS视频播放、编辑、采集的库
                   DESC
  spec.homepage     = "https://github.com/nenhall/NHAVKit"
  spec.license      = { :type => "MIT", :file => "FILE_LICENSE" }
  spec.author       = { "nenhall" => "nenhall@126.com" }
  spec.platform     = :ios
  spec.ios.deployment_target = "9.0"
  spec.source       = { :git => "https://github.com/nenhall/NHAVKit.git", :tag => "#{spec.version}" }
  spec.requires_arc = true
  # spec.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  spec.default_subspec = 'Cocoa', 'Player', 'Capture'
  
end
  b.subspec 'Cocoa' do |b|
  b.source_files  = "NHEditor/NHEditor/Sources/**/*.{h,swift}"
  b.public_header_files = "NHEditor/NHAVEditor/Sources/**/*.{h}"
  b.frameworks = "AVFoundation", "CoreGraphics", "CoreMedia", "VideoToolbox", "AudioToolbox"
end

spec.subspec 'Player' do |p|
  b.source_files  = "NHPlayer/NHPlayer/Sources/**/*.{h,swift}"
  b.public_header_files = "NHPlayer/NHPlayer/Sources/**/*.{h}"
  p.resources = "NHPlayer/NHPlayer/NHPlayer.bundle"
end

spec.subspec 'Capture' do |c|
  c.source_files  = "NHCapture/NHCapture/Sources/**/*.{h,swift}"
  c.public_header_files = "NHCapture/NHCapture/Sources/**/*.{h}"
end





