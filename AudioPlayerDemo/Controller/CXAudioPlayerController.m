//
//  CXAudioPlayerController.m
//  chuxinketing
//
//  Created by yp on 2018/3/12.
//  Copyright © 2018年 北京心花怒放网络科技有限公司. All rights reserved.
//
// orderType 订单类型：0充值，1内容，2问题，3咨询，4测试，5专辑，6优惠卡，7听书
// detailType 具体类型：0文本，1音频，2视频，3问答，4咨询，5测试，6专辑，7专辑中的课程，6优惠卡，8听书专辑，9听书专辑中单个课程

#import "CXAudioPlayerController.h"
#import "CXAudioControlView.h"
#import "CXAudioPlayer.h"
#import "CXMusicPlayListModel.h"
#import "CXAudioListView.h"
#import "CXAudioListController.h"

@interface CXAudioPlayerController ()<CXAudioPlayerDelegate, CXAudioListViewDelegate, CXAudioControlViewDeleagte>

@property (nonatomic,strong) NSTimer *refreshTimer;
/** 音频标题 */
@property (nonatomic, strong) UILabel *titleLabel;
/** 封面图 */
@property (nonatomic, strong) UIImageView *coverView;
/** 控制面板 */
@property (nonatomic, strong) CXAudioControlView *controlView;
/** 播放器 */
@property (nonatomic, strong) CXAudioPlayer *audioPlayer;
/** 音频列表view */
@property (nonatomic, strong) CXAudioListView *audioListView;
/** 音频列表数据源 */
@property (nonatomic, strong) NSMutableArray *dataArray;
/** 缓存字典 */
@property (nonatomic, strong) NSDictionary *dataDict;
/** 是否正在拖动滑块 */
@property (nonatomic, assign) BOOL isDraging;
/** 当前索引 */
@property (nonatomic, assign) NSInteger currentIndex;
/** 当前音频专辑是否免费 */
@property (nonatomic, assign) BOOL fee;
/** 当前音频数据模型 */
@property (nonatomic, strong) CXMusicPlayListModel *curAudioModel;

@end

@implementation CXAudioPlayerController

#pragma mark - life cycle
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    [self removeTimer];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    //  1.需要获取音频列表
    if (self.regetList) {
        //  停止音频播放，获取音频列表
        [self.audioPlayer stop];
        [self getMusicListData];
    } else {
        // 2.
        if (self.sameLast) {
            // 2.1  不需要获取音频列表，不需要执行操作
        } else {
            // 2.2  与上次音频不同,需要播放新
            [self.audioPlayer stop];
            for (CXMusicPlayListModel *model in self.dataArray) {
                if ([model.businessId isEqualToString:self.playCurrentId]) {
                    [self playMusicWithModel:model];
                    break;
                }
            }
        }
    }
    //  添加定时器
    [self addTimer];
    //  注册通知
    [self setupNotification];
}

#pragma mark - 获取音乐播放列表
- (void)getMusicListData {
    
    
    NSString *plistName = [NSString stringWithFormat:@"%@.plist", self.playId];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:plistName ofType:nil]];
    
    if (dict != nil) {
  
        self.dataDict = dict;

         NSArray *tempArray = [CXMusicPlayListModel mj_objectArrayWithKeyValuesArray:dict[@"dtList"]];

        if (tempArray.count == 0) {
            [SVProgressHUD setMinimumDismissTimeInterval:1];
            [SVProgressHUD showErrorWithStatus:@"暂无音频数据"];
            return;
        }

        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:tempArray];
        //  刷新播放列表数据
        self.audioListView.listInfoArray = self.dataArray;
        //  取出传入ID的音频进行播放
        for (CXMusicPlayListModel *model in tempArray) {
            if ([model.businessId isEqualToString:self.playCurrentId]) {
                [self playMusicWithModel:model];
                break;
            }
        }
        
    } else {
             [SVProgressHUD setMinimumDismissTimeInterval:1.5];
            [SVProgressHUD showErrorWithStatus:@"解析数据失败"];
     }
}
#pragma mark - 播放音乐
- (void)playMusicWithModel:(CXMusicPlayListModel *)audioModel {
 
    //  获取当前播放音频索引
    if ([self.dataArray containsObject:audioModel]) {
        
        self.currentIndex = [self.dataArray indexOfObject:audioModel];
    }
    //  设置封面和标题
    NSString *playUrlStr = [NSObject fileURLString:audioModel.linkUrl];
    self.audioPlayer.playUrlStr = playUrlStr;
    self.playCurrentId = audioModel.businessId;
    self.curAudioModel = audioModel;
    //  设置封面和标题
    [self setupAudioTitleAndCover];
}
#pragma mark - 设置封面和标题
- (void)setupAudioTitleAndCover {
    
    self.titleLabel.text = self.curAudioModel.title;
    NSURL *coverUrl = [NSObject fileURL:self.curAudioModel.image];
    [self.coverView sd_setImageWithURL:coverUrl placeholderImage:[UIImage imageNamed:@"icon_logo"]];
}

