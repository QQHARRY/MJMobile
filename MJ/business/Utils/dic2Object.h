//
//  dic2Object.h
//  MJ
//
//  Created by harry on 14/12/12.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface dic2Object : NSObject
-(BOOL)initWithDictionary:(NSDictionary*)dic;
-(NSDictionary*)convert2Dic;
@end
