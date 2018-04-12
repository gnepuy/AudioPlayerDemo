//
//  ViewController.m
//  AudioPlayerDemo
//
//  Created by yp on 2018/3/16.
//  Copyright © 2018年 yp. All rights reserved.
//

#import "ViewController.h"
//#import "CXAudioPlayerController.h"
#import "YPAudioListModel.h"
#import "CXAudioListController.h"

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *listTableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) YPVolumeButton *volumeBtn;

@end

@implementation ViewController

- (void)viewDidLoad {

    [super viewDidLoad];
    
    [self setuoUI];
    
    [self getAudilListData];
}

- (void)getAudilListData {
    
    [self.dataArray removeAllObjects];
    NSArray *dataArray = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"audioList.plist" ofType:nil]];
    [self.dataArray addObjectsFromArray:[YPAudioListModel mj_objectArrayWithKeyValuesArray:dataArray]];
    [self.listTableView reloadData];
}

- (void)setuoUI {
    
    [self setupClearNavbarUI];

    
    self.title = @"音频列表";
    [self.view addSubview:self.listTableView];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.volumeBtn];
    [self.listTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"YPAudioListViewCell"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YPAudioListModel *audioListModel = self.dataArray[indexPath.row];
    UITableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:@"YPAudioListViewCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"YPAudioListViewCell"];
    }
    cell.textLabel.text = audioListModel.title;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    YPAudioListModel *audioListModel = self.dataArray[indexPath.row];
    CXAudioListController *listVc = [[CXAudioListController alloc] init];
    listVc.audioName = audioListModel.name;
    listVc.title = audioListModel.title;
    [self.navigationController pushViewController:listVc animated:YES];
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
//        _dataArray = @[@"普通音频专辑", @"听书音频专辑", @"主题音频专辑"];
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

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    //    判断音乐是否正在播放 修改状态栏图标状态
    CXAudioPlayerController *playerVC = [CXAudioPlayerController sharedInstance];
    
    self.volumeBtn.animated = playerVC.isPlaying ? YES : NO;
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self setupClearNavbarUI];
}

@end
