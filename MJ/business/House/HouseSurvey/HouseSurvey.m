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
#import "roleType.h"
#import "person.h"
#import "UtilFun.h"
#import "houseSurveyTableViewController.h"
#import "postFileUtils.h"
#import "HouseDetail.h"


@interface HouseSurvey()<HouseAddSurveryDelegate>

@property(strong,nonatomic)HouseDetail*houseDtl;
@property(strong,nonatomic)NSArray*roleNodeList;
@property(strong,nonatomic)NSString*no;//父图册编号
@end




@implementation HouseSurvey



-(BOOL)canAddSurveryToHouse:(HouseDetail*)house WithExistingRoleList:(NSArray*)roleList
{
    if (house == nil)
    {
        return NO;
    }
    
    if (roleList.count > 0)
    {
        for (RoleListNode* roleNode in roleList)
        {
            if ([roleNode isKindOfClass:[RoleListNode class]])
            {
                if ([roleNode.role_type intValue] == MjHouseRoleTypeHouseSurvey && ![roleNode.job_no isEqualToString:[person me].job_no])
                {
                    return NO;
                }
            }
        }
    }
    return YES;
}

-(void)startSurveyWithHouse:(HouseDetail*)house RoleList:(NSArray*)roleList InVc:(UIViewController*)viewController
{
    self.houseDtl = house;
    self.roleNodeList = roleList;
    
    if ([self canAddSurveryToHouse:house WithExistingRoleList:roleList])
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
        SHOWHUD_WINDOW
        [self getFileStorageNoSuccess:^( NSString* no) {
            HIDEHUD_WINDOW
            //第二步选择图片
            self.no = no;
            houseSurveyTableViewController*vc = [[houseSurveyTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
            ;
            vc.watchMode = ADDMODE;
            vc.houseDtl = house;
            vc.delegate = self;
            vc.parentPictureID = self.no;
            if (viewController)
            {
                [viewController.navigationController pushViewController:vc animated:YES];
            }
        } failure:^(NSError *error) {
            HIDEHUD_WINDOW
            self.no = nil;
        }];

    }
    else
    {
        PRESENTALERT(@"此房源已添加实勘,您不能再添加新的实勘", nil, nil,nil, viewController);
    }
}




-(void)getFileStorageNoSuccess:(void(^)( NSString* no))success failure:(void (^)(NSError *error))failure
{
   
    NSDictionary *parameters = nil;

    [NetWorkManager PostWithApiName:API_GET_HOUSE_IMAGE_FILE_STORAGE_NO parameters:parameters success:
     ^(id responseObject)
     {
#ifdef DEBUG
         
         NSString *jsonString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
#endif
         NSError*err = nil;
         
         NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&err];
         if ([HouseSurvey checkReturnStatus:resultDic Success:success failure:failure ShouldReturnWhenSuccess:NO])
         {
             success([resultDic objectForKey:@"fileStorageNO"]);
         }
     }
                            failure:^(NSError *error)
     {
         failure(error);
     }];
}