#pragma mark - 刷新定时器事件 -- 缓存、播放进度
- (void)updatePlaybackProgress {
    
    //  如果流是连续的（没有已知的持续时间），则该属性为真。
    if (self.audioPlayer.audioStream.continuous) {

        self.controlView.value = 0;
        self.controlView.cacheValue = 0;
        self.controlView.currentTime = @"";
        self.controlView.totalTime = @"";
    } else {
        //  滑块 可以点击
        //  正在拖动滑块
        if (self.isDraging == YES)  return;
 
        FSStreamPosition cur = self.audioPlayer.audioStream.currentTimePlayed;
        FSStreamPosition end = self.audioPlayer.audioStream.duration;
        //  音频播放进度
        self.controlView.value = cur.position;
        //  音频当前播放时间
        self.controlView.currentTime = [NSString stringWithFormat:@"00:%02i:%02i", cur.minute, cur.second];
        //  音频总时间
        self.controlView.totalTime = [NSString stringWithFormat:@"00:%02i:%02i", end.minute, end.second];
    }

    if (self.audioPlayer.audioStream.contentLength > 0  ) {
        
        UInt64 totalBufferedData =  self.audioPlayer.audioStream.prebufferedByteCount;
        float bufferedDataFromTotal = (float)totalBufferedData / self.audioPlayer.audioStream.contentLength;
//        音频缓存进度
        self.controlView.cacheValue = bufferedDataFromTotal;

    } else {
        // A continuous stream, use the buffering indicator to show progress
        // among the filled prebuffer
//        缓存进度条进度刷新
        UInt64 totalBufferedData =  self.audioPlayer.audioStream.prebufferedByteCount;
        self.controlView.cacheValue =  (float)totalBufferedData / self.audioPlayer.audioStream.configuration.maxPrebufferedByteCount;
    }
}
#pragma mark - 音频播放完成
- (void)audioPlayerDidPlayMusicCompleted {
    
    //  1.判断是否为最后一首
    if (self.currentIndex == self.dataArray.count - 1) {
        
        return;
    }
    //  2.判断下一首是否已购买 buyed:0未购买 1 购买 fee:0免费 1收费
    CXMusicPlayListModel *mediaDtModel = self.dataArray[self.currentIndex + 1];
    if ([mediaDtModel.fee integerValue] == 1 && [mediaDtModel.buyed integerValue] == 0) {
        
        return;
    }
    [self playNextMusicItem];
}

