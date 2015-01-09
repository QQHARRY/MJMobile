//
//  DataPersistence.h
//  MJ
//
//  Created by harry on 15/1/10.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "dictionaryManager.h"


@protocol DATAPERISTENCEPROTOCOL <NSObject>

@required
+(void)insertObj:(id<SQLPROTOCOL>)obj ToTable:(NSString*)tableName;
+(NSArray*)seachRecordWithCondition:(NSString*)cond;
+(void)deleteTable:(NSString*)tabName;
+(void)createTable:(NSString*)tabName;
@end



