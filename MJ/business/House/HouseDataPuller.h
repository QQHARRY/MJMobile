//
//  HouseDataPuller.h
//  MJ
//
//  Created by harry on 14/12/12.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HouseFilter.h"
#import "HouseDetail.h"
#import "HouseParticulars.h"
#import "houseSecretParticulars.h"


@interface HouseDataPuller : NSObject

+(void)pullDataWithFilter:(HouseFilter *)filter Success:(void (^)(NSArray *houseDetailList))success failure:(void (^)(NSError *error))failure;
+(void)pullAreaListDataSuccess:(void (^)(NSArray *areaList))success failure:(void (^)(NSError *error))failure;

+(void)pullHouseParticulars:(HouseDetail *)dtl Success:(void (^)(HouseParticulars *housePtl))success failure:(void (^)(NSError *error))failure;

+(void)pushImage:(UIImage*)image ToHouse:(HouseDetail *)dtl HouseParticulars:(HouseParticulars*)ptcl ImageType:(NSString*)imgType Success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;

+(void)pullHouseSecrectParticulars:(HouseDetail *)dtl Success:(void (^)(houseSecretParticulars *housePtl))success failure:(void (^)(NSError *error))failure;

+(void)pushHouseEditedParticulars:(NSDictionary *)partlDic Success:(void (^)(houseSecretParticulars *housePtl))success failure:(void (^)(NSError *error))failure;


+(void)pullBuildingByContidion:(NSDictionary *)condition Success:(void (^)(NSArray*buildingsArr))success failure:(void (^)(NSError *error))failure;
+(void)pullBuildingDetailsByContidion:(NSString *)buildingNO Success:(void (^)(NSArray*arr))success failure:(void (^)(NSError *error))failure;
@end
