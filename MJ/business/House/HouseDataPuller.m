//
//  HouseDataPuller.m
//  MJ
//
//  Created by harry on 14/12/12.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import "HouseDataPuller.h"
#import "Macro.h"
#import "person.h"
#import "NetWorkManager.h"
#import "HouseDetail.h"
#import "bizManager.h"
#import "UtilFun.h"
#import "AFNetworking.h"
#import "buildings.h"
#import "building.h"
#import "postFileUtils.h"
#import <objc/runtime.h>
#import "dictionaryManager.h"
#import "houseUnit.h"
#import "RoleListNode.h"

@implementation HouseDataPuller



+(NSDictionary*)paramDictionaryFromFilter:(HouseFilter*)filter
{
    NSMutableDictionary*dic = [[NSMutableDictionary alloc] init];
    Class cls = [filter class];
    unsigned int ivarsCnt = 0;
    Ivar *ivars = class_copyIvarList(cls, &ivarsCnt);
    
    for (const Ivar *p = ivars; p < ivars + ivarsCnt; ++p)
    {
        NSString *key = [NSString stringWithUTF8String:ivar_getName(*p)];
        id value = object_getIvar(filter, *p);
        if (value && [value isKindOfClass:[NSString class]] &&
            ((NSString*)value).length > 0)
        {
            [dic setValue:value forKey:key];
        }
    }
    
    free(ivars);
    
    return dic;
}

+(void)pullDataWithFilter:(HouseFilter *)filter Success:(void (^)(NSArray *houseDetailList))success failure:(void (^)(NSError *error))failure;
{
    assert(filter);
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:[person me].job_no forKey:@"job_no"];
    [param setValue:[person me].password forKey:@"acc_password"];
    
    
    NSDictionary*dic = [filter convert2Dic];
    [param addEntriesFromDictionary:dic];
    
    
