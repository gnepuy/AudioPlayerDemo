//
//  CXAudioControlView.m
//  chuxinketing
//
//  Created by yp on 2018/3/12.
//  Copyright © 2018年 北京心花怒放网络科技有限公司. All rights reserved.
//
#import "CXAudioControlView.h"
#import "CXSliderView.h"


@interface CXAudioControlView ()<CXSliderViewDelegate>
/** 播放按钮 */
@property (nonatomic, strong) UIButton *playBtn;
/** 上一首 */
@property (nonatomic, strong) UIButton *prevBtn;
/** 下一首 */
@property (nonatomic, strong) UIButton *nextBtn;
/** 列表 */
@property (nonatomic, strong) UIButton *listBtn;
/** 滑块背景view*/
@property (nonatomic, strong) UIView *sliderView;
/** 当前进度时间label*/
@property (nonatomic, strong) UILabel *currentLabel;
/** 总时间label */
@property (nonatomic, strong) UILabel *totalLabel;
/** 滑块 */
@property (nonatomic, strong) CXSliderView *slider;

@end

@implementation CXAudioControlView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
//        self.backgroundColor = [UIColor whiteColor];
    
        self.clipsToBounds = YES;
        
        CGFloat slideViewX = 0;
        CGFloat slideViewY = 0;
        CGFloat slideViewW = (kMainScreenWidth - 60);
        CGFloat slideViewH = 37;
        //  滑块背景view
        self.sliderView.frame = CGRectMake(slideViewX, slideViewY, slideViewW, slideViewH);
        [self addSubview:self.sliderView];
//       self.sliderView.backgroundColor = [UIColor orangeColor];
//      滑块
        CGFloat slideX = 0;
        CGFloat slideY = 0;
        CGFloat slideW = self.sliderView.bounds.size.width;
        CGFloat slideH = 20;
        self.slider.frame = CGRectMake(slideX, slideY, slideW, slideH);
        [self.sliderView addSubview:self.slider];
//        self.slider.backgroundColor = [UIColor redColor];
//        当前时间
        CGFloat currentLabelX = 2;
        CGFloat currentLabelY = 20 ;
        CGFloat currentLabelW = self.sliderView.bounds.size.width * 0.5 - 2;
        CGFloat currentLabelH = 17;
        self.currentLabel.frame = CGRectMake(currentLabelX, currentLabelY, currentLabelW, currentLabelH);
        [self.sliderView addSubview:self.currentLabel];
//        self.currentLabel.text = @"";
//        self.currentLabel.textColor = [UIColor blackColor];
//        self.currentLabel.backgroundColor = [UIColor redColor];
//        全部时间
        CGFloat totalLabelW = self.sliderView.bounds.size.width * 0.5 - 2;
        CGFloat totalLabelX = self.sliderView.bounds.size.width * 0.5 - 2;
        CGFloat totalLabelY = 20 ;
        CGFloat totalLabelH = 17;
        self.totalLabel.frame = CGRectMake(totalLabelX, totalLabelY, totalLabelW, totalLabelH);
        [self.sliderView addSubview:self.totalLabel];
//        self.totalLabel.textColor = [UIColor blackColor];
//        self.totalLabel.backgroundColor = [UIColor redColor];
        //  播放按钮
        CGFloat playBtnW = 43;
        CGFloat playBtnH = 43;
        CGFloat playBtnY = CGRectGetMaxY(self.currentLabel.frame) + 18.5;
        CGFloat playBtnX = self.sliderView.bounds.size.width * 0.5 - playBtnW *0.5;
        self.playBtn.frame = CGRectMake(playBtnX, playBtnY, playBtnW, playBtnH);
        [self addSubview:self.playBtn];
//        self.playBtn.backgroundColor = [UIColor redColor];
        //  上一首
        CGFloat prevBtnW = 24;
        CGFloat prevBtnH = 21;
        CGFloat prevBtnY = CGRectGetMidY(self.playBtn.frame) - prevBtnH *0.5;
        CGFloat prevBtnX = CGRectGetMinX(self.playBtn.frame) - 47.5- prevBtnW;
        self.prevBtn.frame = CGRectMake(prevBtnX, prevBtnY, prevBtnW, prevBtnH);
        [self addSubview:self.prevBtn];
//        self.prevBtn.backgroundColor = [UIColor redColor];
        //  下一首
        CGFloat nextBtnW = 24;
        CGFloat nextBtnH = 21;
        CGFloat nextBtnY = CGRectGetMidY(self.playBtn.frame) - prevBtnH *0.5;
        CGFloat nextBtnX = CGRectGetMaxX(self.playBtn.frame) + 47.5;
        self.nextBtn.frame = CGRectMake(nextBtnX, nextBtnY, nextBtnW, nextBtnH);
        [self addSubview:self.nextBtn];
