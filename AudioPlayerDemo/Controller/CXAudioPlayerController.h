//
//  CXAudioPlayerController.h
//  chuxinketing
//
//  Created by yp on 2018/3/12.
//  Copyright © 2018年 北京心花怒放网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kWYPlayerVC         [CXAudioPlayerController sharedInstance]

@interface CXAudioPlayerController : UIViewController

 /** 类型:1.音频 7.音月专辑 9.听书 */
@property (nonatomic, copy) NSString *playType;
/** 音频id 音乐专辑id 听书id */
@property (nonatomic, copy) NSString *playId;
/** 当前播放音频id */
@property (nonatomic, copy) NSString *playCurrentId;
/** 是否需要重新获取列表 */
@property (nonatomic, assign) BOOL regetList;
/** 是否正在播放 */
@property (nonatomic, assign) BOOL isPlaying;
/** 与上次播放音频id相同 */
@property (nonatomic, assign) BOOL sameLast;

+ (instancetype)sharedInstance;
/** 停止播放音乐 */
- (void)stopMusic;

@end
