//
//  MJMenuItem.h
//  MJDropDownMenuBar
//
//  Created by harry on 15/5/19.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MJMenuItemValue.h"

@interface MJMenuItem : NSObject

@property(strong,nonatomic)NSString*title;
@property(strong,nonatomic)MJMenuItemValue*value;

-(NSDictionary*)convert2Dic;
@end
