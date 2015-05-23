//
//  MJMenuModel.m
//  MJDropDownMenuBar
//
//  Created by harry on 15/5/19.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//

#import "MJMenuModel.h"
#import "HouseDataPuller.h"
#import "MJMenuItem.h"
#import "person.h"
#import "dictionaryManager.h"
#import "Macro.h"


@implementation MJMenuModel

-(NSDictionary*)convert2Dic
{
    NSDictionary*dic = @{@"menuItem":[self.menuItem convert2Dic],@"subMenuItem":self.subMenuItems};
    return dic;
}


+(void)asyncGetUrbanAndAreaMenuItemList:(void(^)(BOOL success,NSArray*urbanArr))complete
{
    __strong static NSArray* urbanAreaList = nil;
    __strong static NSMutableArray*urbanAreaModelArr = nil;
    
    void(^blk)()  = ^{
        if (urbanAreaList)
        {
            if (urbanAreaModelArr == nil)
            {
                urbanAreaModelArr = [[NSMutableArray alloc ] init];
                
                for (NSDictionary *urban in urbanAreaList)
                {
                    NSString*urbanName = [[urban objectForKey:@"dict"] objectForKey:@"areas_name"];
                    NSString*urbanNo = [urban objectForKey:@"no"];
                    NSLog(@"-%@ %@",urbanName,urbanNo);
                    
                    
                    MJMenuItem*urbanItem = [[MJMenuItem alloc ]init];
                    urbanItem.title = urbanName;
                    urbanItem.value = [MJMenuItemValue valueWithType:MJMenuItemValueTypeSingle Values:urbanNo,nil];
                    
                    
                    MJMenuModel*urbanAreaModel = [[MJMenuModel alloc] init];
                    urbanAreaModel.subMenuItems = [[NSMutableArray alloc] init];
                    urbanAreaModel.menuItem = urbanItem;
                    
                    
                    
                    NSArray*areaArr = [urban objectForKey:@"sections"];
                    for (id area in areaArr)
                    {
                        NSString*areaName = [area objectForKey:@"areas_name"];
                        NSString*areaNo = [area objectForKey:@"areas_current_no"];
                        NSLog(@"    +%@%@",areaName,areaNo);
                        
                        
                        MJMenuItem*areaItem = [[MJMenuItem alloc ]init];
                        areaItem.title = areaName;
                        areaItem.value = [MJMenuItemValue valueWithType:MJMenuItemValueTypeSingle Values:areaNo,nil];
                        
                        
                        [urbanAreaModel.subMenuItems addObject:areaItem];
                    }
                    
                    [urbanAreaModelArr addObject:[urbanAreaModel convert2Dic]];
                }
                
                complete(YES,urbanAreaModelArr);
            }
            else
            {
                complete(YES,urbanAreaModelArr);
            }
            
            
        }
        else
        {
            complete(NO,nil);
        }
    };
    
    if (urbanAreaList == nil)
    {
       [HouseDataPuller pullAreaListDataSuccess:^(NSArray *areaList) {
           urbanAreaList = [areaList mutableCopy];
           blk();
       } failure:^(NSError *error) {
           complete(NO,nil);
       }];
    }
    else
    {
        if (urbanAreaModelArr)
        {
            complete(YES,urbanAreaModelArr);
        }
        else
        {
            blk();
        }
    }
}



+(NSArray*)getSellPriceMenuItemList
{
    __strong static NSArray*sellPriceArr = nil;
    if (sellPriceArr == nil)
    {
        
        const NSNumber* at = [NSNumber numberWithInt:MJMenuItemValueTypeArea];
        const NSNumber* ct = [NSNumber numberWithInt:MJMenuItemValueTypeCustomizeArea];
        sellPriceArr = @[
                         @{@"menuItem":
                                @{@"title":@"不限",@"value":@[@"0",@"0"],@"valueType":at},
                         },
                         @{@"menuItem":
                               @{@"title":@"30万以下",@"value":@[@"0",@"30"],@"valueType":at},
                           },
                         @{@"menuItem":
                               @{@"title":@"30-50万",@"value":@[@"30",@"50"],@"valueType":at},
                           },
                         @{@"menuItem":
                               @{@"title":@"50-80万",@"value":@[@"50",@"80"],@"valueType":at},
                           },
                         @{@"menuItem":
                               @{@"title":@"80-100万",@"value":@[@"80",@"100"],@"valueType":at},
                           },
                         @{@"menuItem":
                               @{@"title":@"100-120万",@"value":@[@"100",@"120"],@"valueType":at},
                           },
                         @{@"menuItem":
                               @{@"title":@"100-120万",@"value":@[@"100",@"120"],@"valueType":at},
                           },
                         @{@"menuItem":
                               @{@"title":@"120-150万",@"value":@[@"120",@"150"],@"valueType":at},
                           },
                         @{@"menuItem":
                               @{@"title":@"150-200万",@"value":@[@"150",@"200"],@"valueType":at},
                           },
                         @{@"menuItem":
                               @{@"title":@"200-300万",@"value":@[@"200",@"300"],@"valueType":at},
                           },
                         @{@"menuItem":
                               @{@"title":@"300万以上",@"value":@[@"300",@"0"],@"valueType":at},
                           },
                         @{@"menuItem":
                               @{@"title":@"自定义",@"value":@[@"0",@"0"],@"valueType":ct},
                           },
                         ];


    }
    
    return sellPriceArr;
}

