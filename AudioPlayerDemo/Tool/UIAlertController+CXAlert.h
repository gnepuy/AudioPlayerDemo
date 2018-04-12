//
//  UIAlertController+CXAlert.h
//  BeginnerRoom
//
//  Created by 谢果冻 on 2017/9/25.
//  Copyright © 2017年 谢果冻. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ActionResponse)(NSInteger clickIndex);

@interface UIAlertController (CXAlert)

+ (void)alertWithViewController:(UIViewController *)viewController preferredStyle:(UIAlertControllerStyle)preferredStyle Title:(NSString *)title message:(NSString *)message actionTitles:(NSArray *)actionTitles response:(ActionResponse)response;
@end
