//
//  ContactListTableViewController.h
//  MJ
//
//  Created by harry on 14/12/14.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "unit.h"



@protocol contacSelection <NSObject>

@required

-(void)returnSelection:(NSArray*)curSelection;

@end

@interface ContactListTableViewController : UITableViewController

@property(nonatomic,strong)unit*contactListTreeHead;
@property(nonatomic,assign)BOOL selectMode;
@property(nonatomic,assign)BOOL singleSelect;
@property(nonatomic,assign)BOOL singleSelectCanSelectDepart;
@property(nonatomic,assign)id<contacSelection>selectResultDelegate;
- (IBAction)expandBtnClicked:(id)sender;
@property(nonatomic,strong)unit*curSelected;


@end
