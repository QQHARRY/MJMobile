//
//  MJMenuItemValue.m
//  MJDropDownMenuBar
//
//  Created by harry on 15/5/19.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//

#import "MJMenuItemValue.h"
#import <objc/runtime.h>

@implementation MJMenuItemValue
@synthesize valueType;
@synthesize valueArr;



+(id)valueWithType:(MJMenuItemValueType)type Values:(id)val1, ...
{
    NSMutableArray *argsArray = [[NSMutableArray alloc] init];
    va_list params;
    va_start(params,val1);
    id arg = nil;
    if (val1)
    {
        [argsArray addObject:val1];

        while( (arg = va_arg(params,id)) )
        {
            if (arg)
                [argsArray addObject:arg];
        }
    }
    va_end(params);
        
    
    MJMenuItemValue* obj = [[MJMenuItemValue alloc] init];
    if (obj)
    {
        obj.valueType = type;
        
        switch (obj.valueType)
        {
            case MJMenuItemValueTypeSingle:
            {
                if (argsArray.count > 0)
                {
                    obj.valueArr = @[argsArray[0]];
                }
            }
                break;
            case MJMenuItemValueTypeMulti:
            {
                if (argsArray.count > 0)
                {
                    obj.valueArr = [NSArray arrayWithArray:argsArray];
                }
            }
                break;
            case MJMenuItemValueTypeArea:
            {
                if (argsArray.count > 1)
                {
                    obj.valueArr = @[argsArray[0],argsArray[1]];
                }
            }
                break;
                
            default:
                break;
        }
        
//        if (obj.valueArr == nil)
//        {
//            obj = nil;
//        }
    }
    
    return obj;
}


-(id)getSingleValue
{
    if (valueArr != nil && valueArr.count != 0)
    {
        return valueArr[0];
    }
    return nil;
}
-(NSArray*)getMultiValue
{
    if (valueArr != nil && valueArr.count != 0)
    {
        return valueArr;
    }
    return nil;
}
-(NSArray*)getAreaValue
{
    if (valueArr != nil && valueArr.count > 1)
    {
        return [[NSArray alloc] initWithObjects:valueArr[0],valueArr[1],nil];
    }
    return nil;
}





@end
