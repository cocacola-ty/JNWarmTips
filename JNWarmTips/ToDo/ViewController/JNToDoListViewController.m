//
// Created by fengtianyu on 2/5/18.
// Copyright (c) 2018 fengtianyu. All rights reserved.
//

#import "JNToDoListViewController.h"
#import "JNWarmTipsPublicFile.h"
#import "View+MASAdditions.h"


@interface JNToDoListViewController() <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation JNToDoListViewController {

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = GRAY_BACKGROUND_COLOR;
    self.automaticallyAdjustsScrollViewInsets = NO;

    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(70);
        make.left.equalTo(self.view.mas_left).offset(8);
        make.right.equalTo(self.view.mas_right).offset(-8);
        make.bottom.equalTo(self.view.mas_bottom).offset(-60);
    }];

    // TEST
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 20;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *sectionView = [UIView new];
    sectionView.backgroundColor = [UIColor greenColor];
    return sectionView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;

        _tableView.layer.cornerRadius = 8;
        _tableView.backgroundColor = [UIColor whiteColor];
        UIView *headerView = [UIView new];
        headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 70);
        headerView.backgroundColor = [UIColor redColor];
        _tableView.tableHeaderView = headerView;
    }
    return _tableView;
}

@end