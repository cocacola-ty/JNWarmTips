//
// Created by fengtianyu on 6/7/18.
// Copyright (c) 2018 fengtianyu. All rights reserved.
//

#import "JNEventTimeLineViewController.h"
#import "UIColor+Extension.h"
#import "Masonry.h"
#import "JNEventTimeLineTableViewCell.h"
#import "JNWarmTipsPublicFile.h"

@interface JNEventTimeLineViewController() <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation JNEventTimeLineViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
//    [self addNavigationBar];
    [self addTopView];
    
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(180);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"JNEventTimeLineTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"JNEventTimeLineTableViewCellReuseId"];

}

- (void) addTopView {
    UIImageView *backImageView = [UIImageView new];
    backImageView.image = [[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [backImageView setTintColor:MAIN_COLOR];
    [self.view addSubview:backImageView];
    [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(20);
        make.left.equalTo(self.view.mas_left).offset(25);
        make.top.equalTo(self.view.mas_top).offset(30);
    }];
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = @"TIMELINE";
    titleLabel.font = [UIFont boldSystemFontOfSize:28];
    [self.view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(25);
        make.top.equalTo(self.view.mas_top).offset(100);
    }];
}

- (void) addNavigationBar {
    UIView *navigationBar = [UIView new];
    navigationBar.backgroundColor = [UIColor colorWithHexString:@"F08080"];
    [self.view addSubview:navigationBar];
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = @"TimeLine";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [navigationBar addSubview:titleLabel];
    
    [navigationBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_top);
        make.height.mas_equalTo(64);
    }];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(navigationBar.mas_centerX);
        make.centerY.equalTo(navigationBar.mas_centerY).offset(10);
    }];
    
    UIImageView *bannerImageView = [UIImageView new];
    bannerImageView.image = [UIImage imageNamed:@"group_bg3.jpg"];
    [self.view addSubview:bannerImageView];
    [bannerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view);
        make.top.equalTo(navigationBar.mas_top);
        make.height.mas_equalTo(180);
    }];
}

#pragma mark - Delegate & DataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JNEventTimeLineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JNEventTimeLineTableViewCellReuseId"];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 点击显示距离今天的天数
}

#pragma mark - Getter & Setter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 80;
        _tableView.estimatedRowHeight = 50;
        _tableView.estimatedRowHeight = UITableViewAutomaticDimension;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

@end
