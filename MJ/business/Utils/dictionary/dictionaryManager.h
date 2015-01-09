//
//  dictionaryManager.h
//  MJ
//
//  Created by harry on 15/1/9.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//


#import "bizManager.h"

@interface dictionaryManager:bizManager


+(void)updateDic;


+(void)setDicVersion:(float)version;

+(float)readDicVersion;
@end
