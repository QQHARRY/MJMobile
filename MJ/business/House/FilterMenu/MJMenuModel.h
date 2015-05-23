//
//  MJMenuModel.h
//  MJDropDownMenuBar
//
//  Created by harry on 15/5/19.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJMenuItem.h"


#define MJ_MENU_ITEM_VALUE_SINGLE @"MJ_MENU_ITEM_VALUE_SINGLE"
#define MJ_MENU_ITEM_VALUE_MULTI @"MJ_MENU_ITEM_VALUE_MULTI"
#define MJ_MENU_ITEM_VALUE_SECTION @"MJ_MENU_ITEM_VALUE_SECTION"

@interface MJMenuModel : NSObject

@property(strong,nonatomic)MJMenuItem*menuItem;
@property(strong,nonatomic)NSMutableArray*subMenuItems;

-(NSDictionary*)convert2Dic;
+(NSString*)getDicValueByLabel:(NSString*)label FromDicArr:(NSArray*)dicArr;

+(void)asyncGetUrbanAndAreaMenuItemList:(void(^)(BOOL success,NSArray*urbanArr))complete;
+(NSArray*)getOrientMenuItemList;


@end
