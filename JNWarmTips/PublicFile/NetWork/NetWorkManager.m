//
//  NetWorkManager.m
//  JNWarmTips
//
//  Created by fengtianyu on 4/12/2018.
//  Copyright © 2018 fengtianyu. All rights reserved.
//

#import "NetWorkManager.h"
#import "AFNetworking.h"
@interface NetWorkManager()
@property (nonatomic, strong) AFHTTPSessionManager *sessionManger;
@end

@implementation NetWorkManager

+ (instancetype)shareInstance {
    static NetWorkManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[NetWorkManager alloc] init];
    });
    return instance;
}

-(instancetype)init {
    self = [super init];
    if (self) {
        self.sessionManger.requestSerializer = [AFHTTPRequestSerializer serializer];
        self.sessionManger.responseSerializer = [AFJSONResponseSerializer serializer];
    }
    return self;
}

- (void)get {
    
}

#pragma mark - Getter

- (AFHTTPSessionManager *)sessionManger{
    if (!_sessionManger) {
        _sessionManger = [AFHTTPSessionManager manager];
    }
    return _sessionManger;
}
@end
