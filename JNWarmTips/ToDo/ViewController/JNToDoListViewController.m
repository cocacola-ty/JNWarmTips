//
// Created by fengtianyu on 2/5/18.
// Copyright (c) 2018 fengtianyu. All rights reserved.
//

#import "JNToDoListViewController.h"
#import "JNWarmTipsPublicFile.h"
#import "JNToDoItemCell.h"
#import "View+MASAdditions.h"
#import "JNEventEditorViewController.h"
#import "JNGroupModel.h"
#import "JNDBManager.h"
#import "JNDBManager+Items.h"
#import "JNItemModel.h"
#import "JNAddListItemViewController.h"


static const int kToDoListSectionHeaderViewHeight = 60;

static NSString *const kToDoListCellReuseId = @"kToDoListCellReuseId";

static const int kTableViewHeaderViewHeight = 100;

static const int kLeftAndRightMargin = 8;

static const int kTopAndBottomMargin = 70;

static const double kViewShowAnimationDuration = 0.35;

@interface JNToDoListViewController() <UITableViewDelegate, UITableViewDataSource, CAAnimationDelegate>
@property (nonatomic, strong) UIImageView *headerView;
@property (nonatomic, strong) UILabel *headerTitleLabel;
@property (nonatomic, strong) UIView *coverView;
@property (nonatomic, strong) UIButton *addItemBtn;
@property (nonatomic, strong) UILabel *placeHolderLabel;
@property (nonatomic, strong) NSMutableArray<NSMutableArray *> *dataArray;
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSMutableArray<JNItemModel *> *> *dataSourceDict;
@property (nonatomic, strong) NSArray *sectionArray;
@end

@implementation JNToDoListViewController {

}
- (void)viewDidLoad {

    [super viewDidLoad];
    self.view.backgroundColor = RGB(240, 240, 240);
    self.automaticallyAdjustsScrollViewInsets = NO;

    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(kTopAndBottomMargin);
        make.left.equalTo(self.view.mas_left).offset(kLeftAndRightMargin);
        make.right.equalTo(self.view.mas_right).offset(-kLeftAndRightMargin);
        make.bottom.equalTo(self.view.mas_bottom).offset(-kTopAndBottomMargin);
    }];
    [self.tableView addSubview:self.placeHolderLabel];
    [self.placeHolderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.tableView.mas_centerX);
        make.centerY.equalTo(self.tableView.mas_centerY);
    }];

    UIView *coverView = [UIView new];
    coverView.userInteractionEnabled = NO;
    self.coverView = coverView;
    coverView.backgroundColor = [UIColor whiteColor];
    coverView.frame = CGRectMake(0, kTableViewHeaderViewHeight, SCREEN_WIDTH - kLeftAndRightMargin * 2, SCREEN_HEIGHT - kTopAndBottomMargin * 2 - kTableViewHeaderViewHeight);
    [self.tableView addSubview:coverView];

    [self.tableView registerClass:[JNToDoItemCell class] forCellReuseIdentifier:kToDoListCellReuseId];

    [self.view addSubview:self.addItemBtn];
    [self.addItemBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(50);
        make.bottom.equalTo(self.view.mas_bottom).offset(-10);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    self.addItemBtn.transform = CGAffineTransformMakeTranslation(0, 100);

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // 添加遮罩展开动画
    [self.tableView bringSubviewToFront:self.coverView];

    [self viewShowanimation];
}

#pragma mark - Private Method

/*界面显示时候的动画*/
- (void) viewShowanimation {

    // 添加按钮动画
    [UIView animateWithDuration:kViewShowAnimationDuration animations:^{
        self.addItemBtn.transform = CGAffineTransformIdentity;
    }];

    // tableView 遮罩动画
    CGFloat centerX = (SCREEN_WIDTH - kLeftAndRightMargin * 2) / 2;
    CGFloat centerY = (SCREEN_HEIGHT - kTopAndBottomMargin * 2 - kTableViewHeaderViewHeight) / 2;

    CGRect endRect = CGRectMake(centerX, centerY, 0, 0);
    UIBezierPath *startPath = [UIBezierPath bezierPathWithRect:self.coverView.bounds];
    UIBezierPath *endPath = [UIBezierPath bezierPathWithOvalInRect:endRect];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = startPath.CGPath;
    maskLayer.fillColor = [UIColor redColor].CGColor;
    self.coverView.layer.mask = maskLayer;

    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];
    animation.fromValue = (__bridge id) startPath.CGPath;
    animation.toValue = (__bridge id) endPath.CGPath;
    animation.duration = 0.45;
    animation.beginTime = CACurrentMediaTime();
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    [maskLayer addAnimation:animation forKey:nil];
}

