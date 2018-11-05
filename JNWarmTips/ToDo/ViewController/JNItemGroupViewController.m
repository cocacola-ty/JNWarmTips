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

@interface JNItemGroupViewController() <UICollectionViewDelegate, UICollectionViewDataSource, UIGestureRecognizerDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UIView *alertView;
@property (nonatomic, strong) UITextField *groupNameField;

@property (nonatomic, strong) NSMutableArray<JNGroupModel *> *groups;

@property (nonatomic, assign) BOOL waitDeleting;
@property (nonatomic, strong) NSOperationQueue *operationQueue;
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

#pragma mark - Event Response

- (void) terminateAddGroup {
    
    [self.alertView endEditing:YES];
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.25 animations:^{
            self.alertView.alpha = 0;
        } completion:^(BOOL finished) {
            [self.alertView removeFromSuperview];
            self.alertView = nil;
        }];
    });
}

- (void) addGroup {
    if (self.groupNameField.text) {
        JNGroupModel *groupModel = [JNGroupModel new];
        groupModel.groupName = self.groupNameField.text;
        [[JNDBManager shareInstance] addGroup:groupModel];

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t) (0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self terminateAddGroup];

            [JNAlertAssistant alertDoneMessage:@"添加成功"];
            self.groups = nil;
            [self.collectionView reloadData];
        });
    } else {
        [JNAlertAssistant alertWarningInfo:@"小组名不能为空"];
    }
}

- (void) longPressAction {
    self.waitDeleting = YES;
    
    NSArray *cellArray = [self.collectionView visibleCells];
    for (UICollectionViewCell *cell in cellArray) {
        if ([cell isKindOfClass:[JNItemGroupCell class]]) {
            [((JNItemGroupCell *)cell) startShake];
        }
    }
}

- (void) tapAction {
    
    self.waitDeleting = NO;
    NSArray *cellArray = [self.collectionView visibleCells];
    for (UICollectionViewCell *cell in cellArray) {
        if ([cell isKindOfClass:[JNItemGroupCell class]]) {
            [((JNItemGroupCell *)cell) stopShake];
        }
    }
}

- (void) showAddGroupView {
    // 正在显示 不重复添加
    if (self.alertView) {
        return;
    }
    UIView *alertView = [UIView new];
    self.alertView = alertView;
    alertView.layer.cornerRadius = 8;
    alertView.backgroundColor = GRAY_BACKGROUND_COLOR;
    [self.view addSubview:alertView];
    [alertView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY).offset(-60);
        CGFloat  width = SCREEN_WIDTH * 0.7;
        CGFloat height = width * 0.6;
        make.width.mas_equalTo(width);
        make.height.mas_equalTo(height);
    }];

    UIImageView *iconImageView = [UIImageView new];
    iconImageView.image = [UIImage imageNamed:@"group_icon"];
    [alertView addSubview:iconImageView];
    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(32);
        make.centerX.equalTo(alertView.mas_centerX);
        make.centerY.equalTo(alertView.mas_top);
    }];

    UITextField *groupNameField = [UITextField new];
    self.groupNameField = groupNameField;
    groupNameField.backgroundColor = [UIColor whiteColor];
    groupNameField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 0)];
    groupNameField.leftViewMode = UITextFieldViewModeAlways;
    [groupNameField becomeFirstResponder];
    groupNameField.placeholder = @"请输入小组名";
    groupNameField.layer.cornerRadius = 6;
    groupNameField.font = [UIFont systemFontOfSize:14.0];
    [alertView addSubview:groupNameField];
    [groupNameField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(alertView.mas_centerX);
        make.centerY.equalTo(alertView.mas_centerY);
        make.height.mas_equalTo(30);
        make.left.mas_equalTo(alertView.mas_left).offset(30);
        make.right.mas_equalTo(alertView.mas_right).offset(-30);
    }];

    UIButton *addGroupBtn = [UIButton new];
    addGroupBtn.backgroundColor = MAIN_COLOR;
    [addGroupBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addGroupBtn setTitle:@"完成" forState:UIControlStateNormal];
    addGroupBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [addGroupBtn addTarget:self action:@selector(addGroup) forControlEvents:UIControlEventTouchUpInside];
    addGroupBtn.layer.cornerRadius = 15;
    [alertView addSubview:addGroupBtn];
    [addGroupBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(alertView.mas_centerX);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(120);
        make.bottom.equalTo(alertView.mas_bottom).offset(-10);
    }];

    UIButton *terminateAddGroup = [UIButton new ];
    [terminateAddGroup setImage:[UIImage imageNamed:@"error"] forState:UIControlStateNormal];
    [terminateAddGroup addTarget:self action:@selector(terminateAddGroup) forControlEvents:UIControlEventTouchUpInside];
    [alertView addSubview:terminateAddGroup];
    [terminateAddGroup mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(18);
        make.top.equalTo(alertView.mas_top).offset(12);
        make.right.equalTo(alertView.mas_right).offset(-12);
    }];

    UILabel *titleLabel = [UILabel new];
    [alertView addSubview:titleLabel];
    titleLabel.font = [UIFont boldSystemFontOfSize:14.0];
    titleLabel.textColor = MAIN_COLOR;
    titleLabel.text = @"添加小组";
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(alertView.mas_centerX);
        make.top.equalTo(iconImageView.mas_bottom).offset(12);
    }];

    alertView.transform = CGAffineTransformMakeScale(0, 1);
    alertView.alpha = 0;

    [UIView animateWithDuration:0.25 animations:^{
        alertView.transform = CGAffineTransformIdentity;
        alertView.alpha = 1;
    }];

}

