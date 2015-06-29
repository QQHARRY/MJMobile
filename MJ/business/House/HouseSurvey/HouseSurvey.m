//
//  HouseSurvey.m
//  MJ
//
//  Created by harry on 15/6/24.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//

#import "HouseSurvey.h"
#import "person.h"
#import "NetWorkManager.h"
#import "Macro.h"
#import "imageStorageInfo.h"
#import "UtilFun.h"

@implementation HouseSurvey


+(void)addHouseSurvery:(NSDictionary*)imageDic Remark:(NSString*)remark Success:(void(^)(id obj))success failure:(void (^)(NSError *error))failure
{
    //新增房源，现在新增房源已经不包含图片信息了。图片通过房源实勘添加
//#define API_ADD_ESTATE @"business/addEstate"
    //房源实勘三部曲
    //第一步:39. 图册父编号
//#define API_GET_HOUSE_IMAGE_FILE_STORAGE_NO @"business/getfileStorageNO"
    //第二步:将图片,父编号，房源编号上传到图片服务器，获取图片路径，缩略图路径,这里需要使用图片服务器提供的接口
//#define IMAGE_SERVE_API_SAVE_IMAGE    IMAGE_SERVER_URL
    //第三步:40. 保存实勘等在图片服务器存贮路径等信息
//#define API_ADD_APP_SURVERY_INFO @"business/sav
    
    //第一步获取图册父编号
    [self getFileStorageNoSuccess:^( NSString* no) {
        //第二步上传图片
        [self uploadImages:imageDic WithStorageNo:no Success:^(NSArray *infoArr)
        {
            //第三步保存到MOS
            [self saveImageWithInfoArr:infoArr Remark:remark Success:^(id result) {
                
            } failure:^(NSError *error) {
                
            }];
        } failure:^(NSError *error) {
            
        }]; 
    } failure:^(NSError *error) {
        
    }];
}


+(void)getFileStorageNoSuccess:(void(^)( NSString* no))success failure:(void (^)(NSError *error))failure
{
   
    NSDictionary *parameters = @{@"job_no":[person me].job_no,
                                 @"acc_password":[person me].password,
                                  @"DeviceID":[UtilFun getUDID],
                                 };

    

    
  
    [NetWorkManager PostWithApiName:API_GET_HOUSE_IMAGE_FILE_STORAGE_NO parameters:parameters success:
     ^(id responseObject)
     {
         //NSString *jsonString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
//         jsonString =  @"{\"Status\":\"0\",\"ErrorInfo\":\"\",\"fileStorageNO\":0x03}";
//         responseObject = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
         NSError*err = nil;
         
         NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&err];
         if ([self checkReturnStatus:resultDic Success:success failure:failure ShouldReturnWhenSuccess:NO])
         {
             success([resultDic objectForKey:@"fileStorageNO"]);
         }
         
     }
                            failure:^(NSError *error)
     {
         failure(error);
     }];
}

+(void)uploadImages:(NSDictionary*)imageDic WithStorageNo:(NSString*)storageNo Success:(void(^)(NSArray*infoArr))success failure:(void (^)(NSError *error))failure
{
    NSArray*allKeys = [imageDic allKeys];
    NSInteger imageCnt = 0;
    for (NSString*key in allKeys)
    {
        NSArray*imageArrForKey = [imageDic objectForKey:key];
        imageCnt += imageArrForKey.count;
    }
    volatile NSMutableArray*infoArr = [[NSMutableArray alloc] initWithCapacity:imageCnt];
    
    
    for (NSString*key in allKeys)
    {
        NSArray*imageArrForKey = [imageDic objectForKey:key];
        for (UIImage*image in imageArrForKey)
        {
            [self uploadImage:image WithStorageNo:storageNo Topic:key Success:^(imageStorageInfo* info) {
                
                info.topic = key;
                info.storageNo = storageNo;
            
                @synchronized(infoArr)
                {
                    [infoArr addObject:info];
                    
                    if (infoArr.count == imageCnt)
                    {
                        success((NSArray*)infoArr);
                    }
                }
                
            } failure:^(NSError *error) {
                
            }];
        }
    }
}

+(void)uploadImage:(UIImage*)image WithStorageNo:(NSString*)storageNo Topic:(NSString*)topic Success:(void(^)(imageStorageInfo* info))success failure:(void (^)(NSError *error))failure
{
    
}


+(void)saveImageWithInfoArr:(NSArray*)arr Remark:(NSString*)remark Success:(void(^)(id result))success failure:(void (^)(NSError *error))failure
{
    
}


@end
