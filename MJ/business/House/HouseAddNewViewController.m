//
//  HouseAddNewViewController.m
//  MJ
//
//  Created by harry on 15/1/14.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//

#import "HouseAddNewViewController.h"
#import "UtilFun.h"
#import "HouseDataPuller.h"
#import "BuildingsSelectTableViewController.h"
#import "dictionaryManager.h"
#import "HouseSelectBuildingTableViewController.h"
#import "HouseDataPuller.h"

@interface HouseAddNewViewController ()
@property(strong,readwrite,nonatomic)RETableViewSection*teneApplicationAbout;
@end

@implementation HouseAddNewViewController
@synthesize curBuildings;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.curBuilidngsOfCurBuildings = [[NSMutableArray alloc] init];
    [self reloadUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getData
{
}

-(void)reloadUI
{
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(sumitBtnClicked:)];
    
    [self prepareSections];
    [self prepareItems];
    [self.tableView reloadData];
}

-(void)createSections
{
    CGFloat sectH = 22;
    self.addInfoSection = [RETableViewSection sectionWithHeaderTitle:@""];
    self.addInfoSection.headerHeight = sectH;
    self.teneApplicationAbout = [RETableViewSection sectionWithHeaderTitle:@""];
    self.teneApplicationAbout.headerHeight = sectH;
    self.infoSection = [RETableViewSection sectionWithHeaderTitle:@"基本信息"];
    self.infoSection.headerHeight = sectH;
    self.secretSection = [RETableViewSection sectionWithHeaderTitle:@""];
    self.addInfoSection = [RETableViewSection sectionWithHeaderTitle:@""];
}

-(void)prepareSections
{
    [self.manager removeAllSections];
    [self.manager addSection:self.addInfoSection];
}

-(void)prepareItems
{
    [self prepareAddInfoSectionItems];
    //[self prepareInfoSectionItems];
}


-(void)sumitBtnClicked:(id)sender
{
    if (self.housePtcl && self.houseSecretPtcl)
    {
        NSMutableDictionary*dic = [[NSMutableDictionary alloc] init];
        
        NSArray*arr = [self.infoSection items];
        
        for (RETableViewItem* item in arr)
        {
            NSString*name = [self nameOfInstance:item];
            if (name && [name hasPrefix:@"_"])
            {
                name = [name substringFromIndex:1];
                if ([name length] > 0)
                {
                    SEL sel =@selector(value);
                    if ([item respondsToSelector:sel])
                    {
                        NSString*vl = [item performSelector:sel];
                        NSString*tmp = [self convertToDicValueForItem:name FromValue:vl];
                        if ([tmp length] > 0)
                        {
                            vl = tmp;
                        }
                        [dic setValue:vl forKey:name];
                    }
                    
                }
            }
            
        }
        
        [dic setValue:self.houseDtl.house_trade_no forKey:@"house_trade_no"];
        SHOWHUD_WINDOW;
        [HouseDataPuller pushHouseEditedParticulars:dic Success:^(houseSecretParticulars *housePtl) {
            HIDEHUD_WINDOW;
            SEL sel = @selector(setNeedRefresh);
            if (self.delegate && [self.delegate respondsToSelector:sel])
            {
                [self.delegate performSelector:sel];
            }
            
            PRSENTALERTWITHHANDER(@"编辑成功",@"",@"OK",self,^(UIAlertAction *action)
                                  {
                                      [self.navigationController popViewControllerAnimated:YES];
                                  }
                                  );
            
            
        } failure:^(NSError *error) {
            HIDEHUD_WINDOW;
            NSString*errorStr = [NSString stringWithFormat:@"%@",error];
            PRSENTALERTWITHHANDER(@"编辑失败",errorStr,@"OK",self,^(UIAlertAction *action)
                                  {
                                      [self.navigationController popViewControllerAnimated:YES];
                                  }
                                  );
        }];
    }
}
-(void)prepareInfoSectionItems
{
    [super prepareInfoSectionItems];
    [self.infoSection removeItem:self.watchHouseImages];
    //[self.infoSection removeItem:self.]
}

-(void)prepareSecretSectionItems
{
    [super prepareSecretSectionItems];
    [self.secretSection removeItem:self.look_permit];
}


