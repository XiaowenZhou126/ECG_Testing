//
//  AgeTableDAO.h
//  PersistenceLayer
//
//  Created by kathy on 2017/4/8.
//  Copyright © 2017年 kathy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AgeTable.h"
#import <sqlite3.h>

#define DBFILE_NAME "ECG_Testing.db"

@interface AgeTableDAO : NSObject
{
    sqlite3 *db;//保存对数据库的引用
}

//@property (nonatomic,strong) NSMutableArray* listData;//保存数据列表

//+(AgeTableDAO*) sharedManager;

+(AgeTableDAO *)sharedManager;
-(NSString*)applicationDocumentsDirectoryPath;//返回文件路径
-(void)createEditableCopyOfDatabaseIfNeeded;
-(void)closeDatabase;
-(NSMutableArray*) findAll;
-(AgeTable*)findById:(AgeTable*)model;

@end