/*界面退出时的动画*/
- (void) viewDismissAnimation {

    // 添加按钮动画
    [UIView animateWithDuration:kViewShowAnimationDuration animations:^{
        self.addItemBtn.transform = CGAffineTransformMakeTranslation(0, 100);
    }];

    // tableView 遮罩动画
    CGFloat centerX = (SCREEN_WIDTH - kLeftAndRightMargin * 2) / 2;
    CGFloat centerY = (SCREEN_HEIGHT - kTopAndBottomMargin * 2 - kTableViewHeaderViewHeight) / 2;

    CGRect startRect = CGRectMake(centerX, centerY, 0, 0);
    UIBezierPath *endPath = [UIBezierPath bezierPathWithRect:self.coverView.bounds];
    UIBezierPath *startPath = [UIBezierPath bezierPathWithOvalInRect:startRect];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = startPath.CGPath;
    maskLayer.fillColor = [UIColor redColor].CGColor;
    self.coverView.layer.mask = maskLayer;

    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];
    animation.delegate = self;
    animation.fromValue = (__bridge id) startPath.CGPath;
    animation.toValue = (__bridge id) endPath.CGPath;
    animation.duration = 0.45;
    animation.beginTime = CACurrentMediaTime();
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    [maskLayer addAnimation:animation forKey:nil];
}

#pragma mark - Event Response

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    [super touchesBegan:touches withEvent:event];

    /*
    [JNWarmTipsPublicFile showTabbar:(UITabBarController *)[UIApplication sharedApplication].delegate.window.rootViewController];
    [self viewDismissAnimation];
    */
    [self viewDismissAnimation];
//    [self.navigationController popViewControllerAnimated:YES];
}

- (void) addItem {
    /*
    JNEventEditorViewController *editorViewController = [[JNEventEditorViewController alloc] init];
    editorViewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    editorViewController.editFinishBlock = ^(NSString *text) {
        // 插入数据库

        // 刷新当前视图
        JNItemModel *itemModel = [JNItemModel new];
        itemModel.content = text;
        itemModel.finished = NO;
        itemModel.startTime = 0;
        itemModel.endTime = 0;
        itemModel.notification = NO;
        itemModel.groupId = [self.groupModel.groupId integerValue];

        [[JNDBManager shareInstance] addItem:itemModel];

        self.sectionArray = nil;
        self.dataArray = nil;
        [self.tableView reloadData];

        // 回调更新group页面
        if (self.updateItemInGorup) {
            self.updateItemInGorup(text);
        }
    };
    [self presentViewController:editorViewController animated:YES completion:nil];
    */
    JNAddListItemViewController *addListItemViewController = [[JNAddListItemViewController alloc] init];
    addListItemViewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self presentViewController:addListItemViewController animated:NO completion:nil];
}