#pragma mark - 音频播放器播放状态变化
- (void)audioPlayer:(CXAudioPlayer *)player stateChangeWithState:(FSAudioStreamState)state {
    
    self.isPlaying = state == kFsAudioStreamPlaying ? YES : NO;

    switch (state) {
        case kFsAudioStreamRetrievingURL:
            //  检索文件中...
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
            NSLog(@"   retrieving URL  -- 检索文件");
            break;
            
        case kFsAudioStreamStopped:
            //  停止播放了
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            [self.controlView setupPauseBtn];
            NSLog(@"   kFsAudioStreamStopped --- 停止播放了 ");

            break;
            
        case kFsAudioStreamBuffering: {
            //  缓存中，其他处理暂未添加
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
            [self.controlView showLoadingAnim];
            NSLog(@"   buffering --- 缓存中  ");
            break;
        }
            
        case kFsAudioStreamPaused:
            
            [self.controlView setupPauseBtn];
            NSLog(@"暂停了");
            break;

        case kFsAudioStreamSeeking:
            //   快进 或者 快退
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
            NSLog(@" kFsAudioStreamSeeking -- 快进 或者 快退");
            break;
            
        case kFsAudioStreamPlaying:
            //  播放中
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            [self.controlView hideLoadingAnim];
            [self.controlView setupPlayBtn];
            [self setupLockScreenInfo];
            NSLog(@" 播放ing  -- ");
            break;
            
        case kFsAudioStreamFailed:
            //  加载失败处理
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            [self.controlView setupPauseBtn];
            [SVProgressHUD setMinimumDismissTimeInterval:2];
            [SVProgressHUD showErrorWithStatus:@"音频文件加载失败"];
            NSLog(@"加载失败");
            break;
            
        case kFsAudioStreamPlaybackCompleted:
            //  缓存一部分结束后 --  快进结束后   --- 大概就是 音频流回放
            NSLog(@"kFsAudioStreamPlaybackCompleted -- 回放完成");
            break;
            
        case kFsAudioStreamRetryingStarted:
            //  回放失败
            NSLog(@"Failed to retry playback");
            break;
            
        case kFsAudioStreamRetryingSucceeded:
            //  重试成功
            NSLog(@"kFsAudioStreamRetryingSucceeded");
            break;
            
        case kFsAudioStreamRetryingFailed:
            //  重试失败
            NSLog(@"Failed to retry playback -- 重试失败吧");
            break;
            
        default:
            break;
    }
}
#pragma mark - ControlView 播放&暂停
- (void)controlView:(CXAudioControlView *)controlView didClickPlay:(UIButton *)playBtn {
//    NSLog(@" -- 点击播放列表按钮 -- ");

    if (self.audioPlayer.state == kFsAudioStreamStopped) {

        [self.audioPlayer play];
    }
    if (self.audioPlayer.state == kFsAudioStreamPlaying) {

        [self.audioPlayer pause];
    }
    if (self.audioPlayer.state == kFsAudioStreamPaused) {

        [self.audioPlayer resume];
    }
}
#pragma mark - ControlView 上一首
- (void)controlView:(CXAudioControlView *)controlView didClickPrev:(UIButton *)prevBtn {

    [self playPreMusic];
}
#pragma mark - ControlView 下一首
- (void)controlView:(CXAudioControlView *)controlView didClickNext:(UIButton *)nextBtn {

    [self playNextMusic];
}
#pragma mark - ControlView 列表
- (void)controlView:(CXAudioControlView *)controlView didClickList:(UIButton *)listBtn {
//    NSLog(@" -- 点击播放列表按钮 -- ");
//    判断是否是 音频 或者 专辑 是否免费
    BOOL showBuyBtn = YES;

    if ([self.playType isEqualToString:@"1"] || [self.dataDict[@"fee"] integerValue] == 0 ) {
        showBuyBtn = NO;
    } else {
        showBuyBtn = YES;
    }
    
    [self.audioListView showAudioListViewWithShowBuyBtn:showBuyBtn];
}
#pragma mark - 购买专辑
- (void)audioListViewPurchaseMusicSubject {
    
//    NSLog(@"购买专辑");
    if ([self.playType isEqualToString:@"1"]) {
        return;
    }
    
    [self.audioListView hideAudioListView];

    NSString *title = [NSString stringWithFormat:@"%@", self.dataDict[@"title"]];
    NSString *message = [NSString stringWithFormat:@"价格%.2f", [self.dataDict[@"price"] floatValue]];
    NSString *price = [NSString stringWithFormat:@"%.2f", [self.dataDict[@"price"] floatValue]];
    NSString *businessId = [NSString stringWithFormat:@"%@", self.playId];
    NSString *orderType = @"";
    
    if ([self.playType isEqualToString:@"7"]) {
        orderType = @"6";
    } else if ([self.playType isEqualToString:@"9"]) {
        orderType = @"8";
    }
    
//    NSDictionary *paymentInfo = @{
//                                  @"price" : price,
//                                  @"type" : orderType,
//                                  @"orderType" : orderType,
//                                  @"id" : businessId,
//                                  @"title" :title
//                                  };
//
//    __weak typeof(self) weakSelf = self;
    
    [UIAlertController alertWithViewController:self preferredStyle:UIAlertControllerStyleAlert Title:title message:message actionTitles:@[@"取消", @"购买"] response:^(NSInteger clickIndex) {
    
        if (clickIndex == 1) {
           
            NSLog(@"购买整个音频专辑");
        }
    }];
}

