//
//  CXAudioControlView.h
//  chuxinketing
//
//  Created by yp on 2018/3/12.
//  Copyright © 2018年 北京心花怒放网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CXAudioControlView;

@protocol CXAudioControlViewDeleagte<NSObject>

@optional
/** 点击上一首 */
- (void)controlView:(CXAudioControlView *)controlView didClickPrev:(UIButton *)prevBtn;
/** 点击播放 */
- (void)controlView:(CXAudioControlView *)controlView didClickPlay:(UIButton *)playBtn;
/** 点击下一首 */
- (void)controlView:(CXAudioControlView *)controlView didClickNext:(UIButton *)nextBtn;
/** 点击播放列表按钮 */
- (void)controlView:(CXAudioControlView *)controlView didClickList:(UIButton *)listBtn;
// 滑杆滑动 及 点击
- (void)controlView:(CXAudioControlView *)controlView didSliderTouchBegan:(float)value;
- (void)controlView:(CXAudioControlView *)controlView didSliderTouchEnded:(float)value;
- (void)controlView:(CXAudioControlView *)controlView didSliderValueChange:(float)value;
- (void)controlView:(CXAudioControlView *)controlView didSliderTapped:(float)value;

@end

@interface CXAudioControlView : UIView

@property (nonatomic, weak) id<CXAudioControlViewDeleagte> delegate;

@property (nonatomic, copy) NSString *currentTime;
/** 总时间 */
@property (nonatomic, copy) NSString *totalTime;
/** 播放进度 */
@property (nonatomic, assign) float value;
/** 缓存进度 */
@property (nonatomic, assign) float cacheValue;
/** 初始化数据 */
- (void)setupInitialData;
/** 显示 缓存动画 */
- (void)showLoadingAnim;
/** 隐藏 缓存动画 */
- (void)hideLoadingAnim;
/** 创建播放按钮 */
- (void)setupPlayBtn;
/** 创建暂停按钮 */
- (void)setupPauseBtn;

@end
