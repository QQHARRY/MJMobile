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
#import "DataPersistence.h"
#import "Sqlite3DataPersistence.h"
#import "Macro.h"

@implementation DicItem

@synthesize dict_label;
@synthesize dict_label_type;
@synthesize dict_sort;
@synthesize dict_value;


-(NSString*)insertString
{
    NSString *sqlStr = [NSString stringWithFormat:@"INSERT INTO %@ (dict_label,dict_label_type,dict_sort,dict_value) VALUES(\"%@\",\"%@\",\"%@\",\"%@\")",DIC_TABLE_NAME,self.dict_label,self.dict_label_type,self.dict_sort,self.dict_value];
    return sqlStr;
}
+(NSString*)searchString
{
    NSString *sqlStr = [NSString stringWithFormat:@"SELECT dict_label,dict_label_type,dict_sort,dict_value from %@",DIC_TABLE_NAME];
    return sqlStr;
}

@end

@implementation dictionaryManager




+(void)updateDicSuccess:(void (^)(id responseObject))success
                failure:(void (^)(NSError *error))failure
{
    float curVer = [self readDicVersion];
    [self getDicCurVersion:curVer Success:success failure:failure];
}

+(void)writeDicToDB:(NSArray*)itemArr
{
    [self clearCurTable];
    
    NSArray*dicArr = [self getDicItemArr:itemArr];
    for (DicItem*dicItem in dicArr)
    {
        [self writeItem:dicItem];
    }
}


+(void)clearCurTable
{
    [Sqlite3DataPersistence deleteTable:DIC_TABLE_NAME];
    [Sqlite3DataPersistence createTable:DIC_TABLE_NAME];
}

+(void)writeItem:(DicItem*)item
{
    [Sqlite3DataPersistence insertObj:item ToTable:DIC_TABLE_NAME];
}
+(NSArray*)getDicItemArr:(NSArray*)arr
{
    if (arr == nil)
    {
        return nil;
    }

    NSMutableArray* dicArr = [[NSMutableArray alloc] init];
    
    for (NSDictionary*dic in arr)
    {
        DicItem* obj = [[DicItem alloc] init];
        [obj initWithDictionary:dic];
        [dicArr  addObject:obj];
        
    }
    
    return dicArr;
}

+(void)getDicCurVersion:(float)verion Success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure
{
    NSString*strVer = [NSString stringWithFormat:@"V%.2f",verion];
    NSDictionary *parameters = @{@"job_no":[person me].job_no,
                                 @"acc_password":[person me].password,
                                 @"version_no":strVer
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
                 [self writeDicToDB:[resultDic objectForKey:@"DictionaryNode"]];
                 
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
    NSString*cond = [NSString stringWithFormat:@"where dict_label_type=\"%@\" order by dict_sort asc",type];

    NSArray* arr = [Sqlite3DataPersistence seachRecordWithCondition:cond];

    return arr;
}

@end