#pragma mark - 购买单个音频
- (void)goPurchaseMusic:(NSNotification *)musicInfo {
    
    [self.audioListView hideAudioListView];
    
    CXMusicPlayListModel *mediaDtModel = [CXMusicPlayListModel mj_objectWithKeyValues:musicInfo.userInfo];
    NSString *title = [NSString stringWithFormat:@"%@", mediaDtModel.title];
    NSString *message = [NSString stringWithFormat:@"价格%.2f", [mediaDtModel.price floatValue]];

    NSString *orderType = @"";
    if ([self.playType isEqualToString:@"1"]) {
        orderType = @"1";
    } else if ([self.playType isEqualToString:@"7"]) {
        orderType = @"5";
    } else if ([self.playType isEqualToString:@"9"]) {
        orderType = @"7";
    }
//    NSDictionary *paymentInfo = @{
//                                  @"price" : mediaDtModel.price,
//                                  @"type" : mediaDtModel.playType,
//                                  @"orderType" : orderType,
//                                  @"id" : mediaDtModel.businessId,
//                                  @"title" : mediaDtModel.title
//                                  };
//    __weak typeof(self) weakSelf = self;
    
    [UIAlertController alertWithViewController:self preferredStyle:UIAlertControllerStyleAlert Title:title message:message actionTitles:@[@"取消", @"购买"] response:^(NSInteger clickIndex) {

        if (clickIndex == 1) {
            NSLog(@"购买整个音频专辑");
        }
    }];
}

#pragma mark - 点击专辑列表单个音频进行播放
- (void)audioListView:(CXAudioListView *)audioListView didSelectRowAtIndexPathWith:(CXMusicPlayListModel *)dtListModel {
    
    [self.audioListView hideAudioListView];
    
    if ([dtListModel.fee integerValue] == 1 && [dtListModel.buyed integerValue] == 0) {
        [SVProgressHUD setMinimumDismissTimeInterval:1];
        [SVProgressHUD showErrorWithStatus:@"当前音频暂未购买"];
        return;
    }
    [self playMusicWithModel:dtListModel];
}

// 滑杆滑动 及 点击
- (void)controlView:(CXAudioControlView *)controlView didSliderTouchBegan:(float)value {
//    NSLog(@" -- didSliderTouchBegan -- ");
    self.isDraging = YES;
}

- (void)controlView:(CXAudioControlView *)controlView didSliderTouchEnded:(float)value {
//    NSLog(@" -- didSliderTouchEnded -- ");
    self.isDraging = NO;
    //  避免用户拖动进度条出现极值导致音频文件加载失败问题
    if (value == 0)  value = 0.001;
    if (value == 1)  value = 0.999;
    
    self.audioPlayer.progress = value;
}

