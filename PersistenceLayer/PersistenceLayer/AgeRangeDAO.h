//
//  AgeRangeDAO.h
//  PersistenceLayer
//
//  Created by kathy on 2017/4/10.
//  Copyright © 2017年 kathy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "AgeRange.h"

@interface AgeRangeDAO : NSObject
{
    sqlite3 *db;//保存对数据库的引用
}

+(AgeRangeDAO *)sharedManager;
-(void)createEditableCopyOfDatabaseIfNeeded;
-(NSString *)applicationDocumentsDirectoryPath;//返回文件路径
-(void)closeDatabase;
-(AgeRange *)findById:(AgeRange *)model andID:(NSString *)tableName;

@end
