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
#import "CLClippingTool.h"
#import "CLClippingTool+CustomizeItems.h"
#import "UIViewController+BackButtonHandler.h"

typedef enum {
    READMODE        =1,
    EDITMODE               = 2,
    ADDMODE                  = 3,
} imageWatherMode;

@interface houseImagesTableViewController : UITableViewController<RETableViewManagerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,CLImageEditorDelegate,CLClippingToolItemsDataSource,BackButtonHandlerProtocol>
@property(strong,nonatomic)HouseDetail*houseDtl;
@property(strong,nonatomic)HouseParticulars*housePtcl;
@property(assign,nonatomic)imageWatherMode watchMode;

@property (strong,readwrite, nonatomic)NSMutableArray*xqtArr;
@property (strong,readwrite, nonatomic)NSMutableArray*hxtArr;
@property (strong,readwrite, nonatomic)NSMutableArray*sntArr;
@property (strong,readwrite, nonatomic)NSMutableArray*zqtArr;

@property (strong, readwrite, nonatomic) RETableViewManager *manager;
@property (strong, readwrite, nonatomic) RETableViewSection *xqtSection;
@property (strong, readwrite, nonatomic) RETableViewSection *hxtSection;
@property (strong, readwrite, nonatomic) RETableViewSection *sntSection;
@property (strong, readwrite, nonatomic) RETableViewSection *zptSection;
@property (strong, readwrite, nonatomic) RETableViewSection *curSection;


@property (strong, readwrite, nonatomic) NSString*lastestMimeType;

- (void)createAddImageButton:(RETableViewSection*)section;
@end
