//
//  building.m
//  MJ
//
//  Created by harry on 15/1/24.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//

#import "building.h"

@implementation building


@synthesize building_name;
@synthesize building_no;
@synthesize unit_count;
//@synthesize floor_count;
//@synthesize elevator_house;



-(NSArray*)getSerialArr
{
    NSMutableArray*arr = [[NSMutableArray alloc] init];
    return arr;
    if (self.unit_count)
    {
        NSString*minFloor =@"1";
        NSInteger iMinFloor = [minFloor intValue];
        NSString*maxFloor = self.unit_count;
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
