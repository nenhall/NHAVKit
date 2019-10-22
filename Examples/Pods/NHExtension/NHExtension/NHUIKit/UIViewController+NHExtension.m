//
//  UIViewController+NHExtension.m
//  NHExtension
//
//  Created by neghao on 2016/12/28.
//  Copyright © 2016年 neghao.studio. All rights reserved.
//

#import "UIViewController+NHExtension.h"


@implementation UIViewController (NHExtension)

- (void)backController {
    [self.view endEditing:YES];
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)endScrollViewRefresh:(UIScrollView *)scrollView{
    
    if ([scrollView isKindOfClass:[UITableView class]]) {
        UITableView *tableView = (UITableView *)scrollView;
//        [tableView.header performSelectorOnMainThread:@selector(endRefreshing) withObject:tableView waitUntilDone:NO];
//        [tableView.footer performSelectorOnMainThread:@selector(endRefreshing) withObject:tableView waitUntilDone:NO];
    }

    if ([scrollView isKindOfClass:[UICollectionView class]]){
        UICollectionView *collectionView = (UICollectionView *)scrollView;
//        [collectionView.header performSelectorOnMainThread:@selector(endRefreshing) withObject:collectionView waitUntilDone:NO];
//        [collectionView.footer performSelectorOnMainThread:@selector(endRefreshing) withObject:collectionView waitUntilDone:NO];
    }
}

- (UIViewController*)topViewControllerWithRootViewController:(UIViewController*)rootViewController {
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController* tabBarController = (UITabBarController*)rootViewController;
        return [self topViewControllerWithRootViewController:tabBarController.selectedViewController];
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController* navigationController = (UINavigationController*)rootViewController;
        return [self topViewControllerWithRootViewController:navigationController.visibleViewController];
    } else if (rootViewController.presentedViewController) {
        UIViewController* presentedViewController = rootViewController.presentedViewController;
        return [self topViewControllerWithRootViewController:presentedViewController];
    } else {
        return rootViewController;
    }
}

- (void)dismissViewControllerClass:(Class)cla {
    UIViewController *vc = self;
    while (![vc isKindOfClass:cla] && vc != nil) {
        vc = vc.presentingViewController;
        if ([vc isKindOfClass:[UINavigationController class]]) {
            vc = ((UINavigationController *)vc).viewControllers.lastObject;
        }
    }
    [vc dismissViewControllerAnimated:YES completion:nil];
}

- (UIViewController *)getCurrentTopViewController {
    UIViewController *result = nil;
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    if ([window subviews].count >= 1) {
        UIView *frontView = [[window subviews] objectAtIndex:0];
        id nextResponder = [frontView nextResponder];
        
        if ([nextResponder isKindOfClass:[UIViewController class]]){
            result = nextResponder;
        } else {
            result = window.rootViewController;
        }
    }
    return result;
}

@end

