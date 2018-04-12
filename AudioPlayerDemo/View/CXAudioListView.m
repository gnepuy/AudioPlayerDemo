//
//  CXAudioListView.m
//  chuxinketing
//
//  Created by yp on 2018/2/8.
//  Copyright © 2018年 北京心花怒放网络科技有限公司. All rights reserved.
//

#import "CXAudioListView.h"
#import "CXMusicPlayListModel.h"
#import "CXMediaPlayViewCell.h"

@interface CXAudioListView ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *backView;

@property (weak, nonatomic) IBOutlet UIButton *buyButton;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, assign) BOOL showBuyBtn;

@end

@implementation CXAudioListView


+ (instancetype)audioListView {
    
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
}

- (void)setListInfoArray:(NSArray *)listInfoArray {
    
    _listInfoArray = listInfoArray;
    [self.tableView reloadData];
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.backView.backgroundColor = [UIColor clearColor];
    [self setupTableView];
}


- (void)setupTableView {
    
    self.tableView .rowHeight = 68;
    self.tableView .delegate = self;
    self.tableView .dataSource = self;
    self.tableView .separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView .showsVerticalScrollIndicator = NO;
    self.tableView .tableFooterView = [[UIView alloc] init];
    [self.tableView registerNib:[UINib nibWithNibName:@"CXMediaPlayViewCell" bundle:nil] forCellReuseIdentifier:@"CXMediaPlayViewCell"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.listInfoArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CXMusicPlayListModel *dtListModel = self.listInfoArray[indexPath.row];
    CXMediaPlayViewCell *musicCell = [tableView dequeueReusableCellWithIdentifier:@"CXMediaPlayViewCell" forIndexPath:indexPath];
    musicCell.dtListModel = dtListModel;
    return musicCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CXMusicPlayListModel *dtListModel = self.listInfoArray[indexPath.row];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(audioListView:didSelectRowAtIndexPathWith:)]) {
        
        [self.delegate audioListView:self didSelectRowAtIndexPathWith:dtListModel];
    }
}

- (void)setShowBuyBtn:(BOOL)showBuyBtn {
    
    _showBuyBtn = showBuyBtn;
    
    if (showBuyBtn) {
        self.buyButton.hidden = NO;
    } else {
        self.buyButton.hidden = YES;
    }
}

- (void)showAudioListViewWithShowBuyBtn:(BOOL)showButBtn {
    
    self.showBuyBtn = showButBtn;
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    //添加自己到窗口上
    [window addSubview:self];
    self.frame = window.bounds;
    UIColor *blackColor = [UIColor blackColor];
    self.backgroundColor = [blackColor colorWithAlphaComponent:0.25];
    self.backView.frame = CGRectMake(0, kMainScreenHeight, kMainScreenWidth, kMainScreenHeight);
    [UIView animateWithDuration:0.4 animations:^{
        self.backView.frame = CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight);
    }];
}

- (void)hideAudioListView {
    
    [UIView animateWithDuration:0.25 animations:^{
        self.backView.frame = CGRectMake(0, kMainScreenHeight, kMainScreenWidth, kMainScreenHeight);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (IBAction)buyButtonClickEvent:(UIButton *)sender {
    
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(audioListViewPurchaseMusicSubject)]) {
        
        [self.delegate performSelector:@selector(audioListViewPurchaseMusicSubject)];
    }
}

//- (void)setShowBuyButton:(BOOL)showBuyButton {
//
//    _showBuyButton = showBuyButton;
//
//    self.buyButton.hidden = showBuyButton;
//}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self hideAudioListView];
}

- (IBAction)closeButtonClickEvent:(UIButton *)sender {
    
    [self hideAudioListView];
}


@end

