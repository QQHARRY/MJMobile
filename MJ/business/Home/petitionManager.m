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
#import "UtilFun.h"

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
//             NSArray*arr = [resultDic objectForKey:@"PetitionDetails"];
//             NSDictionary*dic  =[arr objectAtIndex:0];
//             
             
             success(resultDic);
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
    if ([annArr respondsToSelector:@selector(count)])
    {
        if ([annArr count] > 0)
        {
            for (NSDictionary*dic in annArr)
            {
                petiotionBrief* pet = [[petiotionBrief alloc] init];
                [pet initWithDictionary:dic];
                [arr  addObject:pet];
                
            }
        }
        
    }
    
    if ([arr count] == 0)
    {
        return nil;
    }
    
    return arr;
}

+(void)approveID:(NSString*)ids TaskID:(NSString*)taskID ActionType:(int)actionType Reason:(NSString*)reason AssistDepts:(NSArray*)assits Success:(void (^)(id responseObject))success
failure:(void (^)(NSError *error))failure;
{
    NSMutableDictionary*param = [[NSMutableDictionary alloc ] init];
    
    int i = 0;
    NSString*assistDepts = @"";
    for(NSString*str in assits)
    {
        if(i > 0)
        {
            assistDepts = [assistDepts stringByAppendingString:@","];
            
        }
        assistDepts = [assistDepts stringByAppendingString:str];
        i++;
    }
    
    //[param setValue:assistDepts forKey:@"task_performer_no"];
    [param setValue:@"DEPT_NO000041" forKey:@"task_performer_no"];
    
    NSDictionary *parameters = @{@"job_no":[person me].job_no,
                                 @"acc_password":[person me].password,
                                 @"DeviceID" : [UtilFun getUDID],
                                 @"id":[NSNumber numberWithInt:[ids intValue]],
                                 @"taskid":[NSNumber numberWithInt:[taskID intValue]],
                                 @"Action_Type":[NSNumber numberWithInt:actionType],
                                 @"Reason":reason,
                                 @"params":param
                                 
                                 };
    
    
    [NetWorkManager PostWithApiName:API_PETITION_APPROVE parameters:parameters success:
     ^(id responseObject)
     {
         
         NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         if ([self checkReturnStatus:resultDic Success:success failure:failure ShouldReturnWhenSuccess:NO])
         {

             success(nil);
             return;
         }
         
         
     }
                            failure:^(NSError *error)
     {
         failure(error);
         return;
     }];
}

@end
