//
//  MJMenuModel.h
//  MJDropDownMenuBar
//
//  Created by harry on 15/5/19.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MJMenuModel : NSObject

+(void)initUrbanAndAreaList:(void(^)(BOOL success,NSArray*urbanArr))complete;

@end
