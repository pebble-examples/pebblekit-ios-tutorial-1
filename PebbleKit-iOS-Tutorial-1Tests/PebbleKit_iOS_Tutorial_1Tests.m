//
//  PebbleKit_iOS_Tutorial_1Tests.m
//  PebbleKit-iOS-Tutorial-1Tests
//
//  Created by Chris Lewis on 11/25/14.
//  Copyright (c) 2014 Pebble. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

@interface PebbleKit_iOS_Tutorial_1Tests : XCTestCase

@end

@implementation PebbleKit_iOS_Tutorial_1Tests

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
    XCTAssert(YES, @"Pass");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
