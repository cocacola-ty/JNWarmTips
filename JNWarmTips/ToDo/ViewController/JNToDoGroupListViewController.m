//
// Created by fengtianyu on 2/5/18.
// Copyright (c) 2018 fengtianyu. All rights reserved.
//

#import "JNToDoGroupListViewController.h"
#import "View+MASAdditions.h"
#import "JNGroupListCell.h"
#import "JNWarmTipsPublicFile.h"

static NSString *const kGroupListCellReuseId = @"JNGroupListCellReuseId";

@interface JNToDoGroupListViewController() <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *headerView;
@end

@implementation JNToDoGroupListViewController {

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[JNGroupListCell class] forCellReuseIdentifier:kGroupListCellReuseId];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JNGroupListCell *cell = [tableView dequeueReusableCellWithIdentifier:kGroupListCellReuseId];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;

        _tableView.tableHeaderView = self.headerView;
    }
    return _tableView;
}

- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [UIView new];
        CGFloat height = 64 + 50;
        _headerView.bounds = CGRectMake(0, 0, SCREEN_WIDTH, height);
        _headerView.backgroundColor = RANDOM_COLOR;
    }
    return _headerView;
}
@end