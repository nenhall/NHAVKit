# NHAVKit
基于苹果原生的框架编写的 iOS视频播放、编辑、采集的库



![NHAVKit-Structure](https://github.com/nenhall/NHAVKit/blob/master/NHAVKit-Structure.png)



目前是还在开发中，还不能使用cocoapod引入，后续按这种模式走

```ruby
#默认会导入所有模块：播放、采集、FFmpeg、X624
pod 'NHAVKit'

# 若想导入指定某模块，则使用如下命令：
pod 'NHAVKit/Play' #播放，全是基于苹果原生框架封装的
pod 'NHAVKit/Capture' #采集，全是基于苹果原生框架封装的
pod 'NHAVKit/Editor' #编辑
pod 'NHAVKit/FFmpegEncoder' # FFmpeg 编码
pod 'NHAVKit/FFmpegDecoder' # FFmpeg 解码
```