- (void)controlView:(CXAudioControlView *)controlView didSliderValueChange:(float)value {
//    NSLog(@" -- didSliderValueChange -- ");
    self.isDraging = YES;
}
#pragma mark - 登录后刷新音频列表
- (void)userLoginSuccess {
    
    [self refreshAudioList];
}
#pragma mark -  购买成功
- (void)purchaseSuccessful {
    
    [self refreshAudioList];
}

#pragma mark - 购买后刷新数据
- (void)refreshAudioList {
    
//    [[CXRequest sharedCXRequest] getMusicPlayLisWithType:self.playType playId:self.playId block:^(__kindof id response, CXResponseCode code, NSError *error) {
//        if (code == CXResponseCodeSuccess) {
//            //            NSLog(@" 购买后刷新数据 %@", response);
//            self.dataDict = response[@"data"];
//            NSArray *tempArray = [CXMusicPlayListModel mj_objectArrayWithKeyValuesArray:response[@"data"][@"dtList"]];
//            if (tempArray.count == 0) {
//                [SVProgressHUD setMinimumDismissTimeInterval:1];
//                [SVProgressHUD showErrorWithStatus:@"暂无音频数据"];
//                return;
//            }
//            [self.dataArray removeAllObjects];
//            [self.dataArray addObjectsFromArray:tempArray];
//
//            self.audioListView.listInfoArray = self.dataArray;
//
//            self.regetList = NO;
//            self.sameLast = YES;
//        } else {
//            if (response[@"message"] != nil) {
//                [SVProgressHUD setMinimumDismissTimeInterval:1];
//                [SVProgressHUD showErrorWithStatus:response[@"message"]];
//            }
//        }
//    }];
}
#pragma mark -  是否播放上一首判断逻辑
- (void)playPreMusic {
    //  1.判断是否为第一首
    if (self.currentIndex == 0) {
        
        [SVProgressHUD setMinimumDismissTimeInterval:1];
        [SVProgressHUD showErrorWithStatus:@"已经是第一首了"];
        return;
    }
    //  2.判断上一首是否已购买 buyed:0未购买 1 购买 fee:0免费 1收费
    CXMusicPlayListModel *mediaDtModel = self.dataArray[self.currentIndex - 1];
    if ([mediaDtModel.fee integerValue] == 1 && [mediaDtModel.buyed integerValue] == 0) {
        
        [SVProgressHUD setMinimumDismissTimeInterval:1];
        [SVProgressHUD showErrorWithStatus:@"上一首暂未购买"];
        return;
    }
    
    [self playPreMusicItem];
}

#pragma mark - 播放上一首
- (void)playPreMusicItem {
    
    CXMusicPlayListModel *preMusicModel = self.dataArray[self.currentIndex - 1];
    [self playMusicWithModel:preMusicModel];
}

#pragma mark - 播下一首按钮事件
- (void)playNextMusic {
    
    if (self.currentIndex == self.dataArray.count - 1) {
        
        [SVProgressHUD setMinimumDismissTimeInterval:1];
        [SVProgressHUD showErrorWithStatus:@"已经是最后一首了"];
        return;
    }
    //  2.判断下一首是否已购买 buyed:0未购买 1 购买 fee:0免费 1收费
    CXMusicPlayListModel *mediaDtModel = self.dataArray[self.currentIndex + 1];
    if ([mediaDtModel.fee integerValue] == 1 && [mediaDtModel.buyed integerValue] == 0) {
        
        [SVProgressHUD setMinimumDismissTimeInterval:1];
        [SVProgressHUD showErrorWithStatus:@"下一首暂未购买"];
        return;
    }
    
    [self playNextMusicItem];
}

#pragma mark - 播放下一首
- (void)playNextMusicItem {
    
    CXMusicPlayListModel *nextMusicModel = self.dataArray[self.currentIndex + 1];
    [self playMusicWithModel:nextMusicModel];
}

#pragma mark - 停止播放音乐
- (void)stopMusic {
    
    [self.audioPlayer stop];
    [self closedLockScreenInfo];
}
#pragma mark - 关闭锁屏信息交互
- (void)closedLockScreenInfo {
    
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
}

