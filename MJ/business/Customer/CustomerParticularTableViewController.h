//
//  CustomerParticularTableViewController.h
//  MJ
//
//  Created by harry on 15/1/10.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomerDetail.h"
#import "RETableViewManager.h"
#import "RETableViewOptionsController.h"



typedef NS_ENUM(NSInteger, CUSPAICULARMODE) {
    CUSPAICULARMODE_READ,
    CUSPAICULARMODE_EDIT,
    CUSPAICULARMODE_WRITE
};



@interface CustomerParticularTableViewController : UITableViewController<RETableViewManagerDelegate>

@property(strong,nonatomic)CustomerDetail*customerDtl;



@property(assign,nonatomic)CUSPAICULARMODE mode;


@end
