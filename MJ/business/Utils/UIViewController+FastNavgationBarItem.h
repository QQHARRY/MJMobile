//
//  FastNavgationBarItem.h
//  MJ
//
//  Created by harry on 14-12-6.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface  UIViewController(FastNavgationBarItem)


-(void)setupLeftMenuButtonOfVC:(UIViewController*)vc Image:(UIImage*)image action:(SEL)action;

-(void)setupRightMenuButtonOfVC:(UIViewController*)vc Image:(UIImage*)image action:(SEL)action;
@end
