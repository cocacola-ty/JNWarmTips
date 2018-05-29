//
// Created by fengtianyu on 2/5/18.
// Copyright (c) 2018 fengtianyu. All rights reserved.
//

#import "JNToDoGroupListViewController.h"
#import "View+MASAdditions.h"
#import "JNGroupListCell.h"
#import "JNWarmTipsPublicFile.h"
#import "JNToDoListViewController.h"
#import "JNDBManager.h"
#import "JNDBManager+Group.h"
#import "JNGroupModel.h"
#import "JNAddGroupAlertViewController.h"
#import "JNPresentTransitionAnimator.h"

static NSString *const kGroupListCellReuseId = @"JNGroupListCellReuseId";

@interface JNToDoGroupListViewController() <UITableViewDelegate, UITableViewDataSource, UIViewControllerTransitioningDelegate>
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) NSMutableArray *groups;
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

- (void) addTag {
    JNAddGroupAlertViewController *addGroupAlertViewController = [[JNAddGroupAlertViewController alloc] init];
    addGroupAlertViewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    addGroupAlertViewController.finishAddGroup = ^(JNGroupModel *groupModel) {
        [self.groups addObject:groupModel];
        [self.tableView reloadData];
    };
    [self presentViewController:addGroupAlertViewController animated:NO completion:nil];

}

#pragma mark - Delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JNGroupModel *groupModel = self.groups[indexPath.row];
    JNGroupListCell *cell = [tableView dequeueReusableCellWithIdentifier:kGroupListCellReuseId];
    [cell updateContentWithTitle:groupModel.groupName WithItemTitle:groupModel.firstItemContent WithItemCount:groupModel.itemCount];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.groups.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    /*隐藏tabbar */
    [JNWarmTipsPublicFile hiddenTabbar:self.tabBarController];

    JNGroupListCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    self.cellBackGroundImage = cell.backgroundImage;
    self.currentSelectIndexPath = indexPath;
    JNGroupModel *groupModel = self.groups[indexPath.row];

    JNToDoListViewController *toDoListViewController = [[JNToDoListViewController alloc] init];
    toDoListViewController.transitioningDelegate = self;
    toDoListViewController.groupModel = groupModel;
    toDoListViewController.headerImage = cell.backgroundImage;
    [self presentViewController:toDoListViewController animated:YES completion:nil];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.row != 0;
}

- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        JNGroupModel *groupModel = self.groups[indexPath.row];
        [[JNDBManager shareInstance] deleteGroup:groupModel];

        [self.groups removeObject:groupModel];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    }];
    return @[action];
}


- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return [[JNPresentTransitionAnimator alloc] initWithType:JNPresentTransitionTypePresent];
}


#pragma mark - Getter & Setter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = GRAY_BACKGROUND_COLOR;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 125;
        _tableView.rowHeight = UITableViewAutomaticDimension;

        _tableView.tableHeaderView = self.headerView;
    }
    return _tableView;
}

- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [UIView new];
        CGFloat height = 64 + 50;
        _headerView.bounds = CGRectMake(0, 0, SCREEN_WIDTH, height);
        _headerView.backgroundColor = GRAY_BACKGROUND_COLOR;

        CGFloat btnHeight = 18;
        UIButton *addTagBtn = [UIButton new];
        [addTagBtn addTarget:self action:@selector(addTag) forControlEvents:UIControlEventTouchUpInside];
        addTagBtn.backgroundColor = GRAY_BACKGROUND_COLOR;
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:addTagBtn.bounds];
        [path moveToPoint:CGPointMake(btnHeight/2, 0)];
        [path addLineToPoint:CGPointMake(btnHeight/2, btnHeight)];
        [path moveToPoint:CGPointMake(0, btnHeight/2)];
        [path addLineToPoint:CGPointMake(btnHeight, btnHeight/2)];

        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.path = path.CGPath;
        shapeLayer.frame = addTagBtn.bounds;
        shapeLayer.strokeColor = [UIColor blackColor].CGColor;
        shapeLayer.fillColor = [UIColor clearColor].CGColor;
        shapeLayer.lineWidth = 2;
        [addTagBtn.layer addSublayer:shapeLayer];

        [_headerView addSubview:addTagBtn];
        [addTagBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(btnHeight);
            make.right.equalTo(_headerView.mas_right).offset(-15);
            make.top.equalTo(_headerView.mas_top).offset(35);
        }];

    }
    return _headerView;
}

- (NSMutableArray<JNGroupModel *> *)groups {
    if (!_groups) {
        [_groups addObjectsFromArray:[[JNDBManager shareInstance] getAllGroups]];
        _groups = [NSMutableArray arrayWithArray:[[JNDBManager shareInstance] getAllGroups]];
    }
    return _groups;
}
@end