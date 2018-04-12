//
//  UIAlertController+CXAlert.m
//  BeginnerRoom
//
//  Created by 谢果冻 on 2017/9/25.
//  Copyright © 2017年 谢果冻. All rights reserved.
//

#import "UIAlertController+CXAlert.h"

@implementation UIAlertController (CXAlert)

+ (void)alertWithViewController:(UIViewController *)viewController preferredStyle:(UIAlertControllerStyle)preferredStyle Title:(NSString *)title message:(NSString *)message actionTitles:(NSArray *)actionTitles response:(ActionResponse)response {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:preferredStyle];
    NSUInteger index = 0;
    for (NSString *actionTitle in actionTitles) {
        [alertController addAction:[UIAlertAction actionWithTitle:actionTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (response) {
                response(index);
            }
        }]];
        index++;
    }
    [viewController presentViewController:alertController animated:YES completion:^{
        
    }];
}

@end
