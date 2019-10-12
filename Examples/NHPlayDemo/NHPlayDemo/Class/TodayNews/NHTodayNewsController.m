//
//  NHTodayNewsController.m
//  NHPlayDemo
//
//  Created by nenhall on 2019/10/10.
//  Copyright © 2019 nenhall_studio. All rights reserved.
//

#import "NHTodayNewsController.h"
#import <NHExtension/NHUIKit.h>
#import <NHExtension/NHFoundation.h>
#import "NHTodayNewsCell.h"
#import <NHPlayKit/NHPlayKit.h>


@interface NHTodayNewsController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, copy) NSArray *videoList;
@property (nonatomic, strong) NHAVPlayer *player;

@end

@implementation NHTodayNewsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self videoList];
    //    _player = [NHAVPlayer playerWithView:_playView playUrl:_videoList.firstObject];
    _player = [[NHAVPlayer alloc] init];
    [_player setPlayerRate:1.0];
    _player.playerView.customToolBar = true;
    
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_player pause];
}


- (IBAction)openPlayController:(UIButton *)sender {
//   UIStoryboard *storeboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
//    NHRecordViewController *recordView = [storeboard instantiateViewControllerWithIdentifier:@"NHRecordViewController"];
//    [self presentViewController:recordView animated:YES completion:nil];
}

- (IBAction)otherEvent:(UIButton *)sender {

}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _videoList.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(collectionView.width, collectionView.width *9 / 16);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"NHTodayNewsCell" forIndexPath:indexPath];
    
    
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(NHTodayNewsCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    [cell setPlayURL:self.videoList[indexPath.item]];
//    [self restartPlay];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NHTodayNewsCell *currentCell = (NHTodayNewsCell *)[_collectionView cellForItemAtIndexPath:indexPath];
    [_player setPlaySuperView:[currentCell playView]];
    [_player replaceCurrentItemWithPlayUrl:_videoList[indexPath.row]];
    [_player play];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
  
}

- (void)restartPlay {
    NSArray *cells = [_collectionView visibleCells];
    if (cells.count) {
        NHTodayNewsCell *currentCell = cells.lastObject;
        NSIndexPath *indexPath = [_collectionView indexPathForCell:currentCell];
        [_player setPlaySuperView:[currentCell playView]];
        [_player replaceCurrentItemWithPlayUrl:_videoList[indexPath.row]];
        [_player play];
    }
}


- (NSArray *)videoList {
    if (!_videoList) {
        _videoList = @[
            @"https://www.apple.com/105/media/cn/mac/family/2018/46c4b917_abfd_45a3_9b51_4e3054191797/films/bruce/mac-bruce-tpl-cn-2018_1280x720h.mp4",
                        [[NSBundle mainBundle] pathForResource:@"I’m-so-sick-1080P—Apink" ofType:@"mp4"],
                        @"https://www.apple.com/105/media/cn/mac/family/2018/46c4b917_abfd_45a3_9b51_4e3054191797/films/bruce/mac-bruce-tpl-cn-2018_1280x720h.mp4",
                        [[NSBundle mainBundle] pathForResource:@"I’m-so-sick-1080P—Apink" ofType:@"mp4"],
                        @"https://www.apple.com/105/media/cn/mac/family/2018/46c4b917_abfd_45a3_9b51_4e3054191797/films/bruce/mac-bruce-tpl-cn-2018_1280x720h.mp4",
                        [[NSBundle mainBundle] pathForResource:@"I’m-so-sick-1080P—Apink" ofType:@"mp4"],
                        @"https://devstreaming-cdn.apple.com/videos/wwdc/2018/236mwbxbxjfsvns4jan/236/hls_vod_mvp.m3u8",
                        @"https://aweme-hl.snssdk.com/aweme/v1/play/?video_id=v0200f090000bgno2nrrm1n371stb970&line=0&ratio=540p&media_type=4&vr_type=0&test_cdn=None&improve_bitrate=0&iid=45608209672&ac=WIFI&os_api=18&app_name=aweme&channel=App%20Store&idfa=7503AAF2-77CB-4997-BDF2-CE494751168A&device_platform=iphone&build_number=28007&vid=102AA134-9F9B-47D1-95D9-09DEA1DED71E&openudid=3bb37a065a22e5e38c9d90c47fd7fa76283a83f0&device_type=iPhone8%2C1&app_version=2.8.0&device_id=57633106806&version_code=2.8.0&os_version=10.3.2&screen_width=750&aid=1128",
                        @"https://www.apple.com/105/media/us/iphone-x/2017/01df5b43-28e4-4848-bf20-490c34a926a7/films/feature/iphone-x-feature-tpl-cc-us-20170912_1280x720h.mp4",
        ];
    }
    return _videoList;
}

@end