-(void)getBuildingDetails
{
    SHOWHUD_WINDOW;
    
    [HouseDataPuller pullBuildingDetailsByBuildingNO:self.curBuildings.buildings_dict_no Success:^(buildingDetails *dtl,NSArray*arr)
     {
         [self.curBuilidngsOfCurBuildings removeAllObjects];
         if ([arr count] > 0)
         {
             [self.curBuilidngsOfCurBuildings addObjectsFromArray:arr];
             self.curBuildingsDetails = dtl;
         }
         else
         {
             PRSENTALERT(@"楼盘未录入栋座",@"请先联系主管添加栋座信息",@"OK",self);
         }
         HIDEHUD_WINDOW;
     }
                                            failure:^(NSError* error)
     {
         
         HIDEHUD_WINDOW;
     }];
}
-(void)createInfoSectionItems
{
    __typeof (&*self) __weak weakSelf = self;
    [super createInfoSectionItems];
    self.buildings_name = [[RERadioItem alloc] initWithTitle:@"楼盘名称:" value:@"" selectionHandler:^(RERadioItem *item) {
        [item deselectRowAnimated:YES];
        BuildingsSelectTableViewController*selCtrl = [BuildingsSelectTableViewController initWithDelegate:weakSelf AndCompleteHandler:^(buildings *bld) {
            if (bld)
            {
                //if (bld && self.curBuildings != bld)
                {
                    self.curBuildings = bld;
                    self.buildings_name.value = bld.buildings_name;
                    self.urbanname.value = bld.urbanname;
                    self.areaname.value = bld.areaname;
                    self.buildings_address.value = bld.Buildings_address;
                    [self.curBuilidngsOfCurBuildings removeAllObjects];
                    self.curBuildingsDetails = nil;
                    
                    self.buildname.enabled = YES;
                    self.house_serect_unit.enabled = YES;
                    self.house_tablet.enabled = YES;
                    [self.manager addSection:self.teneApplicationAbout];
                    [self.tableView reloadData];
                    [self performSelectorOnMainThread:@selector(getBuildingDetails) withObject:nil waitUntilDone:NO];
                    
                }
                
                
            }
            
        }];
        
        [weakSelf.navigationController pushViewController:selCtrl animated:YES];
    }];
    
    
    
    self.buildname = [[RERadioItem alloc] initWithTitle:@"栋座:" value:@"" selectionHandler:^(RERadioItem *item) {
        [item deselectRowAnimated:YES];
        HouseSelectBuildingTableViewController*selCtrl = [HouseSelectBuildingTableViewController initWithDelegate:weakSelf  BuildingsArr:self.curBuilidngsOfCurBuildings AndCompleteHandler:^(building *bld) {
            if (bld)
            {
                
                self.buildname.value = bld.build_full_name;

                self.curBuilding = bld;
                [self.tableView reloadData];
            }
            
        }];
        
        [weakSelf.navigationController pushViewController:selCtrl animated:YES];
    }];
    
    
    self.house_serect_unit = [[RERadioItem alloc] initWithTitle:@"单元:" value:@"" selectionHandler:^(RERadioItem *item)
    {
        [item deselectRowAnimated:YES]; // same as [weakSelf.tableView deselectRowAtIndexPath:item.indexPath animated:YES];
        RETableViewOptionsController *optionsController = [[RETableViewOptionsController alloc] initWithItem:item options:[self.curBuilding getSerialArr] multipleChoice:NO completionHandler:^(RETableViewItem *selectedItem)
                                                           {
                                                               [weakSelf.navigationController popViewControllerAnimated:YES];
                                                               
                                                               self.house_serect_unit.value = selectedItem.title;
                                                               [item reloadRowWithAnimation:UITableViewRowAnimationNone];
                                                           }];
        // Adjust styles
        optionsController.delegate = weakSelf;
        optionsController.style = self.teneApplicationAbout.style;
        if (weakSelf.tableView.backgroundView == nil)
        {
            optionsController.tableView.backgroundColor = weakSelf.tableView.backgroundColor;
            optionsController.tableView.backgroundView = nil;
        }
        // Push the options controller
        [weakSelf.navigationController pushViewController:optionsController animated:YES];
    }];
}

