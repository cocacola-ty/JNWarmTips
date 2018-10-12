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

@end

@implementation JNEventTimeLineTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.circleView.layer.cornerRadius = 10;
    self.circleView.layer.borderColor = MAIN_COLOR.CGColor;
    self.circleView.layer.borderWidth = 3;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