//        self.nextBtn.backgroundColor = [UIColor redColor];
        //  列表按钮
        CGFloat listBtnW = 24;
        CGFloat listBtnH = 21;
        CGFloat listBtnY = CGRectGetMidY(self.playBtn.frame) - listBtnH *0.5;
        CGFloat listBtnX = CGRectGetMaxX(self.sliderView.frame) - listBtnW - 1;
        self.listBtn.frame = CGRectMake(listBtnX, listBtnY, listBtnW, listBtnH);
        [self addSubview:self.listBtn];
//        self.listBtn.backgroundColor = [UIColor redColor];
    }
    return self;
}

- (void)setCurrentTime:(NSString *)currentTime {
    
    _currentTime = currentTime;
    self.currentLabel.text = currentTime;
}

- (void)setTotalTime:(NSString *)totalTime {
    
    _totalTime = totalTime;
    self.totalLabel.text = totalTime;
}

- (void)setValue:(float)value {
    
    _value = value;
    self.slider.value = value;
}

- (void)setCacheValue:(float)cacheValue {
    
    _cacheValue = cacheValue;
    self.slider.bufferValue = cacheValue;
}

- (void)setupInitialData {
    
    self.value       = 0;
    self.currentTime = @"00:00:00";
    self.totalTime   = @"00:00:00";
    //    [self showLoadingAnim];
}

- (void)showLoadingAnim {
   
    [self.slider showLoading];
}

- (void)hideLoadingAnim {
    
    [self.slider hideLoading];
}

- (void)setupPlayBtn {
    
    [self.playBtn setImage:[UIImage imageNamed:@"btn_media_play"] forState:UIControlStateNormal];
    [self.playBtn setImage:[UIImage imageNamed:@"btn_media_play"] forState:UIControlStateHighlighted];
}

- (void)setupPauseBtn {
    
    [self.playBtn setImage:[UIImage imageNamed:@"btn_media_pause"] forState:UIControlStateNormal];
    [self.playBtn setImage:[UIImage imageNamed:@"btn_media_pause"] forState:UIControlStateHighlighted];
}

#pragma mark - UserAction


- (void)playBtnClick:(id)sender {
    
    self.playBtn.selected = !self.playBtn.selected;
    
    if (self.playBtn.selected) {
        [self setupPlayBtn];
    }else {
        [self setupPauseBtn];
    }
    
    if ([self.delegate respondsToSelector:@selector(controlView:didClickPlay:)]) {
        [self.delegate controlView:self didClickPlay:sender];
    }
}


- (void)prevBtnClick:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(controlView:didClickPrev:)]) {
        [self.delegate controlView:self didClickPrev:sender];
    }
}

- (void)nextBtnClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(controlView:didClickNext:)]) {
        [self.delegate controlView:self didClickNext:sender];
    }
}

//  列表按钮事件
- (void)listBtnClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(controlView:didClickList:)]) {
        [self.delegate controlView:self didClickList:sender];
    }
}

#pragma mark - CXSliderViewDelegate
//  滑块开始滑动
- (void)sliderTouchBegin:(float)value {
    if ([self.delegate respondsToSelector:@selector(controlView:didSliderTouchBegan:)]) {
        [self.delegate controlView:self didSliderTouchBegan:value];
    }
}
//  滑块滑动结束
- (void)sliderTouchEnded:(float)value {
    if ([self.delegate respondsToSelector:@selector(controlView:didSliderTouchEnded:)]) {
        [self.delegate controlView:self didSliderTouchEnded:value];
    }
}
//  轻触滑块
- (void)sliderTapped:(float)value {
    if ([self.delegate respondsToSelector:@selector(controlView:didSliderTapped:)]) {
        [self.delegate controlView:self didSliderTapped:value];
    }
}
//  滑块数值改变
- (void)sliderValueChanged:(float)value {
    if ([self.delegate respondsToSelector:@selector(controlView:didSliderValueChange:)]) {
        [self.delegate controlView:self didSliderValueChange:value];
    }
}

#pragma mark - 懒加载
 
