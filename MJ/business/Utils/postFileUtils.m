//
//  postFileUtils.m
//  MJ
//
//  Created by harry on 15/2/10.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//

#import "postFileUtils.h"
#import "person.h"
#import "UtilFun.h"
#import "Macro.h"

#define UTFEncode(str) [str dataUsingEncoding:NSUTF8StringEncoding]
#define BeginString @"--YY\r\n"
#define EndString @"--YY--\r\n"

@implementation postFileUtils

+(void)postFileWithURL:(NSURL *)url data:(NSData *)imageData Parameter:(NSDictionary*)params ServerParamName:(NSString*)paramName FileName:(NSString*)fileName MimeType:(NSString*)mmType Success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure;
{
    //分界线
    NSString *HTTP_FORM_BOUNDARY = @"AaB03x";
    NSString *MJboundary=[[NSString alloc]initWithFormat:@"--%@",HTTP_FORM_BOUNDARY];
    NSString *endMJboundary=[[NSString alloc]initWithFormat:@"%@--",MJboundary];
    NSString *end=[[NSString alloc]initWithFormat:@"\r\n%@",endMJboundary];

    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:10];
    
    NSMutableString *body=[[NSMutableString alloc]init];
    
    //json参数
    NSArray *keys= [params allKeys];
    for(int i=0;i<[keys count];i++)
    {
        NSString *key=[keys objectAtIndex:i];
        [body appendFormat:@"%@\r\n",MJboundary];
        [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key];
        [body appendFormat:@"%@\r\n",[params objectForKey:key]];
    }
    
    [body appendFormat:@"%@\r\n",MJboundary];
    [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n",paramName,fileName];
    [body appendFormat:@"Content-Type: image/jpeg\r\n\r\n"];
    
    NSMutableData *myRequestData=[NSMutableData data];
    [myRequestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
    [myRequestData appendData:imageData];
    [myRequestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];

    NSString *content=[[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",HTTP_FORM_BOUNDARY];
    [request setValue:content forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%ld", (long)myRequestData.length] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:myRequestData];
    [request setHTTPMethod:@"POST"];
    
   
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        sleep(1);
        if (connectionError)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (failure)
                {
                    failure(connectionError);
                }
            });
        }
        else
        {
            NSError*error;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
#ifdef DEBUG
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-variable"
             NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
#pragma clang diagnostic pop
#endif
            
            if (json && ([[json objectForKey:@"Status"] intValue] == 0 ||
                         [[json objectForKey:@"status"] intValue] == 0))
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (success)
                    {
                        success(json);
                    }
                });
                
            }
            else
            {
                if (failure)
                {
                    if (error)
                    {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            failure(error);
                        });
                    }
                    else
                    {
                        NSError*error = [NSError errorWithDomain:@"" code:[[json objectForKey:@"Status"]  intValue] userInfo:@{@"":@""}];
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            failure(error);
                        });
                    }
                    
                }
            }
        }
    }];
}



@end
