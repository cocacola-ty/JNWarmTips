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
        self.sessionManger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
        self.sessionManger.completionQueue = dispatch_get_global_queue(0, 0);
    }
    return self;
}

- (void)getWithUrl:(NSString *)url WithParams:(NSDictionary *)params success:(void(^)(id))success failure:(void(^)(NSError *))failure{
    
    [self.sessionManger GET:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
    
}

#pragma mark - Getter

- (AFHTTPSessionManager *)sessionManger{
    if (!_sessionManger) {
        _sessionManger = [AFHTTPSessionManager manager];
    }
    return _sessionManger;
}
@end
