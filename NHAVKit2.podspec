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
  spec.default_subspec = 'NHBaseic', 'NHPlayer', 'NHCapture'


spec.subspec 'NHBaseic' do |b|
  # b.source_files        = 'NHAVKit2/NHCaptureKit/Library/FFmpeg/include/**/*.h'
  b.public_header_files = 'NHAVKit2/NHCaptureKit/Library/FFmpeg/include/**/*.h'
  b.vendored_libraries  = 'NHAVKit2/NHCaptureKit/Library/FFmpeg/lib/*.a'
  b.frameworks = 'AVFoundation', 'CoreGraphics', 'CoreMedia', 'VideoToolbox', 'AudioToolbox'
  b.libraries  = 'z', 'bz2', 'iconv'
end

spec.subspec 'NHPlayer' do |p|
  p.source_files  = 'NHAVKit2/NHPlayKit/**/*.{h,m}'
  p.resources  = 'NHAVKit2/NHPlayKit/Library/NHPlay.bundle'
  p.frameworks = 'AVFoundation', 'CoreGraphics', 'CoreMedia', 'VideoToolbox', 'AudioToolbox'
  p.libraries  = 'z', 'bz2', 'iconv'
  p.dependency 'NHAVKit2/NHAVBaseic'
end

spec.subspec 'NHCapture' do |c|
  # 'NHAVKit2/NHCaptureKit/Library/x264-iOS/include/*.h'
  c.source_files  = 'NHAVKit2/NHCaptureKit/**/*.{h,m}', 'NHAVKit2/NHCaptureKit/Library/GPUImage/Source/*.h','NHAVKit2/NHAVCapture/GPUImage/Source/iOS/*.{h,m}'
  c.public_header_files = 'NHAVKit2/NHCaptureKit/NHLib/x264-iOS/include/*.h'
  c.vendored_libraries  = 'NHAVKit2/NHCaptureKit/NHLib/x264-iOS/lib/libx264.a'
  c.frameworks = 'OpenGLES', 'CoreMedia', 'QuartzCore', 'AVFoundation', 'CoreVideo', 'VideoToolbox'
  c.libraries  = 'z', 'bz2', 'iconv'
  c.dependency 'NHAVKit2/NHAVBaseic'
end

end


