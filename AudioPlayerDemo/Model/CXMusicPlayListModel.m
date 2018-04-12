//
//  CXMusicPlayListModel.m
//  chuxinketing
//
//  Created by yp on 2018/2/6.
//  Copyright © 2018年 北京心花怒放网络科技有限公司. All rights reserved.
//

#import "CXMusicPlayListModel.h"

@implementation CXMusicPlayListModel

- (BOOL)isEqual:(id)object {
    CXMusicPlayListModel *obj = object;
    return [self.businessId isEqualToString:obj.businessId];
}


@end
