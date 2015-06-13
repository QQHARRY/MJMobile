//
//  MJKeywordPersistence.h
//  MJ
//
//  Created by harry on 15/6/13.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MJKeywordPersistence <NSObject>
@required
-(NSArray*)getHistoryKeyWordByKey:(NSString*)key;
-(void)synHistoryKeyWordArr:(NSMutableArray*)arr ByKey:(NSString*)key;
-(void)clearHistoryKeyWordArrByKey:(NSString*)key;

@end


@interface MJKeywordPersistenceFactory : NSObject
+(id<MJKeywordPersistence>)getPersistenceImp;

@end