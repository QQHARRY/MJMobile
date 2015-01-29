//
//  chooseAssistDeptTableViewController.h
//  MJ
//
//  Created by harry on 14/12/18.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol SelectionDelegate <NSObject>

@required

-(void)returnSelection:(NSArray*)curSelection;

@end

@interface chooseAssistDeptTableViewController : UITableViewController

@property(nonatomic,strong)NSArray*deptArr;

@property(nonatomic,strong)NSMutableArray*initialSelectArr;
@property(nonatomic,strong)NSMutableArray*selectArr;

@property(nonatomic,assign)id<SelectionDelegate>delegate;
@end