#pragma mark - 开启锁屏信息交互与歌曲信息设置
- (void)setupLockScreenInfo {
    
    if (self.curAudioModel == nil) return;
 
    //  远程控制中心
    MPRemoteCommandCenter *remoteCommandCenter = [MPRemoteCommandCenter sharedCommandCenter];

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //  播放
        [remoteCommandCenter.playCommand addTarget:self action:@selector(playerPlay)];
        //  暂停
        [remoteCommandCenter.pauseCommand addTarget:self action:@selector(playerPause)];
        //  下一首
        [remoteCommandCenter.nextTrackCommand addTarget:self action:@selector(playerNext)];
        //  上一首
        [remoteCommandCenter.previousTrackCommand addTarget:self action:@selector(playerPrevious)];
        //  进度条事件
        [remoteCommandCenter.changePlaybackPositionCommand addTarget:self action:@selector(changePlaybackPositionCommand:)];
    });
    
    if (self.dataArray.count < 2) {
        
        remoteCommandCenter.previousTrackCommand.enabled = NO;
        remoteCommandCenter.nextTrackCommand.enabled = NO;
        
    } else if (self.dataArray.count < 3){
        //  共  2 首
        //  第一首的时候
        if (self.currentIndex == 0) {
            
            remoteCommandCenter.previousTrackCommand.enabled = NO;
            CXMusicPlayListModel *mediaDtModel = self.dataArray[self.currentIndex + 1];
            if ([mediaDtModel.fee integerValue] == 1 && [mediaDtModel.buyed integerValue] == 0) {
                remoteCommandCenter.nextTrackCommand.enabled = NO;
            } else {
                remoteCommandCenter.nextTrackCommand.enabled = YES;
            }
            
        } else {
            //            第二首的时候
            remoteCommandCenter.nextTrackCommand.enabled = NO;
            
            CXMusicPlayListModel *mediaDtModel = self.dataArray[self.currentIndex - 1];
            if ([mediaDtModel.fee integerValue] == 1 && [mediaDtModel.buyed integerValue] == 0) {
                
                remoteCommandCenter.previousTrackCommand.enabled = NO;
//                NSLog(@"上一首不可用");
            } else {
                remoteCommandCenter.previousTrackCommand.enabled = YES;
//                NSLog(@"上一首可以用");
            }
        }
    } else {
        //    第一首
        if (self.currentIndex == 0)  {
            remoteCommandCenter.previousTrackCommand.enabled = NO;
            
            CXMusicPlayListModel *nextMediaDtModel = self.dataArray[self.currentIndex + 1];
            if ([nextMediaDtModel.fee integerValue] == 1 && [nextMediaDtModel.buyed integerValue] == 0) {
                remoteCommandCenter.nextTrackCommand.enabled = NO;
            } else {
                remoteCommandCenter.nextTrackCommand.enabled = YES;
            }
            //      最后一首
        } else  if (self.currentIndex == self.dataArray.count - 1 ){
            
            //        下一首 == NO
            remoteCommandCenter.nextTrackCommand.enabled = NO;
            //        上一首
            CXMusicPlayListModel *mediaDtModel = self.dataArray[self.currentIndex - 1];
            if ([mediaDtModel.fee integerValue] == 1 && [mediaDtModel.buyed integerValue] == 0) {
                remoteCommandCenter.previousTrackCommand.enabled = NO;
            } else {
                remoteCommandCenter.previousTrackCommand.enabled = YES;
            }
        } else {
            //            非第一首 和 最后一首
            CXMusicPlayListModel *previousMediaDtModel = self.dataArray[self.currentIndex - 1];
            if ([previousMediaDtModel.fee integerValue] == 1 && [previousMediaDtModel.buyed integerValue] == 0) {
                remoteCommandCenter.previousTrackCommand.enabled = NO;
            } else {
                remoteCommandCenter.previousTrackCommand.enabled = YES;
            }
            CXMusicPlayListModel *nextMediaDtModel = self.dataArray[self.currentIndex + 1];
            if ([nextMediaDtModel.fee integerValue] == 1 && [nextMediaDtModel.buyed integerValue] == 0) {
                remoteCommandCenter.nextTrackCommand.enabled = NO;
            } else {
                remoteCommandCenter.nextTrackCommand.enabled = YES;
            }
        }
    }
    //  进度条
    //  开启远程交互
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    //  1.初始化一个存放音乐信息的字典
    NSMutableDictionary *playingInfoDict = [NSMutableDictionary dictionary];
    //  2.设置歌曲名 MPMediaItemPropertyTitle 设置这个就不会显示进度条
    [playingInfoDict setObject:self.curAudioModel.title ? self.curAudioModel.title : @"" forKey:MPMediaItemPropertyTitle];
    //  3.设置歌手名
    [playingInfoDict setObject:self.curAudioModel.author ? self.curAudioModel.author : @"" forKey:MPMediaItemPropertyArtist];
    //  4.设置封面的图片
    //  图片 本地封面图有 直接可以取来用
    UIImage *image = self.coverView.image;
    MPMediaItemArtwork *artwork = [[MPMediaItemArtwork alloc] initWithImage:image];
    [playingInfoDict setObject:artwork forKey:MPMediaItemPropertyArtwork];

    FSStreamPosition cur = self.audioPlayer.audioStream.currentTimePlayed;
    FSStreamPosition end = self.audioPlayer.audioStream.duration;
    NSTimeInterval currentTime = (cur.minute * 60 + cur.second);
    NSTimeInterval totalTime = (end.minute * 60 + end.second);
    //  5.设置歌曲的总时长
    [playingInfoDict setObject:@(totalTime) forKey:MPMediaItemPropertyPlaybackDuration];
    //  6.当前时间
    [playingInfoDict setObject:@(currentTime) forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
    //  7.音乐信息赋值给获取锁屏中心的nowPlayingInfo属性
    [MPNowPlayingInfoCenter defaultCenter].nowPlayingInfo = playingInfoDict;
}
#pragma mark - 锁屏上一首按钮事件
- (void)playerPrevious {
    
    [self playPreMusic];
}
#pragma mark - 锁屏下一首按钮事件
- (void)playerNext {
    
    [self playNextMusic];
}
#pragma mark - 锁屏暂停按钮事件
- (void)playerPause {
    [self.audioPlayer pause];
}
#pragma mark - 锁屏播放按钮事件
- (void)playerPlay {
    
    [self.audioPlayer resume];
}
#pragma mark - 远程控制中心
- (void)changePlaybackPositionCommand:(MPRemoteCommandEvent *)event {
    
    MPChangePlaybackPositionCommandEvent *playbackPositionEvent = (MPChangePlaybackPositionCommandEvent *)event;
    FSStreamPosition end = self.audioPlayer.audioStream.duration;
    float totalTime = (end.minute * 60 + end.second);
    float progress = (float) playbackPositionEvent.positionTime / totalTime;
    
    //  避免用户拖动进度条出现极值导致音频文件加载失败问题
    if (progress == 0)  progress = 0.001;
    if (progress == 1)  progress = 0.999;
 
    self.audioPlayer.progress = progress;
}
#pragma mark - 添加通知
- (void)setupNotification {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goPurchaseMusic:) name:@"GoPurchaseMusic" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLoginSuccess) name:@"LoginSuccess" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playIntrupt) name:AVPlayerItemPlaybackStalledNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioInterruption:) name:AVAudioSessionInterruptionNotification object:nil];
}

