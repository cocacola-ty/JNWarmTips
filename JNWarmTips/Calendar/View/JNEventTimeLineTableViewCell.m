//
//  JNEventTimeLineTableViewCell.m
//  JNWarmTips
//
//  Created by fengtianyu on 12/10/2018.
//  Copyright © 2018 fengtianyu. All rights reserved.
//

#import "JNEventTimeLineTableViewCell.h"
#import "UIColor+Extension.h"
#import "JNWarmTipsPublicFile.h"

@interface JNEventTimeLineTableViewCell()
@property (weak, nonatomic) IBOutlet UIView *circleView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation JNEventTimeLineTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.circleView.layer.cornerRadius = 8;
    self.circleView.layer.borderColor = MAIN_COLOR.CGColor;
    self.circleView.layer.borderWidth = 2;
    
    self.timeLabel.text = @"2018/10/12 \n 10:32";
}

@end
