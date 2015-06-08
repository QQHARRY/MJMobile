//
//  MJMenuItemValue.h
//  MJDropDownMenuBar
//
//  Created by harry on 15/5/19.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, MJMenuItemValueType) {

    MJMenuItemValueTypeSingle     = 0, //单选值
    MJMenuItemValueTypeMulti      = 1, //多选值
    MJMenuItemValueTypeArea       = 2, //单选值区间
    MJMenuItemValueTypeCustomizeSinge = 3, //单选、自定义单值
    MJMenuItemValueTypeCustomizeArea = 4,  //单选、自定义区间
    MJMenuItemValueTypeMultiCustomizeSingle = 5,//多选,自定义单值
     MJMenuItemValueTypeMultiCustomizeArea = 6,//多选，自定义区间
};

@interface MJMenuItemValue : NSObject

@property(nonatomic,assign)MJMenuItemValueType valueType;
@property(nonatomic,strong)NSArray* valueArr;

+(id)valueWithType:(MJMenuItemValueType)type Values:(id)val1, ...;

-(id)getSingleValue;
-(NSArray*)getMultiValue;
-(NSArray*)getAreaValue;


@end
