//
// Created by fengtianyu on 2/5/18.
// Copyright (c) 2018 fengtianyu. All rights reserved.
//

#import "JNToDoListViewController.h"
#import "JNWarmTipsPublicFile.h"
#import "JNToDoItemCell.h"
#import "View+MASAdditions.h"
#import "JNEventEditorViewController.h"


static const int kToDoListSectionHeaderViewHeight = 60;

static NSString *const kToDoListCellReuseId = @"kToDoListCellReuseId";

@interface JNToDoListViewController() <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UILabel *headerTitleLabel;
@property (nonatomic, strong) UIImageView *addItemImageView;
@property (nonatomic, strong) NSArray *dataArray;
@end

@implementation JNToDoListViewController {

}
- (void)viewDidLoad {

    [super viewDidLoad];
    self.view.backgroundColor = RGB(240, 240, 240);
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tabBarController.tabBar.hidden = YES;

    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(70);
        make.left.equalTo(self.view.mas_left).offset(8);
        make.right.equalTo(self.view.mas_right).offset(-8);
        make.bottom.equalTo(self.view.mas_bottom).offset(-70);
    }];

    [self.tableView registerClass:[JNToDoItemCell class] forCellReuseIdentifier:kToDoListCellReuseId];

    [self.view addSubview:self.addItemImageView];
    [self.addItemImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(50);
        make.bottom.equalTo(self.view.mas_bottom).offset(-10);
        make.centerX.equalTo(self.view.mas_centerX);
    }];

}

#pragma mark - Event Response

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) addItem {
    JNEventEditorViewController *editorViewController = [[JNEventEditorViewController alloc] init];
    editorViewController.editFinishBlock = ^(NSString *text) {
        // 插入数据库
        // 刷新当前视图
    };
    [self presentViewController:editorViewController animated:YES completion:nil];
}

#pragma mark - Delegate & DataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JNToDoItemCell *cell = [tableView dequeueReusableCellWithIdentifier:kToDoListCellReuseId];
    [cell reloadCellWithTitle:@"明天不上班" taskFinishStatus:NO];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    JNToDoItemCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell refreshTaskStatus:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *sectionView = [UIView new];
    sectionView.backgroundColor = [UIColor whiteColor];
    UILabel *sectionTitleLabel = [UILabel new];
    sectionTitleLabel.text = @"未分类";
    sectionTitleLabel.textColor = GRAY_TEXT_COLOR;
    sectionTitleLabel.font = [UIFont systemFontOfSize:15.0];
    sectionTitleLabel.frame = CGRectMake(20, 0, SCREEN_WIDTH, kToDoListSectionHeaderViewHeight);
    [sectionView addSubview:sectionTitleLabel];
    return sectionView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kToDoListSectionHeaderViewHeight;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;

        _tableView.layer.cornerRadius = 12;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.tableHeaderView = self.headerView;
    }
    return _tableView;
}

- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [UIView new];
        _headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH-16, 100);
        _headerView.backgroundColor = [UIColor redColor];

        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_headerView.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(12, 12)];
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.path = maskPath.CGPath;
        maskLayer.frame = _headerView.bounds;
        _headerView.layer.mask = maskLayer;

        [self.headerView addSubview:self.headerTitleLabel];
        [self.headerTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.headerView.mas_centerY);
            make.centerX.equalTo(self.headerView.mas_centerX);
        }];
    }
    return _headerView;
}

- (UILabel *)headerTitleLabel {
    if (!_headerTitleLabel) {
        _headerTitleLabel = [UILabel new];
        _headerTitleLabel.font = [UIFont systemFontOfSize:18.0];
        _headerTitleLabel.textColor = [UIColor whiteColor];
        _headerTitleLabel.text = @"ALL";
    }
    return _headerTitleLabel;
}

- (UIImageView *)addItemImageView {
    if (!_addItemImageView) {
        _addItemImageView = [[UIImageView alloc] init];
        _addItemImageView.image = [UIImage imageNamed:@"publish_btn"];
        _addItemImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addItem)];
        [_addItemImageView addGestureRecognizer:tapGestureRecognizer];
    }
    return _addItemImageView;
}

- (NSArray *)dataArray {
    if (!_dataArray) {

    }
    return _dataArray;
}

@end