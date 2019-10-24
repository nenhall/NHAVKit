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
  spec.default_subspec = [
    'Baseic', 'Play', 'Capture', 
    'FFmpegEncoder','FFmpegDecoder', 'X26xEncoder'
  ]
  spec.info_plist = {
    'NSCameraUsageDescription' => 'Use Camera',
    'NSMicrophoneUsageDescription' => 'Use Microphone',
    # 'NSPhotoLibraryAddUsageDescription' => 'Use Camera',
    # 'NSPhotoLibraryUsageDescription' => 'Use Camera',
  }
  
  spec.subspec 'Baseic' do |b|
    b.source_files        = 'NHAVKit2/Baseic/**/*.{h,m}'
    b.frameworks          = 'Foundation', 'UIKit'
    b.prefix_header_contents = '#import <UIKit/UIKit.h>', '#import <Foundation/Foundation.h>'
  end
  
  spec.subspec 'FFmpeg' do |ff|
    ff.source_files        = 'NHAVKit2/Library/FFmpeg/include/**/*.h'
    ff.public_header_files = 'NHAVKit2/Library/FFmpeg/include/**/*.h'
    ff.header_mappings_dir = 'NHAVKit2/Library/FFmpeg/include'
    ff.vendored_libraries  = 'NHAVKit2/Library/FFmpeg/lib/*.a'
    ff.frameworks = 'AVFoundation', 'VideoToolbox', 'AudioToolbox'
    ff.libraries  = 'z', 'bz2', 'iconv'
    ff.dependency 'NHAVKit2/Baseic'
  end
  
  spec.subspec 'FFmpegEncoder' do |fec|
    fec.source_files = 'NHAVKit2/Capture/Encoder/FFmpeg/*.{h,m}'
    fec.dependency 'NHAVKit2/Baseic'
    fec.dependency 'NHAVKit2/FFmpeg'
  end
  
  spec.subspec 'FFmpegDecoder' do |fdc|
    fdc.source_files = 'NHAVKit2/Play/Decoder/FFmpeg/*.{h,m}'
    fdc.dependency 'NHAVKit2/Baseic'
    fdc.dependency 'NHAVKit2/FFmpeg'
  end
  
  spec.subspec 'X26xLib' do |x|
    x.source_files        = 'NHAVKit2/Library/x264/include/**/*.h'
    x.header_mappings_dir = 'NHAVKit2/Library/x264/include'
    x.public_header_files = 'NHAVKit2/Library/x264/include/**/*.h'
    x.vendored_libraries  = 'NHAVKit2/Library/x264/lib/*.a'
    x.frameworks = 'VideoToolbox', 'AudioToolbox'
    x.libraries  = 'z', 'bz2', 'iconv'
    x.prefix_header_contents = [
      '#import <Foundation/Foundation.h>', 
      '#import <AVFoundation/AVFoundation.h>'
    ]
    x.dependency 'NHAVKit2/Baseic'
  end

  spec.subspec 'X26xEncoder' do |x26ec|
    x26ec.source_files        = 'NHAVKit2/Capture/Encoder/X264/*.{h,m}'
    x26ec.frameworks = 'VideoToolbox', 'AudioToolbox'
    x26ec.libraries  = 'z', 'bz2', 'iconv'
    x26ec.prefix_header_contents = [
      '#import <Foundation/Foundation.h>', 
      '#import <AVFoundation/AVFoundation.h>'
    ]
    x26ec.dependency 'NHAVKit2/Baseic'
    x26ec.dependency 'NHAVKit2/X26xLib'
    x26ec.dependency 'NHAVKit2/FFmpegEncoder'
  end
  
  spec.subspec 'Play' do |p|
    p.source_files  = 'NHAVKit2/Play/**/*.{h,m}'
    p.exclude_files = 'NHAVKit2/Play/Decoder/FFmpeg/**/*.{h,m}'
    p.resources  = 'NHAVKit2/Play/Library/NHPlay.bundle'
    p.frameworks = 'AVFoundation', 'VideoToolbox'
    p.libraries  = 'z', 'bz2', 'iconv'
    p.dependency 'NHAVKit2/Baseic'
  end
  
  spec.subspec 'Capture' do |c|
    c.source_files  = [
      'NHAVKit2/Capture/**/*.{h,m}',
      'NHAVKit2/Capture/Library/GPUImage/Source/*.h',
      'NHAVKit2/Capture/Library/GPUImage/Source/iOS/*.{h,m}'
    ]
    c.exclude_files = [
      'NHAVKit2/Capture/Encoder/FFmpeg/**/*.{h,m}',
      'NHAVKit2/Capture/Encoder/X264/**/*.{h,m}'
    ]
    c.resources  = 'NHAVKit2/Capture/Library/GPUImage/Resources/*.png'
    c.frameworks = 'OpenGLES', 'AVFoundation', 'CoreVideo', 'VideoToolbox'
    c.libraries  = 'z', 'bz2', 'iconv'
    c.dependency 'NHAVKit2/Baseic'
  end
  
end


