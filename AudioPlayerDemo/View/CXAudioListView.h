//
//  CXAudioListView.h
//  chuxinketing
//
//  Created by yp on 2018/2/8.
//  Copyright © 2018年 北京心花怒放网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CXMusicPlayListModel;
@class CXAudioListView;

@protocol  CXAudioListViewDelegate <NSObject>

@optional

- (void)audioListViewPurchaseMusicSubject;

- (void)audioListView:(CXAudioListView *)audioListView didSelectRowAtIndexPathWith:(CXMusicPlayListModel *)dtListModel;


@end

@interface CXAudioListView : UIView

@property (nonatomic, strong) NSArray *listInfoArray;

@property (nonatomic, weak) id<CXAudioListViewDelegate>delegate;

+ (instancetype)audioListView;

- (void)showAudioListViewWithShowBuyBtn:(BOOL)showButBtn;

- (void)hideAudioListView;

@end

