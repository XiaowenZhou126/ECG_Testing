//
//  PersionInfoDAO.h
//  PersistenceLayer
//
//  Created by kathy on 2017/4/8.
//  Copyright © 2017年 kathy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PersionInfo.h"
#import <sqlite3.h>

#define DBFILE_NAME "ECG_Testing.db"
@interface PersionInfoDAO : NSObject
{
    sqlite3 *db;//保存对数据库的引用
}

+(PersionInfoDAO*)sharedManager;
-(void)createEditableCopyOfDatabaseIfNeeded;
-(NSString*)applicationDocumentsDirectoryPath;//返回文件路径
-(void)closeDatabase;
-(PersionInfo*)findInfo;
-(int)updateInfo:(PersionInfo *)model;
-(int)insertInfo:(PersionInfo *)model;
-(int)removeInfo;

@end
