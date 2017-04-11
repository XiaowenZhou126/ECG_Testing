//
//  ECGData.h
//  PersistenceLayer
//
//  Created by kathy on 2017/4/11.
//  Copyright © 2017年 kathy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ECGData : NSObject

@property(nonatomic) NSString *createDateTime;
@property(nonatomic,strong) NSString *data;

@end
