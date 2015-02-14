//
//  petionDetailsTableViewController.h
//  MJ
//
//  Created by harry on 14/12/17.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "petitionDetail.h"


@interface petionDetailsTableViewController : UITableViewController

@property(strong,nonatomic)NSString*petitionID;
@property(strong,nonatomic)NSString*petitionTaskID;
@property(strong,nonatomic)NSString*petitionTypeString;
@property(assign,nonatomic)BOOL task_state;//签收状态
//@property(strong,nonatomic)NSArray*petionDetails;
//@property(strong,nonatomic)NSString*petionStatusChartUrl;
@property(strong,nonatomic)petitionDetail*petDetail;
@end
