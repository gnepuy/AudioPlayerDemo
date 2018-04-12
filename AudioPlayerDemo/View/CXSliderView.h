//
//  CXSliderView.h
//  chuxinketing
//
//  Created by yp on 2018/3/12.
//  Copyright © 2018年 北京心花怒放网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol CXSliderViewDelegate <NSObject>

@optional

- (void)sliderTouchBegin:(float)value;
- (void)sliderValueChanged:(float)value;
- (void)sliderTouchEnded:(float)value;
- (void)sliderTapped:(float)value;

@end

@interface CXSliderView : UIView

@property (nonatomic, weak) id<CXSliderViewDelegate> delegate;

/** 默认滑杆的颜色 */
@property (nonatomic, strong) UIColor *maximumTrackTintColor;
/** 滑杆进度颜色 */
@property (nonatomic, strong) UIColor *minimumTrackTintColor;
/** 缓存进度颜色 */
@property (nonatomic, strong) UIColor *bufferTrackTintColor;
/** 默认滑杆的图片 */
@property (nonatomic, strong) UIImage *maximumTrackImage;
/** 滑杆进度的图片 */
@property (nonatomic, strong) UIImage *minimumTrackImage;
/** 缓存进度的图片 */
@property (nonatomic, strong) UIImage *bufferTrackImage;

/** 滑杆进度 */
@property (nonatomic, assign) float value;
/** 缓存进度 */
@property (nonatomic, assign) float bufferValue;
/** 是否允许点击，默认是yes */
@property (nonatomic, assign) BOOL allowTapped;

@property (nonatomic, assign) CGFloat sliderHeight;

// 设置滑块的属性
// 滑块背景
- (void)setBackgroundImage:(UIImage *)image forState:(UIControlState)state;
// 滑块图片
- (void)setThumbImage:(UIImage *)image forState:(UIControlState)state;

- (void)showLoading;

- (void)hideLoading;

@end


@interface CXSliderButton : UIButton

- (void)showActivityAnim;

- (void)hideActivityAnim;

@end

@interface UIView (CXFrame)

@property (nonatomic, assign) CGFloat top;
@property (nonatomic, assign) CGFloat left;
@property (nonatomic, assign) CGFloat right;
@property (nonatomic, assign) CGFloat bottom;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;

@end
