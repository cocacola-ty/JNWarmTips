//
//  JNAddEventStyleOneViewController.m
//  JNWarmTips
//
//  Created by fengtianyu on 17/7/18.
//  Copyright © 2018年 fengtianyu. All rights reserved.
//

#import <Masonry/View+MASAdditions.h>
#import "JNAddEventStyleOneViewController.h"
#import "JNWarmTipsPublicFile.h"
#import "UIColor+Extension.h"
#import "JNDBManager.h"
#import "JNDBManager+Events.h"
#import "JNEventTypeModel.h"

static const int kTopImageViewHeight = 180;

static const int kStarImageViewWH = 40;

static const int kTagViewHeight = 80;

@interface JNAddEventStyleOneViewController ()
@property (nonatomic, strong) UIImageView *topImageView;
@property (nonatomic, strong) UIImageView *starImageView;

@property (nonatomic, strong) UIView *eventView;
@property (nonatomic, strong) UIView *timeView;
@property (nonatomic, strong) UIView *tagView;

@property (nonatomic, strong) NSArray *allTagModels;
@property (nonatomic, strong) UIButton *selectedTagBtn;
@property (nonatomic, strong) JNEventTypeModel *selectedTagModel;
@property (nonatomic, strong) NSMutableArray *allTagBtns;
@end

@implementation JNAddEventStyleOneViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    [self displaySubviews];
}

- (void) displaySubviews {
    [self.view addSubview:self.topImageView];
    [self.topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(kTopImageViewHeight);
    }];

    [self.view addSubview:self.starImageView];
    [self.starImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-30);
        make.centerY.equalTo(self.topImageView.mas_bottom);
        make.width.height.mas_equalTo(kStarImageViewWH);
    }];

    [self.view addSubview:self.eventView];
    [self.eventView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topImageView.mas_bottom).offset(60);
        make.left.equalTo(self.view.mas_left).offset(40);
        make.right.equalTo(self.view.mas_right).offset(-30);
        make.height.mas_equalTo(60);
    }];

    [self.view addSubview:self.tagView];
    [self.tagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.eventView.mas_bottom).offset(25);
        make.left.equalTo(self.eventView.mas_left);
        make.width.equalTo(self.eventView.mas_width);
        make.height.mas_equalTo(kTagViewHeight);
    }];

    [self.view addSubview:self.timeView];
    [self.timeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tagView.mas_bottom).offset(40);
        make.width.equalTo(self.eventView.mas_width);
        make.left.equalTo(self.eventView.mas_left);
        make.height.mas_equalTo(50);
    }];
//    self.timeView.alpha = 0;

    UIButton *doneBtn = [UIButton new];
    [doneBtn setTitle:@"ADD" forState:UIControlStateNormal];
    doneBtn.backgroundColor = MAIN_COLOR;
    doneBtn.backgroundColor = GRAY_BACKGROUND_COLOR;
    doneBtn.layer.cornerRadius = 4;
    [self.view addSubview:doneBtn];
    [doneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(40);
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.view.mas_bottom).offset(-30);
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
//    [self dismissViewControllerAnimated:YES completion:nil];
//    [self.tagView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_equalTo(50);
//    }];
//    [UIView animateWithDuration:0.35 animations:^{
//        self.timeView.alpha = 1;
//        [self.view layoutIfNeeded];
//        [self.view setNeedsUpdateConstraints];
//    }];
}

- (void) selectTag:(UIButton *)btn {

    self.selectedTagBtn.layer.borderColor = GRAY_BACKGROUND_COLOR.CGColor;
    self.selectedTagBtn.selected = NO;
    self.selectedTagBtn = btn;
    btn.selected = YES;

    NSInteger index = [self.allTagBtns indexOfObject:btn];
    JNEventTypeModel *typeModel = [self.allTagModels objectAtIndex:index];
    self.selectedTagModel = typeModel;
    btn.layer.borderColor = [UIColor colorWithHexString:typeModel.typeColor].CGColor;
    [self.starImageView setTintColor:[UIColor colorWithHexString:typeModel.typeColor]];
    self.starImageView.layer.borderColor = [UIColor colorWithHexString:typeModel.typeColor].CGColor;

}

#pragma mark - Getter & Setter

- (UIImageView *)topImageView {
    if (!_topImageView) {
        _topImageView = [UIImageView new];
        _topImageView.image = [UIImage imageNamed:@"group_bg2.jpg"];
    }
    return _topImageView;
}

