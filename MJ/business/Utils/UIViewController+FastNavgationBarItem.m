//
//  FastNavgationBarItem.m
//  MJ
//
//  Created by harry on 14-12-6.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import "UIViewController+FastNavgationBarItem.h"
#import "ILBarButtonItem.h"


@implementation UIViewController(FastNavgationBarItem)


-(void)setupLeftMenuButtonOfVC:(UIViewController*)vc Image:(UIImage*)image action:(SEL)action
{

    ILBarButtonItem *item =
    [ILBarButtonItem barItemWithImage:image
                        selectedImage:nil
                               target:vc
                               action:action];
    
    [vc.navigationItem setLeftBarButtonItem:item animated:YES];
    
}

-(void)setupRightMenuButtonOfVC:(UIViewController*)vc Image:(UIImage*)image action:(SEL)action
{
    
    ILBarButtonItem *item =
    [ILBarButtonItem barItemWithImage:image
                        selectedImage:nil
                               target:vc
                               action:action];
    
    [vc.navigationItem setRightBarButtonItem:item animated:YES];
    
    
    CGRect rct = vc.navigationItem.titleView.frame;
    rct.origin.x ;
    
    vc.navigationItem.titleView.frame = rct;
}
@end
