//
//  petitionManager.m
//  MJ
//
//  Created by harry on 14-12-9.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import "petitionManager.h"
#import "person.h"
#import "Macro.h"
#import "NetWorkManager.h"
#import "petiotionBrief.h"

@implementation petitionManager

+(void)getListFrom:(NSString*)from To:(NSString*)to Count:(int)count Success:(void (^)(id responseObject))success
             failure:(void (^)(NSError *error))failure
{
    NSDictionary *parameters = @{@"job_no":[person me].job_no,
                                 @"acc_password":[person me].password,
                                 @"FromID":from,
                                 @"ToID":to,
                                 @"Count":[NSNumber numberWithInt:count]
                                 };
    
    
    [NetWorkManager PostWithApiName:API_PETITION_LIST parameters:parameters success:
     ^(id responseObject)
     {
         
         NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         if ([self checkReturnStatus:resultDic Success:success failure:failure ShouldReturnWhenSuccess:NO])
         {
             success([self getArr:resultDic]);
             return;
         }

         
     }
                            failure:^(NSError *error)
     {
         failure(error);
         return;
     }];
}

+(void)getDetailsWithTaskID:(NSString*)taskID PetitionID:(NSString*)PetID Success:(void (^)(id responseObject))success
          failure:(void (^)(NSError *error))failure
{
    NSDictionary *parameters = @{@"job_no":[person me].job_no,
                                 @"acc_password":[person me].password,
                                 @"id":PetID,
                                 @"taskid":taskID
                                 };
    
    
    [NetWorkManager PostWithApiName:API_PETITION_DETAIL parameters:parameters success:
     ^(id responseObject)
     {
         
         NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         if ([self checkReturnStatus:resultDic Success:success failure:failure ShouldReturnWhenSuccess:NO])
         {
             NSArray*arr = [resultDic objectForKey:@"PetitionDetails"];
             NSDictionary*dic  =[arr objectAtIndex:0];
             success(dic);
             return;
         }
         
         
     }
                            failure:^(NSError *error)
     {
         failure(error);
         return;
     }];

}

+(NSArray*)getArr:(NSDictionary*)dic
{
    NSArray*annArr = [dic objectForKey:@"PetitionNode"];
    NSMutableArray* arr = [[NSMutableArray alloc] init];
    
    for (NSDictionary*dic in annArr)
    {
        petiotionBrief* pet = [[petiotionBrief alloc] init];
        [pet initWithDictionary:dic];
        [arr  addObject:pet];
        
    }
    
    return arr;
}

@end
