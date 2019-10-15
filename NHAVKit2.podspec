Pod::Spec.new do |spec|

  spec.name         = 'NHAVKit2'
  spec.version      = '0.0.1'
  spec.summary      = 'iOS视频播放、编辑、采集的库'
  spec.description  = <<-DESC
  基于苹果原生的AVFoundation框架编写的 iOS视频播放、编辑、采集的库
                   DESC
  spec.homepage     = 'https://github.com/nenhall/NHAVKit2'
  spec.license      = { :type => 'MIT', :file => 'LICENSE' }
  spec.author       = { 'nenhall' => 'nenhall@126.com' }
  spec.platform     = :ios
  spec.ios.deployment_target = '8.0'
  spec.source       = { :git => 'https://github.com/nenhall/NHAVKit2.git', :tag => '#{spec.version}' }
  spec.requires_arc = true
  spec.xcconfig 	= {
      'ENABLE_STRICT_OBJC_MSGSEND' => 'NO'
  }
  spec.default_subspec = 'NHAVBaseic', 'NHAVPlayer', 'NHAVCapture'


spec.subspec 'NHAVBaseic' do |b|
  b.source_files  = 'NHAVKit2/NHAVBaseic/NHLib/FFmpeg/include/**/*.h', 'NHAVKit2/NHAVBaseic/NHLib/x264-iOS/include/*.h'
  b.public_header_files = 'NHAVKit2/NHAVBaseic/NHLib/FFmpeg/include/**/*.h'
  b.vendored_libraries  = 'NHAVKit2/NHAVBaseic/NHLib/FFmpeg/lib/*.a'
  b.resources  = 'NHAVKit2/NHAVPlayer/NHPlay.bundle'
  b.frameworks = 'AVFoundation', 'CoreGraphics', 'CoreMedia', 'VideoToolbox', 'AudioToolbox'
  b.libraries  = 'z', 'bz2', 'iconv'
end

spec.subspec 'NHAVPlayer' do |p|
  p.source_files  = 'NHAVKit2/NHAVPlayer/**/*.{h,m}'
  p.resources = 'NHAVKit2/NHAVPlayer/NHPlay.bundle'
  p.frameworks = 'AVFoundation', 'CoreGraphics', 'CoreMedia', 'VideoToolbox', 'AudioToolbox'
  p.libraries = 'z', 'bz2', 'iconv'
  p.dependency 'NHAVKit2/NHAVBaseic'
end

spec.subspec 'NHAVCapture' do |c|
  c.source_files  = 'NHAVKit2/NHAVCapture/**/*.{h,m}', 'NHAVKit2/NHAVBaseic/NHLib/GPUImage/Source/*.h','NHAVKit2/NHAVBaseic/NHLib/GPUImage/Source/iOS/*.{h,m}'
  c.public_header_files = 'NHAVKit2/NHAVBaseic/NHLib/x264-iOS/include/*.h'
  c.vendored_libraries  = 'NHAVKit2/NHAVBaseic/NHLib/x264-iOS/lib/libx264.a'
  c.resources = 'NHAVKit2/NHAVPlayer/NHPlay.bundle'
  c.frameworks = 'OpenGLES', 'CoreMedia', 'QuartzCore', 'AVFoundation', 'CoreVideo', 'VideoToolbox'
  c.libraries = 'z', 'bz2', 'iconv'
  c.dependency 'NHAVKit2/NHAVBaseic'
end


end