#if 0
    
    
//    if (filter.consignment_type && filter.consignment_type.length > 0)
//    {
//        [param setValue:filter.consignment_type forKey:@"consignment_type"];
//    }
//    if (filter.trade_type && filter.trade_type.length > 0)
//    {
//        [param setValue:filter.trade_type forKey:@"trade_type"];
//    }
//    if (filter.sale_state && filter.sale_state.length > 0)
//    {
//        [param setValue:filter.sale_state forKey:@"sale_state"];
//    }
//    if (filter.lease_state && filter.lease_state.length > 0)
//    {
//        [param setValue:filter.lease_state forKey:@"lease_state"];
//    }
//    if (filter.hall_num && filter.hall_num.length > 0)
//    {
//        [param setValue:filter.hall_num forKey:@"hall_num"];
//    }
//    if (filter.room_num && filter.room_num.length > 0)
//    {
//        [param setValue:filter.room_num forKey:@"room_num"];
//    }
//    if (filter.buildname && filter.buildname.length > 0)
//    {
//        [param setValue:filter.buildname forKey:@"buildname"];
//    }
//    if (filter.unit_name && filter.unit_name.length > 0)
//    {
//        [param setValue:filter.unit_name forKey:@"house_unit"];
//    }
//    if (filter.house_floor && filter.house_floor.length > 0)
//    {
//        [param setValue:filter.house_floor forKey:@"house_fluor"];
//    }
//    if (filter.house_tablet && filter.house_tablet.length > 0)
//    {
//        [param setValue:filter.house_tablet forKey:@"house_tablet"];
//    }
//    if (filter.house_driect && filter.house_driect.length > 0)
//    {
//        [param setValue:filter.house_driect forKey:@"house_driect"];
//    }
//    if (filter.structure_area_from && filter.structure_area_from.length > 0)
//    {
//        [param setValue:filter.structure_area_from forKey:@"structure_area_from"];
//    }
//    if (filter.structure_area_to && filter.structure_area_to.length > 0)
//    {
//        [param setValue:filter.structure_area_to forKey:@"structure_area_to"];
//    }
//    if (filter.house_area && filter.house_area.length > 0)
//    {
//        [param setValue:filter.house_area forKey:@"housearea"];
//    }
//    if (filter.house_urban && filter.house_urban.length > 0)
//    {
//        [param setValue:filter.house_urban forKey:@"houseurban"];
//    }
//    if (filter.fitment_type && filter.fitment_type.length > 0)
//    {
//        [param setValue:filter.fitment_type forKey:@"fitment_type"];
//    }
//    if (filter.house_floor_from && filter.house_floor_from.length > 0)
//    {
//        [param setValue:filter.house_floor_from forKey:@"house_floor_from"];
//    }
//    if (filter.house_floor_to && filter.house_floor_to.length > 0)
//    {
//        [param setValue:filter.house_floor_to forKey:@"house_floor_to"];
//    }
//    if (filter.sale_value_from && filter.sale_value_from.length > 0)
//    {
//        [param setValue:filter.sale_value_from forKey:@"sale_value_from"];
//    }
//    if (filter.sale_value_to && filter.sale_value_to.length > 0)
//    {
//        [param setValue:filter.sale_value_to forKey:@"sale_value_to"];
//    }
//    if (filter.lease_value_from && filter.lease_value_from.length > 0)
//    {
//        [param setValue:filter.lease_value_from forKey:@"lease_value_from"];
//    }
//    if (filter.lease_value_to && filter.lease_value_to.length > 0)
//    {
//        [param setValue:filter.lease_value_to forKey:@"lease_value_to"];
//    }
//    if (filter.Keyword && filter.Keyword.length > 0)
//    {
//        [param setValue:filter.Keyword forKey:@"Keyword"];
//    }
//    if (filter.FromID && filter.FromID.length > 0)
//    {
//        [param setValue:filter.FromID forKey:@"FromID"];
//    }
//    if (filter.ToID && filter.ToID.length > 0)
//    {
//        [param setValue:filter.ToID forKey:@"ToID"];
//    }
//    if (filter.Count && filter.Count.length > 0)
//    {
//        [param setValue:filter.Count forKey:@"Count"];
//    }
//    if (filter.search_job_no && filter.search_job_no.length > 0)
//    {
//        [param setValue:filter.search_job_no forKey:@"search_job_no"];
//    }
//    if (filter.search_dept_no && filter.search_dept_no.length > 0)
//    {
//        [param setValue:filter.search_dept_no forKey:@"search_dept_no"];
//    }
#endif
    [NetWorkManager PostWithApiName:API_HOUSE_LIST parameters:param success:^(id responseObject)
     {
         NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         if ([bizManager checkReturnStatus:resultDic Success:success failure:failure ShouldReturnWhenSuccess:NO])
         {
             NSArray *src = [resultDic objectForKey:@"EstateNode"];
             NSMutableArray *dst = [NSMutableArray array];
             for (NSDictionary *d in src)
             {
                 HouseDetail *o = [[HouseDetail alloc] init];
                 [o initWithDictionary:d];
                 [dst addObject:o];
             }
             success(dst);
         }
     }
                            failure:^(NSError *error)
     {
         failure(error);
     }];
}

+(void)pullAreaListDataSuccess:(void (^)(NSArray *areaList))success failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:[person me].job_no forKey:@"job_no"];
    [param setValue:[person me].password forKey:@"acc_password"];
    
    [NetWorkManager PostWithApiName:API_AREA_LIST parameters:param success:^(id responseObject)
     {
         NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         if ([bizManager checkReturnStatus:resultDic Success:success failure:failure ShouldReturnWhenSuccess:NO])
         {
            NSArray *src = [resultDic objectForKey:@"AreaNode"];
            NSMutableArray *dst = [NSMutableArray array];
            // search area
             for (NSDictionary *dict in src)
             {
                 //只取西安市的.西安市的编号为8
                 if ([[dict valueForKey:@"area_pno"] isEqualToString:@"8"])
                 {
                     NSDictionary *areaDict = @{@"no" : [dict valueForKey:@"area_cno"],
                                                @"dict" : dict,
                                                @"sections" : [NSMutableArray array]};
                     [dst addObject:areaDict];
                 }
             }
             // search section
             for (NSDictionary *dict in src)
             {
                 for (NSDictionary *areaDict in dst)
                 {
                     if ([[dict valueForKey:@"area_pno"] isEqualToString:[areaDict objectForKey:@"no"]])
                     {
                         [[areaDict objectForKey:@"sections"] addObject:dict];
                         break;
                     }
                 }
             }
             success(dst);
         }
     }
                            failure:^(NSError *error)
     {
         failure(error);
     }];
}



