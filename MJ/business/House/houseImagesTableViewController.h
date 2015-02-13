//
//  houseImagesTableViewController.h
//  MJ
//
//  Created by harry on 15/1/10.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RETableViewManager.h"
#import "RETableViewOptionsController.h"
#import "HouseDetail.h"
#import "HouseParticulars.h"
#import "houseSecretParticulars.h"

typedef enum {
    READMODE        =1,
    EDITMODE               = 2,
    ADDMODE                  = 3,
} imageWatherMode;

@interface houseImagesTableViewController : UITableViewController<RETableViewManagerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property(strong,nonatomic)HouseDetail*houseDtl;
@property(strong,nonatomic)HouseParticulars*housePtcl;
@property(assign,nonatomic)imageWatherMode watchMode;

@property (strong,readwrite, nonatomic)NSMutableArray*xqtArr;
@property (strong,readwrite, nonatomic)NSMutableArray*hxtArr;
@property (strong,readwrite, nonatomic)NSMutableArray*sntArr;
@end
