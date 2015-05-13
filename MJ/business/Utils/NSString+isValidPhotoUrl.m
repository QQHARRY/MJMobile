//
//  NSString+isValidPhotoUrl.m
//  MJ
//
//  Created by harry on 15/5/13.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//

#import "NSString+isValidPhotoUrl.h"

@implementation NSString (isValidPhotoUrl)

-(BOOL)isValidPhotoUrl
{
    NSString*strLast = [[self pathExtension] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    if ([[strLast lowercaseString] isEqualToString:@"jpg"]
        ||[[strLast lowercaseString] isEqualToString:@"png"]
        ||[[strLast lowercaseString] isEqualToString:@"jpeg"]
        ||[[strLast lowercaseString] isEqualToString:@"gif"]
        )
    {
        return YES;
    }
    return NO;
}
@end