//  播放按钮
- (UIButton *)playBtn {
    if (_playBtn == nil) {
        _playBtn = [UIButton new];
        [_playBtn setImage:[UIImage imageNamed:@"btn_media_pause"] forState:UIControlStateNormal];
        [_playBtn setImage:[UIImage imageNamed:@"btn_media_pause"] forState:UIControlStateHighlighted];
        [_playBtn addTarget:self action:@selector(playBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playBtn;
}
//  上一首按钮
- (UIButton *)prevBtn {
    if (_prevBtn == nil) {
        _prevBtn = [UIButton new];
        [_prevBtn setImage:[UIImage imageNamed:@"btn_media_pre"] forState:UIControlStateNormal];
        [_prevBtn setImage:[UIImage imageNamed:@"btn_media_pre"] forState:UIControlStateHighlighted];
        [_prevBtn addTarget:self action:@selector(prevBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _prevBtn;
}
//  下一首按钮
- (UIButton *)nextBtn {
    if (_nextBtn == nil) {
        _nextBtn = [UIButton new];
        [_nextBtn setImage:[UIImage imageNamed:@"btn_media_next"] forState:UIControlStateNormal];
        [_nextBtn setImage:[UIImage imageNamed:@"btn_media_next"] forState:UIControlStateHighlighted];
        [_nextBtn addTarget:self action:@selector(nextBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextBtn;
}
//  列表按钮
- (UIButton *)listBtn {
    if (_listBtn == nil) {
        _listBtn = [UIButton new];
        [_listBtn setImage:[UIImage imageNamed:@"btn_media_list"] forState:UIControlStateNormal];
        [_listBtn setImage:[UIImage imageNamed:@"btn_media_list"] forState:UIControlStateHighlighted];
        [_listBtn addTarget:self action:@selector(listBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _listBtn;
}
//  滑块背景view
- (UIView *)sliderView {
    if (_sliderView == nil) {
        _sliderView = [[UIView alloc] init];
//        _sliderView.backgroundColor = [UIColor colorWithHexString:@"#F9F9FA"];
//        _sliderView.backgroundColor = [UIColor lightGrayColor];
    }
    return _sliderView;
}
//  当前时间
- (UILabel *)currentLabel {
    if (_currentLabel == nil) {
        _currentLabel = [UILabel new];
        _currentLabel.textColor = [UIColor colorWithHexString:@"#011919"];;
        _currentLabel.textAlignment = NSTextAlignmentLeft;
        _currentLabel.font = [UIFont systemFontOfSize:12.0];
    }
    return _currentLabel;
}
//  全部时间
- (UILabel *)totalLabel {
    if (_totalLabel == nil) {
        _totalLabel = [UILabel new];
        _totalLabel.textColor = [UIColor colorWithHexString:@"#011919"];;
        _totalLabel.textAlignment = NSTextAlignmentRight;
        _totalLabel.font = [UIFont systemFontOfSize:12.0];
    }
    return _totalLabel;
}
//  滑块
- (CXSliderView *)slider {
    
    if (_slider == nil) {
        
        _slider = [CXSliderView new];

        
//        [_slider setBackgroundColor:[UIColor colorWithHexString:@"#43A5FE"]];
//        [_slider setBackgroundImage:[UIImage imageNamed:@"cm2_fm_playbar_btn"] forState:UIControlStateNormal];
//        [_slider setBackgroundImage:[UIImage imageNamed:@"cm2_fm_playbar_btn"] forState:UIControlStateSelected];
//        [_slider setBackgroundImage:[UIImage imageNamed:@"cm2_fm_playbar_btn"] forState:UIControlStateHighlighted];
//
//        [_slider setThumbImage:[UIImage imageNamed:@"cm2_fm_playbar_btn_dot"] forState:UIControlStateNormal];
//        [_slider setThumbImage:[UIImage imageNamed:@"cm2_fm_playbar_btn_dot"] forState:UIControlStateSelected];
//        [_slider setThumbImage:[UIImage imageNamed:@"cm2_fm_playbar_btn_dot"] forState:UIControlStateHighlighted];

        _slider.maximumTrackTintColor = [UIColor colorWithHexString:@"#eeeeee"];
        _slider.minimumTrackTintColor = [UIColor colorWithHexString:@"#43A5FE"];
        _slider.bufferTrackTintColor = [UIColor colorWithHexString:@"#9fd1fe"];
//        _slider.maximumTrackImage = [UIImage imageNamed:@"cm2_fm_playbar_bg"];
//        _slider.minimumTrackImage = [UIImage imageNamed:@"cm2_fm_playbar_curr"];
//        _slider.bufferTrackImage  = [UIImage imageNamed:@"cm2_fm_playbar_ready"];
        
        _slider.allowTapped = NO;
        _slider.delegate = self;
        _slider.sliderHeight = 2.5;
    }
    return _slider;
}

@end