//-(void)uploadImages:(NSDictionary*)imageDic WithStorageNo:(NSString*)storageNo Success:(void(^)(NSArray*infoArr))success failure:(void (^)(NSError *error))failure
//{
//    SHOWHUD_WINDOW
//    NSArray*allKeys = [imageDic allKeys];
//    NSInteger imageCnt = 0;
//    for (NSString*key in allKeys)
//    {
//        NSArray*imageArrForKey = [imageDic objectForKey:key];
//        imageCnt += imageArrForKey.count;
//    }
//    volatile  NSMutableArray*infoArr = [[NSMutableArray alloc] initWithCapacity:imageCnt];
//    volatile __block int succeedCount = 0;
//    
//    
//    for (NSString*key in allKeys)
//    {
//        NSArray*imageArrForKey = [imageDic objectForKey:key];
//        for (UIImage*image in imageArrForKey)
//        {
//            [self uploadImage:image WithStorageNo:storageNo Topic:key Success:^(imageStorageInfo* info) {
//                
//                info.topic = key;
//                info.storageNo = storageNo;
//                
//                succeedCount++;
//                
//                @synchronized(infoArr)
//                {
//                    [infoArr addObject:info];
//                    
//                    if (succeedCount == imageCnt)
//                    {
//                        HIDEHUD_WINDOW
//                        success((NSArray*)infoArr);
//                    }
//                }
//                
//            } failure:^(NSError *error) {
//                succeedCount++;
//                if (succeedCount == imageCnt)
//                {
//                    HIDEHUD_WINDOW
//                    success((NSArray*)infoArr);
//                }
//            }];
//        }
//    }
//}
//
//-(void)uploadImage:(UIImage*)image WithStorageNo:(NSString*)storageNo Topic:(NSString*)topic Success:(void(^)(imageStorageInfo* info))success failure:(void (^)(NSError *error))failure
//{
//    //filePath:上传图片需要制定一个相对路径,路径生成规则为:“surveyPhotos”＋上传时间+父图册编号+Topic,如:surveyPhotos/2015/06/16/0000000006/zt/
//    //其中Topic为图片类型,比如主图(zt),户型图(hxt),室内图(snt),自拍图(zpt)
//    //
//    //fileSize 指定服务器处理后,大图的尺寸，字符串格式,在美嘉系统中大图统一使用尺寸为："600,450"
//    //
//    //thumbSize 指定服务器处理后,缩略图的尺寸，字符串格式,在美嘉系统中缩略图统一使用尺寸为："260,195"
//    //
//    //图片服务器会把图片保存在你发过去的路径下，然后给图片重新命个名，给你返回回来，返回来的格式是 ：（原始图的路径）/surveyPhotos/2015/06/16/0000000006/zt/ea26aca99ebe77fa53a328fd8173469213692683_600x450.jpg
//    //
//    //缩略图/surveyPhotos/2015/06/16/0000000006/zt/ea26aca99ebe77fa53a328fd8173469216328369_260x195.jpg
//    
//    NSMutableDictionary*paramDic = [[NSMutableDictionary alloc] init];
//    NSURL*url = [NSURL URLWithString:IMAGE_SERVER_URL];
//    NSData*data = UIImageJPEGRepresentation(image, 1.0);
//    NSDate *date = [NSDate date];
//    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
//    NSDateComponents *comps = [[NSDateComponents alloc] init];
//    NSInteger unitFlags = NSYearCalendarUnit |
//    NSMonthCalendarUnit |
//    NSDayCalendarUnit |
//    NSWeekdayCalendarUnit |
//    NSHourCalendarUnit |
//    NSMinuteCalendarUnit |
//    NSSecondCalendarUnit;
//    comps = [calendar components:unitFlags fromDate:date];
//    int year= (int)[comps year];
//    int month = (int)[comps month];
//    int day = (int)[comps day];
//    
//    NSString*filePath = [NSString stringWithFormat:@"surveyPhotos/%d/%d/%d/%@/%@/",year,month,day,self.no,topic];
//    [paramDic setValue:filePath forKey:@"filePath"];
//    [paramDic setValue:@"600,450" forKey:@"fileSize"];
//    [paramDic setValue:@"260,195" forKey:@"thumbSize"];
//    
//    
//    [postFileUtils postFileWithURL:url data:data  Parameter:paramDic ServerParamName:@"upload_file" FileName:@"upload_file" MimeType:@"image/jpeg" Success:^(id responseObj){
//    
//    } failure:^(NSError *error) {
//        
//    }];
//}


-(void)saveImageWithInfoArr:(NSArray*)arr Remark:(NSString*)remark Success:(void(^)(id result))success failure:(void (^)(NSError *error))failure
{
    NSMutableString*imageArrJson = [[NSMutableString alloc] initWithString:@"["];
    for (NSString*str in arr)
    {
        [imageArrJson appendString:str];
        [imageArrJson appendString:@","];
    }

    NSUInteger location = [imageArrJson length]-1;
    NSRange range       = NSMakeRange(location, 1);
    [imageArrJson replaceCharactersInRange:range withString:@"]"];
    
    NSDictionary*param = @{
                           @"trade_no":self.houseDtl.trade_no,
                           @"fileStorageNO":self.no,
                           @"images":imageArrJson,
                           @"remark":(remark==nil)?@"":remark
                           
                           };

    
    [NetWorkManager PostWithApiName:API_ADD_APP_SURVERY_INFO parameters:param success:
     ^(id responseObject)
     {
#ifdef DEBUG
         
         NSString *jsonString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
#endif
         NSError*err = nil;
         
         NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&err];
         if ([HouseSurvey checkReturnStatus:resultDic Success:success failure:failure ShouldReturnWhenSuccess:NO])
         {
             success(nil);
         }
     }
                            failure:^(NSError *error)
     {
         failure(error);
     }];
    
}



-(void)hasSelectZt:(NSArray *)ztArr Snt:(NSArray *)sntArr Hxt:(NSArray *)hxtArr Zpt:(NSArray *)zptArr Remark:(NSString *)remark ForHouse:(HouseDetail *)house
{
    NSMutableArray*imageArr = [[NSMutableArray alloc] init];
    NSMutableArray*arrArr = [[NSMutableArray alloc ]init];
    if (ztArr)[imageArr addObjectsFromArray:ztArr];
    if (sntArr)[imageArr addObjectsFromArray:sntArr];
    if (hxtArr)[imageArr addObjectsFromArray:hxtArr];
    if (zptArr)[imageArr addObjectsFromArray:zptArr];
    
    for (imageStorageInfo*info in imageArr)
    {
        [arrArr addObject:[info convert2JSON]];
    }
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:arrArr
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData
                                                 encoding:NSUTF8StringEncoding];
    //保存到MOS
    [self saveImageWithInfoArr:arrArr Remark:remark Success:^(id result) {
        
    } failure:^(NSError *error) {
        
    }];
    
}

@end
