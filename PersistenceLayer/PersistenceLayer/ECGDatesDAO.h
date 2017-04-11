//
//  ECGDatesDAO.h
//  PersistenceLayer
//
//  Created by kathy on 2017/4/11.
//  Copyright © 2017年 kathy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "ECGData.h"

@interface ECGDatesDAO : NSObject
{
    sqlite3 *db;//保存对数据库的引用
}

+(ECGDatesDAO *)sharedManager;
-(void)createEditableCopyOfDatabaseIfNeeded;
-(NSString *)applicationDocumentsDirectoryPath;//返回文件路径
-(void)closeDatabase;
-(int)createTable:(NSString *)tableName;//不存在添加一张表
-(int)insertData:(ECGData *)model andtableName:(NSString*)tableName;//插入一条数据
-(NSMutableArray *)findNewDate:(NSString *)tableName;
-(void)deleteTable:(NSString*)tableName;

@end
