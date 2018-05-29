//
// Created by fengtianyu on 20/4/18.
// Copyright (c) 2018 fengtianyu. All rights reserved.
//

#import "JNWarmTipsPublicFile.h"
#import <CoreText/CTFont.h>


@implementation JNWarmTipsPublicFile {
}

+ (NSString *)dateStringFormat:(NSInteger)year month:(NSInteger)month day:(NSInteger)day {
    if (day == nil) {
        return [NSString stringWithFormat:@"%d-%02d", year, month];
    }
    return [NSString stringWithFormat:@"%d-%02d-%02d", year, month, day];
}

+ (void) downFont:(NSString *)fontName {

    NSMutableDictionary *attrs = [NSMutableDictionary dictionaryWithObjectsAndKeys:fontName, kCTFontNameAttribute, nil];
    CTFontDescriptorRef desc = CTFontDescriptorCreateWithAttributes((__bridge CFDictionaryRef)attrs);
    NSMutableArray *descs = [NSMutableArray arrayWithCapacity:0];
    [descs addObject:(__bridge id)desc];
    CFRelease(desc);

    CTFontDescriptorMatchFontDescriptorsWithProgressHandler((__bridge CFArrayRef)descs, NULL, ^bool(CTFontDescriptorMatchingState state, CFDictionaryRef progressParameter) {
        double progressValue = [[(__bridge NSDictionary *)progressParameter objectForKey:(id)kCTFontDescriptorMatchingPercentage] doubleValue];
        // 字体已经匹配
        if (state == kCTFontDescriptorMatchingDidBegin) {
            NSLog(@"开始匹配");
        } else if (state == kCTFontDescriptorMatchingDidFinish) { // 下载完成
            [[NSNotificationCenter defaultCenter] postNotificationName:FONT_DOWNLOAD_NOTIFICATION object:nil];
            NSLog(@"匹配完成");
        } else if (state == kCTFontDescriptorMatchingWillBeginDownloading) { // 开始下载
        } else if (state == kCTFontDescriptorMatchingDownloading) { // 下载中
            NSLog(@"download....");
            NSLog(@"progressValue = %lf", progressValue);
        } else if (state == kCTFontDescriptorMatchingDidFinishDownloading) {
            NSLog(@"download done ");
        } else if (state == kCTFontDescriptorMatchingDidFailWithError) {
            NSError *error = [(__bridge NSDictionary *)progressParameter objectForKey:(id)kCTFontDescriptorMatchingError];
            NSLog(@"error.userInfo = %@", error.userInfo);
            NSLog(@"error");
        }

        return (bool)YES;
    });
}

+ (void) hiddenTabbar:(UITabBarController *)vc {
    [UIView animateWithDuration:0.25 animations:^{
        for(UIView *view in vc.view.subviews)
        {
            if([view isKindOfClass:[UITabBar class]])
            {
                [view setFrame:CGRectMake(view.frame.origin.x,
                        view.frame.origin.y + 50,
                        view.frame.size.width,
                        view.frame.size.height)];
            }
            else
            {
                [view setFrame:CGRectMake(view.frame.origin.x,
                        view.frame.origin.y,
                        view.frame.size.width,
                        view.frame.size.height + 50)];
            }
        }
    }];
}

+ (void) showTabbar:(UITabBarController *)vc {
    [UIView animateWithDuration:0.25 animations:^{
        for(UIView *view in vc.view.subviews)
        {
            if([view isKindOfClass:[UITabBar class]])
            {
                [view setFrame:CGRectMake(view.frame.origin.x,
                        view.frame.origin.y - 50,
                        view.frame.size.width,
                        view.frame.size.height)];
            }
            else
            {
                [view setFrame:CGRectMake(view.frame.origin.x,
                        view.frame.origin.y,
                        view.frame.size.width,
                        view.frame.size.height - 50)];
            }
        }
    }];
}
@end

const CGFloat CalendarDefaultMargin = 20;

NSString * const MOTIONEVENTNOTIFICATION = @"MOTIONEVENTNOTIFICATION";

NSString * const FONT_NAME_WAWA = @"DFWaWaSC-W5";

NSString * const FONT_NAME_SHOUZHA = @"HannotateSC-W5";

NSString * const FONT_NAME_YAPI = @"YuppySC-Regular";

NSString * const FONT_DOWNLOAD_NOTIFICATION = @"FONTDOWNLOADFINISHNOTIFICATION";
