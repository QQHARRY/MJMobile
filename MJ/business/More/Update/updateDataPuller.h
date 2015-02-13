//
//  updateDataPuller.h
//  MJ
//
//  Created by harry on 15/2/12.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HouseFilter.h"
#import "HouseDetail.h"
#import "HouseParticulars.h"
#import "houseSecretParticulars.h"
#import "buildingDetails.h"
#import "versionInfo.h"


@interface updateDataPuller : NSObject

+(void)pullNewVersionSuccess:(void (^)(versionInfo *vInfo))success failure:(void (^)(NSError *error))failure;
@end
