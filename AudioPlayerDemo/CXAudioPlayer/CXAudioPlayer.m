//
//  CXAudioPlayer.m
//  chuxinketing
//
//  Created by yp on 2018/3/13.
//  Copyright © 2018年 北京心花怒放网络科技有限公司. All rights reserved.
//

#import "CXAudioPlayer.h"
//#import "FSAudioStream.h"

@interface CXAudioPlayer ()
/** 播放状态 */
@property (nonatomic, readwrite) FSAudioStreamState state;
/** 用于总时间的获取 */
@property (nonatomic, copy) NSString *totalTime;

@end

@implementation CXAudioPlayer


- (FSAudioStream *)audioStream {
    
    if (_audioStream == nil) {
    
        _audioStream = [[FSAudioStream alloc] init];
        _audioStream.strictContentTypeChecking = NO;
        _audioStream.defaultContentType = @"audio/mpeg";
    }
    return _audioStream;
}

+ (instancetype)sharedInstance {
    
    static CXAudioPlayer *instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[CXAudioPlayer alloc] init];
    });
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
        self.state = kFsAudioStreamStopped;
    }
    return self;
}

#pragma mark - Setter

- (void)setPlayUrlStr:(NSString *)playUrlStr {
    
    //  当前播放链接与传入链接一致
    if ([self.playUrlStr isEqual:playUrlStr]) {
        
        if (self.state == kFsAudioStreamPlaying) {

            return;
        }
        if (self.state == kFsAudioStreamPaused) {
            [self.audioStream play];
            return;
        }
        if (self.state == kFsAudioStreamBuffering) {
            return;
        }
    }
    
    _playUrlStr = playUrlStr;

    if (self.state == kFsAudioStreamPlaying) {
        [self stop];
    }
    
    NSURL *audioUrl = [NSURL URLWithString:playUrlStr];
    [self.audioStream playFromURL:audioUrl];
    
    __weak typeof(self) weakSelf = self;
    
    //  播放完成回调事件
    [self.audioStream setOnCompletion:^{
        NSLog(@"完成了");
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(audioPlayerDidPlayMusicCompleted)]) {
            [weakSelf.delegate performSelector:@selector(audioPlayerDidPlayMusicCompleted)];
        }
    }];
    
    [self.audioStream setOnStateChange:^(FSAudioStreamState state) {
        weakSelf.state = state;
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(audioPlayer:stateChangeWithState:)]) {
            [weakSelf.delegate audioPlayer:weakSelf stateChangeWithState:weakSelf.state];
        }
    }];
    
    
    self.audioStream.onFailure = ^(FSAudioStreamError error, NSString *errorDescription) {
        NSString *errorCategory;
        
        switch (error) {
            case kFsAudioStreamErrorOpen:
                errorCategory = @"Cannot open the audio stream: ";
                break;
            case kFsAudioStreamErrorStreamParse:
                errorCategory = @"Cannot read the audio stream: ";
                break;
            case kFsAudioStreamErrorNetwork:
                errorCategory = @"Network failed: cannot play the audio stream: ";
                break;
            case kFsAudioStreamErrorUnsupportedFormat:
                errorCategory = @"Unsupported format: ";
                break;
            case kFsAudioStreamErrorStreamBouncing:
                errorCategory = @"Network failed: cannot get enough data to play: ";
                break;
            default:
                errorCategory = @"Unknown error occurred: ";
                break;
        }
        
        NSString *formattedError = [NSString stringWithFormat:@"%@ %@", errorCategory, errorDescription];

        NSLog(@"%@", formattedError);
    };
}

 
//  设置音频播放进度
- (void)setProgress:(float)progress {
    
    FSStreamPosition pos = {0};
    pos.position = progress;
    [self.audioStream seekToPosition:pos];
}

#pragma mark - Public Method

- (void)play {
    
    if (self.state == kFsAudioStreamStopped) {
        
        [self.audioStream play];
    }
    
    if (self.state == kFsAudioStreamPaused) {
        
        [self resume];
    }
}
//  暂停
- (void)pause {
    
    if (self.state == kFsAudioStreamPlaying) {
        [self.audioStream pause];
    }
}
//  恢复
- (void)resume {
    if (self.state == kFsAudioStreamPaused) {
        [self.audioStream pause];
     }
}
//  停止播放
- (void)stop {
    
    if (self.state != kFsAudioStreamStopped) {
        [self.audioStream stop];
    }
}

@end