+(void)pullHouseParticulars:(HouseDetail *)dtl Success:(void (^)(HouseParticulars *housePtl,NSArray*roleList))success failure:(void (^)(NSError *error))failure
{
    NSDictionary *parameters = @{@"job_no":[person me].job_no,
                                 @"acc_password":[person me].password,
                                 @"trade_no":dtl.trade_no,
                                 };
    
    
    [NetWorkManager PostWithApiName:API_HOUSE_PARTICULARS parameters:parameters success:
     ^(id responseObject)
     {
         NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         if ([bizManager checkReturnStatus:resultDic Success:nil failure:nil ShouldReturnWhenSuccess:NO])
         {
             HouseParticulars*housePtcl = [[HouseParticulars alloc] init];
             [housePtcl initWithDictionary:[[resultDic  objectForKey:@"EstateDetailsNode"] objectAtIndex:0]];
             
             NSMutableArray*roleList = [[NSMutableArray alloc] init];
             NSArray*roleListNode = [resultDic objectForKey:@"RoleListNode"];
             for (NSDictionary*dicTmp in roleListNode)
             {
                 RoleListNode*node = [[RoleListNode alloc] init];
                 [node initWithDictionary:dicTmp];
                 [roleList addObject:node];
             }
             
             
             
             NSArray*tradeTypeDicArr = [dictionaryManager getItemArrByType:DIC_TRADE_TYPE];
             
             
             for (DicItem *di in tradeTypeDicArr)
             {
                 if ([di.dict_value isEqualToString:housePtcl.trade_type])
                 {
                     housePtcl.trade_type = di.dict_label;
                     break;
                 }
             }
            
             
             success(housePtcl,roleList);
         }
         else
         {
             failure(nil);
         }
         
     }
                            failure:^(NSError *error)
     {
         failure(error);
     }];
}

+(void)pullHouseSecrectParticulars:(HouseDetail *)dtl Success:(void (^)(houseSecretParticulars *housePtl))success failure:(void (^)(NSError *error))failure
{
    NSDictionary *parameters = @{@"job_no":[person me].job_no,
                                 @"acc_password":[person me].password,
                                 @"trade_no":dtl.trade_no,
                                 };
    
    
    [NetWorkManager PostWithApiName:API_HOUSE_SECRET_PARTICULARS parameters:parameters success:
     ^(id responseObject)
     {
         NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         if ([bizManager checkReturnStatus:resultDic Success:success failure:failure ShouldReturnWhenSuccess:NO])
         {
             houseSecretParticulars*housePtcl = [[houseSecretParticulars alloc] init];
             [housePtcl initWithDictionary:[resultDic  objectForKey:@"EstateSecretNode"]];
             
             
             success(housePtcl);
         }
         
     }
                            failure:^(NSError *error)
     {
         failure(error);
     }];
}


+(void)pushHouseEditedParticulars:(NSDictionary *)partlDic Success:(void (^)(houseSecretParticulars *housePtl))success failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary*mutDic = [[NSMutableDictionary alloc] initWithDictionary:partlDic];
    [mutDic setValue:[person me].job_no forKey:@"job_no"];
    [mutDic setValue:[person me].password forKey:@"acc_password"];
    [mutDic setValue:[UtilFun getUDID] forKey:@"DeviceID"];
    
    [NetWorkManager PostWithApiName:API_HOUSE_EDIT_PARTICULARS parameters:mutDic success:
     ^(id responseObject)
     {
         NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         if ([bizManager checkReturnStatus:resultDic Success:success failure:failure ShouldReturnWhenSuccess:NO])
         {
             
             success(nil);
         }
         
     }
                            failure:^(NSError *error)
     {
         failure(error);
     }];
}

+(void)pullBuildingByContidion:(NSDictionary *)condition Success:(void (^)(NSArray*buildingsArr))success failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary*mutDic = [[NSMutableDictionary alloc] initWithDictionary:condition];
    [mutDic setValue:[person me].job_no forKey:@"job_no"];
    [mutDic setValue:[person me].password forKey:@"acc_password"];


    
    [NetWorkManager PostWithApiName:API_HOUSE_GET_BUILDINGS_LIST parameters:mutDic success:
     ^(id responseObject)
     {
         NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         if ([bizManager checkReturnStatus:resultDic Success:success failure:failure ShouldReturnWhenSuccess:NO])
         {
             NSMutableArray*buildingsArr = [[NSMutableArray alloc] init];
             NSArray*arr = [resultDic objectForKey:@"BuildingListNode"];
             if (arr)
             {
                 for (NSDictionary*bldDic in arr)
                 {
                     buildings*bld = [[buildings alloc] init];
                     [bld initWithDictionary:bldDic];
                     [buildingsArr addObject:bld];
                 }
             }
             success(buildingsArr);
         }
         
     }
                            failure:^(NSError *error)
     {
         failure(error);
     }];
}

