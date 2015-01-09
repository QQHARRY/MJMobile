//
//  dictionaryManager.h
//  MJ
//
//  Created by harry on 15/1/9.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//


#import "bizManager.h"
#import "dic2Object.h"

@interface DicItem:dic2Object

@property(strong,nonatomic)NSString*dict_label;
@property(strong,nonatomic)NSString*dict_label_type;
@property(strong,nonatomic)NSString*dict_sort;
@property(strong,nonatomic)NSString*dict_value;



@end


@interface dictionaryManager:bizManager


+(void)updateDicSuccess:(void (^)(id responseObject))success
                failure:(void (^)(NSError *error))failure;


+(void)setDicVersion:(float)version;

+(float)readDicVersion;

+(NSArray*)getItemArrByType:(NSString*)type;
@end
