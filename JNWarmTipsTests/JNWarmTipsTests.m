//
//  JNWarmTipsTests.m
//  JNWarmTipsTests
//
//  Created by fengtianyu on 23/4/18.
//  Copyright © 2018年 fengtianyu. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface JNWarmTipsTests : XCTestCase

@end

@implementation JNWarmTipsTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    NSString *eventStr = [NSString stringWithFormat:@"15:17-今天没啥事"];
    NSRange range = [eventStr rangeOfString:@"-"];
    NSLog(@"%lu, %lu",(unsigned long)range.location, (unsigned long)range.length);
    NSString *subString = [eventStr substringToIndex:range.location];
    NSString *subString2 = [eventStr substringFromIndex:range.location];
    NSLog(@"subString = %@", subString);
    NSLog(@"subString2 = %@", subString2);

    NSString *testStr2 = @"14-今天没啥-事";
    NSRange range2 = [testStr2 rangeOfString:@"-"];
    NSLog(@"range2.location = %lu %lu", range2.location, range2.length);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
