//
//  PersistenceLayerTests.m
//  PersistenceLayerTests
//
//  Created by kathy on 2017/4/8.
//  Copyright © 2017年 kathy. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PersistenceLayer.h"

@interface PersistenceLayerTests : XCTestCase

@end

@implementation PersistenceLayerTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

-(void)testPrint{
    PersistenceLayer *pl = [[PersistenceLayer alloc] init];
    XCTAssertEqualObjects(@"PersistenceLayer OK", pl.print);
}

-(void)testCreateTable{
    PersistenceLayer *pl = [[PersistenceLayer alloc] init];
    XCTAssertEqualObjects(@"1", pl.createTable);
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
