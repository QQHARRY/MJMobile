//
//  MJMenuModel.m
//  MJDropDownMenuBar
//
//  Created by harry on 15/5/19.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//

#import "MJMenuModel.h"


@implementation MJMenuModel

+(void)initUrbanAndAreaList:(void(^)(BOOL success,NSArray*urbanArr))complete
{
    static NSMutableArray*arr;
    if (arr == nil)
    {
        arr = [[NSMutableArray alloc] init];
    }
    

}
@end
