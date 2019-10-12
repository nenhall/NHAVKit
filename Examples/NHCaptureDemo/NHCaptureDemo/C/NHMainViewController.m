//
//  NHMainViewController.m
//  NHCaptureDemo
//
//  Created by nenhall on 2019/3/11.
//  Copyright © 2019 nenhall. All rights reserved.
//

#import "NHMainViewController.h"
#import "NHVideoListCell.h"
#import "NHPushViewController.h"
#import "NHVideoRecordViewController.h"
#import <NHFoundation.h>
#import <NHUIKit.h>



@interface NHMainViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *recordButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *videoDatas;

@end

@implementation NHMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}


- (NSString *)outputURL {
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"test.mov"];
    return filePath;
}

- (IBAction)beginPushStream:(UIButton *)sender {
    NHPushViewController *pushVC = [[NHPushViewController alloc] initWithNibName:@"NHPushViewController" bundle:nil];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:pushVC];
    [self presentViewController:nav animated:YES completion:nil];
}

- (IBAction)startOrStopRecord:(UIButton *)sender {
    NHVideoRecordViewController *recordViewControll = [[NHVideoRecordViewController alloc] initWithNibName:@"NHVideoRecordViewController" bundle:nil];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:recordViewControll];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)updateVideoData:(NSString *)path {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDirectory = YES;
    BOOL isExist = [fileManager fileExistsAtPath:path isDirectory:&isDirectory];
    if (isExist) {
        NSArray *dirArray = [fileManager contentsOfDirectoryAtPath:path error:nil];
        
        if (isDirectory) {
            NSString * subPath = nil;
            for (NSString *fileName in dirArray) {
                BOOL issubDir = NO;
                subPath = [path stringByAppendingPathComponent:fileName];
                BOOL isExistsub = [fileManager fileExistsAtPath:fileName isDirectory:&issubDir];
                if (isExistsub) {
                    [self updateVideoData:subPath];
                } else {
                    [self.videoDatas addObject:subPath];
                }
            }
        } else {
            for (NSString *fileName in dirArray) {
                NSString *subPath = [path stringByAppendingPathComponent:fileName];
                [self.videoDatas addObject:fileName];
            }
        }
    }
    
    [self.tableView reloadData];
    if (self.videoDatas.count > 0) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.videoDatas count] -1 inSection:0]
                                      atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            });
        });
    }
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.videoDatas.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NHVideoListCell *cell = [NHVideoListCell loadCellWithTableView:tableView];
    
    NSString *title = self.videoDatas[indexPath.row];
    
    [cell setVideoTitle:title];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (tableView.bounds.size.width * 9 / 16) / 2 ;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *path = self.videoDatas[indexPath.row];
    
    
}

- (NSMutableArray *)videoDatas {
    if (!_videoDatas) {
        _videoDatas = [[NSMutableArray alloc] init];
    }
    return _videoDatas;
}

- (BOOL)shouldAutorotate {
    return YES;
}

@end

