//
//  NSObject+Util.m
//  chuxinketing
//
//  Created by yp on 2017/10/12.
//  Copyright © 2017年 北京心花怒放网络科技有限公司. All rights reserved.
//

#define kMainUrlStringHTTP @"http://app.chuxinketing.com/api"


#import "NSObject+Util.h"

@implementation NSObject (Util)

+ (NSString *)fileURLString:(NSString *)path {
    if ([path hasPrefix:@"http"]) {
        return path;
    }
    return [NSString stringWithFormat:@"%@%@", kMainUrlStringHTTP, path];
}

+ (NSURL *)fileURL:(NSString *)path {
    NSString *string = [self fileURLString:path];
    return [NSURL URLWithString:string];
}

//1.计算文件大小：
- (long long) fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
    
}
//2.计算文件夹大小:
//遍历文件夹获得文件夹大小，返回多少M
+ (float )cacheFileSize{
    
    NSString *folderPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize/(1024.0*1024.0);
    
}

+ (void)clearCacheFile {
    NSString *folderPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:folderPath];
    
    for (NSString *p in files) {
        NSError *error;
        NSString *Path = [folderPath stringByAppendingPathComponent:p];
        if ([[NSFileManager defaultManager] fileExistsAtPath:Path]) {
            [[NSFileManager defaultManager] removeItemAtPath:Path error:&error];
        }
    }
}

@end