+(void)pullBuildingDetailsByBuildingNO:(NSString *)buildingNO Success:(void (^)(buildingDetails*dtl, NSArray*arr))success failure:(void (^)(NSError *error))failure
{
    NSDictionary *parameters = @{@"job_no":[person me].job_no,
                                 @"acc_password":[person me].password,
                                 @"domain_no":buildingNO,
                                 };
    
    
    [NetWorkManager PostWithApiName:API_HOUSE_GET_BULDINGS_DETAILS parameters:parameters success:
     ^(id responseObject)
     {
         NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];

             buildingDetails*dtl = [[buildingDetails alloc] init];
             [dtl initWithDictionary:[[resultDic objectForKey:@"EstateBuildingsDetailsNode"] objectAtIndex:0]];
             
             NSMutableArray*buildingsArr = [[NSMutableArray alloc] init];
             NSArray*arr = [resultDic objectForKey:@"EstateBuildsDetailsNode"];
             if (arr)
             {
                 for (NSDictionary*bldDic in arr)
                 {
                     building*bld = [[building alloc] init];
                     [bld initWithDictionary:bldDic];
                     [buildingsArr addObject:bld];
                 }
             }

         success(dtl,buildingsArr);
     }
                            failure:^(NSError *error)
     {
         failure(error);
     }];
}

+(void)pullIsHouseExisting:(NSDictionary *)dic Success:(void (^)(HouseParticulars*hosuePtl))success failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary*mutDic = [[NSMutableDictionary alloc] initWithDictionary:dic];
    [mutDic setValue:[person me].job_no forKey:@"job_no"];
    [mutDic setValue:[person me].password forKey:@"acc_password"];

    [NetWorkManager PostWithApiName:API_HOUSE_IS_ESTATE_EXISTING parameters:mutDic success:
     ^(id responseObject)
     {
         NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         ([self checkReturnStatus:resultDic Success:^(id responseObject)
         {
             
             NSString*status = [resultDic objectForKey:@"TradeStatus"];
             NSInteger iStatus = [status intValue];
             HouseParticulars*housePtl = [[HouseParticulars alloc] init];
             if (iStatus == 1 || iStatus == 2 || iStatus == 3)
             {
                 NSDictionary*houseInfoNode = [resultDic objectForKey:@"HouseInfoNode"];
                 if ([houseInfoNode isKindOfClass:[NSArray class]] || [houseInfoNode isKindOfClass:[NSMutableArray class]])
                 {
                     houseInfoNode = [[resultDic objectForKey:@"HouseInfoNode"] objectAtIndex:0];
                 }
                 
                 //NSDictionary* houseInfoNode = [[resultDic objectForKey:@"HouseInfoNode"] objectAtIndex:0];
                 if (houseInfoNode)
                 {
                     [housePtl initWithDictionary:houseInfoNode];
                 }
                 else
                 {
                     
                 }
             }
             
             //注意这里为了方便,将status值保存到了trade_type变量中
             //stauts值的含义见文档接口29
             housePtl.trade_type = status;
             success(housePtl);
         }
                          failure:^(NSError *error)
         {
             failure(error);
         } ShouldReturnWhenSuccess:YES]);
         
         
     }
                            failure:^(NSError *error)
     {
         failure(error);
     }];
}


+(void)pushImage:(UIImage*)image ToHouse:(HouseDetail *)dtl HouseParticulars:(HouseParticulars*)ptcl ImageType:(NSString*)imgType Success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure
{
    NSData*data = UIImageJPEGRepresentation(image, 0.5);
    NSDictionary *parameters = @{@"job_no":[person me].job_no,
                                 @"acc_password":[person me].password,
                                 @"DeviceID":[UtilFun getUDID],
                                 @"obj_type":@"房源",
                                 @"obj_no":ptcl.buildings_picture,
                                 @"imageType":imgType,
//                                 @"imagedata":@"",
                                 };
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager POST:[NSString stringWithFormat:@"%@%@", SERVER_URL, ADD_IMAGE] parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            [formData appendPartWithFormData:data name:@"imagedata"];
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            success(nil);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            failure(nil);
        }];
    
