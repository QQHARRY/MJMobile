//
//  dictionaryManager.h
//  MJ
//
//  Created by harry on 15/1/9.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//


#import "bizManager.h"
#import "dic2Object.h"


@protocol SQLPROTOCOL <NSObject>

@required
-(NSString*)insertString;
-(NSString*)searchString;
@end

@interface DicItem:dic2Object

@property(strong,nonatomic)NSString*dict_label;
@property(strong,nonatomic)NSString*dict_label_type;
@property(strong,nonatomic)NSString*dict_sort;
@property(strong,nonatomic)NSString*dict_value;

-(NSString*)insertString;
+(NSString*)searchString;

@end


@interface dictionaryManager:bizManager


+(void)updateDicSuccess:(void (^)(id responseObject))success
                failure:(void (^)(NSError *error))failure;


+(void)setDicVersion:(float)version;

+(float)readDicVersion;

+(void)setDicVersionStr:(NSString*)version;

+(NSString*)readDicVersionStr;


+(NSArray*)getItemArrByType:(NSString*)type;
@end
