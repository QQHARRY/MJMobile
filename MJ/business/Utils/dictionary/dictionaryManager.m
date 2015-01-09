//
//  dictionaryManager.m
//  MJ
//
//  Created by harry on 15/1/9.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//

#import "dictionaryManager.h"
#import "NetWorkManager.h"
#import "Macro.h"
#import "person.h"
#import "messageObj.h"
#import "UtilFun.h"

@implementation DicItem

@synthesize dict_label;
@synthesize dict_label_type;
@synthesize dict_sort;
@synthesize dict_value;

@end

@implementation dictionaryManager




+(void)updateDicSuccess:(void (^)(id responseObject))success
                failure:(void (^)(NSError *error))failure
{
    float curVer = [self readDicVersion];
    [self getDicCurVersion:0 Success:success failure:failure];
}

+(void)writeToDB:(NSArray*)itemArr
{

}


+(void)getDicCurVersion:(float)verion Success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure
{
    NSDictionary *parameters = @{@"job_no":[person me].job_no,
                                 @"acc_password":[person me].password,
                                 @"version_no":[NSNumber numberWithFloat:verion]
                                 };
    
    
    [NetWorkManager PostWithApiName:GET_DICTIONARY parameters:parameters success:
     ^(id responseObject)
     {
         
         NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         if ([self checkReturnStatus:resultDic Success:success failure:failure ShouldReturnWhenSuccess:NO])
         {
             NSString*vNum = [resultDic objectForKey:@"version_no"];
             vNum = [vNum substringFromIndex:1];
             float fVNum = [vNum floatValue];
             if (verion < fVNum)
             {
                 [self setDicVersion:fVNum];
                 [self writeToDB:[resultDic objectForKey:@"DictionaryNode"]];
             }
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


+(void)setDicVersion:(float)version
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setFloat:version forKey:@"DicVersion"];
    [prefs synchronize];
}

+(float)readDicVersion
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    float version =[prefs floatForKey:@"DicVersion"];
    return version;
}


+(NSArray*)getItemArrByType:(NSString*)type
{
    NSArray* arr = [[NSMutableArray alloc] init];
    return arr;
}

@end
