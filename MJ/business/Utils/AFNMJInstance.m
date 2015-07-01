//
//  AFNMJInstance.m
//  MJ
//
//  Created by harry on 14/12/4.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import "AFNMJInstance.h"
#import "Macro.h"
#import "person.h"
#import "UtilFun.h"

@implementation AFNMJInstance

+(id<POSTMETHOD>)instance
{
    return [[AFNMJInstance alloc] init];
}


-(NSMutableDictionary*)addBasicRequiredItemsToParamDic:(NSDictionary*)dic
{
    //if (dic)
    {
        NSMutableDictionary*dicAdded = [[NSMutableDictionary alloc] initWithDictionary:dic];
        if ([dicAdded objectForKey:@"job_no"] == nil)
        {
            [dicAdded setValue:[person me].job_no forKey:@"job_no"];
        }
        
        if ([dicAdded objectForKey:@"acc_password"] == nil)
        {
            [dicAdded setValue:[person me].password forKey:@"acc_password"];
        }
        
        if ([dicAdded objectForKey:@"DeviceID"] == nil)
        {
            [dicAdded setValue:[UtilFun getUDID] forKey:@"DeviceID"];
        }
        
        
        return dicAdded;
    }
    
    return nil;
}

-(void)PostWithApiName:(NSString*)apiName parameters:(NSDictionary *)parameters
               success:(void (^)(id responseObject))success
               failure:(void (^)(NSError *error))failure
{
    
    NSDictionary*dicParam = [self addBasicRequiredItemsToParamDic:parameters];
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer =[AFHTTPResponseSerializer serializer];
    
    NSString*strUrl = [NSString stringWithFormat:@"%@%@", SERVER_URL, apiName];
    [manager POST:strUrl parameters:dicParam success:
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
    

    NSString*url = [NSString stringWithFormat:@"%@%@", SERVER_URL, apiName];
    
#if 0
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
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
    
#else
    
    
#if 1
    
    
    NSString *docsDir;
    NSArray *dirPaths;
    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = [dirPaths objectAtIndex:0];
    NSString* databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: DIC_DB_NAME]];
//    AFHTTPRequestOperationManager *manager1 = [AFHTTPRequestOperationManager manager];
//    manager1.responseSerializer =[AFHTTPResponseSerializer serializer];
//    [manager1 POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
//     {
////         NSData*data = UIImageJPEGRepresentation(image, 0.05);
////         [formData appendPartWithFileData:data name:@"imagedata" fileName:@"aaaa" mimeType:@"image/jpeg"];
//         
//         
//         
//         
//         [formData appendPartWithFileURL:[NSURL URLWithString:databasePath] name:@"db" error:nil];
//     }
//           success:^(AFHTTPRequestOperation *operation, id responseObject)
//     {
//         if (success)
//         {
//             success(responseObject);
//         }
//     }
//           failure:^(AFHTTPRequestOperation *operation, NSError *error)
//     {
//         if (failure)
//         {
//             failure(error);
//         }
//     }];
    
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager2 = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    
    NSURLSessionUploadTask *uploadTask = [manager2 uploadTaskWithRequest:request fromFile:[NSURL URLWithString:databasePath] progress:nil completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            NSLog(@"Success: %@ %@", response, responseObject);
        }
    }];
    [uploadTask resume];
    
#else
    AFHTTPRequestOperationManager *manager1 = [AFHTTPRequestOperationManager manager];
    manager1.responseSerializer =[AFHTTPResponseSerializer serializer];
    NSString *docsDir;
    NSArray *dirPaths;
    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = [dirPaths objectAtIndex:0];
    NSString* databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: DIC_DB_NAME]];
    
    [manager1 POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileURL:databasePath name:@"db" error:nil];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Success: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
#endif
    
#endif
}
@end
