//
//  CXMusicPlayListModel.h
//  chuxinketing
//
//  Created by yp on 2018/2/6.
//  Copyright © 2018年 北京心花怒放网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CXMusicPlayListModel : NSObject

/** 是否购买 0未购买 1 购买 */
@property (nonatomic, copy) NSString *buyed;
/** 是否收费 0免费 1收费 */
@property (nonatomic, copy) NSString *fee;
/** 业务id */
@property (nonatomic, copy) NSString *businessId;
/** 图片 路径 */
@property (nonatomic, copy) NSString *image;
/** 0:文章 1 音频 2 视频 */
@property (nonatomic, copy) NSString *type;
/** 业务类型 1音频 7专辑 9听书 */
@property (nonatomic, copy) NSString *playType;
/** 标题 */
@property (nonatomic, copy) NSString *title;
/** 内容 */
@property (nonatomic, copy) NSString *content;
/** 作者 */
@property (nonatomic, copy) NSString *author;
/** 视频/音频路径 */
@property (nonatomic, copy) NSString *linkUrl;
/** 时长 */
@property (nonatomic, copy) NSString *timeLength;
/** 金额 */
@property (nonatomic, copy) NSString *price;

@end
