//
// Created by fengtianyu on 18/8/18.
// Copyright (c) 2018 fengtianyu. All rights reserved.
//

#import <Masonry/View+MASAdditions.h>
#import "JNItemGroupViewController.h"
#import "JNItemGroupCell.h"
#import "JNWarmTipsPublicFile.h"

static NSString *const kGroupCollectionCellID= @"ItemGroupCellIdentity";

static const int kHMargin = 12;

@interface JNItemGroupViewController() <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation JNItemGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];

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
//    cell.backgroundColor = [UIColor orangeColor];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 10;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
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
@end