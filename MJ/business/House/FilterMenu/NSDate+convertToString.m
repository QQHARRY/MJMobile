//
//  NSDate+convertToString.m
//  MJ
//
//  Created by harry on 15/6/8.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//

#import "NSDate+convertToString.h"

@implementation NSDate (convertToString)


-(NSString*)toStringYear2Second
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [dateFormatter stringFromDate:self];
}
@end
