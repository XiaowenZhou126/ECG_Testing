//
//  PersistenceLayer.m
//  PersistenceLayer
//
//  Created by kathy on 2017/4/6.
//  Copyright © 2017年 kathy. All rights reserved.
//

#import "PersistenceLayer.h"

@implementation PersistenceLayer

-(NSString*)print{
    return @"PersistenceLayer OK";
}

-(NSString *)createTable{
    NSString* filename=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]stringByAppendingPathComponent:@"test.db"];
    NSLog(@"%@",filename);
    NSString *flag = @"-1";
    sqlite3 *test;
    int status=sqlite3_open(filename.UTF8String, &test);
    
    if(status == SQLITE_OK){//枚举值SQLITE_OK，代表成功的状态
        char *errorMsg;
        const char *createsql = "create table IF NOT exists info(id integer primary key, inf integer);";
        if ( sqlite3_exec(test, createsql, NULL, NULL, &errorMsg) != SQLITE_OK ) {
            NSLog(@"craete %s",errorMsg);
            flag = @"0";
            sqlite3_close(test);
        }
        else{
            flag = @"1";
        }
    }
    else{
        NSLog(@"打开数据库失败");
    }
    
    return flag;
}

@end
