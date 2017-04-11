//
//  PersistenceLayerTests.m
//  PersistenceLayerTests
//
//  Created by kathy on 2017/4/8.
//  Copyright © 2017年 kathy. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PersistenceLayer.h"
#import "AgeTableDAO.h"
#import "AgeTable.h"
#import "PersionInfoDAO.h"
#import "PersionInfo.h"
#import "AgeRange.h"
#import "AgeRangeDAO.h"
#import "ECGData.h"
#import "ECGDatesDAO.h"

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

-(void)testPersistenceLayer{
    PersistenceLayer *pl = [[PersistenceLayer alloc] init];
    XCTAssertEqualObjects(@"1", pl.createTable);
}

-(void)testAll{
    [self tECGDates];
    [self tPersionInfo];
    [self tAgeRange];
    [self tAgeTable];
}

-(void)tECGDates{
    NSLog(@"1");
    NSString *tableName = @"xx";
    ECGDatesDAO *ECGDates = [ECGDatesDAO sharedManager];
    XCTAssertEqual(1, [ECGDates createTable:tableName]);
    
    ECGData *model = [[ECGData alloc] init];
    model.createDateTime = @"2011-01-16 21:22:12";
    model.data = @"111";
    ECGData *model1 = [[ECGData alloc] init];
    model1.createDateTime = @"2011-01-15 21:21:12";
    model1.data = @"112";
    XCTAssertEqual(1, [ECGDates insertData:model andtableName:tableName]);
    XCTAssertEqual(1, [ECGDates insertData:model1 andtableName:tableName]);
    NSMutableArray *listData = [ECGDates findNewDate:tableName];
    XCTAssertNotNil(listData);
    ECGData *aData = [listData objectAtIndex:1];
    XCTAssertEqualObjects(@"2011-01-15 21:21:12", aData.createDateTime);
//    [ECGDates deleteTable:tableName];
}

-(void)tAgeRange{
    NSLog(@"2");
    AgeRangeDAO *aRange = [AgeRangeDAO sharedManager];
    AgeRange *model = [[AgeRange alloc] init];
    model.dataOfECG = @"80以下";
    model.sex = @"女";
    model.status = @"";
    model.suggest =@"";
    AgeRange *result = [aRange findById:model andID:@"ageRange_children"];
    XCTAssertNotNil(result);
    XCTAssertEqualObjects(@"该女童心动过缓，请注意", result.suggest);
}

-(void)tPersionInfo{
    NSLog(@"3");
    PersionInfoDAO *pInfo = [PersionInfoDAO sharedManager];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    //test : remove
    XCTAssertEqual(1, [pInfo removeInfo]);
    
    //test : findInfo method
    XCTAssertNil(pInfo.findInfo);
    
    //test : insertInfo method
    PersionInfo *model1 = [[PersionInfo alloc] init];
    model1.persionInfoId = 1;
    model1.name = @"bob";
    model1.sex = @"男";
    model1.date_of_birth = [dateFormatter dateFromString:@"1992-08-04"];
    model1.age = @"64";
    XCTAssertEqual(1, [pInfo insertInfo:model1]);
    
    //test : findInfo method
    XCTAssertNotNil(pInfo.findInfo);
    
    //test : updateInfo method
    PersionInfo *model = [[PersionInfo alloc] init];
    model.persionInfoId = 1;
    model.name = @"bob";
    model.sex = @"男";
    model.date_of_birth = [dateFormatter dateFromString:@"1997-08-04"];
    model.age = @"63";
    XCTAssertEqual(1, [pInfo updateInfo:model]);
}

-(void)tAgeTable{
    NSLog(@"4");
    AgeTableDAO *aTable = [AgeTableDAO sharedManager];

    AgeTable *model1 = [[AgeTable alloc] init];
    model1.ageRange = @"1岁以下";
    AgeTable *model2 = [aTable findById:model1];
    XCTAssertNotNil(model2);
    XCTAssertEqualObjects(@"ageRange_baby", model2.tableName,@"断言失败");

    XCTAssertNotNil(aTable.findAll);
    AgeTable *model3 = [aTable.findAll objectAtIndex:2];
    XCTAssertEqualObjects(@"ageRange_youngChildren", model3.tableName,@"断言失败");
}
@end
