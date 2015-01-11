//
//  CustomerParticularTableViewController.h
//  MJ
//
//  Created by harry on 15/1/10.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//

#import "CustomerParticularTableViewController.h"
#import "UtilFun.h"
#import "FollowTableViewController.h"
#import "AppointTableViewController.h"

#import <objc/runtime.h>
#import "dictionaryManager.h"
#import "Macro.h"


@interface CustomerParticularTableViewController ()




@property (strong, readwrite, nonatomic) RETableViewManager *manager;
#pragma mark ---------------sections----------------
#pragma mark
@property (strong, readwrite, nonatomic) RETableViewSection *addInfoSection;
@property (strong, readwrite, nonatomic) RETableViewSection *infoSection;
@property (strong, readwrite, nonatomic) RETableViewSection *secretSection;
@property (strong, readwrite, nonatomic) RETableViewSection *actionSection;
#pragma mark ---------------sections----------------
#pragma mark



#pragma mark ---------------actionSection items----------------
#pragma mark
@property (strong, readwrite, nonatomic) RETableViewItem * addGenJinActions;
//跟进按钮
@property (strong, readwrite, nonatomic) RETableViewItem * addDaiKanActions;
//带看按钮
#pragma mark ---------------actionSection items----------------
#pragma mark

@end

@implementation CustomerParticularTableViewController

@synthesize mode;


#pragma mark ---------------viewDidLoad----------------
#pragma mark
- (void)viewDidLoad
{
    [super viewDidLoad];
    

    self.manager = [[RETableViewManager alloc] initWithTableView:self.tableView delegate:self];
    [self createSections];
    [self initDic];
    
    [self getData];
    [self loadUI];
}
#pragma mark ---------------viewDidLoad----------------
#pragma mark



-(void)loadUI
{
    [self prepareSections];
    [self prepareItems];
}
-(void)initDic
{
//    self.tene_application_dic_arr = [dictionaryManager getItemArrByType:DIC_TENE_APPLICATION];
//    self.tene_type_dic_arr = [dictionaryManager getItemArrByType:DIC_TENE_TYPE];
//    self.fitment_type_dic_arr = [dictionaryManager getItemArrByType:DIC_FITMENT_TYPE];
//    self.house_driect_dic_arr = [dictionaryManager getItemArrByType:DIC_HOUSE_DIRECT_TYPE];
//    self.use_situation_dic_arr = [dictionaryManager getItemArrByType:DIC_USE_SITUATION_TYPE];
//    self.client_source_dic_arr = [dictionaryManager getItemArrByType:DIC_CLIENT_SOURCE_TYPE];
//    self.look_permit_dic_arr = [dictionaryManager getItemArrByType:DIC_LOOK_PERMIT_TYPE];
}


-(void)reloadUI
{
    [self prepareSections];
    [self prepareItems];
    [self.tableView reloadData];
}

-(void)prepareSections
{
    [self.manager removeAllSections];
//    [self.manager addSection:self.infoSection];
//    [self.manager addSection:self.secretSection];
    [self.manager addSection:self.actionSection];
}

-(void)prepareItems
{
//    [self prepareInfoSectionItems];
//    [self prepareSecretSectionItems];
    [self prepareActionSectionsItems];
}

-(void)prepareInfoSectionItems
{
    [self createInfoSectionItems];
    
}

-(void)prepareSecretSectionItems
{
    [self createSecretSectionItems];
    [self.secretSection removeAllItems];
}

-(void)prepareActionSectionsItems
{
    [self createActionSectionItems];
    [self.actionSection removeAllItems];
    [self.actionSection addItem:self.addGenJinActions];
    [self.actionSection addItem:self.addDaiKanActions];
}


#pragma mark ---------------getData----------------
#pragma mark
-(void)getData
{
    

}
#pragma mark ---------------getData----------------
#pragma mark


#pragma mark ---------------createSections----------------
#pragma mark
-(void)createSections
{
    CGFloat sectH = 22;
    self.addInfoSection = [RETableViewSection sectionWithHeaderTitle:@"地区和位置信息"];
    self.addInfoSection.headerHeight = sectH;
    self.infoSection = [RETableViewSection sectionWithHeaderTitle:@"基本信息"];
    self.infoSection.headerHeight = sectH;
    self.secretSection = [RETableViewSection sectionWithHeaderTitle:@"保密信息"];
    self.secretSection.headerHeight = sectH;
    self.actionSection = [RETableViewSection sectionWithHeaderTitle:@"相关操作"];
    self.actionSection.headerHeight = sectH;
}
#pragma mark ---------------createSections----------------
#pragma mark

#pragma mark ---------------createAddInfoSectionItems----------------
#pragma mark
-(void)createAddInfoSectionItems
{
    NSString*value = @"";
    __typeof (&*self) __weak weakSelf = self;
    
   
}
#pragma mark ---------------createAddInfoSectionItems----------------
#pragma mark

#pragma mark ---------------createInfoSectionItems----------------
#pragma mark
-(void)createInfoSectionItems
{
    NSString*value = @"";
    __typeof (&*self) __weak weakSelf = self;
    
   
}

#pragma mark ---------------createInfoSectionItems----------------
#pragma mark

-(void)createSecretSectionItems
{
    

    
}

-(void)createActionSectionItems
{
    [self createDaiKanBtn];
    [self createGenjinBtn];
}





//- (void)createGenjinBtn
//{
//    __typeof (&*self) __weak weakSelf = self;
//    self.addGenJinActions = [RETableViewItem itemWithTitle:@"跟进" accessoryType:UITableViewCellAccessoryNone selectionHandler:^(RETableViewItem *item)
//                        {
//                            
//                        }];
//    self.addGenJinActions.textAlignment = NSTextAlignmentCenter;
//}
//- (void)createDaiKanBtn
//{
//    __typeof (&*self) __weak weakSelf = self;
//    self.addDaiKanActions = [RETableViewItem itemWithTitle:@"带看" accessoryType:UITableViewCellAccessoryNone selectionHandler:^(RETableViewItem *item)
//                        {
//
//                        }];
//    self.addDaiKanActions.textAlignment = NSTextAlignmentCenter;
//}
- (void)createGenjinBtn
{
    __typeof (&*self) __weak weakSelf = self;
    self.addGenJinActions = [RETableViewItem itemWithTitle:@"跟进" accessoryType:UITableViewCellAccessoryNone selectionHandler:^(RETableViewItem *item)
                             {
                                 FollowTableViewController *vc = [[FollowTableViewController alloc] initWithNibName:@"FollowTableViewController" bundle:[NSBundle mainBundle]];
                                 vc.sid = self.customerDtl.business_requirement_no;
                                 vc.type = @"租购";
                                 [weakSelf.navigationController pushViewController:vc animated:YES];
                             }];
    self.addGenJinActions.textAlignment = NSTextAlignmentCenter;
}
- (void)createDaiKanBtn
{
    __typeof (&*self) __weak weakSelf = self;
    self.addDaiKanActions = [RETableViewItem itemWithTitle:@"带看" accessoryType:UITableViewCellAccessoryNone selectionHandler:^(RETableViewItem *item)
                             {
                                 AppointTableViewController *vc = [[AppointTableViewController alloc] initWithNibName:@"AppointTableViewController" bundle:[NSBundle mainBundle]];
                                 vc.sid = self.customerDtl.business_requirement_no;
                                 
                                 [weakSelf.navigationController pushViewController:vc animated:YES];
                             }];
    self.addDaiKanActions.textAlignment = NSTextAlignmentCenter;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





@end
