//
//  UIViewController+ViewPersonDetails.m
//  MJ
//
//  Created by harry on 15/5/14.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//

#import "UIViewController+ViewPersonDetails.h"
#import "ContactPersonDetailsViewController.h"
#import "UtilFun.h"
#import "EaseMobFriendsManger.h"
#import "contactDataManager.h"

@implementation UIViewController (ViewPersonDetails)


-(void)ViewPersonDetails:(NSString*)username
{
    if (username != nil && username.length > 0)
    {
        UIStoryboard* curStory = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        ContactPersonDetailsViewController*vc =[curStory instantiateViewControllerWithIdentifier:@"ContactPersonDetailsViewController"];
        if (![vc  isKindOfClass:[ContactPersonDetailsViewController class]])
        {
            return;
            
        }
        
        if ([username.uppercaseString isEqualToString:[person me].job_no])
        {
            vc.psn = [person me];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else
        {
            __weak typeof(self)weakSelf = self;
//            SHOWHUD(self.view);
//            [[EaseMobFriendsManger sharedInstance] getFriendByUserName:username Success:^(BOOL success, person *psn) {
            
                //HIDEHUD(self.view);
//                dispatch_async(dispatch_get_main_queue(), ^{
                
//                    if (psn)
                    {
                        SHOWHUD(self.view);
                        [contactDataManager getPsnByJobNo:[username uppercaseString] Success:^(id responseObject) {
                            HIDEHUD(self.view);
                            vc.psn = responseObject;
                            [weakSelf.navigationController pushViewController:vc animated:YES];
                        } failure:^(NSError *error) {
                            HIDEHUD(self.view);
                        }];
                        
                        
                    }
//                });
             
//            }];
        }
        
    }
}
@end