- (UIImageView *)starImageView {
    if (!_starImageView) {
        _starImageView = [UIImageView new];
        _starImageView.image = [[UIImage imageNamed:@"type"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        _starImageView.tintColor = GRAY_BACKGROUND_COLOR;

        _starImageView.layer.cornerRadius = kStarImageViewWH / 2;
        _starImageView.layer.borderWidth = 1;
        _starImageView.layer.borderColor = GRAY_BACKGROUND_COLOR.CGColor;
    }
    return _starImageView;
}

- (UIView *)eventView {
    if (!_eventView) {
        _eventView = [UIView new];
        [self configCommonView:_eventView AndTitle:@"EVENT" WithImageName:@"event_list_full"];
        UITextField *inputField = [[UITextField alloc] init];
        inputField.placeholder = @"请输入内容";
        [_eventView addSubview:inputField];
        [inputField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self->_eventView.mas_left).offset(35);
            make.height.mas_equalTo(44);
            make.bottom.equalTo(self->_eventView.mas_bottom).offset(-1);
        }];
    }
    return _eventView;
}

- (UIView *)timeView {
    if (!_timeView) {
        _timeView = [UIView new];
        [self configCommonView:_timeView AndTitle:@"TIME" WithImageName:@"timer_highlight"];

        UILabel *timeLabel = [UILabel new];
        timeLabel.text = @"12:00";
        timeLabel.textColor = GRAY_TEXT_COLOR;
        [_timeView addSubview:timeLabel];
        [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self->_timeView.mas_centerY).offset(5);
            make.centerX.equalTo(self->_timeView.mas_centerX);
        }];

        // todo: 添加自定义开关视图
    }
    return _timeView;
}

- (UIView *)tagView {
    if (!_tagView) {
        _tagView = [UIView new];
        [self configCommonView:_tagView AndTitle:@"TAG" WithImageName:@"tag_full"];

        static CGFloat offset = 0;
        self.allTagBtns = [NSMutableArray array];
        for (JNEventTypeModel *model in self.allTagModels) {
            UIButton *tagBtn = [UIButton  new];
            tagBtn.font = [UIFont systemFontOfSize:14.0];
            tagBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
            [tagBtn setTitle:[model.typeName substringToIndex:1] forState:UIControlStateNormal];
            [tagBtn addTarget:self action:@selector(selectTag:) forControlEvents:UIControlEventTouchUpInside];

            [tagBtn setTitleColor:GRAY_TEXT_COLOR forState:UIControlStateNormal];
            [tagBtn setTitleColor:[UIColor colorWithHexString:model.typeColor] forState:UIControlStateSelected];

            tagBtn.layer.borderColor = GRAY_TEXT_COLOR.CGColor;
            tagBtn.layer.borderWidth = 1;
            [_tagView addSubview:tagBtn];
            [self.allTagBtns addObject:tagBtn];


            UILabel *nameLabel = [UILabel new];
            nameLabel.font = [UIFont systemFontOfSize:12.0];
            nameLabel.text = model.typeName;
            [_tagView addSubview:nameLabel];
            [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(_tagView.mas_bottom).offset(-6);
                make.left.equalTo(self->_tagView.mas_left).offset(35 + offset);
            }];

            CGRect rect = [model.typeName boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:nil attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15.0]} context:nil];
            [tagBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(nameLabel.mas_top).offset(-4);
                make.centerX.equalTo(nameLabel.mas_centerX);
                make.width.height.mas_equalTo(30);
            }];
            tagBtn.layer.cornerRadius = (rect.size.height + 4) / 2;
            tagBtn.layer.cornerRadius = 15;

            offset += 50;
        }
    }
    return _tagView;
}

- (void) configCommonView:(UIView *)superView AndTitle:(NSString *)title WithImageName:(NSString *)imageName{

    UILabel *titleLabel = [UILabel new];
    titleLabel.text = title;
    titleLabel.font = [UIFont boldSystemFontOfSize:13.0];
    titleLabel.textColor = [UIColor colorWithHexString:@"c8c8c8"];
    titleLabel.textColor = MAIN_COLOR;
    [superView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superView.mas_top);
        make.left.equalTo(superView.mas_left).offset(35);
    }];

    UIView *line = [UIView new];
    line.backgroundColor = GRAY_BACKGROUND_COLOR;
    line.backgroundColor = MAIN_COLOR;
    [superView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1);
        make.left.equalTo(superView.mas_left).offset(35);
        make.right.equalTo(superView.mas_right);
        make.bottom.equalTo(superView.mas_bottom);
    }];

    UIImageView *iconImageView = [UIImageView new];
    iconImageView.image = [UIImage imageNamed:imageName];
    [superView addSubview:iconImageView];
    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.mas_left);
        make.width.height.mas_equalTo(20);
        make.centerY.equalTo(superView.mas_centerY);
    }];
}

- (NSArray *)allTagModels {
    if (!_allTagModels) {
        _allTagModels = [[JNDBManager shareInstance] getAllEventTypes];
    }
    return _allTagModels;
}
@end
