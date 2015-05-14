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

@implementation UIImageView (LoadPortraitOfPerson)


-(void)loadPortraitOfPerson:(person*)psn
{
    [self loadPortraitOfPerson:psn withDefault:[UIImage imageNamed:@"chatListCellHead.png"]];
}

-(void)loadPortraitOfPerson:(person*)psn withDefault:(UIImage*)image
{
    
    if (psn != nil && psn.photo != nil && [psn.photo isValidPhotoUrl])
    {
        
        NSString*strUrl = [SERVER_ADD stringByAppendingString:psn.photo];
        
        
        __weak typeof(self) weakSelf = self;
        
        [self setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:strUrl]] placeholderImage:image success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            
            if (image != nil)
            {
                [weakSelf setImageToRound:image];
                
            }
            
            
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            
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
