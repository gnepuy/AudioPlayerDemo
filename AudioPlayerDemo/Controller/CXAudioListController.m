//
//  CXAudioListController.m
//  AudioPlayerDemo
//
//  Created by yp on 2018/3/22.
//  Copyright © 2018年 yp. All rights reserved.
//

#import "CXAudioListController.h"
#import "YPAudioListModel.h"
#import "CXMusicPlayListModel.h"

@interface CXAudioListController ()  <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *listTableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) YPVolumeButton *volumeBtn;

@end

@implementation CXAudioListController


- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    //    判断音乐是否正在播放 修改状态栏图标状态
    CXAudioPlayerController *playerVC = [CXAudioPlayerController sharedInstance];
    self.volumeBtn.animated = playerVC.isPlaying ? YES : NO;
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    
    [self setuoUI];
    
    [self getAudilListData];
}

- (void)getAudilListData {
    
    [self.dataArray removeAllObjects];
    
    NSString *plistName = [NSString stringWithFormat:@"%@.plist", self.audioName];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:plistName ofType:nil]];
    [self.dataArray addObjectsFromArray:[CXMusicPlayListModel mj_objectArrayWithKeyValuesArray:dict[@"dtList"]]];
    [self.listTableView reloadData];
}

- (void)setuoUI {
    
//    self.title = @"音频列表";
    [self.view addSubview:self.listTableView];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.volumeBtn];
    [self.listTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"YPAudioListViewCell"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CXMusicPlayListModel *audioModel = self.dataArray[indexPath.row];
    UITableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:@"YPAudioListViewCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"YPAudioListViewCell"];
    }
    cell.textLabel.text = audioModel.title;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CXMusicPlayListModel *audioModel = self.dataArray[indexPath.row];

    NSString *playCurrentId = [NSString stringWithFormat:@"%@", audioModel.businessId];
    NSString *playType = [NSString stringWithFormat:@"%@", audioModel.playType];
    NSString *playId = [NSString stringWithFormat:@"%@", self.audioName];
    
    CXAudioPlayerController *audioVc = [CXAudioPlayerController sharedInstance];
    
    //  是同一种音频类型
    if ([playType isEqualToString:audioVc.playType]) {
        //  音频列表数据相同，不需要重新请求列表数据
        if ([playId isEqualToString:audioVc.playId]) {
            
            audioVc.regetList = NO;
            if ([playCurrentId isEqualToString:audioVc.playCurrentId]) {
                //                    CXLog(@" -同类型音频 - 同一专辑 - 同一个音频");
                //  与上次播放音频一致，直接进入页面即可
                audioVc.sameLast = YES;
                audioVc.playCurrentId = playCurrentId;
                audioVc.playType = playType;
                audioVc.playId = playId;
                [self.navigationController pushViewController:audioVc animated:YES];
            } else {
                //                    CXLog(@" -同类型音频 - 同一专辑 - 不同一个音频");
                //  与上次播放音频不一致
                //  播放列表其他音频文件
                audioVc.sameLast = NO;
                audioVc.playCurrentId = playCurrentId;
                audioVc.playType = playType;
                audioVc.playId = playId;
                [self.navigationController pushViewController:audioVc animated:YES];
            }
        } else {
            //  不是同一种音频列表
            //                CXLog(@" -同类型音频 - 不一专辑 - 音频 XX");
             audioVc.regetList = YES;
            audioVc.sameLast = NO;
            audioVc.playCurrentId = playCurrentId;
            audioVc.playType = playType;
            audioVc.playId = playId;
            [self.navigationController pushViewController:audioVc animated:YES];
        }
    } else {
        
        //            CXLog(@" - 不同类型音频 - 专辑XX - 音频 XX");
        //  不是同一种类型 音频 重新请求接口数据
        audioVc.regetList = YES;
        audioVc.sameLast = NO;
        audioVc.playCurrentId = playCurrentId;
        audioVc.playType = playType;
        audioVc.playId = playId;
        [self.navigationController pushViewController:audioVc animated:YES];
    }
}

- (void)volumeBtnClickEvent:(UIButton *)volumeBtn {
    
    CXAudioPlayerController *audioVc = [CXAudioPlayerController sharedInstance];
    
    if (audioVc.isPlaying == NO) {
        
        [SVProgressHUD setMinimumDismissTimeInterval:1.5];
        [SVProgressHUD showErrorWithStatus:@"当前没有正在播放的音频"];
    } else {
        audioVc.regetList = NO;
        audioVc.sameLast = YES;
        [self.navigationController pushViewController:audioVc animated:YES];
    }
}

- (YPVolumeButton *)volumeBtn {
    
    if (_volumeBtn == nil) {
        
        _volumeBtn = [[YPVolumeButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        _volumeBtn.backgroundColor = [UIColor colorWithHexString:@"#43A5FE"];
        [_volumeBtn addTarget:self action:@selector(volumeBtnClickEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _volumeBtn;
}

- (NSArray *)dataArray {
    
    if (_dataArray == nil) {

        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


- (UITableView *)listTableView {
    
    if (_listTableView == nil) {
        
        _listTableView = [[UITableView alloc] initWithFrame:self.view.bounds];
        _listTableView.dataSource = self;
        _listTableView.delegate = self;
    }
    return _listTableView;
}

//- (void)viewWillAppear:(BOOL)animated {
//    
//    [super viewWillAppear:animated];
//    
//    [self setupClearNavbarUI];
//}
//
//- (void)viewWillDisappear:(BOOL)animated {
//    
//    [super viewWillDisappear:animated];
//    
//    [self setupDefaultNavbarUI];
//}






@end
