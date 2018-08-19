//
// Created by fengtianyu on 18/8/18.
// Copyright (c) 2018 fengtianyu. All rights reserved.
//

#import <Masonry/View+MASAdditions.h>
#import "JNItemGroupViewController.h"
#import "JNItemGroupCell.h"
#import "JNWarmTipsPublicFile.h"
#import "JNToDoListViewController.h"
#import "JNGroupModel.h"
#import "JNDBManager.h"
#import "JNDBManager+Group.h"

static NSString *const kGroupCollectionCellID= @"ItemGroupCellIdentity";

static const int kHMargin = 12;

@interface JNItemGroupViewController() <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray<JNGroupModel *> *groups;
@end

@implementation JNItemGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = YES;

    [self.collectionView registerClass:[JNItemGroupCell class] forCellWithReuseIdentifier:kGroupCollectionCellID];
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(5);
        make.left.equalTo(self.view.mas_left).offset(kHMargin);
        make.right.equalTo(self.view.mas_right).offset(-kHMargin);
        make.bottom.equalTo(self.view.mas_bottom);
    }];

}

#pragma mark - Delegate & DataSource

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JNItemGroupCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kGroupCollectionCellID forIndexPath:indexPath];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.groups.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    /*
    JNGroupListCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    self.cellBackGroundImage = cell.backgroundImage;
    self.currentSelectIndexPath = indexPath;
    JNGroupModel *groupModel = self.groups[indexPath.row];
    */
    
    @weakify(self)
    JNToDoListViewController *toDoListViewController = [[JNToDoListViewController alloc] init];
//    toDoListViewController.transitioningDelegate = self;
//    toDoListViewController.groupModel = groupModel;
//    toDoListViewController.headerImage = cell.backgroundImage;
    toDoListViewController.updateItemInGorup = ^(NSString *content) {
//        groupModel.firstItemContent = content;
//        [ws.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    };
    
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:toDoListViewController animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

#pragma mark - Geeter & Setter

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        CGFloat width = ceilf((SCREEN_WIDTH - kHMargin * 2) / 2) - 1;
        layout.itemSize = CGSizeMake(width, 220);
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0.1;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;

        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
    }
    return _collectionView;
}

- (NSMutableArray<JNGroupModel *> *)groups {
    if (!_groups) {
        _groups = [NSMutableArray arrayWithArray:[[JNDBManager shareInstance] getAllGroups]] ;
    }
    return _groups;
}
@end