-(void)prepareTeneApplicationSectionItemsStep1
{
    [self.teneApplicationAbout removeAllItems];
    __typeof (&*self) __weak weakSelf = self;

    self.tene_application = [[RERadioItem alloc] initWithTitle:@"物业用途:" value:@"" selectionHandler:^(RERadioItem *item) {
        [item deselectRowAnimated:YES]; // same as [weakSelf.tableView deselectRowAtIndexPath:item.indexPath animated:YES];
        NSMutableArray *options = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < self.tene_application_dic_arr.count; i++)
        {
            DicItem *di = [self.tene_application_dic_arr objectAtIndex:i];
            [options addObject:di.dict_label];
        }
        RETableViewOptionsController *optionsController = [[RETableViewOptionsController alloc] initWithItem:item options:options multipleChoice:NO completionHandler:^(RETableViewItem *selectedItem)
                                                           {
                                                               [weakSelf.navigationController popViewControllerAnimated:YES];
                                                               
                                                               [self prepareTeneApplicationSectionItemsStep2ByTenenType:selectedItem.title];
                                                               [item reloadRowWithAnimation:UITableViewRowAnimationNone];
                                                           }];
        // Adjust styles
        optionsController.delegate = weakSelf;
        optionsController.style = self.teneApplicationAbout.style;
        if (weakSelf.tableView.backgroundView == nil)
        {
            optionsController.tableView.backgroundColor = weakSelf.tableView.backgroundColor;
            optionsController.tableView.backgroundView = nil;
        }
        // Push the options controller
        [weakSelf.navigationController pushViewController:optionsController animated:YES];
    }];
    [self.teneApplicationAbout addItem:self.tene_application];
    [self.tableView reloadData];
}

-(void)prepareTeneApplicationSectionItemsStep2ByTenenType:(NSString*)type
{
    //__typeof (&*self) __weak weakSelf = self;
    if ([type  isEqualToString:@"商铺"])
    {
        [self.teneApplicationAbout removeItem:self.room_num];
        [self.teneApplicationAbout removeItem:self.hall_num];
        [self.teneApplicationAbout removeItem:self.kitchen_num];
        [self.teneApplicationAbout removeItem:self.toilet_num];
        [self.teneApplicationAbout removeItem:self.balcony_num];
        [self.teneApplicationAbout removeItem:self.house_driect];
        
        
        [self.teneApplicationAbout addItem:self.house_rank];
        [self.teneApplicationAbout addItem:self.house_depth];
        [self.teneApplicationAbout addItem:self.floor_height];
        [self.teneApplicationAbout addItem:self.floor_count];
        [self.teneApplicationAbout removeItem:self.efficiency_rate];
    }
    else if([type  isEqualToString:@"商住"])
    {
        [self.teneApplicationAbout removeItem:self.room_num];
        [self.teneApplicationAbout removeItem:self.hall_num];
        [self.teneApplicationAbout removeItem:self.kitchen_num];
        [self.teneApplicationAbout removeItem:self.toilet_num];
        [self.teneApplicationAbout removeItem:self.balcony_num];
        [self.teneApplicationAbout removeItem:self.house_driect];
        
        
        [self.teneApplicationAbout addItem:self.house_rank];
        [self.teneApplicationAbout removeItem:self.house_depth];
        [self.teneApplicationAbout addItem:self.floor_height];
        [self.teneApplicationAbout addItem:self.floor_count];
        [self.teneApplicationAbout removeItem:self.efficiency_rate];
    }
    else if([type  isEqualToString:@"厂房"])
    {
        [self.teneApplicationAbout removeItem:self.room_num];
        [self.teneApplicationAbout removeItem:self.hall_num];
        [self.teneApplicationAbout removeItem:self.kitchen_num];
        [self.teneApplicationAbout removeItem:self.toilet_num];
        [self.teneApplicationAbout removeItem:self.balcony_num];
        [self.teneApplicationAbout removeItem:self.house_driect];
        
        
        [self.teneApplicationAbout addItem:self.house_rank];
        [self.teneApplicationAbout removeItem:self.house_depth];
        [self.teneApplicationAbout removeItem:self.floor_height];
        [self.teneApplicationAbout addItem:self.floor_count];
        [self.teneApplicationAbout removeItem:self.efficiency_rate];
    }
    else if([type  isEqualToString:@"仓库"])
    {
        [self.teneApplicationAbout removeItem:self.room_num];
        [self.teneApplicationAbout removeItem:self.hall_num];
        [self.teneApplicationAbout removeItem:self.kitchen_num];
        [self.teneApplicationAbout removeItem:self.toilet_num];
        [self.teneApplicationAbout removeItem:self.balcony_num];
        [self.teneApplicationAbout removeItem:self.house_driect];
        
        
        [self.teneApplicationAbout addItem:self.house_rank];
        [self.teneApplicationAbout removeItem:self.house_depth];
        [self.teneApplicationAbout addItem:self.floor_height];
        [self.teneApplicationAbout addItem:self.floor_count];
        [self.teneApplicationAbout removeItem:self.efficiency_rate];
    }
    else if([type  isEqualToString:@"地皮"])
    {
        [self.teneApplicationAbout removeItem:self.room_num];
        [self.teneApplicationAbout removeItem:self.hall_num];
        [self.teneApplicationAbout removeItem:self.kitchen_num];
        [self.teneApplicationAbout removeItem:self.toilet_num];
        [self.teneApplicationAbout removeItem:self.balcony_num];
        [self.teneApplicationAbout removeItem:self.house_driect];
        
        
        [self.teneApplicationAbout addItem:self.house_rank];
        [self.teneApplicationAbout removeItem:self.house_depth];
        [self.teneApplicationAbout addItem:self.floor_height];
        [self.teneApplicationAbout addItem:self.floor_count];
        [self.teneApplicationAbout removeItem:self.efficiency_rate];
    }
    else if([type  isEqualToString:@"车位"])
    {
        [self.floor_height setTitle:@"宽度"];
        [self.teneApplicationAbout removeItem:self.room_num];
        [self.teneApplicationAbout removeItem:self.hall_num];
        [self.teneApplicationAbout removeItem:self.kitchen_num];
        [self.teneApplicationAbout removeItem:self.toilet_num];
        [self.teneApplicationAbout removeItem:self.balcony_num];
        [self.teneApplicationAbout removeItem:self.house_driect];
        
        
        [self.teneApplicationAbout addItem:self.house_rank];
        [self.teneApplicationAbout addItem:self.house_depth];
        [self.teneApplicationAbout addItem:self.floor_height];
        [self.teneApplicationAbout removeItem:self.floor_count];
        [self.teneApplicationAbout removeItem:self.efficiency_rate];
    }
    else if([type  isEqualToString:@"写字楼"])
    {
        [self.teneApplicationAbout removeItem:self.room_num];
        [self.teneApplicationAbout removeItem:self.hall_num];
        [self.teneApplicationAbout removeItem:self.kitchen_num];
        [self.teneApplicationAbout removeItem:self.toilet_num];
        [self.teneApplicationAbout removeItem:self.balcony_num];
        [self.teneApplicationAbout removeItem:self.house_driect];
        
        
        [self.teneApplicationAbout removeItem:self.house_rank];
        [self.teneApplicationAbout removeItem:self.house_depth];
        [self.teneApplicationAbout addItem:self.floor_height];
        [self.teneApplicationAbout addItem:self.floor_count];
        [self.teneApplicationAbout addItem:self.efficiency_rate];
    }
    else
    {
        [self.teneApplicationAbout addItem:self.room_num];
        [self.teneApplicationAbout addItem:self.hall_num];
        [self.teneApplicationAbout addItem:self.kitchen_num];
        [self.teneApplicationAbout addItem:self.toilet_num];
        [self.teneApplicationAbout addItem:self.balcony_num];
        [self.teneApplicationAbout addItem:self.house_driect];
        
        [self.teneApplicationAbout removeItem:self.house_rank];
        [self.teneApplicationAbout removeItem:self.house_depth];
        [self.teneApplicationAbout removeItem:self.floor_height];
        [self.teneApplicationAbout removeItem:self.floor_count];
        [self.teneApplicationAbout removeItem:self.efficiency_rate];
    }
    
    [self.tableView reloadData];
}

