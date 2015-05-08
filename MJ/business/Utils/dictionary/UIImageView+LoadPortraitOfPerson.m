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

@implementation UIImageView (LoadPortraitOfPerson)


-(void)loadPortraitOfPerson:(person*)psn
{
    if (psn == nil || psn.photo == nil || psn.photo.length == 0) {
        return;
    }
    
    if ([psn.photo hasSuffix:@".jpg"] ||
        [psn.photo hasSuffix:@".png"])
    {
        
        NSString*strUrl = [SERVER_ADD stringByAppendingString:psn.photo];
        
        
        
        __weak typeof(self) weakSelf = self;
        
        [self setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:strUrl]] placeholderImage:[UIImage imageNamed:@"chatListCellHead.png"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            
            if (image != nil)
            {
                [weakSelf setImageToRound:image];
                
            }
            
            
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            
        }];

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
