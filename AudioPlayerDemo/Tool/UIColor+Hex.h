//
//  UIColor+Hex.h
//  chuxinketing
//
//  Created by yp on 2017/9/29.
//  Copyright © 2017年 北京心花怒放网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Hex)

/** 支持 */
+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;

//默认alpha值为1
+ (UIColor *)colorWithHexString:(NSString *)color;

@end
