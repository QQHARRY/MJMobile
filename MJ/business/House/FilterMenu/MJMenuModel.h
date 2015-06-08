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




+(void)asyncGetUrbanAndAreaMenuItemList:(void(^)(BOOL success,NSArray*urbanArr))complete;
+(NSArray*)getSellPriceMenuItemList;
+(NSArray*)getRentPriceMenuItemList;
+(NSArray*)getDeptMenuItemList;
+(NSArray*)getAreaMenuItemList;
+(NSArray*)getHallMenuItemList;
+(NSArray*)getFloorMenuItemList;
+(NSArray*)getOrientMenuItemList;
+(NSArray*)getFitTypeMenuItemList;
+(NSArray*)getSellStausMenuItemList;
+(NSArray*)getLeaseStausMenuItemList;
+(NSArray*)getConsignmentStausMenuItemList;
+(NSArray*)getRoomTypeMenuItemList;
+(NSArray*)getOtherTypeMenuItemList;
+(NSArray*)getDateSectionMenuItemList;
+(NSArray*)getCustomerPropertyMenuItemList;
+(NSArray*)getCustomerStatusMenuItemList;
+(NSArray*)getCusDeptMenuItemList;

+(NSArray*)getDicTypeArrByName:(NSString*)type;

+(NSString*)getDicValueByLabel:(NSString*)label FromDicArr:(NSArray*)dicArr;
@end
