//
//  annoucementManager.m
//  MJ
//
//  Created by harry on 14-12-9.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import "annoucementManager.h"
#import "person.h"
#import "Macro.h"
#import "NetWorkManager.h"
#import "announcement.h"

@implementation annoucementManager

+(void)getListFrom:(NSString*)from To:(NSString*)to Count:(int)count Success:(void (^)(id responseObject))success
                      failure:(void (^)(NSError *error))failure
{
    NSDictionary *parameters = @{@"job_no":[person me].job_no,
                                 @"acc_password":[person me].password,
                                 @"FromID":from,
                                 @"ToID":to,
                                 @"Count":[NSNumber numberWithInt:count]
                                 };
    
    
    [NetWorkManager PostWithApiName:API_ANNC_LIST parameters:parameters success:
     ^(id responseObject)
     {
         NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         if ([self checkReturnStatus:resultDic Success:success failure:failure ShouldReturnWhenSuccess:NO])
         {
             NSArray*arr = [self getArr:resultDic];;
             
             if ([from isEqualToString:@"0"])
             {
                 announcement*annc = [arr objectAtIndex:0];
                 if (annc)
                 {
                     annc.isNew = YES;
                 }
             }
             success(arr);
         };
         
     }
                            failure:^(NSError *error)
     {
         failure(error);
     }];
}

+(NSArray*)getArr:(NSDictionary*)dic
{
    NSArray*annArr = [dic objectForKey:@"ANNCNode"];
    NSMutableArray* arr = [[NSMutableArray alloc] init];
    
    for (NSDictionary*dic in annArr)
    {
        announcement* ann = [[announcement alloc] init];
        [ann initWithDictionary:dic];
        ann.isNew = NO;
        [arr  addObject:ann];
        
    }
    
    return arr;
}
@end
