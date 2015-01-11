//
//  AFNMJInstance.m
//  MJ
//
//  Created by harry on 14/12/4.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import "AFNMJInstance.h"
#import "Macro.h"

@implementation AFNMJInstance

+(id<POSTMETHOD>)instance
{
    return [[AFNMJInstance alloc] init];
}


-(void)PostWithApiName:(NSString*)apiName parameters:(NSDictionary *)parameters
               success:(void (^)(id responseObject))success
               failure:(void (^)(NSError *error))failure
{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer =[AFHTTPResponseSerializer serializer];
    
    [manager POST:[NSString stringWithFormat:@"%@%@", SERVER_URL, apiName] parameters:parameters success:
     ^(AFHTTPRequestOperation *operation, id responseObject)
     {
         if (success)
         {
             success(responseObject);
         }
     }
          failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         if (failure)
         {
             failure(error);
         }
     }
     ];
}

-(void)PostImage:(UIImage*)image WithApiName:(NSString*)apiName parameters:(NSDictionary *)parameters
         success:(void (^)(id responseObject))success
         failure:(void (^)(NSError *error))failure
{
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:@"" parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
                                    {
                                        NSData*data = UIImageJPEGRepresentation(image, 1);
                                        [formData appendPartWithFormData:data name:@""];
                                        
                                    } error:nil];
    
    
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSProgress *progress = nil;
    
    
    
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:request progress:&progress completionHandler:^(NSURLResponse *response, id responseObject, NSError *error)
                                          {
                                              
                                              if (error) {
                                                  
                                                  NSLog(@"Error: %@", error);
                                                  
                                              } else {
                                                  
                                                  NSLog(@"%@ %@", response, responseObject);
                                                  
                                              }
                                              
                                          }];
    
    
    
    [uploadTask resume];
}
@end