#pragma mark - 播放被打断
- (void)playIntrupt {
    NSLog(@"播放被打断");
    [self.audioPlayer pause];
}
#pragma mark - 音频打断
- (void)audioInterruption:(NSNotification *)notification  {
    
    NSDictionary * interruptionDict = notification.userInfo;
    NSNumber * interruptionType = [interruptionDict valueForKey:AVAudioSessionInterruptionTypeKey];
    if (interruptionType.intValue == AVAudioSessionInterruptionTypeBegan) {
        
        NSLog(@"打断开始");
        [self.audioPlayer pause];
    }
    else if (interruptionType.intValue == AVAudioSessionInterruptionTypeEnded) {
        NSLog(@"打断结束");
        //在后台不能恢复播放
        if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) {
            NSLog(@"APP在后台，不能继续播放");
        } else {
            //在前台继续播放
            NSLog(@"APP在前台继续播放");
            [self.audioPlayer resume];
        }
    }
}
#pragma mark - 添加定时器
- (void)addTimer {
    
    if (self.refreshTimer) return;
    self.refreshTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(updatePlaybackProgress) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop]addTimer:self.refreshTimer forMode:NSRunLoopCommonModes];
}
#pragma mark - 移除定时器
- (void)removeTimer {
    
    if (self.refreshTimer == nil) return;
    [self.refreshTimer invalidate];
    self.refreshTimer = nil;
}

