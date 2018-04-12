//
//  CXAudioPlayer.h
//  chuxinketing
//
//  Created by yp on 2018/3/13.
//  Copyright © 2018年 北京心花怒放网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kAudioPlayer [CXAudioPlayer sharedInstance]

@class CXAudioPlayer;

@protocol CXAudioPlayerDelegate <NSObject>

@optional

- (void)audioPlayerDidPlayMusicCompleted;

- (void)audioPlayer:(CXAudioPlayer *)player stateChangeWithState:(FSAudioStreamState)state;

@end

@interface CXAudioPlayer : NSObject

/** 代理 */
@property (nonatomic, weak) id<CXAudioPlayerDelegate> delegate;
/** 播放地址 */
@property (nonatomic, copy) NSString *playUrlStr;
/** 播放视图，用于视频播放 */
//@property (nonatomic, strong) UIView *playView;
/** 播放状态 */
@property (nonatomic, readonly) FSAudioStreamState state;
/** 播放进度 */
@property (nonatomic, assign) float progress;
/** AudioStream 播放器 */
@property (nonatomic, strong) FSAudioStream *audioStream;

+ (instancetype)sharedInstance;
/** 播放 */
- (void)play;
/** 暂停 */
- (void)pause;
/** 恢复播放 */
- (void)resume;
/** 停止播放 */
- (void)stop;

@end