+(NSArray*)getRentPriceMenuItemList
{
    __strong static NSArray*rentPriceArr = nil;
    if (rentPriceArr == nil)
    {
        
        const NSNumber* at = [NSNumber numberWithInt:MJMenuItemValueTypeArea];
        const NSNumber* ct = [NSNumber numberWithInt:MJMenuItemValueTypeCustomizeArea];
        rentPriceArr = @[
                         @{@"menuItem":
                               @{@"title":@"不限",@"value":@[@"0",@"0"],@"valueType":at},
                           },
                         @{@"menuItem":
                               @{@"title":@"500元以下",@"value":@[@"0",@"500"],@"valueType":at},
                           },
                         @{@"menuItem":
                               @{@"title":@"500-1000元",@"value":@[@"500",@"1000"],@"valueType":at},
                           },
                         @{@"menuItem":
                               @{@"title":@"1000-2000元",@"value":@[@"1000",@"2000"],@"valueType":at},
                           },
                         @{@"menuItem":
                               @{@"title":@"2000-3000元",@"value":@[@"2000",@"3000"],@"valueType":at},
                           },
                         @{@"menuItem":
                               @{@"title":@"3000-5000元",@"value":@[@"3000",@"5000"],@"valueType":at},
                           },
                         @{@"menuItem":
                               @{@"title":@"5000-8000元",@"value":@[@"5000",@"8000"],@"valueType":at},
                           },
                         @{@"menuItem":
                               @{@"title":@"8000元以上",@"value":@[@"8000",@"0"],@"valueType":at},
                           },
                         @{@"menuItem":
                               @{@"title":@"自定义",@"value":@[@"0",@"0"],@"valueType":ct},
                           }
                         ];
        
        
    }
    return rentPriceArr;
}

+(NSArray*)getDeptMenuItemList
{
    
    NSString*myDept = [person me].department_no;
    NSString*myJobNo = [person me].job_no;
    const NSNumber* at = [NSNumber numberWithInt:MJMenuItemValueTypeArea];
    NSArray* deptArr = @[
                         @{@"menuItem":
                               @{@"title":@"不限",@"value":@[@"0",@"0"],@"valueType":at},
                           },
                         @{@"menuItem":
                               @{@"title":@"我的房源",@"value":@[myDept,myJobNo],@"valueType":at},
                           },
                         @{@"menuItem":
                               @{@"title":@"选择部门",@"value":@[@"0",@"0"],@"valueType":at},
                           },
                         ];
    
    
    return deptArr;
}


+(NSArray*)getAreaMenuItemList
{
    
    __strong static NSArray*areaArr = nil;
    if (areaArr == nil)
    {
        const NSNumber* at = [NSNumber numberWithInt:MJMenuItemValueTypeArea];
        areaArr = @[
                         @{@"menuItem":
                               @{@"title":@"不限",@"value":@[@"0",@"0"],@"valueType":at},
                           },
                         @{@"menuItem":
                               @{@"title":@"50平米以下",@"value":@[@"0",@"50"],@"valueType":at},
                           },
                         @{@"menuItem":
                               @{@"title":@"50-70平米",@"value":@[@"50",@"70"],@"valueType":at},
                           },
                         @{@"menuItem":
                               @{@"title":@"70-90平米",@"value":@[@"70",@"90"],@"valueType":at},
                           },
                         @{@"menuItem":
                               @{@"title":@"90-110平米",@"value":@[@"90",@"110"],@"valueType":at},
                           },
                         @{@"menuItem":
                               @{@"title":@"110-130平米",@"value":@[@"110",@"130"],@"valueType":at},
                           },
                         @{@"menuItem":
                               @{@"title":@"130-150平米",@"value":@[@"130",@"150"],@"valueType":at},
                           },
                         @{@"menuItem":
                               @{@"title":@"150-200平米",@"value":@[@"150",@"200"],@"valueType":at},
                           },
                         @{@"menuItem":
                               @{@"title":@"200-300平米",@"value":@[@"200",@"300"],@"valueType":at},
                           },
                         @{@"menuItem":
                               @{@"title":@"300平米以上",@"value":@[@"300",@"0"],@"valueType":at},
                           }
                         ];
        
        
    }
    return areaArr;
}


