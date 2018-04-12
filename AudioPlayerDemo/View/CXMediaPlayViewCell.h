//
//  CXMediaPlayViewCell.h
//  chuxinketing
//
//  Created by yp on 2018/1/31.
//  Copyright © 2018年 北京心花怒放网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CXMusicPlayListModel;

//@protocol CXMusicPlayListModelDelegate<NSObject>
//
//@optional

//- (void)purchaseMusicWith:(CXMusicPlayListModel *)musicInfoModel;

//@end

@interface CXMediaPlayViewCell : UITableViewCell

@property (nonatomic, strong) CXMusicPlayListModel *dtListModel;

//@property (nonatomic, weak) id<CXMusicPlayListModelDelegate>delegate;

@end
