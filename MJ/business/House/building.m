//
//  building.m
//  MJ
//
//  Created by harry on 15/1/24.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//

#import "building.h"

@implementation building


@synthesize build_full_name;
@synthesize builds_dict_no;
@synthesize unit_serial;
@synthesize floor_count;
@synthesize elevator_house;



-(NSArray*)getSerialArr
{
    NSMutableArray*arr = [[NSMutableArray alloc] init];
    
    NSArray* subStrArr = [self.unit_serial componentsSeparatedByString:@"-"];
    if (subStrArr)
    {
        NSString*minFloor = [subStrArr objectAtIndex:0];
        NSInteger iMinFloor = [minFloor intValue];
        NSString*maxFloor = [subStrArr objectAtIndex:1];
        NSInteger iMaxFloor = [maxFloor intValue];
        
        for (NSInteger i = iMinFloor; i <= iMaxFloor; i++)
        {
            NSString*iStr = [NSString stringWithFormat:@"%ld",(long)i];
            [arr addObject:iStr];
        }
    }
    
    return arr;
}

@end
