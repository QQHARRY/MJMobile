//
//  MJMenuItemValue.h
//  MJDropDownMenuBar
//
//  Created by harry on 15/5/19.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, MJMenuItemValueType) {

    MJMenuItemValueTypeSingle     = 0,
    MJMenuItemValueTypeMulti      = 1,
    MJMenuItemValueTypeArea       = 2,
    MJMenuItemValueTypeCustomizeSinge = 3,
    MJMenuItemValueTypeCustomizeArea = 4,
   
};

@interface MJMenuItemValue : NSObject

@property(nonatomic,assign)MJMenuItemValueType valueType;
@property(nonatomic,assign)NSArray* valueArr;

+(id)valueWithType:(MJMenuItemValueType)type Values:(id)val1, ...;

-(id)getSingleValue;
-(NSArray*)getMultiValue;
-(NSArray*)getAreaValue;

-(NSDictionary*)convert2Dic;
@end
