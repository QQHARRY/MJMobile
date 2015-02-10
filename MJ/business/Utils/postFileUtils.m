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
        NSString *disposition = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n", key];
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
            
            if ([[json objectForKey:@"status"] intValue] == 0)
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
                    failure(nil);
                }
            }
        }
        
        
        
        
    }];
}


@end
