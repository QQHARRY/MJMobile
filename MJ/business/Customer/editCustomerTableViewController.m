//
//  editCustomerTableViewController.m
//  MJ
//
//  Created by harry on 15/1/27.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//

#import "editCustomerTableViewController.h"
#import "dictionaryManager.h"
#import "UtilFun.h"
#import "CustomerDataPuller.h"

@interface editCustomerTableViewController ()

@end

@implementation editCustomerTableViewController

+(editCustomerTableViewController*)editCtrlWithCusParticulars:(CustomerParticulars*)ptl AndSecrect:(CustomerSecret*)secret  AreaDic:(NSArray*)areaDic Hander:(void(^)())selectionHandler
{
    editCustomerTableViewController*editCtrl = [[editCustomerTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    editCtrl.cusPtrl = ptl;
    editCtrl.cusSecretPtrl = secret;
    editCtrl.areaDictList = areaDic;
    editCtrl.handler =selectionHandler;
    return editCtrl;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
   self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(sumitBtnClicked:)];
}

-(void)sumitBtnClicked:(id)sender
{
    if ([self checkValid])
    {
        NSDictionary*dic  = [self getFiledsDic];
        NSMutableDictionary*dicm = [NSMutableDictionary dictionaryWithDictionary:dic];
        
        
        if (self.curBuildings)
        {
            [dicm setValue:self.curBuildings.domain_no forKey:@"requirement_buildings_no"];
        }
        else
        {
            [dicm setValue:self.cusPtrl.requirement_buildings_no forKey:@"requirement_buildings_no"];
        }
        
        [dicm setValue:self.cusPtrl.business_requirement_no forKey:@"business_requirement_no"];
        
        [dicm removeObjectForKey:@"name_full"];
        [self submit:dicm];
    }
}

-(void)submit:(NSDictionary*)dic
{
    SHOWHUD_WINDOW;
    
    [CustomerDataPuller pullEditCustomer:dic Success:^(id obj) {
        HIDEHUD_WINDOW;
        
        if (self.handler)
        {
            self.handler();
        }
    } failure:^(NSError *error) {
        HIDEHUD_WINDOW;
        PRESENTALERT(@"编辑失败", error.localizedDescription, nil, nil,nil);
    }];
    
}

-(void)createItems
{
    [super createItems];
    self.curPerson = nil;
    self.curBuildings = nil;
    if (self.cusPtrl)
    {
        //@property(nonatomic,strong) RERadioItem *requirement_status;//客源状态
        
        NSString *l = @"";
        for (DicItem *di in self.requirementDictList)
        {
            if ([di.dict_value isEqualToString:self.cusPtrl.requirement_status])
            {
                l = di.dict_label;
                break;
            }
        }
        self.requirement_status.value = l;
        
        //@property(nonatomic,strong) RETextItem *client_name;//客户姓名
        self.client_name.value = self.cusPtrl.client_name;
        
        //@property(nonatomic,strong) RERadioItem *client_gender;//客户性别
        l = @"";
        for (DicItem *di in self.sex_dic_arr)
        {
            if ([di.dict_value isEqualToString:self.cusPtrl.client_gender])
            {
                l = di.dict_label;
                break;
            }
        }
        self.client_gender.value = l;
        
        
        //@property(nonatomic,strong) RERadioItem *client_level;//客户等级
        l = @"";
        for (DicItem *di in self.client_level_dic_arr)
        {
            if ([di.dict_value isEqualToString:self.cusPtrl.client_level])
            {
                l = di.dict_label;
                break;
            }
        }
        self.client_level.value = l;
        
        //@property(nonatomic,strong) RERadioItem *client_background;//客户类别
        l = @"";
        for (DicItem *di in self.client_type_dic_arr)
        {
            if ([di.dict_value isEqualToString:self.cusPtrl.client_background])
            {
                l = di.dict_label;
                break;
            }
        }
        self.client_background.value = l;
        
        
        //@property(nonatomic,strong) RERadioItem *requirement_house_urban;//所属城区编号
        
        l = @"";
        for (NSDictionary *areaDict in self.areaDictList)
        {
            NSString *hno = [areaDict objectForKey:@"no"];
            if ([hno isEqualToString:self.cusPtrl.requirement_house_urban])
            {
                l = [[areaDict objectForKey:@"dict"] objectForKey:@"area_name"];
                break;
            }
        }
        self.requirement_house_urban.value = l;
        
        //@property(nonatomic,strong) RERadioItem *requirement_house_area;//所属片区编号
        l = @"";
        for (NSDictionary *areaDict in self.areaDictList)
        {
            NSArray *sectionList = [areaDict objectForKey:@"sections"];
            BOOL bFind = false;
            for (NSDictionary *sectionDict in sectionList)
            {
                if ([[sectionDict objectForKey:@"area_cno"] isEqualToString:self.cusPtrl.requirement_house_area])
                {
                    l = [sectionDict objectForKey:@"area_name"];
                    bFind = true;
                    break;
                }
            }
            if (bFind)
            {
                break;
            }
        }
        self.requirement_house_area.value = l;

        //@property(nonatomic,strong) RERadioItem *buildings_name;//楼盘编号
        self.buildings_name.value = self.cusPtrl.buildings_name;
        
        
//        @property(nonatomic,strong) RERadioItem *requirement_tene_application;//物业用途
        l = @"";
        for (DicItem *di in self.tene_application_dic_arr)
        {
            if ([di.dict_value isEqualToString:self.cusPtrl.requirement_tene_application])
            {
                l = di.dict_label;
                break;
            }
        }
        self.requirement_tene_application.value = l;
        
        
//        @property(nonatomic,strong) RERadioItem *requirement_tene_type;//物业类型
        l = @"";
        for (DicItem *di in self.tene_type_dic_arr)
        {
            if ([di.dict_value isEqualToString:self.cusPtrl.requirement_tene_type])
            {
                l = di.dict_label;
                break;
            }
        }
        self.requirement_tene_type.value = l;
        
        
//        @property(nonatomic,strong) RERadioItem *requirement_fitment_type;//装修类型
        l = @"";
        for (DicItem *di in self.fitment_type_dic_arr)
        {
            if ([di.dict_value isEqualToString:self.cusPtrl.requirement_fitment_type])
            {
                l = di.dict_label;
                break;
            }
        }
        self.requirement_fitment_type.value = l;
        
//        @property(nonatomic,strong) RERadioItem *requirement_house_driect;//朝向
        l = @"";
        for (DicItem *di in self.house_driect_dic_arr)
        {
            if ([di.dict_value isEqualToString:self.cusPtrl.requirement_house_driect])
            {
                l = di.dict_label;
                break;
            }
        }
        self.requirement_house_driect.value = l;
        
//        @property(nonatomic,strong) RENumberItem *requirement_floor_from;//Int最低楼层要求
        self.requirement_floor_from.value = self.cusPtrl.requirement_floor_from;
        
        
//        @property(nonatomic,strong) RENumberItem *requirement_floor_to;//Int最高楼层要求
        self.requirement_floor_to.value = self.cusPtrl.requirement_floor_to;
        
//        @property(nonatomic,strong) RENumberItem *requirement_room_from;//Int最少卧室数量 要求
        self.requirement_room_from.value = self.cusPtrl.requirement_room_from;
        
        
//        @property(nonatomic,strong) RENumberItem *requirement_room_to;//Int最大卧室数量 要求
        self.requirement_room_to.value = self.cusPtrl.requirement_room_to;
        
//        @property(nonatomic,strong) RENumberItem *requirement_hall_from;//Int最少厅数量要 求
        self.requirement_hall_from.value = self.cusPtrl.requirement_hall_from;
        
        
//        @property(nonatomic,strong) RENumberItem *requirement_hall_to;//Int最大厅数量要 求
        self.requirement_hall_to.value = self.cusPtrl.requirement_hall_to;
        
//        @property(nonatomic,strong) RENumberItem *requirement_area_from;//最小面积要求
        self.requirement_area_from.value = self.cusPtrl.requirement_area_from;
        
//        @property(nonatomic,strong) RENumberItem *requirement_area_to;//String最大面积要求
        self.requirement_area_to.value = self.cusPtrl.requirement_area_to;
        
//        @property(nonatomic,strong) RERadioItem *requirement_client_source;//String客户来源
        l = @"";
        for (DicItem *di in self.client_source_dic_arr)
        {
            if ([di.dict_value isEqualToString:self.cusPtrl.requirement_client_source])
            {
                l = di.dict_label;
                break;
            }
        }
        self.requirement_client_source.value = l;
        
//        @property(nonatomic,strong) RERadioItem *business_requirement_type;//求租或求购
        l = @"";
        if ([self.cusPtrl.business_requirement_type isEqualToString:@"200"])
        {
            l = @"求购";
        }
        else if ([self.cusPtrl.business_requirement_type isEqualToString:@"201"])
        {
            l = @"求租";
        }
        else if ([self.cusPtrl.business_requirement_type isEqualToString:@"202"])
        {
            l = @"租购";
        }
        self.business_requirement_type.value = l;
        [self adjustItemsByTradeType:self.business_requirement_type.value];
        
//        @property(nonatomic,strong) RENumberItem *requirement_sale_price_from;//String//￼最低求购价格
        self.requirement_sale_price_from.value = self.cusPtrl.requirement_sale_price_from;

//        @property(nonatomic,strong) RENumberItem *requirement_sale_price_to;//最高求购价格
        self.requirement_sale_price_to.value = self.cusPtrl.requirement_sale_price_to;
        
//        @property(nonatomic,strong) RERadioItem *sale_price_unit;//求购价格单位
//        l = @"";
//        NSString*unt = self.cusPtrl.sale_price_unit;
//        for (DicItem *di in self.sale_price_unit_dic_arr)
//        {
//            NSString*ll = di.dict_label;
//            NSString*vv = di.dict_value;
//            
//            if ([di.dict_label isEqualToString:self.cusPtrl.sale_price_unit])
//            {
//                l = di.dict_value;
//                break;
//            }
//        }
        self.sale_price_unit.value = self.cusPtrl.sale_price_unit;
        
        
        
//        @property(nonatomic,strong) RENumberItem *requirement_lease_price_from;//最低求租价格
        self.requirement_lease_price_from.value = self.cusPtrl.requirement_lease_price_from;
        
//        @property(nonatomic,strong) RENumberItem *requirement_lease_price_to;//最高求租价格
        self.requirement_lease_price_to.value = self.cusPtrl.requirement_lease_price_to;
//        @property(nonatomic,strong) RERadioItem *lease_price_unit;//求租价格单位
//        l = @"";
//        for (DicItem *di in self.lease_price_unit_dic_arr)
//        {
//            if ([di.dict_label isEqualToString:self.cusPtrl.lease_price_unit])
//            {
//                l = di.dict_value;
//                break;
//            }
//        }
        self.lease_price_unit.value = self.cusPtrl.lease_price_unit;
        
        
//        
//        @property(nonatomic,strong) RETextItem *requirement_memo;//备注
         self.requirement_memo.value = self.cusPtrl.requirement_memo;
        
//        
//        @property(nonatomic,strong) RERadioItem *name_full;//置业顾问名字
    }
    
    if (self.cusSecretPtrl)
    {
        
//        @property(nonatomic,strong) RETextItem *mobilePhone;//手机
        self.mobilePhone.value = self.cusSecretPtrl.obj_mobile;
        
//        @property(nonatomic,strong) RETextItem *fixPhone;//固话
        self.fixPhone.value = self.cusSecretPtrl.obj_fixtel;
        
        
        
//        @property(nonatomic,strong) RETextItem *idCardNO;//身份证
        self.idCardNO.value = self.cusSecretPtrl.client_identity;
        
//        @property(nonatomic,strong) RETextItem *homeAddress;//家庭地址
        self.homeAddress.value = self.cusSecretPtrl.obj_address;
        
//        
//        @property(nonatomic,strong) NSString *obj_mobile;
//        @property(nonatomic,strong) NSString *obj_fixtel;
//        @property(nonatomic,strong) NSString *client_identity;
//        @property(nonatomic,strong) NSString *obj_address;
    }
    
    [self.staffSection removeItem:self.name_full];
    
    
}

@end
