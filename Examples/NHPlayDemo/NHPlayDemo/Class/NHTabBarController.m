//
//  NHTabBarController.m
//  NHPlayDemo
//
//  Created by nenhall on 2019/10/11.
//  Copyright © 2019 nenhall_studio. All rights reserved.
//

#import "NHTabBarController.h"
#import "NHTabBar.h"

@interface NHTabBarController ()

@end

@implementation NHTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];

    NHTabBar *tabbar = [[NHTabBar alloc] initWithFrame:self.tabBar.frame];
    [self setValue:tabbar forKey:@"tabBar"];

    [self setSelectedIndex:1];

}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
