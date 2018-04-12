//
//  CXMediaPlayViewCell.m
//  chuxinketing
//
//  Created by yp on 2018/1/31.
//  Copyright © 2018年 北京心花怒放网络科技有限公司. All rights reserved.
//

#import "CXMediaPlayViewCell.h"
#import "CXMusicPlayListModel.h"

@interface CXMediaPlayViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *coverView;

@property (weak, nonatomic) IBOutlet UIImageView *statusView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UIButton *buyButton;

@end

@implementation CXMediaPlayViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.buyButton.layer.borderColor = [UIColor colorWithHexString:@"#43A5FE"].CGColor;
    self.buyButton.layer.borderWidth = 1.f;
    self.buyButton.layer.cornerRadius = 4.f;
    self.buyButton.layer.masksToBounds = YES;
    
    self.coverView.layer.cornerRadius = 20.f;
    self.coverView.layer.masksToBounds = YES;
}

- (void)setDtListModel:(CXMusicPlayListModel *)dtListModel {
    
    _dtListModel = dtListModel;
    
    self.timeLabel.text = dtListModel.timeLength;
    self.titleLabel.text = dtListModel.title;
    
    NSURL *imageUrl = [NSObject fileURL:dtListModel.image];
    [self.coverView sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"icon_logo"]];
    self.statusView.image = [UIImage imageNamed:@"icon_media_play"];
    
    //  fee 0免费 1收费
    if ([dtListModel.fee integerValue] == 0) {
        
        self.buyButton.backgroundColor = [UIColor whiteColor];
        [self.buyButton setTitle:@"免费" forState:UIControlStateNormal];
        [self.buyButton setTitleColor:[UIColor colorWithHexString:@"#43A5FE"] forState:UIControlStateNormal];
    } else {
        //  buyed 0未购买 1 购买
        if ([dtListModel.buyed integerValue] == 0) {
            //  未购买
            self.buyButton.backgroundColor = [UIColor colorWithHexString:@"#43A5FE"];
            [self.buyButton setTitle:[NSString stringWithFormat:@"￥%.2f", [dtListModel.price floatValue]] forState:UIControlStateNormal];
            [self.buyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        } else {
            //  已购买
            self.buyButton.backgroundColor = [UIColor whiteColor];
            [self.buyButton setTitle:@"已购买" forState:UIControlStateNormal];
            [self.buyButton setTitleColor:[UIColor colorWithHexString:@"#43A5FE"] forState:UIControlStateNormal];
        }
    }
}

- (IBAction)buyButtonClickEvent:(UIButton *)sender {
//    专辑免费 或 已购买
    if ([self.dtListModel.fee integerValue] == 0 || [self.dtListModel.buyed integerValue] == 1) {
        return;
    }
    
    
    NSDictionary *musicInfo = [self.dtListModel mj_keyValues];
    
    if (musicInfo == nil)  return;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"GoPurchaseMusic" object:nil userInfo:musicInfo];
    
//    if (self.delegate && [self.delegate respondsToSelector:@selector(purchaseMusicWith:)]) {
//
//        [self.delegate purchaseMusicWith:self.dtListModel];
//    }
}

@end
