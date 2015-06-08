//
//  NSString+GetNamefull.h
//  MJ
//
//  Created by harry on 15/6/4.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (GetNamefull)

-(NSString*)getNamefull;
-(void)asynGetNamefull:(void(^)(NSString* namefull))success;


@end
