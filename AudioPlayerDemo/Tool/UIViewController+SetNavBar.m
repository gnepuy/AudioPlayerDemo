//
//  UIViewController+SetNavBar.m
//  AudioPlayerDemo
//
//  Created by yp on 2018/3/22.
//  Copyright © 2018年 yp. All rights reserved.
//

#import "UIViewController+SetNavBar.h"

@implementation UIViewController (SetNavBar)

//  设置默认导航栏背景
- (void)setupDefaultNavbarUI {
    
    UIColor *bgColor = [UIColor whiteColor];
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [bgColor CGColor]);
    CGContextFillRect(context, rect);
    UIImage *barBgImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    // 设置导航栏背景图片
    [self.navigationController.navigationBar setBackgroundImage:barBgImage forBarMetrics:UIBarMetricsDefault];
    // 去除navigationBar底部分割线
    self.navigationController.navigationBar.shadowImage = barBgImage;
}
//  设置透明导航栏背景
- (void)setupClearNavbarUI {
    
    UIColor *bgColor = [UIColor colorWithHexString:@"#43A5FE"];
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [bgColor CGColor]);
    CGContextFillRect(context, rect);
    UIImage *barBgImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    // 设置导航栏背景图片
    [self.navigationController.navigationBar setBackgroundImage:barBgImage forBarMetrics:UIBarMetricsDefault];
    // 去除navigationBar底部分割线
    self.navigationController.navigationBar.shadowImage = barBgImage;
}

@end
