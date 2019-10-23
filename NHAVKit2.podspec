Pod::Spec.new do |spec|

  spec.name         = 'NHAVKit2'
  spec.version      = "0.0.1"
  spec.summary      = 'iOS视频播放、编辑、采集的库'
  spec.description  = <<-DESC
  基于苹果原生的AVFoundation框架编写的 iOS视频播放、编辑、采集的库
                   DESC
  spec.homepage     = 'https://github.com/nenhall/NHAVKit2'
  spec.license      = { :type => 'MIT', :file => 'LICENSE' }
  spec.author       = { 'nenhall' => 'nenhall@126.com' }
  spec.platform     = :ios
  spec.ios.deployment_target = '8.0'
  spec.source       = { :git => "https://github.com/nenhall/NHAVKit2.git", :tag => "#{spec.version}", :submodules => true }
  spec.requires_arc = true
  spec.xcconfig 	  = {
      'ENABLE_STRICT_OBJC_MSGSEND' => 'NO'
  }
  spec.default_subspec = 'Baseic', 'FFmpegEncoder','FFmpegDecoder', 'X26x', 'Play', 'Capture'


spec.subspec 'Baseic' do |b|
  b.source_files        = 'NHAVKit2/Baseic/**/*.{h,m}'
  b.frameworks          = 'Foundation', 'UIKit'
  b.prefix_header_contents = '#import <UIKit/UIKit.h>', '#import <Foundation/Foundation.h>'
end

spec.subspec 'FFmpegEncoder' do |cf|
  cf.source_files        = 'NHAVKit2/Library/FFmpeg/include/**/*.h', 'NHAVKit2/Capture/Encoder/FFmpeg/*.{h,m}'
  cf.header_mappings_dir = 'NHAVKit2/Library/FFmpeg/include'
  cf.vendored_libraries  = 'NHAVKit2/Library/FFmpeg/lib/*.a'
  cf.frameworks = 'AVFoundation', 'VideoToolbox', 'AudioToolbox'
  cf.libraries  = 'z', 'bz2', 'iconv'
  cf.dependency 'NHAVKit2/Baseic'
end

spec.subspec 'FFmpegDecoder' do |pf|
  pf.source_files        = 'NHAVKit2/Library/FFmpeg/include/**/*.h'
  # b.public_header_files = 'NHAVKit2/NHCaptureKit/Library/FFmpeg/include/**/*.h'
  pf.header_mappings_dir = 'NHAVKit2/Library/FFmpeg/include'
  pf.vendored_libraries  = 'NHAVKit2/Library/FFmpeg/lib/*.a'
  pf.frameworks = 'AVFoundation', 'VideoToolbox', 'AudioToolbox'
  pf.libraries  = 'z', 'bz2', 'iconv'
  pf.dependency 'NHAVKit2/Baseic'
end

spec.subspec 'X26x' do |x|
  x.source_files        = 'NHAVKit2/Library/x264/include/**/*.h', 'NHAVKit2/Capture/Encoder/X264/*.{h,m}'
  x.header_mappings_dir = 'NHAVKit2/Library/x264/include'
  x.vendored_libraries  = 'NHAVKit2/Library/x264/lib/*.a'
  x.frameworks = 'AVFoundation', 'VideoToolbox', 'AudioToolbox'
  x.libraries  = 'z', 'bz2', 'iconv'
  x.prefix_header_contents = '#import <UIKit/UIKit.h>', '#import <Foundation/Foundation.h>', '#import <AVFoundation/AVFoundation.h>'
  x.dependency 'NHAVKit2/Baseic'
end

spec.subspec 'Play' do |p|
  p.source_files  = 'NHAVKit2/Play/**/*.{h,m}', 'NHAVKit2/Play/Decoder/**/*.{h,m}'
  p.public_header_files = 'NHAVKit2/Play/Library/FFmpeg/include/**/*.h'
  p.resources  = 'NHAVKit2/Play/Library/NHPlay.bundle'
  p.frameworks = 'AVFoundation', 'VideoToolbox'
  p.libraries  = 'z', 'bz2', 'iconv'
  p.dependency 'NHAVKit2/Baseic'
end


spec.subspec 'Capture' do |c|
  c.source_files  = 'NHAVKit2/Capture/**/*.{h,m}', 'NHAVKit2/Capture/Library/GPUImage/Source/*.h','NHAVKit2/Capture/GPUImage/Source/iOS/*.{h,m}'
  c.frameworks = 'OpenGLES', 'AVFoundation', 'CoreVideo', 'VideoToolbox'
  c.libraries  = 'z', 'bz2', 'iconv'
  c.dependency 'NHAVKit2/Baseic'
end

end


