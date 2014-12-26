//
//  AppDelegate.h
//  MJ
//
//  Created by harry on 14-11-22.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

-(void)loadBindStory;
-(void)loadMainSotry;

@property (strong, nonatomic)UIStoryboard*curStory;


-(id)instantiateViewControllerWithIdentifier:(NSString*)identifier AndClass:(Class)cls;

@end

