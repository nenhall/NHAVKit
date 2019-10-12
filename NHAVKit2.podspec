Pod::Spec.new do |spec|

  spec.name         = "NHAVKit2"
  spec.version      = "0.0.1"
  spec.summary      = "基于苹果原生的框架编写的 iOS视频播放、编辑、采集的库"
  spec.description  = <<-DESC
  基于苹果原生的框架编写的 iOS视频播放、编辑、采集的库
                   DESC
  spec.homepage     = "https://github.com/nenhall/NHAVKit"
  spec.license      = { :type => "MIT", :file => "FILE_LICENSE" }
  spec.author       = { "nenhall" => "nenhall@126.com" }
  spec.platform     = :ios
  spec.platform     = :ios, "8.0"
  spec.ios.deployment_target = "10.0"
  spec.ios.deployment_target = "10.0"
  spec.source       = { :git => "https://github.com/nenhall/NHAVKit.git", :tag => "#{spec.version}" }
  spec.requires_arc = true
  # spec.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  spec.default_subspec = 'NHAVBaseic', 'NHAVPlayer', 'NHAVCapture'
end
  b.subspec 'NHAVBaseic' do |b|
  b.source_files  = "NHAVKit2/NHAVBaseic/NHLib/FFmpeg/include/**/*.{h,m}"
  b.public_header_files = "NHAVKit2/NHAVBaseic/NHLib/FFmpeg/include/**/*.h"
  b.resources = "NHAVKit2/NHAVPlayer/NHPlay.bundle"
  b.frameworks = "AVFoundation", "CoreGraphics", "CoreMedia", "VideoToolbox", "AudioToolbox"
  b.libraries = "z", "bz2", "iconv"
end

spec.subspec 'NHAVPlayer' do |p|
  p.source_files  = "NHAVKit2/NHAVPlayer/**/*.{h,m}"
  p.public_header_files = "NHAVKit2/NHAVBaseic/NHLib/FFmpeg/include/**/*.h"
  p.resources = "NHAVKit2/NHAVPlayer/NHPlay.bundle"
  p.frameworks = "AVFoundation", "CoreGraphics", "CoreMedia", "VideoToolbox", "AudioToolbox"
  p.libraries = "z", "bz2", "iconv"
end

spec.subspec 'NHAVCapture' do |c|
  c.source_files  = "NHAVKit2/NHAVCapture/**/*.{h,m}"
  c.public_header_files = "NHAVKit2/NHAVBaseic/NHLib/FFmpeg/include/**/*.h"
  c.resources = "NHAVKit2/NHAVPlayer/NHPlay.bundle"
  c.frameworks = "AVFoundation", "CoreGraphics", "CoreMedia", "VideoToolbox", "AudioToolbox"
  c.libraries = "z", "bz2", "iconv"
end