-(void)prepareAddInfoSectionItems
{
    [self.addInfoSection removeAllItems];
    [self createSecretSectionItems];
    [self createAddInfoSectionItems];
    [self createInfoSectionItems];
    

    //楼盘
    [self.addInfoSection addItem:self.buildings_name];
    //区域
    self.urbanname.enabled = NO;
    [self.addInfoSection addItem:self.urbanname];
    //片区
    self.areaname.enabled = NO;
    [self.addInfoSection addItem:self.areaname];
    //地址
    self.buildings_address.enabled = NO;
    [self.addInfoSection addItem:self.buildings_address];
    //栋座
    self.buildname.enabled = NO;
    [self.addInfoSection addItem:self.buildname];
    //单元
    self.house_serect_unit.enabled = NO;
    [self.addInfoSection addItem:self.house_serect_unit];
    
    self.house_floor.enabled = NO;
    [self.addInfoSection addItem:self.house_floor];
    
    self.build_floor_count.enabled = NO;
    [self.addInfoSection addItem:self.build_floor_count];
    
    //门牌号
    self.house_tablet.enabled = NO;
    [self.addInfoSection addItem:self.house_tablet];
    
    
    
    
    //@property(strong,nonatomic)RETableViewItem* judgementBtn;
    //判重按钮
    self.judgementBtn = [RETableViewItem itemWithTitle:@"判重" accessoryType:UITableViewCellAccessoryNone selectionHandler:^(RETableViewItem *item)
                         {
                             [self prepareTeneApplicationSectionItemsStep1];
                         }];
    self.judgementBtn.textAlignment = NSTextAlignmentCenter;
    //判重按钮
    [self.addInfoSection addItem:self.judgementBtn];
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
