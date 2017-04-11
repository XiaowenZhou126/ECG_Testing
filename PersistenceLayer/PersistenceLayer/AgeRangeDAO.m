//
//  AgeRangeDAO.m
//  PersistenceLayer
//
//  Created by kathy on 2017/4/10.
//  Copyright © 2017年 kathy. All rights reserved.
//

#import "AgeRangeDAO.h"

@implementation AgeRangeDAO

static AgeRangeDAO *manager = nil;

-(AgeRange *)findById:(AgeRange *)model andID:(NSString *)tableName{
    NSString *filePath = [self applicationDocumentsDirectoryPath];
    
    if(sqlite3_open([filePath UTF8String], &db) != SQLITE_OK){
        NSAssert(NO, @"数据库打开失败");
        [self closeDatabase];
    }
    else{
        NSString *selectOneSql1 = [@"select * from " stringByAppendingString:tableName];
        NSString *selectOneSql2 =@" where ECG_data=? and sex=?";
        NSString *selectOneSql = [selectOneSql1 stringByAppendingString:selectOneSql2];
        
        sqlite3_stmt *statement;

        if(sqlite3_prepare_v2(db, [selectOneSql UTF8String], -1, &statement, NULL) == SQLITE_OK){
            
            sqlite3_bind_text(statement, 1, [model.dataOfECG UTF8String], -1, NULL);
            sqlite3_bind_text(statement, 2, [model.sex UTF8String], -1, NULL);

            if(sqlite3_step(statement) == SQLITE_ROW) {
                char *dataOfECG = (char *)sqlite3_column_text(statement, 0);
                NSString *nsdataOfECG = [[NSString alloc] initWithUTF8String:dataOfECG];
                
                char *sex = (char *)sqlite3_column_text(statement, 1);
                NSString *nssex = [[NSString alloc] initWithUTF8String:sex];
                
                char *status = (char *)sqlite3_column_text(statement, 2);
                NSString *nsstatus = [[NSString alloc] initWithUTF8String:status];
                
                char *suggest = (char *)sqlite3_column_text(statement, 3);
                NSString *nssuggest = [[NSString alloc] initWithUTF8String:suggest];
                
                AgeRange *ageRange = [[AgeRange alloc] init];
                ageRange.dataOfECG = nsdataOfECG;
                ageRange.sex = nssex;
                ageRange.status = nsstatus;
                ageRange.suggest = nssuggest;
                return ageRange;
            }
        }
        sqlite3_finalize(statement);
        [self closeDatabase];
    }
    
    return nil;
}

+(AgeRangeDAO *)sharedManager{
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