+(NSArray*)getHallMenuItemList
{
    
    __strong static NSArray*areaArr = nil;
    if (areaArr == nil)
    {
        const NSNumber* st = [NSNumber numberWithInt:MJMenuItemValueTypeSingle];
        areaArr = @[
                    @{@"menuItem":
                          @{@"title":@"不限",@"value":@[@"0"],@"valueType":st},
                      },
                    @{@"menuItem":
                          @{@"title":@"1厅",@"value":@[@"1"],@"valueType":st},
                      },
                    @{@"menuItem":
                          @{@"title":@"2厅",@"value":@[@"2"],@"valueType":st},
                      },
                    @{@"menuItem":
                          @{@"title":@"3厅",@"value":@[@"3"],@"valueType":st},
                      },
                    @{@"menuItem":
                          @{@"title":@"4厅",@"value":@[@"4"],@"valueType":st},
                      },
                    @{@"menuItem":
                          @{@"title":@"5厅",@"value":@[@"5"],@"valueType":st},
                      },
                    @{@"menuItem":
                          @{@"title":@"5厅以上",@"value":@[@"6"],@"valueType":st},
                      }
                    ];
        
        
    }
    return areaArr;
}

+(NSArray*)getFloorMenuItemList
{
    
    __strong static NSArray*floorArr = nil;
    if (floorArr == nil)
    {
        const NSNumber* at = [NSNumber numberWithInt:MJMenuItemValueTypeArea];
        floorArr = @[
                    @{@"menuItem":
                          @{@"title":@"不限",@"value":@[@"0",@"0"],@"valueType":at},
                      },
                    @{@"menuItem":
                          @{@"title":@"底层(1~6层)",@"value":@[@"1",@"6"],@"valueType":at},
                      },
                    @{@"menuItem":
                          @{@"title":@"中层(7~12层)",@"value":@[@"7",@"12"],@"valueType":at},
                      },
                    @{@"menuItem":
                          @{@"title":@"高层(12层以上)",@"value":@[@"12",@"0"],@"valueType":at},
                      },
                    
                    ];
        
        
    }
    return floorArr;
}


+(NSArray*)getOrientMenuItemList
{
    
    NSArray*dicArr = [dictionaryManager getItemArrByType:DIC_HOUSE_DIRECT_TYPE];
    const NSNumber* st = [NSNumber numberWithInt:MJMenuItemValueTypeSingle];
    
    NSArray*areaArr = @[
                        @{@"menuItem":
                              @{@"title":@"不限",@"value":@[@""],@"valueType":st},
                          },
                        @{@"menuItem":
                              @{@"title":@"南北",@"value":@[[self getDicValueByLabel:@"南北" FromDicArr:dicArr]],@"valueType":st},
                          },
                        @{@"menuItem":
                              @{@"title":@"东西",@"value":@[[self getDicValueByLabel:@"东西" FromDicArr:dicArr]],@"valueType":st},
                          },
                        @{@"menuItem":
                              @{@"title":@"南",@"value":@[[self getDicValueByLabel:@"南" FromDicArr:dicArr]],@"valueType":st},
                          },
                        @{@"menuItem":
                              @{@"title":@"北",@"value":@[[self getDicValueByLabel:@"北" FromDicArr:dicArr]],@"valueType":st},
                          },
                        @{@"menuItem":
                              @{@"title":@"东",@"value":@[[self getDicValueByLabel:@"东" FromDicArr:dicArr]],@"valueType":st},
                          },
                        @{@"menuItem":
                              @{@"title":@"西",@"value":@[[self getDicValueByLabel:@"西" FromDicArr:dicArr]],@"valueType":st},
                          },
                        @{@"menuItem":
                              @{@"title":@"东南",@"value":@[[self getDicValueByLabel:@"东南" FromDicArr:dicArr]],@"valueType":st},
                          },
                        @{@"menuItem":
                              @{@"title":@"西南",@"value":@[[self getDicValueByLabel:@"西南" FromDicArr:dicArr]],@"valueType":st},
                          },
                        @{@"menuItem":
                              @{@"title":@"东北",@"value":@[[self getDicValueByLabel:@"东北" FromDicArr:dicArr]],@"valueType":st},
                          },
                        @{@"menuItem":
                              @{@"title":@"西北",@"value":@[[self getDicValueByLabel:@"西北" FromDicArr:dicArr]],@"valueType":st},
                          },
                        ];
    
    
    return areaArr;
}


+(NSString*)getDicValueByLabel:(NSString*)label FromDicArr:(NSArray*)dicArr
{
    if (label != nil && label.length != 0 && dicArr != nil && dicArr.count > 0)
    {
        for (DicItem *di in dicArr)
        {
            if ([di.dict_label isEqualToString:label])
            {
                return di.dict_value;
            }
        }
    }
    
    
    
    return @"";
}


@end
