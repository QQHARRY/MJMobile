//
//  UIImageView+LoadPortraitOfPerson.m
//  MJ
//
//  Created by harry on 15/5/8.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//

#import "UIImageView+LoadPortraitOfPerson.h"
#import "Macro.h"
#import "UIImageView+AFNetworking.h"
#import "UIImageView+RoundImage.h"
#import "EaseMobFriendsManger.h"
#import "NSString+isValidPhotoUrl.h"
#import "UIImageView+EMWebCache.h"


#define STORED_IMAGE_H 200
#define STORED_IMAGE_W 200

@implementation UIImageView (LoadPortraitOfPerson)


-(void)loadPortraitOfPerson:(person*)psn
{
    [self loadPortraitOfPerson:psn withDefault:[UIImage imageNamed:@"个人详情默认头像.png"] round:YES];
}

-(void)loadPortraitOfPerson:(person*)psn round:(BOOL)round
{
    [self loadPortraitOfPerson:psn withDefault:[UIImage imageNamed:@"个人详情默认头像.png"] round:round];
}

-(void)loadPortraitOfPerson:(person*)psn withDefault:(UIImage*)image
{
    [self loadPortraitOfPerson:psn withDefault:image round:YES];
}

-(void)loadPortraitOfPerson:(person*)psn withDefault:(UIImage*)image round:(BOOL)round
{
    
    if (psn != nil && psn.photo != nil && [psn.photo isValidPhotoUrl])
    {
        
        NSString*strUrl = [SERVER_ADD stringByAppendingString:psn.photo];
        
        
        __weak typeof(self) weakSelf = self;
        
//        [self setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:strUrl]] placeholderImage:image success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
//            
//            if (image.size.height > STORED_IMAGE_H && image.size.width > STORED_IMAGE_W)
//            {
//                
//            }
//            
//            if (image != nil)
//            {
//                [weakSelf setImageToRound:image];
//                
//            }
//            
//            
//        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
//            
//        }];
        
        
        [self sd_setImageWithURL:[NSURL URLWithString:strUrl] placeholderImage:image completed:^(UIImage *image, NSError *error, EMSDImageCacheType cacheType, NSURL *imageURL) {
            if (image != nil && error == nil)
            {
                if (round)
                {
                    [weakSelf setImageToRound:image];
                }
                else
                {
                    weakSelf.image = image;
                }
                
            }
        }];
        
    }
    else
    {
        [self setImage:image];
    }
}



-(void)loadPortraitOfUser:(NSString*)userName
{
    [[EaseMobFriendsManger sharedInstance] getFriendByUserName:userName Success:^(BOOL success, person *psn) {
        if (success)
        {
            [self loadPortraitOfPerson:psn];
        }
    }];
}

-(void)quickLoadPortraitOfUser:(NSString*)userName
{
    person*psn = [[EaseMobFriendsManger sharedInstance] getFriendByUserName:userName];
    [self loadPortraitOfPerson:psn];
}
@end
