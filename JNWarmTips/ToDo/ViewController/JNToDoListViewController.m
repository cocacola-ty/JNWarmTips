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
#import "UIColor+Extension.h"


static const int kToDoListSectionHeaderViewHeight = 60;

static NSString *const kToDoListCellReuseId = @"kToDoListCellReuseId";

static const int kTableViewHeaderViewHeight = 150;

static const int kLeftAndRightMargin = 0;

static const int kTopAndBottomMargin = 0;

static const double kViewShowAnimationDuration = 0.35;

static const int kAddCategoryBtnHeight = 18;

static const int kBackBtnWH = 20;

static const int kAddCategoryViewWidth = 220;

static const int kAddCategoryViewHeight = 140;

@interface JNToDoListViewController() <UITableViewDelegate, UITableViewDataSource, CAAnimationDelegate>
@property (nonatomic, strong) UIImageView *headerView;
@property (nonatomic, strong) UILabel *headerTitleLabel;
@property (nonatomic, strong) UIView *coverView;
@property (nonatomic, strong) UIButton *addItemBtn;
@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UIButton *addCategoryBtn;
@property (nonatomic, strong) UILabel *placeHolderLabel;
@property (nonatomic, strong) UIView *addCategoryView;

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

    [self.headerView addSubview:self.addCategoryBtn];
    [self.addCategoryBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(kAddCategoryBtnHeight);
        make.top.equalTo(self.headerView.mas_top).offset(28);
        make.right.equalTo(self.headerView.mas_right).offset(-12);
    }];
    [self.headerView addSubview:self.backBtn];
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(kBackBtnWH);
        make.centerY.equalTo(self.addCategoryBtn.mas_centerY);
        make.left.equalTo(self.headerView.mas_left).offset(12);
    }];
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

    [self viewDismissAnimation];
}

- (void) addItem {
    JNAddListItemViewController *addListItemViewController = [[JNAddListItemViewController alloc] init];
    addListItemViewController.groupId = [self.groupModel.groupId longLongValue];
    addListItemViewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self presentViewController:addListItemViewController animated:NO completion:nil];
}

- (void) backAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) addCategoryAction {
    [self.view addSubview:self.addCategoryView];
    [self.addCategoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY);
        make.width.mas_equalTo(kAddCategoryViewWidth);
        make.height.mas_equalTo(kAddCategoryViewHeight);
    }];

    self.addCategoryView.transform = CGAffineTransformMakeScale(0, 0);
    [UIView animateWithDuration:0.25 animations:^{
        self.addCategoryView.transform = CGAffineTransformIdentity;
    }];

}

#pragma mark - Delegate & DataSource

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    [self.navigationController popViewControllerAnimated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *categoryDict = self.sectionArray[indexPath.section];
    NSArray *list = [self.dataSourceDict valueForKey:categoryDict[@"categoryName"]];
    JNItemModel *itemModel = list[indexPath.row];

    JNToDoItemCell *cell = [tableView dequeueReusableCellWithIdentifier:kToDoListCellReuseId];
    [cell reloadCellWithTitle:itemModel.content taskFinishStatus:itemModel.finished];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    JNToDoItemCell *cell = [tableView cellForRowAtIndexPath:indexPath];

    NSDictionary *categoryDict = self.sectionArray[indexPath.section];
    NSArray *list = [self.dataSourceDict valueForKey:categoryDict[@"categoryName"]];
    JNItemModel *itemModel = list[indexPath.row];
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
        NSDictionary *categoryDict = self.sectionArray[indexPath.section];
        NSMutableArray *list = [self.dataSourceDict valueForKey:categoryDict[@"categoryName"]];
        JNItemModel *itemModel = list[indexPath.row];
        [[JNDBManager shareInstance] deleteItem:itemModel.itemId];

        [list removeObject:itemModel];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];

        BOOL hidden = NO;
        for (NSArray *items in list) {
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

//        _tableView.layer.cornerRadius = 8;
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.tableHeaderView = self.headerView;
    }
    return _tableView;
}

- (UIImageView *)headerView {
    if (!_headerView) {
        _headerView = [UIImageView  new];
        _headerView.contentMode = UIViewContentModeScaleAspectFill;
        _headerView.layer.masksToBounds = YES;
        _headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, kTableViewHeaderViewHeight);
        _headerView.image = [UIImage imageNamed:@"group_bg5.jpg"];
        _headerView.userInteractionEnabled = YES;

        UIBezierPath *bezierPath = [UIBezierPath bezierPath];
        [bezierPath moveToPoint:CGPointMake(0, 0)];
        [bezierPath addLineToPoint:CGPointMake(0, kTableViewHeaderViewHeight - 25)];
        [bezierPath addQuadCurveToPoint:CGPointMake(SCREEN_WIDTH, kTableViewHeaderViewHeight - 25) controlPoint:CGPointMake(SCREEN_WIDTH / 2, kTableViewHeaderViewHeight+10)];
        [bezierPath addLineToPoint:CGPointMake(SCREEN_WIDTH, 0)];
        [bezierPath closePath];

        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.path = bezierPath.CGPath;
        shapeLayer.fillColor = [UIColor redColor].CGColor;

        _headerView.layer.mask = shapeLayer;
        /*
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_headerView.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(8, 8)];
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.path = maskPath.CGPath;
        maskLayer.frame = _headerView.bounds;
        _headerView.layer.mask = maskLayer;
         */

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
        _headerTitleLabel.font = [UIFont systemFontOfSize:24.0];
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

- (UIButton *)addCategoryBtn {
    if (!_addCategoryBtn) {
        _addCategoryBtn = [UIButton new];
        [_addCategoryBtn addTarget:self action:@selector(addCategoryAction) forControlEvents:UIControlEventTouchUpInside];

        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(0, kAddCategoryBtnHeight / 2)];
        [path addLineToPoint:CGPointMake(kAddCategoryBtnHeight, kAddCategoryBtnHeight / 2)];
        [path moveToPoint:CGPointMake(kAddCategoryBtnHeight / 2, 0)];
        [path addLineToPoint:CGPointMake(kAddCategoryBtnHeight / 2, kAddCategoryBtnHeight)];

        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.frame = CGRectMake(0, 0, kAddCategoryBtnHeight, kAddCategoryBtnHeight);
        layer.path = path.CGPath;
        layer.strokeColor = [UIColor colorWithHexString:@"222222"].CGColor;
        layer.strokeColor = MAIN_COLOR.CGColor;
        layer.fillColor = [UIColor clearColor].CGColor;
        layer.lineWidth = 2;
        [_addCategoryBtn.layer addSublayer:layer];
    }
    return _addCategoryBtn;
}

- (UIView *)addCategoryView {
    if (!_addCategoryView) {
        _addCategoryView = [UIView new];
        _addCategoryView.backgroundColor = [UIColor redColor];
        _addCategoryView.layer.cornerRadius = 5;

        UILabel *titleLabel = [UILabel new];
        [_addCategoryView addSubview:titleLabel];

        UITextField *categoryInputField = [[UITextField alloc] init];
        [_addCategoryView addSubview:categoryInputField];

        UIButton *cancleBtn = [UIButton new];
        [_addCategoryView addSubview:cancleBtn];

        UIButton *doneBtn = [UIButton new];
        [_addCategoryView addSubview:doneBtn];
    }
    return _addCategoryView;
}

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton new];
        UIImage *image = [[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [_backBtn setImage:image forState:UIControlStateNormal];
        _backBtn.tintColor = MAIN_COLOR;

        [_backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
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

- (NSArray *)sectionArray {
    if (!_sectionArray) {
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
