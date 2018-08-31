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
#import "JNAddGroupCollectionViewCell.h"
#import "JNAlertAssistant.h"

static NSString *const kGroupCollectionCellID= @"ItemGroupCellIdentity";

static const int kHMargin = 12;

static NSString *const kAddGroupCollectionViewCellId = @"JNAddGroupCollectionViewCell";

@interface JNItemGroupViewController() <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray<JNGroupModel *> *groups;
@end

@implementation JNItemGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = YES;

    [self.collectionView registerClass:[JNItemGroupCell class] forCellWithReuseIdentifier:kGroupCollectionCellID];
    [self.collectionView registerClass:[JNAddGroupCollectionViewCell class] forCellWithReuseIdentifier:kAddGroupCollectionViewCellId];
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
    if (indexPath.row == self.groups.count) {
        JNAddGroupCollectionViewCell *addGroupCollectionViewCell = [collectionView dequeueReusableCellWithReuseIdentifier:kAddGroupCollectionViewCellId forIndexPath:indexPath];
        @weakify(self)
        addGroupCollectionViewCell.clickActionBlock = ^() {
            @strongify(self)
            /*
            UIView *alertView = [UIView new];
            alertView.layer.cornerRadius = 8;
            alertView.backgroundColor = RANDOM_COLOR;
            [self.view addSubview:alertView];
            [alertView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.view.mas_centerX);
                make.centerY.equalTo(self.view.mas_centerY).offset(-60);
                CGFloat  width = SCREEN_WIDTH * 0.7;
                CGFloat height = width * 0.6;
                make.width.mas_equalTo(width);
                make.height.mas_equalTo(height);
            }];

            alertView.transform = CGAffineTransformMakeScale(0, 0);
            alertView.alpha = 0;

            [UIView animateWithDuration:0.25 animations:^{
                alertView.transform = CGAffineTransformIdentity;
                alertView.alpha = 1;
            }];

            */
            [JNAlertAssistant alertMessage:@"保存成功" WithType:1];

        };
        return addGroupCollectionViewCell;
    }
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.groups.count + 1;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    JNGroupModel *groupModel = self.groups[indexPath.row];
    JNToDoListViewController *toDoListViewController = [[JNToDoListViewController alloc] init];
    toDoListViewController.groupModel = groupModel;

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
