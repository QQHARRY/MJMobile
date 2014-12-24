//
//  shopBizManager.m
//  MJ
//
//  Created by harry on 14/12/24.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import "shopBizManager.h"
#import "person.h"
#import "NetWorkManager.h"
#import "Macro.h"
#import "UtilFun.h"
#import "shopItem.h"
#import "order.h"

@implementation shopBizManager

+(void)getListByType:(NSInteger)type From:(NSString*)from To:(NSString*)to Count:(int)count Success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure
{
    NSDictionary *parameters = @{@"job_no":[person me].job_no,
                                 @"acc_password":[person me].password,
                                 @"goods_type":[NSNumber numberWithInt:(int)type],
                                 @"goods_name":@"",
                                 @"goods_category":@"",
                                 @"FromID":from,
                                 @"ToID":to,
                                 @"Count":[NSNumber numberWithInt:count]
                                 };
    
    
    [NetWorkManager PostWithApiName:GET_SHOP_ITEM_LIST parameters:parameters success:
     ^(id responseObject)
     {
         NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         if ([self checkReturnStatus:resultDic Success:success failure:failure ShouldReturnWhenSuccess:NO])
         {
             success([self getArr:resultDic]);
         }
         
     }
                            failure:^(NSError *error)
     {
         failure(error);
     }];
}

+(NSArray*)getArr:(NSDictionary*)dic
{
    NSArray*annArr = [dic objectForKey:@"PersonalDeptGoodsNode"];
    NSMutableArray* arr = [[NSMutableArray alloc] init];
    
    for (NSDictionary*dic in annArr)
    {
        shopItem* obj = [[shopItem alloc] init];
        [obj initWithDictionary:dic];
        [arr  addObject:obj];
        
    }
    
    return arr;
}

+(NSArray*)getOrderArr:(NSDictionary*)dic
{
    NSArray*annArr = [dic objectForKey:@"PersonalDeptOrderNode"];
    NSMutableArray* arr = [[NSMutableArray alloc] init];
    
    for (NSDictionary*dic in annArr)
    {
        order* obj = [[order alloc] init];
        [obj initWithDictionary:dic];
        [arr  addObject:obj];
        
    }
    
    return arr;
}
+(void)addToCartByBillType:(int)billType GoodID:(NSString*)goodID BillNum:(NSInteger)count  Success:(void (^)(id responseObject))success
                   failure:(void (^)(NSError *error))failure
{
    NSDictionary *parameters = @{@"job_no":[person me].job_no,
                                 @"acc_password":[person me].password,
                                 @"DeviceID":[UtilFun getUDID],
                                 @"bill_type":[NSNumber numberWithInt:billType],
                                 @"goods_no":goodID,
                                 @"bill_num":[NSNumber numberWithInt:(int)count]
                                 };
    
    
    [NetWorkManager PostWithApiName:ADD_ITEM_TO_CART parameters:parameters success:
     ^(id responseObject)
     {
         NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         if ([self checkReturnStatus:resultDic Success:success failure:failure ShouldReturnWhenSuccess:NO])
         {
             success(nil);
         }
         
     }
                            failure:^(NSError *error)
     {
         failure(error);
     }];
}


+(void)getOrderListByType:(NSInteger)type From:(NSString*)from To:(NSString*)to Count:(int)count Success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))failure
{
    NSDictionary *parameters = @{@"job_no":[person me].job_no,
                                 @"acc_password":[person me].password,
                                 @"bill_type":[NSNumber numberWithInt:(int)type],
                                 @"FromID":from,
                                 @"ToID":to,
                                 @"Count":[NSNumber numberWithInt:count]
                                 };
    
    
    [NetWorkManager PostWithApiName:GET_ORDER_LIST parameters:parameters success:
     ^(id responseObject)
     {
         NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         if ([self checkReturnStatus:resultDic Success:success failure:failure ShouldReturnWhenSuccess:NO])
         {
             success([self getOrderArr:resultDic]);
         }
         
     }
                            failure:^(NSError *error)
     {
         failure(error);
     }];
}


+(void)cancelOrder:(NSArray*)orderArr Success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure
{
    
    NSString*strOrder = @"";
    NSInteger i = [orderArr  count];
    for (order*odr in orderArr)
    {
        i--;
        strOrder = [strOrder stringByAppendingString:odr.bill_no];
        if (i > 0)
        {
            strOrder = [strOrder stringByAppendingString:@","];
        }
        
    }
    NSDictionary *parameters = @{@"job_no":[person me].job_no,
                                 @"acc_password":[person me].password,
                                 @"DeviceID":[UtilFun getUDID],
                                 @"bill_no":strOrder,
                                 };
    
    
    [NetWorkManager PostWithApiName:CANCEL_ORDER_LIST parameters:parameters success:
     ^(id responseObject)
     {
         NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         if ([self checkReturnStatus:resultDic Success:success failure:failure ShouldReturnWhenSuccess:NO])
         {
             success([self getOrderArr:resultDic]);
         }
         
     }
                            failure:^(NSError *error)
     {
         failure(error);
     }];
}

+(void)confirmOrder:(NSArray*)orderArr Success:(void (^)(id responseObject))success
            failure:(void (^)(NSError *error))failure
{
    NSString*strOrder = @"";
    NSInteger i = [orderArr  count];
    for (order*odr in orderArr)
    {
        i--;
        strOrder = [strOrder stringByAppendingString:odr.bill_no];
        if (i > 0)
        {
            strOrder = [strOrder stringByAppendingString:@","];
        }
        
    }
    NSDictionary *parameters = @{@"job_no":[person me].job_no,
                                 @"acc_password":[person me].password,
                                 @"DeviceID":[UtilFun getUDID],
                                 @"bill_no":strOrder,
                                 };
    
    
    [NetWorkManager PostWithApiName:CONFIRM_ORDER_LIST parameters:parameters success:
     ^(id responseObject)
     {
         NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         if ([self checkReturnStatus:resultDic Success:success failure:failure ShouldReturnWhenSuccess:NO])
         {
             success([self getOrderArr:resultDic]);
         }
         
     }
                            failure:^(NSError *error)
     {
         failure(error);
     }];
}

@end
