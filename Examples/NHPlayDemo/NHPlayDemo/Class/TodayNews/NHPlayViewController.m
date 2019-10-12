//
//  NHPlayViewController.m
//  NHPlayDemo
//
//  Created by nenhall on 2019/3/9.
//  Copyright © 2019 nenhall_studio. All rights reserved.
//

#import "NHPlayViewController.h"
#import <NHPlayKit/NHPlayKit.h>
#import <NHExtension/NHUIKit.h>
#import <NHExtension/NHFoundation.h>


@interface NHPlayViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *playView;
@property (nonatomic, strong) NHAVPlayer *player;
@property (nonatomic, weak)IBOutlet UITableView *tableView;
@property (nonatomic, copy) NSArray *playList;

@end

@implementation NHPlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.estimatedRowHeight = 60;
    
    _player = [NHAVPlayer playerWithView:_playView playUrl:self.playList.lastObject];
    [_player setPlayerRate:1.0];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_player pause];
}

//- (BOOL)shouldAutorotate{
//  return YES;
//}
//
//- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
//  return UIInterfaceOrientationPortrait;
//}
//
//- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
//  if (_player.isFullScreen) {
//    return UIInterfaceOrientationMaskLandscapeRight;
//  } else {
//    return UIInterfaceOrientationMaskPortrait;
//  }
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView cellForRowAtIndexPath:indexPath].imageView.image = [NHImageHandle getCoverImageFromVideoURL:self.playList[indexPath.row] time:10];
    
    [_player pause];
    
    _player = nil;
    _player = [NHAVPlayer playerWithView:_playView playUrl:self.playList[indexPath.row]];
    [_player play];
    
    //    [_player replaceCurrentItemWithPlayUrl:_playList[indexPath.row]];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.playList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    
    cell.textLabel.text = self.playList[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:12];
    cell.textLabel.numberOfLines = 3;
    cell.textLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    cell.imageView.image = [NHImageHandle getCoverImageFromVideoURL:self.playList[indexPath.row] time:5.0];
    
    return cell;
}

// 字体设置为白色
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (NSArray *)playList {
    if (!_playList) {
        _playList = @[
                      @"http://pde9w6bo8.bkt.clouddn.com/%D0%91%D0%B0%D0%BC%D0%B1%D0%B8%D0%BD%D1%82%D0%BE%D0%BD%20-%20%D0%97%D0%B0%D1%8F_m.mp4",
                      @"https://devstreaming-cdn.apple.com/videos/wwdc/2018/236mwbxbxjfsvns4jan/236/hls_vod_mvp.m3u8",
                      @"http://qvw.facebac.com/hls/16fe72d730196a7ce310/xfvd866xlpi7rji5wmvs/n_n/b8d4963121d0ec94c2959f4cfe9b3367.m3u8?xstToken=470d1359",
                      @"https://aweme-hl.snssdk.com/aweme/v1/play/?video_id=v0200f090000bgno2nrrm1n371stb970&line=0&ratio=540p&media_type=4&vr_type=0&test_cdn=None&improve_bitrate=0&iid=45608209672&ac=WIFI&os_api=18&app_name=aweme&channel=App%20Store&idfa=7503AAF2-77CB-4997-BDF2-CE494751168A&device_platform=iphone&build_number=28007&vid=102AA134-9F9B-47D1-95D9-09DEA1DED71E&openudid=3bb37a065a22e5e38c9d90c47fd7fa76283a83f0&device_type=iPhone8%2C1&app_version=2.8.0&device_id=57633106806&version_code=2.8.0&os_version=10.3.2&screen_width=750&aid=1128",
                      @"https://www.apple.com/105/media/us/iphone-x/2017/01df5b43-28e4-4848-bf20-490c34a926a7/films/feature/iphone-x-feature-tpl-cc-us-20170912_1280x720h.mp4",
                      @"https://www.apple.com/105/media/cn/mac/family/2018/46c4b917_abfd_45a3_9b51_4e3054191797/films/bruce/mac-bruce-tpl-cn-2018_1280x720h.mp4",
                      [[NSBundle mainBundle] pathForResource:@"I’m-so-sick-1080P—Apink" ofType:@"mp4"]
                      ];
    }
    return _playList;
}

@end
