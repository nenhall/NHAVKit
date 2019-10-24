# NHAVKit2
基于苹果原生的框架编写的 iOS视频播放、编辑、采集的库



## 使用方法

#### cocoapod:

```ruby
#默认会导入所有模块：播放、采集、FFmpeg、X624
pod 'NHAVKit2'

# 若想导入指定某模块，则使用如下命令：
pod 'NHAVKit2/Play' #播放，全是基于苹果原生框架封装的
pod 'NHAVKit2/Capture' #采集，全是基于苹果原生框架封装的
pod 'NHAVKit2/X26xEncoder' # h264 编码
pod 'NHAVKit2/FFmpegEncoder' # FFmpeg 编码
pod 'NHAVKit2/FFmpegDecoder' # FFmpeg 解码
```



