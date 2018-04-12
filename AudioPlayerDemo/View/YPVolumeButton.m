//
//  CXVolumeButton.m
//  VolumeDemo
//
//  Created by yp on 2018/3/6.
//  Copyright © 2018年 yp. All rights reserved.
//

#import "YPVolumeButton.h"

@interface YPVolumeButton ()

@property (nonatomic, strong) CAReplicatorLayer *replicatorLayer;

@end

@implementation YPVolumeButton

// 44 * 44

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        //  实例化 CAReplicatorLayer 对象
        CAReplicatorLayer *replicatorLayer = [[CAReplicatorLayer alloc] init];
        //  设置图片的生效范围
        replicatorLayer.frame = self.bounds;
        //  复制20份图层 每一份表示一根音量跳动的音量柱
        replicatorLayer.instanceCount = 1;
        //  设置复制图层之间的渐变效果，这里设置图层沿x方向，每隔20个点复制一份
        replicatorLayer.instanceTransform = CATransform3DMakeTranslation(10, 0, 0);
        //  复制间隔为每0.2s一次
        replicatorLayer.instanceDelay = 0.2;
        //  将图层超出生效范围之外的部分剪切掉
        replicatorLayer.masksToBounds = YES;
        //  设置图层北京颜色为黑色      UIColor *bgColor = [UIColor colorWithHexString:@"#43A5FE"];
        replicatorLayer.backgroundColor = [UIColor colorWithHexString:@"#43A5FE"].CGColor;
 
        CGFloat allHeight = CGRectGetHeight(self.frame);
        CGFloat halfHeight = allHeight* 0.5;
        CGFloat allWidth = CGRectGetWidth(self.frame);
 
        CGFloat itemW = 3;
        CGFloat itemH = allHeight;
        CGFloat margin = (allWidth - 4 *itemW) / 5;
 
        CGFloat itemX = 0;
        CGFloat itemY = 0;

        for (int i = 0; i < 4; i++) {
            //  实例化一个Layer图层，每一个图层示例对象对应一个音量跳动音量柱
            CALayer *layer = [[CALayer alloc] init];
            itemX = i * (margin + itemW) + margin;
            if (i % 2 == 0) {
                itemY = halfHeight;
            } else {
                itemY = 0;
            }
            //  设置图层范围
            layer.frame = CGRectMake(itemX,itemY, itemW, itemH);
            //  设置图层颜色
            layer.backgroundColor = [UIColor whiteColor].CGColor;
            //  将Layer图层添加到replicatorLayer图层上
            layer.cornerRadius = 2;
            layer.masksToBounds = YES;
            [replicatorLayer addSublayer:layer];
        }
        [self.layer addSublayer:replicatorLayer];
        self.replicatorLayer = replicatorLayer;
    }
    return self;
}

- (void)setAnimated:(BOOL)animated {
    _animated = animated;
    if (animated ) {
//        NSLog(@"%@", self.replicatorLayer.sublayers);
        CGFloat allHeight = CGRectGetHeight(self.frame);
        CGFloat halfHeight = allHeight* 0.5;
        
        for (int i = 0; i < self.replicatorLayer.sublayers.count; i ++ ) {
            CALayer *layer  = self.replicatorLayer.sublayers[i];
            
            if (i % 2 == 0) {
                
                CABasicAnimation *animation = [[CABasicAnimation alloc] init];
                //  设置动画属性为 position.y 属性
                animation.keyPath = @"position.y";
                //  设置动画周期为0.5s
                animation.duration = 0.5;
                //  设置音量柱高度在200~150范围内波动
                animation.fromValue = @(allHeight);
                animation.toValue = @(halfHeight);
                //  设置动画完成之后不返回
                animation.autoreverses = YES;
                //  设置动画不断重复
                animation.repeatCount = MAXFLOAT;
                //  将动画添加到当前图层上
                [layer addAnimation:animation forKey:nil];
                
            } else {
                CABasicAnimation *animation1 = [[CABasicAnimation alloc] init];
                //  设置动画属性为 position.y 属性
                animation1.keyPath = @"position.y";
                //  设置动画周期为0.5s
                animation1.duration = 0.5;
                //  设置音量柱高度在 A~B 范围内波动
                animation1.fromValue = @(halfHeight);
                animation1.toValue = @(allHeight);
                //  设置动画完成之后不返回
                animation1.autoreverses = YES;
                //  设置动画不断重复
                animation1.repeatCount = MAXFLOAT;
                [layer addAnimation:animation1 forKey:nil];
            }
        }
    } else {
        //  清楚自图层动画
        [self.replicatorLayer.sublayers makeObjectsPerformSelector:@selector(removeAllAnimations)];
    }
}





@end
