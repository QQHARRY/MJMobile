//
//  postFileUtils.h
//  MJ
//
//  Created by harry on 15/2/10.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface postFileUtils : NSObject

+(void)postFileWithURL:(NSURL *)url data:(NSData *)imageData Parameter:(NSDictionary*)params ServerParamName:(NSString*)paramName FileName:(NSString*)fileName  MimeType:(NSString*)mmType Success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure;
@end
