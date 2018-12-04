//
//  NetWorkManager.h
//  JNWarmTips
//
//  Created by fengtianyu on 4/12/2018.
//  Copyright © 2018 fengtianyu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NetWorkManager : NSObject
+ (instancetype)shareInstance;

- (void)getWithUrl:(NSString *)url WithParams:(NSDictionary *)params success:(void(^)(id))success failure:(void(^)(NSError *))failure;
@end

NS_ASSUME_NONNULL_END
