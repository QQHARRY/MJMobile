//
//  imageStorageInfo.m
//  MJ
//
//  Created by harry on 15/6/24.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//

#import "imageStorageInfo.h"

@implementation imageStorageInfo
@synthesize fileName;
@synthesize filePath;
@synthesize thumbPath;
@synthesize status;
@synthesize topic;
@synthesize storageNo;

-(NSDictionary*)convert2Dic
{
    NSMutableDictionary*dic = [[NSMutableDictionary alloc] init];
    [dic setValue:topic forKey:@"topic"];
    [dic setValue:filePath forKey:@"filepath"];
    [dic setValue:thumbPath forKey:@"thumbpath"];
    return dic;
}

-(NSString*)convert2JSON
{
    NSDictionary*dic = [self convert2Dic];
    NSString*str = @"{";
    
    NSArray*allKeys = [dic allKeys];
    int count = allKeys.count;
    int i =  0;
    for (NSString*key in allKeys)
    {
        i++;
        NSValue*value = [dic objectForKey:key];
        str = [str stringByAppendingFormat:@"\"%@\":\"%@\"",key,value];
        if (i < count) {
            str = [str stringByAppendingString:@","];
        }
        
    }
    
    str = [str stringByAppendingString:@"}"];
    
    return str;
}
@end
