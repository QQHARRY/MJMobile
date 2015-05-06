//
//  MJCatch.m
//  MJ
//
//  Created by harry on 15/5/5.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//

#import "MJCatch.h"

@implementation MJCatch




+(void)storeImage:(UIImage*)image ForKey:(NSString*)key
{
    if (key == nil || image == nil || key.length == 0)
    {
        return;
    }

    
    NSData *imageData = UIImagePNGRepresentation(image);
    

    
    NSString *fullPath = [[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]  stringByAppendingPathComponent:@"CatchedImage"] stringByAppendingString:key];
    
    [imageData writeToFile:fullPath atomically:NO];

}


+(UIImage*)imageOfKey:(NSString*)key
{
    UIImage*img = nil;
    return img;
}


+(void)storePortraitImage:(UIImage*)image ForPerson:(person*)key
{
    
}




@end
