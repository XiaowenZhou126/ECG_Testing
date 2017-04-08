//
//  PersistenceLayer.h
//  PersistenceLayer
//
//  Created by kathy on 2017/4/6.
//  Copyright © 2017年 kathy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface PersistenceLayer : NSObject

-(NSString *)print;
-(NSString *)createTable;

@end
