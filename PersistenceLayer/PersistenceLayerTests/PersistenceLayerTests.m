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
@property (nonatomic,strong) ECGDatesDAO *ECGDates;
@property (nonatomic,strong) PersionInfoDAO *pInfo;
@property (nonatomic,strong) NSDateFormatter *dateFormatter;
@property (nonatomic,strong) AgeTableDAO *aTable;
@end

@implementation PersistenceLayerTests

- (void)setUp {
    [super setUp];
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    self.ECGDates = [ECGDatesDAO sharedManager];
    self.pInfo = [PersionInfoDAO sharedManager];
    self.aTable = [AgeTableDAO sharedManager];

}

- (void)tearDown {
    [super tearDown];
    self.dateFormatter = nil;
    self.ECGDates = nil;
    self.pInfo = nil;
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
    NSString *tableName = @"xx";
    XCTAssertEqual(1, [self.ECGDates createTable:tableName]);
    
    ECGData *model = [[ECGData alloc] init];
    model.createDateTime = @"2011-01-16 21:22:12";
    model.data = @"111";
    ECGData *model1 = [[ECGData alloc] init];
    model1.createDateTime = @"2011-01-15 21:21:12";
    model1.data = @"112";
    XCTAssertEqual(1, [self.ECGDates insertData:model andtableName:tableName]);
    XCTAssertEqual(1, [self.ECGDates insertData:model1 andtableName:tableName]);
    NSMutableArray *listData = [self.ECGDates findNewDate:tableName];
    XCTAssertNotNil(listData);
    ECGData *aData = [listData objectAtIndex:1];
    XCTAssertEqualObjects(@"2011-01-15 21:21:12", aData.createDateTime);
    [self.ECGDates deleteTable:tableName];
}

-(void)tAgeRange{
    AgeRangeDAO *aRange = [AgeRangeDAO sharedManager];
    
    AgeRange *model = [[AgeRange alloc] init];
    model.dataOfECG = @"小于80";
    model.sex = @"女";
    model.status = @"";
    model.suggest =@"";
    AgeRange *result = [aRange findById:model andID:@"ageRange_children"];
    XCTAssertNotNil(result);
    XCTAssertEqualObjects(@"该女童窦性心动过缓，请及时就医", result.suggest);
}

-(void)tPersionInfo{
    //test : remove
    XCTAssertEqual(1, [self.pInfo removeInfo]);
    
    //test : findInfo method
    XCTAssertNil(self.pInfo.findInfo);
    
    //test : insertInfo method
    PersionInfo *model1 = [[PersionInfo alloc] init];
    model1.persionInfoId = 1;
    model1.name = @"bob";
    model1.sex = @"男";
    model1.date_of_birth = [self.dateFormatter dateFromString:@"1992-08-04"];
    model1.age = @"64";
    XCTAssertEqual(1, [self.pInfo insertInfo:model1]);
    
    //test : findInfo method
    XCTAssertNotNil(self.pInfo.findInfo);
    
    //test : updateInfo method
    PersionInfo *model = [[PersionInfo alloc] init];
    model.persionInfoId = 1;
    model.name = @"bob";
    model.sex = @"男";
    model.date_of_birth = [self.dateFormatter dateFromString:@"1997-08-04"];
    model.age = @"63";
    XCTAssertEqual(1, [self.pInfo updateInfo:model]);
}

-(void)tAgeTable{
    AgeTable *model1 = [[AgeTable alloc] init];
    model1.ageRange = @"1岁以下";
    AgeTable *model2 = [self.aTable findById:model1];
    XCTAssertNotNil(model2);
    XCTAssertEqualObjects(@"ageRange_baby", model2.tableName,@"断言失败");

    XCTAssertNotNil(self.aTable.findAll);
    AgeTable *model3 = [self.aTable.findAll objectAtIndex:2];
    XCTAssertEqualObjects(@"ageRange_youngChildren", model3.tableName,@"断言失败");
}
@end