#pragma mark - Delegate & DataSource

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.groups.count) {
        JNAddGroupCollectionViewCell *addGroupCollectionViewCell = [collectionView dequeueReusableCellWithReuseIdentifier:kAddGroupCollectionViewCellId forIndexPath:indexPath];
        @weakify(self)
        addGroupCollectionViewCell.clickActionBlock = ^() {
            @strongify(self)
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showAddGroupView];
            });
        };
        return addGroupCollectionViewCell;
    }

    JNItemGroupCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kGroupCollectionCellID forIndexPath:indexPath];
    
    if (cell) {
        [cell.imageTask cancel];
    }
    
    JNGroupModel *groupModel = self.groups[indexPath.row];
    cell.groupModel = groupModel;

    int index = indexPath.row % 8 + 1;
    NSString *imgName = [NSString stringWithFormat:@"group_bg%d.jpg", index];
    
    __weak JNItemGroupCell * weakCell = cell;
    __weak UICollectionView *weakCollectionView = collectionView;
    @weakify(self)
    cell.imageTask = [NSBlockOperation blockOperationWithBlock:^{
        
        NSLog(@"%@", [NSThread currentThread]);

        NSString *path = [[NSBundle mainBundle] pathForResource:imgName ofType:nil];
        UIImage *sourceImg = [UIImage imageWithContentsOfFile:path];
        
        CGImageRef sourceImage = sourceImg.CGImage;
        
        size_t bits = CGImageGetBitsPerComponent(sourceImage);
        size_t bytesPerRow = CGImageGetBytesPerRow(sourceImage);
        CGColorSpaceRef spaceRef = CGImageGetColorSpace(sourceImage);
        uint32_t bitmapInfo = CGImageGetBitmapInfo(sourceImage);
        
        CGContextRef ctx = CGBitmapContextCreate(NULL, 270, 280, bits, bytesPerRow, spaceRef, bitmapInfo);
        CGContextFillRect(ctx, CGRectMake(0, 0, 270, 280));
        CGContextDrawImage(ctx, CGRectMake(0, 0, 270, 280), sourceImage);
        
        CGImageRef desImage = CGBitmapContextCreateImage(ctx);
        
        // 裁剪图片
        UIBezierPath *cornerPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 270, 280) byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(8, 8)];
        UIGraphicsBeginImageContext(CGSizeMake(270, 280));
        CGContextRef imgCtx = UIGraphicsGetCurrentContext();
        CGContextAddPath(imgCtx, cornerPath.CGPath);
        CGContextClip(imgCtx);
        CGContextDrawPath(imgCtx, kCGPathFillStroke);
        CGContextDrawImage(imgCtx, CGRectMake(0, 0, 270, 280), desImage);
        UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
        
        weakCell.image = img;
        
        CGImageRelease(desImage);
        CGContextRelease(ctx);
        CGColorSpaceRelease(spaceRef);
    }];
    
    cell.deleteBlock = ^{
        @strongify(self)
        // 数据库中进行删除
        
        // 移除cell
        [self.groups removeObjectAtIndex:indexPath.row];
        [weakCollectionView deleteItemsAtIndexPaths:@[indexPath]];
    };
    
    [self.operationQueue addOperation:cell.imageTask];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell isKindOfClass:[JNItemGroupCell class]]) {
        if (self.waitDeleting) {
            [((JNItemGroupCell *)cell) startShake];
        }else {
            [((JNItemGroupCell *)cell) stopShake];
        }
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.groups.count + 1;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.row == self.groups.count) {
        return;
    }

    JNGroupModel *groupModel = self.groups[indexPath.row];
    JNToDoListViewController *toDoListViewController = [[JNToDoListViewController alloc] init];
    toDoListViewController.groupModel = groupModel;

    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:toDoListViewController animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isKindOfClass:[UIButton class]]) {
        return NO;
    }
    return self.waitDeleting;
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
        
        UILongPressGestureRecognizer *longPressGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction)];
        longPressGes.minimumPressDuration = 1.5;
        [_collectionView addGestureRecognizer:longPressGes];
        
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        tapGes.delegate = self;
        [_collectionView addGestureRecognizer:tapGes];
    }
    return _collectionView;
}

- (NSMutableArray<JNGroupModel *> *)groups {
    if (!_groups) {
        _groups = [NSMutableArray arrayWithArray:[[JNDBManager shareInstance] getAllGroups]] ;
    }
    return _groups;
}

- (NSOperationQueue *)operationQueue {
    if (!_operationQueue) {
        _operationQueue = [[NSOperationQueue alloc] init];
        _operationQueue.maxConcurrentOperationCount = 5;
    }
    return _operationQueue;
}
@end
