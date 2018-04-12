//
//  NSObject+Util.h
//  chuxinketing
//
//  Created by yp on 2017/10/12.
//  Copyright © 2017年 北京心花怒放网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Util)

+ (NSString *)fileURLString:(NSString *)path;
+ (NSURL *)fileURL:(NSString *)path;
+ (float)cacheFileSize;
+ (void)clearCacheFile;

@end