//    [NetWorkManager PostImage:data WithApiName:ADD_IMAGE parameters:parameters success:^(id responseObject)
//    {
//        
//        NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
//        if ([bizManager checkReturnStatus:resultDic Success:success failure:failure ShouldReturnWhenSuccess:NO])
//        {
//            
//            
//            
//            success(nil);
//        }
//    } failure:^(NSError *error) {
//        failure(error);
//    }];
    
//    [NetWorkManager PostImage:image WithApiName:ADD_IMAGE parameters:parameters success:
//     ^(id responseObject)
//     {
//         NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
//         if ([bizManager checkReturnStatus:resultDic Success:success failure:failure ShouldReturnWhenSuccess:NO])
//         {
//             
//             
//             
//             success(nil);
//         }
//         
//     }
//                      failure:^(NSError *error)
//     {
//         failure(error);
//     }];

    
    
}


+(void)pushAddHouse:(NSDictionary *)partlDic Success:(void (^)(NSString *trade_no,NSString *buildings_picture))success failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary*mutDic = [[NSMutableDictionary alloc] initWithDictionary:partlDic];
    [mutDic setValue:[person me].job_no forKey:@"job_no"];
    [mutDic setValue:[person me].password forKey:@"acc_password"];
    [mutDic setValue:[UtilFun getUDID] forKey:@"DeviceID"];
    [mutDic setValue:[person me].department_no forKey:@"dept_no"];
    
    [NetWorkManager PostWithApiName:API_ADD_ESTATE parameters:mutDic success:
     ^(id responseObject)
     {
         NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         if ([bizManager checkReturnStatus:resultDic Success:nil failure:failure ShouldReturnWhenSuccess:NO])
         {
             success(nil,nil);
         }
         
         
     }
                            failure:^(NSError *error)
     {
         failure(error);
     }];
}

+(void)pushImage:(UIImage*)image TradeNo:(NSString *)tradeNO PictureNO:(NSString*)picNO Type:(NSString*)type Success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure
{
    NSDictionary *parameters = @{@"job_no":[person me].job_no,
                                 @"acc_password":[person me].password,
                                 @"DeviceID":[UtilFun getUDID],
                                 @"obj_type":@"房源",
                                 @"obj_no":picNO,
                                 @"imageType":type,
                                 };
    
    NSData*data = UIImageJPEGRepresentation(image, 0.5);
    
    [postFileUtils postFileWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", SERVER_URL, ADD_IMAGE] ] data:data Parameter:parameters ServerParamName:@"imagedata" FileName:@"" MimeType:@"image/jpeg" Success:^(id responseObj){
        {
            
            success(nil);
            
        }
    } failure:^(NSError *error) {
        {
            
            failure(error);
        }
    }];
}


+(void)pullHouseUnitDetailsByBuilding:(NSString *)buildingNo Success:(void (^)(NSArray*unitsArr))success failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary*mutDic = [[NSMutableDictionary alloc] init];
    [mutDic setValue:[person me].job_no forKey:@"job_no"];
    [mutDic setValue:[person me].password forKey:@"acc_password"];
    [mutDic setValue:buildingNo forKey:@"building_no"];
    
    
    [NetWorkManager PostWithApiName:API_HOUSE_GET_HOUSEUNIT_DETAILS parameters:mutDic success:
     ^(id responseObject)
     {
         NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         if ([bizManager checkReturnStatus:resultDic Success:success failure:failure ShouldReturnWhenSuccess:NO])
         {
             NSMutableArray*houseUnitsArr = [[NSMutableArray alloc] init];
             NSArray*arr = [resultDic objectForKey:@"EstateUnitsDetailsNode"];
             if (arr)
             {
                 for (NSDictionary*houseUnitDic in arr)
                 {
                     houseUnit*unt = [[houseUnit alloc] init];
                     [unt initWithDictionary:houseUnitDic];
                     [houseUnitsArr addObject:unt];
                 }
             }
             success(houseUnitsArr);
         }
         
     }
                            failure:^(NSError *error)
     {
         failure(error);
     }];
}



@end
