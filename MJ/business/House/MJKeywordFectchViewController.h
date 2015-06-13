//
//  MJKeywordFectchViewController.h
//  MJ
//
//  Created by harry on 15/6/13.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//

#import <UIKit/UIKit.h>



@protocol keywordSelectDelegate <NSObject>

-(void)didSelectKeyword:(NSString*)keyWord;

@end

@interface MJKeywordFectchViewController : UITableViewController


@property(nonatomic,strong)NSString*keywordType;
@property(nonatomic,strong)NSString*placeHolderString;
@property(nonatomic,weak)id<keywordSelectDelegate>delegate;


@end
