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
#import "UtilFun.h"
#import "HomeIndicator.h"

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



+(void)getHomeIndicatorCountDataSuccess:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure
{
    NSDictionary *parameters = @{@"job_no":[person me].job_no,
                                 @"acc_password":[person me].password,
                                 @"DeviceID":[UtilFun getUDID],
                                 @"DeviceType":DEVICE_IOS,
                                 };
    
    
    [NetWorkManager PostWithApiName:API_GET_HOME_INDICATOR_DATA parameters:parameters success:
     ^(id responseObject)
     {
         NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         if ([self checkReturnStatus:resultDic Success:success failure:failure ShouldReturnWhenSuccess:NO])
         {
             
             NSDictionary*dic1 = [resultDic objectForKey:@"CountNode"];
             HomeIndicator*indicatorCnt = [[HomeIndicator alloc] init];
             indicatorCnt.alert_count = [[dic1 objectForKey:@"alert_count"] intValue];
             indicatorCnt.appoint_count = [[dic1 objectForKey:@"appoint_count"] intValue];
             indicatorCnt.follow_count = [[dic1 objectForKey:@"follow_count"] intValue];
             indicatorCnt.msg_count = [[dic1 objectForKey:@"msg_count"] intValue];
             indicatorCnt.pert_sum = [[dic1 objectForKey:@"pert_sum"] floatValue];
             indicatorCnt.petition_count = [[dic1 objectForKey:@"petition_count"] intValue];
             
             NSArray*urlArr = [dic1 objectForKey:@"HomeImageInfo"];
             NSArray*imageArr = [dic1 objectForKey:@"HomeImageUrl"];
             int i = 0;
             indicatorCnt.bannerDataArr = [[NSMutableArray alloc] init];
             for (NSString* url in urlArr)
             {
                 BannerData*data = [[BannerData alloc] init];
                 data.webUrl = [[NSString stringWithFormat:@"%@%@",SERVER_ADD,[url stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                 if (i < imageArr.count)
                 {
                     NSString*str = [imageArr[i] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                     data.imgUrl = [NSString stringWithFormat:@"%@%@",SERVER_ADD,str];;
                 }
                 else
                 {
                     data.imgUrl = nil;
                 }
                 i++;
                 [indicatorCnt.bannerDataArr addObject:data];
             }
             
             success(indicatorCnt);
         }
         
     }
                            failure:^(NSError *error)
     {
         failure(error);
     }];
}

+(NSArray*)getBanner:(NSDictionary*)dic
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