#pragma mark - Delegate & DataSource

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
//    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray *itemArray = self.dataArray[indexPath.section];
    JNItemModel *itemModel = itemArray[indexPath.row];

    JNToDoItemCell *cell = [tableView dequeueReusableCellWithIdentifier:kToDoListCellReuseId];
    [cell reloadCellWithTitle:itemModel.content taskFinishStatus:itemModel.finished];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    JNToDoItemCell *cell = [tableView cellForRowAtIndexPath:indexPath];

    NSArray *itemArray = self.dataArray[indexPath.section];
    JNItemModel *itemModel = itemArray[indexPath.row];
    itemModel.finished = !itemModel.finished;
    [[JNDBManager shareInstance] updateFinishStatus:itemModel.finished withItemId:itemModel.itemId];

    [cell refreshTaskStatus: itemModel.finished];

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sectionArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    /*
    NSArray *items = self.dataArray[section];
    return items.count;
     */
    NSDictionary *dict = self.sectionArray[section];
    NSMutableArray *itemArray = [self.dataSourceDict valueForKey:dict[@"categoryName"]];
    return itemArray.count;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSDictionary *dict = self.sectionArray[section];
    NSString *sectionTitle = [dict valueForKey:@"categoryName"];

    UIView *sectionView = [UIView new];
    sectionView.backgroundColor = [UIColor whiteColor];
    UILabel *sectionTitleLabel = [UILabel new];
    sectionTitleLabel.text = sectionTitle;
    sectionTitleLabel.textColor = GRAY_TEXT_COLOR;
    sectionTitleLabel.font = [UIFont systemFontOfSize:15.0];
    sectionTitleLabel.frame = CGRectMake(20, 0, SCREEN_WIDTH, kToDoListSectionHeaderViewHeight);
    [sectionView addSubview:sectionTitleLabel];
    return sectionView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kToDoListSectionHeaderViewHeight;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        NSMutableArray *array = self.dataArray[indexPath.section];
        JNItemModel *itemModel = array[indexPath.row];
        [[JNDBManager shareInstance] deleteItem:itemModel.itemId];

        [array removeObject:itemModel];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];

        BOOL hidden = NO;
        for (NSArray *items in self.dataArray) {
            if (items.count != 0) {
                hidden = YES;
                break;
            }
        }
        self.placeHolderLabel.hidden = hidden;
    }];
    return @[action];
}

#pragma mark - Getter & Setter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;

        _tableView.layer.cornerRadius = 8;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.tableHeaderView = self.headerView;
    }
    return _tableView;
}

- (UIImageView *)headerView {
    if (!_headerView) {
        _headerView = [UIImageView  new];
        _headerView.contentMode = UIViewContentModeScaleAspectFill;
        _headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH-kLeftAndRightMargin*2, kTableViewHeaderViewHeight);
        _headerView.image = self.headerImage;

        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_headerView.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(8, 8)];
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
        _headerTitleLabel.text = self.groupModel.groupName;
    }
    return _headerTitleLabel;
}

- (UIButton *)addItemBtn {
    if (!_addItemBtn) {
        _addItemBtn = [[UIButton alloc] init];
        [_addItemBtn setBackgroundImage:[UIImage imageNamed:@"publish_btn"] forState:UIControlStateNormal];
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addItem)];
        [_addItemBtn addGestureRecognizer:tapGestureRecognizer];
    }
    return _addItemBtn;
}

- (UILabel *)placeHolderLabel {
    if (!_placeHolderLabel) {
        _placeHolderLabel = [UILabel new];
        _placeHolderLabel.text = @"这里空空如也..";
        _placeHolderLabel.textColor = GRAY_TEXT_COLOR;
        _placeHolderLabel.font = [UIFont fontWithName:FONT_NAME_SHOUZHA size:18.0];
    }
    return _placeHolderLabel;
}

/*
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
        for (NSDictionary *dict in self.sectionArray) {
            NSString *showDate = dict[@"name"];
            NSMutableArray *array = [NSMutableArray arrayWithArray:[[JNDBManager shareInstance] getAllItemsByShowDate:showDate WithGroupId:self.groupModel.groupId]];
            [_dataArray addObject:array];
        }
    }
    return _dataArray;
}
*/
- (NSArray *)sectionArray {
    if (!_sectionArray) {
//        _sectionArray = [[JNDBManager shareInstance] getAllDateSectionInGroup:self.groupModel.groupId];
        _sectionArray = [[JNDBManager shareInstance] getAllSectionsInGroup:self.groupModel.groupId];
        self.placeHolderLabel.hidden = _sectionArray.count != 0;
    }
    return _sectionArray;
}

- (NSMutableDictionary<NSString *, NSMutableArray<JNItemModel *> *> *)dataSourceDict {
    if (!_dataSourceDict) {
        _dataSourceDict = [[JNDBManager shareInstance] getAllItemsInGroup:self.groupModel.groupId];
    }
    return _dataSourceDict;
}
@end
