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
#import "HouseSelectUnitTableViewController.h"
@interface HouseAddNewViewController ()
@property(strong,readwrite,nonatomic)RETableViewSection*teneApplicationAbout;
@property(strong,readwrite,nonatomic)RETableViewSection*imageSection;
@property(strong,readwrite,nonatomic)NSMutableArray*xqtArr;
@property(strong,readwrite,nonatomic)NSMutableArray*hxtArr;
@property(strong,readwrite,nonatomic)NSMutableArray*sntArr;
@property (nonatomic) NSInteger uploadProgress;
@property (nonatomic,strong)NSString*succeedHouseTradeNo;
@property (nonatomic,strong)NSString*succeedHouseImageNo;
@end

@implementation HouseAddNewViewController
@synthesize curBuildings;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.curBuilidngsOfCurBuildings = [[NSMutableArray alloc] init];
    [self reloadUI];
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.toolbarHidden = YES;
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//cover the metod of super class
-(void)getData
{
}

-(void)reloadUI
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(sumitBtnClicked:)];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
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
    self.teneApplicationAbout.headerHeight = 1;
    self.infoSection = [RETableViewSection sectionWithHeaderTitle:@""];
    self.infoSection.headerHeight = 1;
    self.secretSection = [RETableViewSection sectionWithHeaderTitle:@""];
    self.secretSection.headerHeight = 1;
    self.addInfoSection = [RETableViewSection sectionWithHeaderTitle:@""];
    self.imageSection = [RETableViewSection sectionWithHeaderTitle:@""];
    self.imageSection.headerHeight = 1;
}

-(void)prepareSections
{
    [self.manager removeAllSections];
    [self.manager addSection:self.addInfoSection];
    [self.manager addSection:self.teneApplicationAbout];
    [self.manager addSection:self.infoSection];
    [self.manager addSection:self.secretSection];
    [self.manager addSection:self.imageSection];
    
}

-(void)prepareItems
{
    [self createSecretSectionItems];
    [self createAddInfoSectionItems];
    [self createInfoSectionItems];
    [self prepareAddInfoSectionItems];
//    self.watchHouseImages.title = @"点击添加房源图片";
//    [self.imageSection addItem:self.watchHouseImages];
}