//  单例初始化
+ (instancetype)sharedInstance {
    static CXAudioPlayerController *playerVC = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        playerVC = [[CXAudioPlayerController alloc] init];
    });
    return playerVC;
}

#pragma mark - 初始化
- (instancetype)init {
    
    if (self = [super init]) {
        
        UIView *lineView = [[UIView alloc] init];
        lineView.frame = CGRectMake(0, 64, kMainScreenWidth, 7);
        lineView.backgroundColor = [UIColor colorWithHexString:@"#F9F9FA"];
        [self.view addSubview:lineView];
        //  标题
        CGFloat titleLabelX = 15;
        CGFloat titleLabelY = 27 + 64;
        CGFloat titleLabelH = 21;
        CGFloat titleLabelW = (kMainScreenWidth - 30);
        self.titleLabel.frame = CGRectMake(titleLabelX, titleLabelY, titleLabelW, titleLabelH);
        [self.view addSubview:self.titleLabel];
        //  封面
        CGFloat coverViewW = 225;
        CGFloat coverViewX = (kMainScreenWidth - coverViewW) * 0.5;
        CGFloat coverViewH = coverViewW;
        CGFloat coverViewY = CGRectGetMaxY(self.titleLabel.frame) + 25;
        self.coverView.frame = CGRectMake(coverViewX, coverViewY, coverViewW, coverViewH);
        [self.view addSubview:self.coverView];
        //  控制器面板
        CGFloat controlViewX = 30;
        CGFloat controlViewY = CGRectGetMaxY(self.coverView.frame) + 25;
        CGFloat controlViewW = (kMainScreenWidth - 60);
        CGFloat controlViewH = 108;
        self.controlView.frame = CGRectMake(controlViewX, controlViewY, controlViewW, controlViewH);
        [self.view addSubview:self.controlView];
    }
    return self;
}

#pragma mark - getter and setter

- (CXAudioListView *)audioListView {
    
    if (_audioListView == nil) {
        
        _audioListView = [CXAudioListView audioListView];
        _audioListView.delegate = self;
    }
    return _audioListView;
}

- (CXAudioPlayer *)audioPlayer {
    
    if (_audioPlayer == nil) {
        
        _audioPlayer = [[CXAudioPlayer alloc] init];
        _audioPlayer.delegate = self;
    }
    return _audioPlayer;
}

- (CXAudioControlView *)controlView {
    
    if (_controlView == nil) {
        
        _controlView = [[CXAudioControlView alloc] init];
        _controlView.delegate = self;
    }
    return _controlView;
}

- (UILabel *)titleLabel {
    
    if (_titleLabel == nil) {
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#011919"];
        _titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return _titleLabel;
}

- (UIImageView *)coverView {
    
    if (_coverView ==nil) {

        _coverView = [[UIImageView alloc] init];
        _coverView.layer.cornerRadius = 225 *0.5;
        _coverView.layer.masksToBounds = YES;
    }
    return _coverView;
}

- (NSMutableArray *)dataArray {
    
    if (_dataArray == nil) {
        
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
