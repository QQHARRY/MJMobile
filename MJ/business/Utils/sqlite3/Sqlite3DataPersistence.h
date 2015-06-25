//
//  Sqlite3DataPersistence.h
//  MJ
//
//  Created by harry on 15/1/10.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataPersistence.h"

@interface Sqlite3DataPersistence : NSObject<DATAPERISTENCEPROTOCOL>


+(NSString*)getDatabasePath;
+(void)insertObj:(id<SQLPROTOCOL>)obj ToTable:(NSString*)tableName;
+(NSArray*)seachRecordWithCondition:(NSString*)cond;
+(void)deleteTable:(NSString*)tabName;
+(void)createTable:(NSString*)tabName;
@end
