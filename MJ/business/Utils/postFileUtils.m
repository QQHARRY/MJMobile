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

+(void)postFileWithURL:(NSURL *)url data:(NSData *)data Parameter:(NSDictionary*)params ServerParamName:(NSString*)paramName FileName:(NSString*)fileName MimeType:(NSString*)mmType Success:(void (^)())success failure:(void (^)(NSError *error))failure;
{

    NSString *HTTP_FORM_BOUNDARY = @"AaB03x";

    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:10];
    NSString *MJboundary=[[NSString alloc]initWithFormat:@"--%@",HTTP_FORM_BOUNDARY];
    NSString *endMJboundary=[[NSString alloc]initWithFormat:@"%@--",MJboundary];
  
    

    NSMutableString *body=[[NSMutableString alloc]init];

    NSArray *keys= [params allKeys];
    

    for(int i=0;i<[keys count];i++)
    {

        NSString *key=[keys objectAtIndex:i];
        if(![key isEqualToString:@"pic"])
        {

            [body appendFormat:@"%@\r\n",MJboundary];

            [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key];

            [body appendFormat:@"%@\r\n",[params objectForKey:key]];
        }
    }
    

    [body appendFormat:@"%@\r\n",MJboundary];

    [body appendFormat:@"Content-Disposition: form-data; name=\"imagedata\"; filename=\"1.jpg\"\r\n"];

    [body appendFormat:@"Content-Type: image/jpeg\r\n\r\n"];
    

    NSString *end=[[NSString alloc]initWithFormat:@"\r\n%@",endMJboundary];

    NSMutableData *myRequestData=[NSMutableData data];

    [myRequestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];

    [myRequestData appendData:data];

    [myRequestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
    

    NSString *content=[[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",HTTP_FORM_BOUNDARY];

    [request setValue:content forHTTPHeaderField:@"Content-Type"];

    [request setValue:[NSString stringWithFormat:@"%ld", (long)myRequestData.length] forHTTPHeaderField:@"Content-Length"];

    [request setHTTPBody:myRequestData];
    [request setHTTPMethod:@"POST"];
    
   
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError)
        {
            if (failure)
            {
                failure(connectionError);
            }
        }
        else
        {
            NSError*error;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            
            if (json && [[json objectForKey:@"Status"] intValue] == 0)
            {
                if (success)
                {
                    success();
                }
            }
            else
            {
                if (failure)
                {
                    if (error)
                    {
                        failure(error);
                    }
                    else
                    {
                        NSError*error = [NSError errorWithDomain:@"" code:[[json objectForKey:@"Status"]  intValue] userInfo:@{@"":@""}];
                        
                        failure(error);
                    }
                    
                }
            }
        }
        
        
        
        
    }];
    
   

}


+(void)postFileWithURL2:(NSURL *)url data:(NSData *)data Parameter:(NSDictionary*)params ServerParamName:(NSString*)paramName FileName:(NSString*)fileName MimeType:(NSString*)mmType Success:(void (^)())success failure:(void (^)(NSError *error))failure;
{
     NSMutableData *dataM = [NSMutableData data];
    
    [dataM appendData:UTFEncode(BeginString)];
    NSString *disposition = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", paramName, fileName];
    [dataM appendData:UTFEncode(disposition)];
    NSString *type = [NSString stringWithFormat:@"Content-Type: %@\r\n", mmType];
    [dataM appendData:UTFEncode(type)];
    [dataM appendData:UTFEncode(@"\r\n")];
    [dataM appendData:data];
    [dataM appendData:UTFEncode(@"\r\n")];
    
    [params enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [dataM appendData:UTFEncode(BeginString)];
        NSString *disposition = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", key];
        [dataM appendData:UTFEncode(disposition)];
    
        [dataM appendData:UTFEncode(@"\r\n")];
        [dataM appendData:UTFEncode(obj)];
        [dataM appendData:UTFEncode(@"\r\n")];
    }];

    [dataM appendData:UTFEncode(@"\r\n")];
  
    
    [dataM appendData:UTFEncode(EndString)];
 

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:0 timeoutInterval:2.0f];
    request.HTTPBody = dataM;
    request.HTTPMethod = @"POST";
    NSString *strLength = [NSString stringWithFormat:@"%ld", (long)dataM.length];
    [request setValue:strLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"multipart/form-data; boundary=YY" forHTTPHeaderField:@"Content-Type"];
    

    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError)
        {
            if (failure)
            {
                failure(connectionError);
            }
        }
        else
        {
            NSError*error;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            
            if (json && [[json objectForKey:@"Status"] intValue] == 0)
            {
                if (success)
                {
                    success();
                }
            }
            else
            {
                if (failure)
                {
                    if (error)
                    {
                        failure(error);
                    }
                    else
                    {
                        NSError*error = [NSError errorWithDomain:@"" code:[[json objectForKey:@"Status"]  intValue] userInfo:@{@"":@""}];
                        
                        failure(error);
                    }
                    
                }
            }
        }
        
        
        
        
    }];
}


@end
