//
//  AgeTableDAO.m
//  PersistenceLayer
//
//  Created by kathy on 2017/4/8.
//  Copyright © 2017年 kathy. All rights reserved.
//

#import "AgeTableDAO.h"

@implementation AgeTableDAO


static AgeTableDAO *manager = nil;

-(AgeTable*)findById:(AgeTable*)model{
    NSString *filePath = [self applicationDocumentsDirectoryPath];
    
    if(sqlite3_open([filePath UTF8String], &db) != SQLITE_OK){
        NSAssert(NO, @"数据库打开失败");
        [self closeDatabase];
    }
    else{
        NSString *selectOneSql = @"select * from ageTable where ageRange=?";
        sqlite3_stmt *statement;
        
        if(sqlite3_prepare_v2(db, [selectOneSql UTF8String], -1, &statement, NULL) == SQLITE_OK){
            
            sqlite3_bind_text(statement, 1, [model.ageRange UTF8String], -1, NULL);
           
            if(sqlite3_step(statement) == SQLITE_ROW) {
                char *ageRange = (char *)sqlite3_column_text(statement, 0);
                NSString *nsageRange = [[NSString alloc] initWithUTF8String:ageRange];
                
                char *tableName = (char *)sqlite3_column_text(statement, 1);
                NSString *nstableName = [[NSString alloc] initWithUTF8String:tableName];
                
                AgeTable*  ageTable = [[AgeTable alloc] init];
                ageTable.ageRange = nsageRange;
                ageTable.tableName = nstableName;
                return ageTable;
            }
        }        
        sqlite3_finalize(statement);
        [self closeDatabase];
        
    }
    
    return nil;
}

-(NSMutableArray *)findAll{
    NSString *filePath = [self applicationDocumentsDirectoryPath];
    NSMutableArray *listData = [[NSMutableArray alloc] init];
    
    if(sqlite3_open([filePath UTF8String], &db) != SQLITE_OK){
        NSAssert(NO, @"数据库打开失败");
        [self closeDatabase];
    }
    else{
        NSString *selectSql = @"select * from ageTable";
        sqlite3_stmt *statement;
        
        if(sqlite3_prepare_v2(db, [selectSql UTF8String], -1, &statement, NULL) == SQLITE_OK){
            
            while (sqlite3_step(statement) == SQLITE_ROW) {
                
                char *ageRange = (char *)sqlite3_column_text(statement, 0);
                NSString *nsageRange = [[NSString alloc] initWithUTF8String:ageRange];
                
                char *tableName = (char *)sqlite3_column_text(statement, 1);
                NSString *nstableName = [[NSString alloc] initWithUTF8String:tableName];
                
                AgeTable *ageTable = [[AgeTable alloc] init];
                ageTable.ageRange = nsageRange;
                ageTable.tableName = nstableName;
                
                [listData addObject:ageTable];
            }
        }
        
        sqlite3_finalize(statement);
        [self closeDatabase];
    }
    
    return listData;
}

+(AgeTableDAO *)sharedManager{
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        manager = [[self alloc] init];
        [manager createEditableCopyOfDatabaseIfNeeded];
    });
    
    return manager;
}

-(void)createEditableCopyOfDatabaseIfNeeded{
    NSString *fileName = [self applicationDocumentsDirectoryPath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    BOOL dbExits = [fileManager fileExistsAtPath:fileName];
    
    if(!dbExits){
        NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"ECG_Testing.db"];
        dbExits = [fileManager copyItemAtPath:defaultDBPath toPath:fileName error:&error];
        
        if(!dbExits){
            NSAssert1(0, @"Fail to create database file:'%@'.", [error localizedDescription]);
        }
    }
}

-(void)closeDatabase{
    if(sqlite3_close(db) != SQLITE_OK){
        NSAssert1(0, @"Error:failed to close database:'%s'.",         sqlite3_errmsg(db));
    }
    
    sqlite3_close(db);
}

-(NSString*)applicationDocumentsDirectoryPath{
    NSString *documentDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    return [documentDirectory stringByAppendingPathComponent:@"ECG_Testing.db"];
}

@end
