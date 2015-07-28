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

//@interface AFNMJInstance()<AFURLResponseSerialization>
//
//
//@end


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
        
        
        if ([dicAdded objectForKey:@"DeviceType"] == nil)
        {
            [dicAdded setValue:DEVICE_IOS forKey:@"DeviceType"];
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

//- (id)responseObjectForResponse:(NSURLResponse *)response
//                           data:(NSData *)data
//                          error:(NSError *__autoreleasing *)error
//{
//    return [NSSet setWithObjects:@"text/html",@"application/json", nil];
//}

-(void)PostImage:(UIImage*)image WithApiName:(NSString*)apiName parameters:(NSDictionary *)parameters
         success:(void (^)(id responseObject))success
         failure:(void (^)(NSError *error))failure
{
    return [self AFPostImage:image WithApiName:apiName parameters:parameters success:success failure:failure];
    
    
    
    NSData * imagedata = UIImageJPEGRepresentation(image,0.2);
   
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:apiName parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:imagedata name:@"upload_file" fileName:@"upload_file" mimeType:@"image/jpeg"];
    } error:nil];
    [request addValue:@"text/html" forHTTPHeaderField:@"Accept"];
    //[request addValue:@"text/html" forHTTPHeaderField:@"Content-Type"];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    manager.responseSerializer = self;
    
    
    NSProgress *progress = nil;
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:request progress:&progress completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            NSLog(@"%@ %@", response, responseObject);
        }
    }];
    [uploadTask resume];
    

//    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
//    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
//    NSURL *URL = [NSURL URLWithString:@"http://example.com/upload"];
//    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
//    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
//        if (error) {
//            NSLog(@"Error: %@", error);
//        } else {
//            NSLog(@"%@ %@", response, responseObject);
//        }
//    }];
//    [dataTask resume];
    
    
    
//    NSString*url = apiName;
//    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
//    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:[NSOperationQueue mainQueue]];
//    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
//    [request addValue:@"image/jpeg" forHTTPHeaderField:@"Content-Type"];
//    //[request addValue:@"text/html" forHTTPHeaderField:@"Accept"];
//    [request setHTTPMethod:@"POST"];
//    [request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
//    [request setTimeoutInterval:20];
//    
//    
//    NSString*str = @"{";
//    NSMutableDictionary*muDic = [[NSMutableDictionary alloc] initWithDictionary:parameters];
//    //[muDic setValue:@"image/jpeg" forKey:@"Content-Type"];
//    [muDic setValue:@"upload_file" forKey:@"name"];
//    [muDic setValue:@"upload_file" forKey:@"filename"];
//    NSArray*allKeys = [muDic allKeys];
//    int count = (int)allKeys.count;
//    int i =  0;
//    for (NSString*key in allKeys){
//        i++;
//        NSValue*value = [muDic objectForKey:key];
//        str = [str stringByAppendingFormat:@"\"%@\":\"%@\"",key,value];
//        if (i < count) {
//            str = [str stringByAppendingString:@","];
//        }
//    }
//    str = [str stringByAppendingString:@"}"];
//    NSData *postData = [str dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
//    [request setHTTPBody:postData];
//    NSData * imagedata = UIImageJPEGRepresentation(image,0.2);
//    NSURLSessionUploadTask * uploadtask = [session uploadTaskWithRequest:request fromData:imagedata completionHandler:^(NSData *data, NSURLResponse *response, NSError *errorInfo) {
//        NSError*error;
//        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
//#ifdef DEBUG
//#pragma clang diagnostic push
//#pragma clang diagnostic ignored "-Wunused-variable"
//        NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//#pragma clang diagnostic pop
//#endif
//        
//        if (!error&&response){
//            dispatch_async(dispatch_get_main_queue(), ^{
//                if (success)
//                {
//                    success(json);
//                }
//            });
//            
//        }
//        else
//        {
//            if (failure)
//            {
//                if (error)
//                {
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        failure(error);
//                    });
//                }
//                else
//                {
//                    NSError*error = [NSError errorWithDomain:@"" code:[[json objectForKey:@"Status"]  intValue] userInfo:@{@"":@""}];
//                    
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        failure(error);
//                    });
//                }
//                
//            }
//        }
//    }];
//    [uploadtask resume];
}
-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didSendBodyData:(int64_t)bytesSent totalBytesSent:(int64_t)totalBytesSent totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend{
    
}
-(void)AFPostImage:(UIImage*)image WithApiName:(NSString*)apiName parameters:(NSDictionary *)parameters
         success:(void (^)(id responseObject))success
         failure:(void (^)(NSError *error))failure
{
    CGSize sz = image.size;
    CGFloat compressQuality = 1.0f;
    if (sz.width > 600.0f) {
        compressQuality = 600.0f/sz.width;
    }
    NSData *imageData = UIImageJPEGRepresentation(image, compressQuality);
#if 1
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manager.requestSerializer.timeoutInterval = 10;
    
    
        [formData appendPartWithFileData:imageData name:@"upload_file" fileName:@"upload_file" mimeType:@"image/jpeg"];
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        if (success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                 success(responseObject);
            });
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure){
            dispatch_async(dispatch_get_main_queue(), ^{
                failure(error);
            });
        }
    }];
    
    
    
    
    
    
#else
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    [manager POST:apiName parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData :imageData name:@"upload_file" fileName:@"upload_file" mimeType:@"image/jpeg"];
    } success:^(AFHTTPRequestOperation *operation,id responseObject) {
        NSDictionary *json = responseObject;
        if (json && ([[json objectForKey:@"Status"] intValue] == 0)){
            dispatch_async(dispatch_get_main_queue(), ^{
                if (success){
                    success(json);
                }
            });
        }else {
            if (failure){
                NSError*error = [NSError errorWithDomain:@"" code:[[json objectForKey:@"Status"]  intValue] userInfo:@{@"Description    ":@"服务器返回错误"}];
                dispatch_async(dispatch_get_main_queue(), ^{
                    failure(error);
                });
            }
        }
    } failure:^(AFHTTPRequestOperation *operation,NSError *error) {
        if (failure){
            dispatch_async(dispatch_get_main_queue(), ^{
                failure(error);
            });
        }
    }];
#endif
}
@end