- (void)createWatchImageBtn
{
    __typeof (&*self) __weak weakSelf = self;
    self.watchHouseImages = [RETableViewItem itemWithTitle:@"点击查看并编辑图片" accessoryType:UITableViewCellAccessoryNone selectionHandler:^(RETableViewItem *item)
                             {
                                 if(self.houseImageCtrl == nil)
                                 {
                                     self.houseImageCtrl = [[houseImagesTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
                                     self.houseImageCtrl.housePtcl = self.housePtcl;
                                     self.houseImageCtrl.houseDtl = self.houseDtl;
                                     self.houseImageCtrl.watchMode = ADDMODE;
                                 }
                                 
                                 
                                 [weakSelf.navigationController pushViewController:self.houseImageCtrl animated:YES];
                             }];
    self.watchHouseImages.textAlignment = NSTextAlignmentCenter;
    [self.imageSection addItem:self.watchHouseImages];
}


-(void)setInfoSectionItemsValue
{
    NSString*value = @"";
    //
    //    @property (strong, readwrite, nonatomic) RENumberItem * structure_area;
    //    //float
    //    //面积
    [self.structure_area addObserver:self forKeyPath:@"value" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
    value = @"";
    if (self.housePtcl)
    {
        if(self.housePtcl.structure_area)
        {
            value = [NSString stringWithFormat:@"%@m²",self.housePtcl.structure_area];
            self.structure_area.value =value;
            self.structure_area.enabled = NO;
        }
        
    }
    


    
    value = @"";
    if (self.curBuildingsDetails && self.curBuildingsDetails.cons_elevator_brand)
    {
        for (DicItem *di in self.cons_elevator_brand_dic_arr)
        {
            if ([di.dict_value isEqualToString:self.curBuildingsDetails.cons_elevator_brand])
            {
                value = di.dict_label;
                break;
            }
        }
    }
    
    
    self.cons_elevator_brand = [[RETextItem alloc] initWithTitle:@"电梯:" value:value];
    self.cons_elevator_brand.enabled = NO;
    
    //
    //    @property (strong, readwrite, nonatomic) RETextItem * facility_heating;
    //    //String
    //    //暖气
    value = @"";
    if (self.curBuildingsDetails&& self.curBuildingsDetails.facility_heating)
    {
        for (DicItem *di in self.facility_heating_dic_arr)
        {
            if ([di.dict_value isEqualToString:self.curBuildingsDetails.facility_heating])
            {
                value = di.dict_label;
                break;
            }
        }
    }
    self.facility_heating = [[RETextItem alloc] initWithTitle:@"暖气:" value:value];
    self.facility_heating.enabled = NO;
    
    //
    //    @property (strong, readwrite, nonatomic) RETextItem * facility_gas;
    //    //String
    //    //燃气
    value = @"";
    if (self.curBuildingsDetails&& self.curBuildingsDetails.facility_gas)
    {
        for (DicItem *di in self.facility_gas_dic_arr)
        {
            if ([di.dict_value isEqualToString:self.curBuildingsDetails.facility_gas])
            {
                value = di.dict_label;
                break;
            }
        }
    }
    self.facility_gas = [[RETextItem alloc] initWithTitle:@"燃气:" value:value];
    self.facility_gas.enabled = NO;
    //
    //    @property (strong, readwrite, nonatomic) RERadioItem * build_year;
    //    //Int
    //    //建房年代
    value = @"";
    if (self.housePtcl)
    {
        value = self.housePtcl.build_year;
        self.build_year.value =value;
    }
    
    
    //
    //    @property (strong, readwrite, nonatomic) RERadioItem * property_term;
    //    //Int
    //    //产权年限
    value = @"";
    if (self.housePtcl)
    {
        value = self.housePtcl.property_term;
        self.property_term.value =value;
    }
    
    
    //
    //    @property (strong, readwrite, nonatomic) RERadioItem * use_situation;
    //    //Int
    //    //现状
    
    value = @"";
    if (self.housePtcl)
    {
        for (DicItem *di in self.use_situation_dic_arr)
        {
            if ([di.dict_value isEqualToString:self.housePtcl.use_situation])
            {
                value = di.dict_label;
                self.use_situation.value =value;
                break;
            }
        }
    }
    
    
    
    
    //
    //    @property (strong, readwrite, nonatomic) RETextItem * client_remark;
    //    //String
    //    //备注
    value = @"";
    if (self.housePtcl && self.housePtcl.client_remark)
    {
        value = self.housePtcl.client_remark;
        self.client_remark.value =value;
    }
    
    
    //
    //    @property (strong, readwrite, nonatomic) RETextItem * b_staff_describ;
    //    //String
    //    //房源描述
    value = @"";
    if (self.housePtcl && self.housePtcl.describ)
    {
        value = self.housePtcl.describ;
        self.describ.value =value;
    }
    
    
   
    
    
    //
    //    @property (strong, readwrite, nonatomic) RERadioItem * client_source;
    //    //String
    //    //信息来源
    value = @"";
    if (self.housePtcl)
    {
        for (DicItem *di in self.client_source_dic_arr)
        {
            if ([di.dict_value isEqualToString:self.housePtcl.client_source])
            {
                value = di.dict_label;
                self.client_source.value =value;
                break;
            }
        }
    }
    
    
    
    //@property (strong, readwrite, nonatomic) RERadioItem * look_permit;
    //String
    //看房:
    //预约
    //有钥匙
    //借钥匙
    //直接
    value = @"";
    if (self.housePtcl)
    {
        for (DicItem *di in self.look_permit_dic_arr)
        {
            if ([di.dict_value isEqualToString:self.housePtcl.look_permit])
            {
                value = di.dict_label;
                self.look_permit.value =value;
                break;
            }
        }
    }
    
    
    
}

-(void)sumitBtnClicked:(id)sender
{
    if (![self checkValid])
    {
        return;
    }
    
    
    NSMutableDictionary*dic = [[NSMutableDictionary alloc] init];
    
    NSMutableArray*requiredFields = [[NSMutableArray alloc] init];
    [requiredFields addObjectsFromArray:[self.addInfoSection items]];
    [requiredFields addObjectsFromArray:[self.teneApplicationAbout items]];
    [requiredFields addObjectsFromArray:[self.infoSection items]];
    [requiredFields addObjectsFromArray:[self.secretSection items]];
    [requiredFields removeObject:self.judgementBtn];
    [requiredFields removeObject:self.house_area];
    [requiredFields removeObject:self.domain_address];
    [requiredFields removeObject:self.domain_name];
    [requiredFields removeObject:self.building_name];
    [requiredFields removeObject:self.house_urban];
    
    for (RETableViewItem* item in requiredFields)
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
    [dic setValue:self.curHouseUnit.unit_no forKey:@"unit_no"];
    [dic setValue:self.curBuildings.domain_no forKey:@"domain_no"];
    [dic setValue:self.curBuilding.building_no forKey:@"building_no"];
    //这里trade_type的值其实是isEstateExist 返回的status值
    //stauts值的含义见文档接口29
    int existingTradeType = [self.housePtcl.trade_type intValue];
    if (existingTradeType == 0)
    {
        [dic setValue:@"" forKey:@"house_no"];
        [dic setValue:@"1"forKey:@"add_estate"];
        
        
    }
    else if (existingTradeType == 1 || existingTradeType == 2 || existingTradeType == 3)
    {
        [dic setValue:self.housePtcl.house_no forKey:@"house_no"];
        [dic setValue:@"0"forKey:@"add_estate"];
    }
    
    SHOWHUD_WINDOW;
    [HouseDataPuller pushAddHouse:dic Success:^(NSString *trade_no, NSString *buildings_picture) {
        
        SEL sel = @selector(setNeedRefresh);
        if (self.delegate && [self.delegate respondsToSelector:sel])
        {
            [self.delegate performSelector:sel];
        }

        HIDEHUD_WINDOW;
        self.succeedHouseTradeNo = trade_no;
        self.succeedHouseImageNo = buildings_picture;
        //[self getImageArr];
        //self.uploadProgress = 0;
        //[self uploadImage];
    } failure:^(NSError *error) {
        HIDEHUD_WINDOW;
        NSString*errorStr = [NSString stringWithFormat:@"%@",error];
        PRESENTALERT(@"添加失败,请稍候重试",errorStr,@"OK",^()
                               {
                                   
                               }
                               ,self);
    }];
}

-(void)getImageArr
{
    if (self.xqtArr == nil)
    {
        self.xqtArr = [[NSMutableArray alloc] init];
    }
    else
    {
        [self.xqtArr  removeAllObjects];
    }
    
    if (self.hxtArr == nil)
    {
        self.hxtArr = [[NSMutableArray alloc] init];
    }
    else
    {
        [self.hxtArr  removeAllObjects];
    }
    
    if (self.sntArr == nil)
    {
        self.sntArr = [[NSMutableArray alloc] init];
    }
    else
    {
        [self.sntArr  removeAllObjects];
    }
    
    
    if (self.houseImageCtrl)
    {
        if (self.houseImageCtrl.xqtArr)
        {
            if (self.xqtArr == nil)
            {
                self.xqtArr = [[NSMutableArray alloc] init];
            }
            else
            {
                [self.xqtArr  removeAllObjects];
            }
            for (NSDictionary*dic in self.houseImageCtrl.xqtArr)
            {
                UIImage*image = [[dic allValues] objectAtIndex:0];
                if (image && [image isKindOfClass:[UIImage class]])
                {
                    [self.xqtArr addObject:image];
                }
            }
        }

        if (self.houseImageCtrl.hxtArr)
        {
            for (NSDictionary*dic in self.houseImageCtrl.hxtArr)
            {
                UIImage*image = [[dic allValues] objectAtIndex:0];
                if (image && [image isKindOfClass:[UIImage class]])
                {
                    [self.hxtArr addObject:image];
                }
            }
        }
        
        if (self.houseImageCtrl.sntArr)
        {
            for (NSDictionary*dic in self.houseImageCtrl.sntArr)
            {
                UIImage*image = [[dic allValues] objectAtIndex:0];
                if (image && [image isKindOfClass:[UIImage class]])
                {
                    [self.sntArr addObject:image];
                }
            }
        }

    }
}

-(void)uploadImage
{
     NSLog(@"start to pushimage");
    UIImage *image = nil;
    NSString *type = @"";
    NSString *tip = @"";
    if (self.uploadProgress < self.xqtArr.count)
    {
        image = [self.xqtArr objectAtIndex:self.uploadProgress];
        type = @"xqt";
        tip = [NSString stringWithFormat:@"正在上传主图第%d张(共%d张)...", (int)(self.uploadProgress + 1), (int)self.xqtArr.count];
    }
    else if (self.uploadProgress < (self.xqtArr.count + self.hxtArr.count) )
    {
        image = [self.hxtArr objectAtIndex:(self.uploadProgress - self.xqtArr.count) ];
        type = @"hxt";
        tip = [NSString stringWithFormat:@"正在上传户型图第%d张(共%d张)...", (int)(self.uploadProgress + 1 - self.xqtArr.count), ( int)self.hxtArr.count];
    }
    else if (self.uploadProgress < (self.xqtArr.count + self.hxtArr.count + self.sntArr.count) )
    {
        image = [self.sntArr objectAtIndex:(self.uploadProgress - self.xqtArr.count - self.hxtArr.count) ];
        type = @"snt";
        tip = [NSString stringWithFormat:@"正在上传室内图第%d张(共%d张)...", (int)(self.uploadProgress + 1 - self.xqtArr.count - self.hxtArr.count), (int)self.sntArr.count];
    }
    else
    {
        NSLog(@"push image all finished");
        dispatch_async(dispatch_get_main_queue(), ^{
            PRESENTALERT(@"成功", @"添加房源成功!",@"OK", ^()
                                   {
                                       NSLog(@"push image all finished ok btn clicked");
                                       [self.navigationController popViewControllerAnimated:YES];
                                       
                                   }, self);
        });
        
        
        return;
    }
    
    NSLog(@"push image tip=%@",tip);
    SHOWWINDOWHUD(tip);
    [HouseDataPuller pushImage:image TradeNo:self.succeedHouseTradeNo PictureNO:self.succeedHouseImageNo Type:type Success:^(id responseObject)
     {
         HIDEALLWINDOWHUD;
         NSLog(@"push image one finished,start to next");
         self.uploadProgress++;
         [self performSelectorOnMainThread:@selector(uploadImage) withObject:nil waitUntilDone:YES];
         return;
     }
                          failure:^(NSError *error)
     {
         HIDEALLWINDOWHUD;
         NSLog(@"push image one failed,exit");
         PRESENTALERT(@"失败", @"上传图片时失败，请稍后再试！",@"OK", nil, ^()
                                {
                                    [self.navigationController popViewControllerAnimated:YES];
                                });
         return;
     }];

}



-(NSString*)convertToDicValueForItem:(NSString*)itemName FromValue:(NSString*)value
{
    NSString*dicValue = @"";
    
    NSArray*arr = nil;
    
    if(value && itemName)
    {
        if([itemName isEqualToString:@"house_driect"])
        {
            arr =  self.house_driect_dic_arr;
        }
        else if ([itemName isEqualToString:@"fitment_type"])
        {
            arr =  self.fitment_type_dic_arr;
        }
        else if ([itemName isEqualToString:@"use_situation"])
        {
            arr =  self.use_situation_dic_arr;
        }
        else if ([itemName isEqualToString:@"client_gender"])
        {
            arr =  self.sex_dic_arr;
        }
        else if ([itemName isEqualToString:@"look_permit"])
        {
            arr =  self.look_permit_dic_arr;
        }
        else if ([itemName isEqualToString:@"client_source"])
        {
            arr =  self.client_source_dic_arr;
        }
        else if ([itemName isEqualToString:@"house_application"])
        {
            arr =  self.tene_application_dic_arr;
        }
        else if ([itemName isEqualToString:@"house_driect"])
        {
            arr =  self.house_driect_dic_arr;
        }
        else if ([itemName isEqualToString:@"property_term"])
        {
            arr =  self.build_property_dic_arr;
        }
        else if ([itemName isEqualToString:@"cons_elevator_brand"])
        {
            arr =  self.cons_elevator_brand_dic_arr;
        }
        else if ([itemName isEqualToString:@"facility_gas"])
        {
            arr =  self.facility_gas_dic_arr;
        }
        else if ([itemName isEqualToString:@"facility_heating"])
        {
            arr =  self.facility_heating_dic_arr;
        }
        
        else if ([itemName isEqualToString:@"trade_type"])
        {
            if ([self.trade_type.value isEqualToString:@"出售"])
            {
                return @"100";
            }
            else if ([self.trade_type.value isEqualToString:@"出租"])
            {
                return @"101";
            }
            else if ([self.trade_type.value isEqualToString:@"租售"])
            {
                return @"102";
            }
            
        }
    }
    
    
    
    if (arr)
    {
        for (DicItem*di in arr)
        {
            if ([value  isEqualToString:di.dict_label])
            {
                return di.dict_value;
            }
        }
    }
    return  dicValue;
}



-(void)prepareInfoSectionItems
{
    [self.infoSection removeAllItems];

    //面积
    [self.infoSection addItem:self.structure_area];
    

    //
    //    @property (strong, readwrite, nonatomic) RERadioItem * fitment_type;
    //    //Int
    //    //装修
    [self.infoSection addItem:self.fitment_type];

    //
    //    @property (strong, readwrite, nonatomic) RETextItem * cons_elevator_brand;
    //    //String
    //    //电梯（如奥旳斯
    [self.infoSection addItem:self.cons_elevator_brand];
    
    //
    //    @property (strong, readwrite, nonatomic) RETextItem * facility_heating;
    //    //String
    //    //暖气
    [self.infoSection addItem:self.facility_heating];
    
    //
    //    @property (strong, readwrite, nonatomic) RETextItem * facility_gas;
    //    //String
    //    //燃气
    [self.infoSection addItem:self.facility_gas];
    
    //
    //    @property (strong, readwrite, nonatomic) RERadioItem * build_year;
    //    //Int
    //    //建房年代
    [self.infoSection addItem:self.build_year];
    
    //
    //    @property (strong, readwrite, nonatomic) RERadioItem * property_term;
    //    //Int
    //    //产权年限
    [self.infoSection addItem:self.property_term];
    
    //
    //    @property (strong, readwrite, nonatomic) RERadioItem * use_situation;
    //    //Int
    //    //现状
    [self.infoSection addItem:self.use_situation];
    
    
    
    //
    //    @property (strong, readwrite, nonatomic) RETextItem * client_remark;
    //    //String
    //    //备注
    //[self.infoSection addItem:self.client_remark];
    
    //
    //    @property (strong, readwrite, nonatomic) RETextItem * b_staff_describ;
    //    //String
    //    //房源描述
    [self.infoSection addItem:self.describ];
    
    
    //
    //    @property (strong, readwrite, nonatomic) RERadioItem * client_source;
    //    //String
    //    //信息来源
    [self.infoSection addItem:self.client_source];
    
    
    //@property (strong, readwrite, nonatomic) RERadioItem * look_permit;
    //String
    //看房:
    //预约
    //有钥匙
    //借钥匙
    //直接
    [self.infoSection addItem:self.look_permit];
    
}

-(void)prepareSecretSectionItems
{
    [super prepareSecretSectionItems];

    [self.secretSection removeAllItems];
    
    self.client_name.value = @"";
    self.obj_mobile.value = @"";
    self.client_remark.value = @"";
    
    [self.secretSection addItem:self.client_name];
    [self.secretSection addItem:self.obj_mobile];
    [self.secretSection addItem:self.client_remark];
    
    [self.secretSection addItem:self.trade_type];
}



-(void)adjustByTradeType
{
    if ([self.trade_type.value length] > 0)
    {
        [self.secretSection removeItem:self.lease_state];
        [self.secretSection removeItem:self.rent_listing];
        [self.secretSection removeItem:self.rent_single];
        [self.secretSection removeItem:self.sale_state];
        [self.secretSection removeItem:self.sale_listing];
        [self.secretSection removeItem:self.sale_single];
        [self.secretSection removeItem:self.sale_bottom];
        
        
        [self.secretSection addItem:self.sale_listing];
        [self.secretSection addItem:self.sale_single];
        [self.secretSection addItem:self.sale_bottom];
        [self.secretSection addItem:self.rent_listing];
        [self.secretSection addItem:self.rent_single];
        
        
        if ([self.trade_type.value isEqualToString:@"出售"])
        {
            [self.secretSection removeItem:self.lease_state];
            [self.secretSection removeItem:self.rent_listing];
            [self.secretSection removeItem:self.rent_single];
        }
        else if ([self.trade_type.value isEqualToString:@"出租"])
        {
            [self.secretSection removeItem:self.sale_state];
            [self.secretSection removeItem:self.sale_listing];
            [self.secretSection removeItem:self.sale_single];
            [self.secretSection removeItem:self.sale_bottom];
        }
        else if ([self.trade_type.value isEqualToString:@"租售"])
        {
            
        }
    }

    
    [self.tableView reloadData];
}

-(void)adjustExistingProps
{
    if (self.housePtcl)
    {
        //这里trade_type的值其实是isEstateExist 返回的status值
        //stauts值的含义见文档接口29
        NSInteger tradeType = [self.housePtcl.trade_type intValue];
        switch (tradeType)
        {
            case 1:
            case 2:
            case 3:
            {
                if (self.housePtcl&& self.housePtcl.house_application)
                {
                    for (DicItem *di in self.tene_application_dic_arr)
                    {
                        if ([di.dict_value isEqualToString:self.housePtcl.house_application])
                        {
                            self.house_application.value = di.dict_label;
                            break;
                        }
                    }
                }
                self.house_application.enabled = NO;
                
                self.room_num.value = self.housePtcl.room_num;
                self.room_num.enabled = NO;
                
                self.hall_num.value = self.housePtcl.hall_num;
                self.hall_num.enabled = NO;
                
                self.kitchen_num.value = self.housePtcl.kitchen_num;
                self.kitchen_num.enabled = NO;
                
                self.toilet_num.value = self.housePtcl.toilet_num;
                self.toilet_num.enabled = NO;
                
                self.balcony_num.value = self.housePtcl.balcony_num;
                self.balcony_num.enabled = NO;
                
                self.house_driect.value = self.housePtcl.house_driect;
                self.house_driect.enabled = NO;
                
                self.structure_area.value = self.housePtcl.structure_area;
                self.structure_area.enabled = NO;
                
                self.house_depth.value = self.housePtcl.house_depth;
                self.house_depth.enabled = NO;
                
                self.floor_height.value = self.housePtcl.floor_height;
                self.floor_height.enabled = NO;
                
                self.floor_num.value = self.housePtcl.floor_count;
                self.floor_num.enabled = NO;
                
                self.efficiency_rate.value = self.housePtcl.efficiency_rate;
                self.efficiency_rate.enabled = NO;
                
                
                self.build_year.value = self.housePtcl.build_year;
                self.build_year.enabled = NO;
                
                
                self.property_term.enabled = NO;
                if (self.housePtcl&& self.housePtcl.property_term)
                {
                    for (DicItem *di in self.build_property_dic_arr)
                    {
                        if ([di.dict_value isEqualToString:self.housePtcl.property_term])
                        {
                            self.property_term.value = di.dict_label;
                            break;
                        }
                    }
                }
                
                
                self.fitment_type.enabled = NO;

                
            }
                break;
            default:
            {
                self.house_application.enabled = YES;
                
                self.room_num.value = @"";
                self.room_num.enabled = YES;
                
                self.hall_num.value = @"";
                self.hall_num.enabled = YES;
                
                self.kitchen_num.value = @"";
                self.kitchen_num.enabled = YES;
                
                self.toilet_num.value = @"";
                self.toilet_num.enabled = YES;
                
                self.balcony_num.value = @"";
                self.balcony_num.enabled = YES;
                
                self.house_driect.value = @"";
                self.house_driect.enabled = YES;
                
                self.structure_area.value = @"";
                self.structure_area.enabled = YES;
                
                self.house_depth.value = @"";
                self.house_depth.enabled = YES;
                
                self.floor_height.value = @"";
                self.floor_height.enabled = YES;
                
                self.floor_num.value = @"";
                self.floor_num.enabled = YES;
                
                self.efficiency_rate.value = @"";
                self.efficiency_rate.enabled = YES;
                
                
                self.build_year.value = @"";
                self.build_year.enabled = YES;
                
                self.property_term.value = @"";
                self.property_term.enabled = YES;
                
                
                
                self.fitment_type.value = @"";
                self.fitment_type.enabled = YES;
            }
                break;
        }
    }
}


-(void)getBuildingDetails
{
    SHOWHUD_WINDOW;
    
    [HouseDataPuller pullBuildingDetailsByBuildingNO:self.curBuildings.domain_no Success:^(buildingDetails *dtl,NSArray*arr)
     {
         [self.curBuilidngsOfCurBuildings removeAllObjects];
         if ([arr count] > 0)
         {
             [self.curBuilidngsOfCurBuildings addObjectsFromArray:arr];
             self.curBuildingsDetails = dtl;
             self.building_name.enabled = YES;
             self.judgementBtn.enabled = YES;
         }
         else
         {
             PRESENTALERT(@"楼盘未录入栋座",@"请先联系主管添加栋座信息",@"OK",nil,self);
             self.building_name.enabled = NO;
             self.house_unit.enabled = NO;
             self.judgementBtn.enabled = NO;
         }
         HIDEHUD_WINDOW;
         [self.tableView reloadData];
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
    
    self.domain_name = [[RERadioItem alloc] initWithTitle:@"楼盘名称:" value:@"" selectionHandler:^(RERadioItem *item) {
        [item deselectRowAnimated:YES];
        BuildingsSelectTableViewController*selCtrl = [BuildingsSelectTableViewController initWithDelegate:weakSelf AndCompleteHandler:^(buildings *bld) {
            if (bld)
            {
                //if (bld && self.curBuildings != bld)
                {
                    [self.infoSection removeAllItems];
                    [self.secretSection removeAllItems];
                    [self.teneApplicationAbout removeAllItems];
                    
                    self.curBuildings = bld;
                    self.domain_name.value = bld.domain_name;
                    self.house_urban.value = bld.urbanname;
                    self.house_area.value = bld.areaname;
                    self.domain_address.value = bld.domain_address;
                    [self.curBuilidngsOfCurBuildings removeAllObjects];
                    self.curBuildingsDetails = nil;
                    
                    self.building_name.enabled = YES;
                    
                    //self.house_tablet.enabled = YES;
                    self.building_name.value = @"";
                    self.house_unit.value = @"";
                    [self.tableView reloadData];
                    [self performSelectorOnMainThread:@selector(getBuildingDetails) withObject:nil waitUntilDone:NO];
                    
                }
                
                
            }
            
        }];
        
        [weakSelf.navigationController pushViewController:selCtrl animated:YES];
    }];
    
    
    
    self.building_name = [[RERadioItem alloc] initWithTitle:@"栋座:" value:@"" selectionHandler:^(RERadioItem *item) {
        [item deselectRowAnimated:YES];
        HouseSelectBuildingTableViewController*selCtrl = [HouseSelectBuildingTableViewController initWithDelegate:weakSelf  BuildingsArr:self.curBuilidngsOfCurBuildings AndCompleteHandler:^(building *bld) {
            if (bld)
            {
                [self.infoSection removeAllItems];
                [self.secretSection removeAllItems];
                [self.teneApplicationAbout removeAllItems];
                
                self.building_name.value = bld.building_name;
                
                self.curBuilding = bld;
                self.house_unit.enabled = YES;
                self.house_unit.value = @"";
                
                [self.tableView reloadData];
            }
            
        }];
        
        [weakSelf.navigationController pushViewController:selCtrl animated:YES];
    }];
    
    
    self.house_unit = [[RERadioItem alloc] initWithTitle:@"单元:" value:@"" selectionHandler:^(RERadioItem *item)
    {
        [item deselectRowAnimated:YES]; // same as [weakSelf.tableView deselectRowAtIndexPath:item.indexPath animated:YES];
        
        HouseSelectUnitTableViewController*selectUnitCtrl = [HouseSelectUnitTableViewController ctrlWithDelegate:self BuildingNo:self.curBuilding.building_no AndCompleteHandler:^(houseUnit *houseUnt)
        {
            self.curHouseUnit = houseUnt;
            self.floor_count.value = self.curHouseUnit.floor_count;
            
            
            [self.infoSection removeAllItems];
            [self.secretSection removeAllItems];
            [self.teneApplicationAbout removeAllItems];
            
            self.house_unit.value = self.curHouseUnit.unit_name;
            self.house_tablet.enabled = YES;
            self.judgementBtn.enabled = YES;
            
            
            [self.tableView reloadData];
        }];
        [weakSelf.navigationController pushViewController:selectUnitCtrl animated:YES];
        
//        RETableViewOptionsController *optionsController = [[RETableViewOptionsController alloc] initWithItem:item options:[self.curBuilding getSerialArr] multipleChoice:NO completionHandler:^(RETableViewItem *selectedItem)
//                                                           {
//                                                               
//                                                           }];
//        // Adjust styles
//        optionsController.delegate = weakSelf;
//        optionsController.style = self.teneApplicationAbout.style;
//        if (weakSelf.tableView.backgroundView == nil)
//        {
//            optionsController.tableView.backgroundColor = weakSelf.tableView.backgroundColor;
//            optionsController.tableView.backgroundView = nil;
//        }
//        // Push the options controller
//        [weakSelf.navigationController pushViewController:optionsController animated:YES];
    }];
    
    
    void(^validationBlock)(RETableViewItem* item) = ^(RETableViewItem* item)
    {
        if ([item isEqual:weakSelf.rent_single] ||
            [item isEqual:weakSelf.rent_listing] ||
            [item isEqual:weakSelf.sale_single] ||
            [item isEqual:weakSelf.sale_listing])
        {
            if ([weakSelf.structure_area.value isEqualToString:@""] || [weakSelf.structure_area.value isEqualToString:@"0"] || [weakSelf.structure_area.value floatValue] == 0 )
            {
                [weakSelf.structure_area selectRowAnimated:YES scrollPosition:UITableViewScrollPositionMiddle];
                [weakSelf.tableView reloadData];
                PRESENTALERT(@"请先填写有效的房源建筑面积!", nil, nil,nil, weakSelf);
                return;
            }
        }
            
        
    };
    
    void(^autoFillBlock)(RETableViewItem* item) = ^(RETableViewItem* item)
    {
        if ([item isEqual:weakSelf.rent_single] ||
            [item isEqual:weakSelf.rent_listing] ||
            [item isEqual:weakSelf.sale_single] ||
            [item isEqual:weakSelf.sale_listing])
        {
            if ([weakSelf.structure_area.value isEqualToString:@""] || [weakSelf.structure_area.value isEqualToString:@"0"] || [weakSelf.structure_area.value floatValue] == 0 )
            {
                return;
            }
            else
            {
                if ([item isEqual:weakSelf.rent_single])
                {
                    NSString*newValue =  weakSelf.rent_single.value;
                    
                    if (self.rent_listing)
                    {
                        if ([newValue isEqualToString:@""])
                        {
                            self.rent_listing.value = @"";
                        }
                        else
                        {
                            float value = [newValue floatValue];
                            value = value*[self.structure_area.value floatValue];
                            self.rent_listing.value = [[NSString alloc] initWithFormat:@"%.2f",value];
                        }
                    }
                }
                else if ([item isEqual:weakSelf.rent_listing])
                {
                    NSString*newValue =  weakSelf.rent_listing.value;
                    
                    if (self.rent_single)
                    {
                        if ([newValue isEqualToString:@""])
                        {
                            self.rent_single.value = @"";
                        }
                        else
                        {
                            float value = [newValue floatValue];
                            value = value/[self.structure_area.value floatValue];
                            self.rent_single.value = [[NSString alloc] initWithFormat:@"%.2f",value];
                        }
                    }
                }
                else if ([item isEqual:weakSelf.sale_listing])
                {
                    NSString*newValue =  weakSelf.sale_listing.value;
                    
                    if (self.sale_single)
                    {
                        if ([newValue isEqualToString:@""])
                        {
                            self.sale_single.value = @"";
                        }
                        else
                        {
                            float value = [newValue floatValue];
                            value = value/[self.structure_area.value floatValue];
                            self.sale_single.value = [[NSString alloc] initWithFormat:@"%.2f",value];
                        }
                    }
                }
                else if ([item isEqual:weakSelf.sale_single])
                {
                    NSString*newValue =  weakSelf.sale_single.value;
                    
                    if (self.sale_listing)
                    {
                        if ([newValue isEqualToString:@""])
                        {
                            self.sale_listing.value = @"";
                        }
                        else
                        {
                            float value = [newValue floatValue];
                            value = value*[self.structure_area.value floatValue];
                            self.sale_listing.value = [[NSString alloc] initWithFormat:@"%.2f",value];
                        }
                    }
                }
                [weakSelf.tableView reloadData];
            }
        }
        
        
    };
    
    
    
    
    self.rent_single.onBeginEditing =validationBlock;
    self.rent_listing.onBeginEditing = validationBlock;
    self.sale_listing.onBeginEditing = validationBlock;
    self.sale_single.onBeginEditing = validationBlock;
    
    self.rent_single.onEndEditing =autoFillBlock;
    self.rent_listing.onEndEditing = autoFillBlock;
    self.sale_listing.onEndEditing = autoFillBlock;
    self.sale_single.onEndEditing = autoFillBlock;
}

-(void)prepareTeneApplicationSectionItemsStep1
{
    [self.teneApplicationAbout removeAllItems];
    [self.infoSection removeAllItems];
    [self.secretSection removeAllItems];
    __typeof (&*self) __weak weakSelf = self;

    //这里trade_type的值其实是isEstateExist 返回的status值
    //stauts值的含义见文档接口29
    NSInteger tradeType = [self.housePtcl.trade_type intValue];
    if (tradeType == 1 || tradeType == 2 || tradeType == 3)
    {
        
        
        
        self.house_application = [[RERadioItem alloc] initWithTitle:@"物业用途:" value:@"" selectionHandler:^(RERadioItem *item) {
        }];
        self.house_application.enabled = NO;
        self.house_application.value = self.housePtcl.house_application;
        [self.teneApplicationAbout addItem:self.house_application];
        [self prepareTeneApplicationSectionItemsStep2ByTenenType:self.housePtcl.house_application];
        [self.tableView reloadData];
    }
    else
    {
        self.house_application.enabled = YES;
        self.house_application = [[RERadioItem alloc] initWithTitle:@"物业用途:" value:@"" selectionHandler:^(RERadioItem *item) {
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
                                                                   
                                                                   //[item reloadRowWithAnimation:UITableViewRowAnimationNone];
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
        
        [self.teneApplicationAbout addItem:self.house_application];
        [self.tableView reloadData];
    }
    
    
    
    
    
    
}

-(void)prepareTeneApplicationSectionItemsStep2ByTenenType:(NSString*)type
{
    [self.teneApplicationAbout removeItem:self.room_num];
    [self.teneApplicationAbout removeItem:self.hall_num];
    [self.teneApplicationAbout removeItem:self.kitchen_num];
    [self.teneApplicationAbout removeItem:self.toilet_num];
    [self.teneApplicationAbout removeItem:self.balcony_num];
    [self.teneApplicationAbout removeItem:self.house_driect];
    
    [self.teneApplicationAbout removeItem:self.efficiency_rate];
    [self.teneApplicationAbout removeItem:self.house_depth];
    [self.teneApplicationAbout removeItem:self.floor_height];
    [self.teneApplicationAbout removeItem:self.floor_num];
    [self.teneApplicationAbout removeItem:self.house_rank];
    
    [self.room_num setValue:@""];
    [self.hall_num setValue:@""];
    [self.kitchen_num setValue:@""];
    [self.toilet_num setValue:@""];
    [self.balcony_num setValue:@""];
    [self.house_driect setValue:@""];
    
    [self.efficiency_rate setValue:@""];
    [self.house_depth setValue:@""];
    [self.floor_height setValue:@""];
    [self.floor_num setValue:@""];
    [self.house_rank setValue:@""];
    
    [self.trade_type setValue:@""];
    
    self.floor_height.title = @"高度";
    if ([type  isEqualToString:@"商铺"])
    {
        self.house_rank.title = @"位置";
        [self.teneApplicationAbout addItem:self.house_rank];
        [self.teneApplicationAbout addItem:self.house_depth];
        [self.teneApplicationAbout addItem:self.floor_height];
        [self.teneApplicationAbout addItem:self.floor_num];
        [self.teneApplicationAbout addItem:self.house_driect];
        
    }
    else if([type  isEqualToString:@"商住"])
    {
        self.house_rank.title = @"位置";
        [self.teneApplicationAbout addItem:self.house_rank];
        [self.teneApplicationAbout addItem:self.floor_height];
        [self.teneApplicationAbout addItem:self.floor_num];
        [self.teneApplicationAbout addItem:self.house_driect];
    }
    else if([type  isEqualToString:@"厂房"])
    {
        self.house_rank.title = @"位置";
        [self.teneApplicationAbout addItem:self.house_rank];
        [self.teneApplicationAbout addItem:self.floor_num];
        [self.teneApplicationAbout addItem:self.house_driect];
    }
    else if([type  isEqualToString:@"仓库"])
    {
        self.house_rank.title = @"位置";
        [self.teneApplicationAbout addItem:self.house_rank];
        [self.teneApplicationAbout addItem:self.floor_height];
        [self.teneApplicationAbout addItem:self.floor_num];
        [self.teneApplicationAbout addItem:self.house_driect];
    }
    else if([type  isEqualToString:@"地皮"])
    {
        self.house_rank.title = @"位置";
        [self.teneApplicationAbout addItem:self.house_rank];
        [self.teneApplicationAbout addItem:self.floor_height];
        [self.teneApplicationAbout addItem:self.floor_num];
        [self.teneApplicationAbout addItem:self.house_driect];

    }
    else if([type  isEqualToString:@"车位"])
    {
        self.house_rank.title = @"车位类型";
        [self.floor_height setTitle:@"宽度"];
        [self.teneApplicationAbout addItem:self.house_rank];
        [self.teneApplicationAbout addItem:self.house_depth];
        [self.teneApplicationAbout addItem:self.floor_height];
    }
    else if([type  isEqualToString:@"写字楼"])
    {
        self.house_rank.title = @"级别";
        
        [self.teneApplicationAbout addItem:self.house_rank];
        [self.teneApplicationAbout addItem:self.floor_height];
        [self.teneApplicationAbout addItem:self.floor_num];
        [self.teneApplicationAbout addItem:self.efficiency_rate];
        [self.teneApplicationAbout addItem:self.house_driect];
    }
    else
    {
        [self.teneApplicationAbout addItem:self.room_num];
        [self.teneApplicationAbout addItem:self.hall_num];
        [self.teneApplicationAbout addItem:self.kitchen_num];
        [self.teneApplicationAbout addItem:self.toilet_num];
        [self.teneApplicationAbout addItem:self.balcony_num];
        [self.teneApplicationAbout addItem:self.house_driect];
    }
    
    
    
    [self setInfoSectionItemsValue];
    [self prepareInfoSectionItems];
    [self adjustExistingProps];
    [self prepareSecretSectionItems];
    
    
    [self.tableView reloadData];
}

-(void)prepareAddInfoSectionItems
{
    [self.addInfoSection removeAllItems];
    
    

    //楼盘
    [self.addInfoSection addItem:self.domain_name];
    //区域
    self.house_urban.enabled = NO;
    [self.addInfoSection addItem:self.house_urban];
    //片区
    self.house_area.enabled = NO;
    [self.addInfoSection addItem:self.house_area];
    //地址
    self.domain_address.enabled = NO;
    [self.addInfoSection addItem:self.domain_address];
    //栋座
    self.building_name.enabled = NO;
    [self.addInfoSection addItem:self.building_name];
    //单元
    self.house_unit.enabled = NO;
    [self.addInfoSection addItem:self.house_unit];
    
    //门牌号
    self.house_tablet.enabled = NO;
    self.house_tablet.placeholder = @"楼层(2位) + 房间号(数字)";
    [self.addInfoSection addItem:self.house_tablet];

    [self.house_tablet addObserver:self forKeyPath:@"value" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
    
    //楼层
    self.house_floor.enabled = NO;
    [self.addInfoSection addItem:self.house_floor];
    
    //总楼层
    self.floor_count.enabled = NO;
    [self.addInfoSection addItem:self.floor_count];
    
    
    //@property(strong,nonatomic)RETableViewItem* judgementBtn;
    //判重按钮
    
    self.judgementBtn = [RETableViewItem itemWithTitle:@"判重" accessoryType:UITableViewCellAccessoryNone selectionHandler:^(RETableViewItem *item)
                         {
                             [item deselectRowAnimated:YES];
                             if (self.judgementBtn.enabled == NO)
                             {
                                 return;
                             }
                             
                             
                             NSString*bldName = [self.building_name.value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                             
                             NSString*unt = [self.house_unit.value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                             
                             NSString*tab = [self.house_tablet.value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                             
                             if([bldName isEqualToString:@""] || [unt isEqualToString:@""] || [tab length] < 3 || self.curBuildings == nil || self.curBuilding ==nil)
                             {
                                 PRESENTALERT(@"请先填写完整房屋信息", nil, nil, nil,self);
                             }
                             else
                             {
                                 
                                 NSString*tmpFloor =[self.house_tablet.value substringToIndex:2];
                                 NSInteger iFloor = [tmpFloor intValue];
                                 NSInteger iMaxFloor =[self.curHouseUnit.floor_count intValue];
                                 
                                 if (iFloor < 0 || iFloor > iMaxFloor)
                                 {
                                     PRESENTALERT(@"请填写正确的楼层", nil, nil, nil,self);
                                 }
                                 else
                                 {
                                     tmpFloor = [NSString stringWithFormat:@"%d",(int)iFloor];
                                     self.house_floor.value = tmpFloor;
                                     [self judgeHouseByBuildings:self.curBuildings Building:self.curBuilding Unit:self.curHouseUnit.unit_no Table:self.house_tablet.value];
                                 }
                                 
                             }
                             
                         }];
    self.judgementBtn.textAlignment = NSTextAlignmentCenter;
    self.judgementBtn.enabled = NO;
    //判重按钮
    [self.addInfoSection addItem:self.judgementBtn];
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"value"] && [object isEqual:self.house_tablet])
    {
        NSString*newValue =  [change valueForKey:NSKeyValueChangeNewKey];
        if (self.judgementBtn)
        {
            self.judgementBtn.enabled = YES;
        }
        if (self.house_floor)
        {
            if (newValue.length >=2)
            {
                if ([self.house_floor.value isEqualToString:@""])
                {
                    NSString*floorValue = [NSString stringWithFormat:@"%d",[[newValue substringToIndex:2] intValue]];
                    self.house_floor.value =floorValue;
                    [self.house_floor reloadRowWithAnimation:UITableViewRowAnimationBottom];
                }
                

            }
            else
            {
                if (![self.house_floor.value isEqualToString:@""])
                {
                    self.house_floor.value =@"";
                    [self.house_floor reloadRowWithAnimation:UITableViewRowAnimationBottom];
                }
            }
        }
    }
    else if([keyPath isEqualToString:@"value"] && [object isEqual:self.structure_area])
    {
        
    }
    else if([keyPath isEqualToString:@"value"] && [object isEqual:self.rent_single])
    {
        if ([self.structure_area.value isEqualToString:@""] || [self.structure_area.value isEqualToString:@"0"])
        {
            //[self.lease_value_single removeObserver:self forKeyPath:@"value" context:NULL];
            
            //[self.lease_value_single addObserver:self forKeyPath:@"value" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
            
            PRESENTALERT(@"请先填写有效的房源建筑面积!", nil, nil, nil,nil);
            return;
        }
        
        NSString*newValue =  [change valueForKey:NSKeyValueChangeNewKey];

        if (self.rent_listing)
        {
            if ([newValue isEqualToString:@""])
            {
                self.rent_listing.value = @"";
            }
            else
            {
                float value = [newValue floatValue];
                value = value*[self.structure_area.value floatValue];
                self.rent_listing.value = [[NSString alloc] initWithFormat:@"%.2f",value];
            }
        }
    }
    else if([keyPath isEqualToString:@"value"] && [object isEqual:self.rent_listing])
    {
        if ([self.structure_area.value isEqualToString:@""] || [self.structure_area.value isEqualToString:@"0"])
        {
            PRESENTALERT(@"请先填写有效的房源建筑面积!", nil, nil,nil, nil);
            return;
        }
        
        
        
    }
    else if([keyPath isEqualToString:@"value"] && [object isEqual:self.sale_single])
    {
        if ([self.structure_area.value isEqualToString:@""] || [self.structure_area.value isEqualToString:@"0"])
        {
            PRESENTALERT(@"请先填写有效的房源建筑面积!", nil, nil,nil, nil);
            return;
        }
    }
    else if([keyPath isEqualToString:@"value"] && [object isEqual:self.sale_listing])
    {
        if ([self.structure_area.value isEqualToString:@""] || [self.structure_area.value isEqualToString:@"0"])
        {
            PRESENTALERT(@"请先填写有效的房源建筑面积!", nil, nil, nil,nil);
            return;
        }
    }
    else
    {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

-(void)judgeHouseByBuildings:(buildings*)bldings Building:(building*)blding Unit:(NSString*)unit Table:(NSString*)table
{
    SHOWWINDOWHUD(@"正在判重...");
    
    NSMutableDictionary*dic = [[NSMutableDictionary alloc] init];
    [dic setValue:bldings.domain_no forKey:@"domain_no"];
    [dic setValue:blding.building_no forKey:@"building_no"];
    [dic setValue:unit forKey:@"unit_no"];
    
    [dic setValue:table forKey:@"house_tablet"];
    //[dic setValue:[table substringToIndex:2] forKey:@"house_floor"];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    [HouseDataPuller pullIsHouseExisting:dic Success:^(HouseParticulars*hosuePtl)
     {
         HIDEHUD_WINDOW;
         self.housePtcl = hosuePtl;
         int tradeState = [hosuePtl.trade_type intValue];
         switch (tradeState)
         {
             case 0:
             {
                 PRESENTALERT(@"该房源尚未添加", @"可以添加房源,并添加:出售,出租,租售三种交易信息", nil,nil, self);
             }
                 break;
             case 1:
             {
                 PRESENTALERT(@"该房源已添加", @"可以添加:出售,出租,租售三种交易信息", nil,nil, self);
             }
                 break;
             case 2:
             {
                 PRESENTALERT(@"该房源存在出售交易信息", @"只能添加:出租交易信息", nil,nil, self);
             }
                 break;
             case 3:
             {
                 PRESENTALERT(@"该房源存在出租交易信息", @"只能添加:出售交易信息", nil,nil, self);
             }
                 break;
             case 4:
             {
                 PRESENTALERT(@"该房源存在租售交易信息", @"不能再添加交易信息", nil,nil, self);
                 
             }
                 break;
             default:
                 break;
         }
         if (tradeState != 4)
         {
             self.navigationItem.rightBarButtonItem.enabled = YES;
             [self prepareTeneApplicationSectionItemsStep1];
         }
         
         
     }
                                             failure:^(NSError* error)
     {
         PRESENTALERT(@"服务器判重失败,请重判", nil, nil,nil, nil);
         HIDEHUD_WINDOW;
     }];
}

-(BOOL)checkValid
{
    NSMutableArray*requiredFields = [[NSMutableArray alloc] init];
    [requiredFields addObjectsFromArray:[self.addInfoSection items]];
    [requiredFields addObjectsFromArray:[self.teneApplicationAbout items]];
    [requiredFields addObjectsFromArray:[self.infoSection items]];
    [requiredFields addObjectsFromArray:[self.secretSection items]];
    
    //这里trade_type的值其实是isEstateExist 返回的status值
    //stauts值的含义见文档接口29
    if (self.housePtcl && self.housePtcl.trade_type)
    {
        int tradeState = [self.housePtcl.trade_type intValue];
        switch (tradeState)
        {
            case 0://新增房源
            {
                [requiredFields removeObject:self.balcony_num];
                [requiredFields removeObject:self.toilet_num];
                [requiredFields removeObject:self.build_year];
                [requiredFields removeObject:self.property_term];
                [requiredFields removeObject:self.sale_bottom];
                [requiredFields removeObject:self.client_remark];
                [requiredFields removeObject:self.b_staff_describ_to_view_html];
                [requiredFields removeObject:self.look_permit];
                [requiredFields removeObject:self.judgementBtn];
                [requiredFields removeObject:self.sale_single];
                [requiredFields removeObject:self.rent_single];
            }
                break;
            case 1://新增交易信息
            case 2:
            case 3:
            {
                [requiredFields removeAllObjects];
                [requiredFields addObject:self.use_situation];
                [requiredFields addObject:self.describ];
                [requiredFields addObject:self.client_source];
                
                [requiredFields addObject:self.client_name];
                [requiredFields addObject:self.obj_mobile];
                
                
                if ([self.trade_type.value isEqualToString:@"出租"])
                {
                    [requiredFields addObject:self.rent_listing];
                    [requiredFields addObject:self.rent_single];
                }
                else if ([self.trade_type.value isEqualToString:@"出售"])
                {
                    [requiredFields addObject:self.sale_listing];
                    [requiredFields addObject:self.sale_single];
                }
                else if ([self.trade_type.value isEqualToString:@"租售"])
                {
                    [requiredFields addObject:self.rent_listing];
                    [requiredFields addObject:self.rent_single];
                    [requiredFields addObject:self.sale_listing];
                    [requiredFields addObject:self.sale_single];
                }
            }
                break;
            default:
                break;
        }
    }
    

    
    return [self checkField:requiredFields];
}


-(BOOL)checkField:(NSArray*)fields
{
    BOOL allOK = YES;
    int count = 0;
    NSString* all = @"";
    
    NSArray* clsArr = @[[RETextItem class],
                        [RERadioItem class],
                        [RENumberItem class],
                        [RELongTextItem class]];
    
    if (fields)
    {
        for (RETableViewItem*item in fields)
        {
            for (Class cls in clsArr)
            {
                if ([item isKindOfClass:cls])
                {
                    SEL sel =@selector(value);
                    if ([item respondsToSelector:sel])
                    {
                        
                        NSString*vl = [item performSelector:sel];
                        vl = [vl stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                        if ([vl isEqualToString:@""])
                        {
                            all = [all stringByAppendingString:item.title];
                            all = [all stringByAppendingString:@"\r\n"];
                            allOK = NO;
                            count++;
                        }
                    }
                    break;
                }
            }
        }
    }
    
    if (!allOK)
    {
        NSString* promptTitle = [NSString stringWithFormat:@"有%d个必填信息未填!",count];
        
        
        all = [all stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        PRESENTALERT(promptTitle, all, nil,nil, nil);
    }
    
    return allOK;
}



@end
