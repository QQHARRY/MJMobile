//
//  HouseViewController.m
//  MJ
//
//  Created by harry on 14-11-23.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import "HouseViewController.h"
#import "NetWorkManager.h"
#import "UtilFun.h"
#import "Macro.h"
#import "person.h"
#import "HouseFilter.h"
#import "HouseFilterController.h"
#import "HouseAddNewViewController.h"
#import "MJDropDownMenuBar.h"
#import "MJDropDownMenu.h"
#import "MJMenuItem.h"
#import "MJMenuItemValue.h"
#import "MJMenuModel.h"


#define MENUBAR_HEIGHT 32
#define TABBAR_HEIGHT 44

@interface HouseViewController ()<MJDropDownMenuBarDataSource,MJDropDownMenuBarDelegate,MJDropDownMenuDataSource,MJDropDownMenuDelegate>

@property(nonatomic,strong)HouseFilterController *houseFilterVC;
@property(strong,nonatomic)MJDropDownMenuBar*sellMenuBar;
@property(strong,nonatomic)MJDropDownMenuBar*rentMenuBar;
@property(strong,nonatomic)MJDropDownMenu*rent_areaMenu;
@property(strong,nonatomic)MJDropDownMenu*rent_priceMenu;
@property(strong,nonatomic)MJDropDownMenu*rent_DeptMenu;
@property(strong,nonatomic)MJDropDownMenu*rent_houseModelMenu;
@property(strong,nonatomic)MJDropDownMenu*rent_moreMenu;


@property(strong,nonatomic)MJDropDownMenu*sell_areaMenu;
@property(strong,nonatomic)MJDropDownMenu*sell_priceMenu;
@property(strong,nonatomic)MJDropDownMenu*sell_DeptMenu;
@property(strong,nonatomic)MJDropDownMenu*sell_houseModelMenu;
@property(strong,nonatomic)MJDropDownMenu*sell_moreMenu;


@property(strong,nonatomic)NSMutableArray*urbanArr;
@property(strong,nonatomic)NSMutableArray*areaArr;
@property(strong,nonatomic)NSMutableArray*priceArr;


@property(strong,nonatomic)NSMutableArray*menu_urbanAreaArr;
@property(strong,nonatomic)NSMutableArray*menu_sellPriceArr;
@property(strong,nonatomic)NSMutableArray*menu_rentPriceArr;
@property(strong,nonatomic)NSMutableArray*menu_deptArr;







@property(strong,nonatomic)NSMutableArray*menu_areaArr;
@property(strong,nonatomic)NSMutableArray*menu_hallArr;
@property(strong,nonatomic)NSMutableArray*menu_floorArr;
@property(strong,nonatomic)NSMutableArray*menu_orientArr;
@property(strong,nonatomic)NSMutableArray*menu_FitTypeArr;
@property(strong,nonatomic)NSMutableArray*menu_SellStausArr;
@property(strong,nonatomic)NSMutableArray*menu_LeaseStausArr;
@property(strong,nonatomic)NSMutableArray*menu_ConsignmentStausArr;
@property(strong,nonatomic)NSMutableArray*menu_RoomTypeArr;
@property(strong,nonatomic)NSMutableArray*menu_OtherArr;


@end


//#define TESTDATA

@implementation HouseViewController

- (void)viewDidLoad
{
    // init controller base info
    self.title = @"房源";
    self.dataSource = self;
    self.delegate = self;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    // default is sell controller
    self.nowControllerType = HCT_SELL;
    self.applyForRefresh = NO;
    // ios version fixed code
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    if ([[UIDevice currentDevice].systemVersion floatValue] > 7.0)
    {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
        self.navigationController.navigationBar.translucent = NO;
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
#endif

    // add title button
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"筛选" style:UIBarButtonItemStylePlain target:self action:@selector(onFilterAction:)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(onAddEstate:)];
    
    // add table view controller
    self.rentController = [[HouseTableViewController alloc] initWithNibName:@"HouseTableViewController" bundle:[NSBundle mainBundle]];
    self.rentController.controllerType = HCT_RENT;
    self.rentController.container = self;
    self.rentController.filter = [[HouseFilter alloc] init];
//    self.rentController.filter.consignment_type = @"1"; // 委托类型：A-独家 是”0”、B-一般 是”1”、C-未签 是”2” * TODO
    self.rentController.filter.trade_type = @"101";
//    self.rentController.filter.sale_trade_state = @"0";
    self.rentController.filter.lease_trade_state = @"0";
    self.rentController.filter.FromID = @"0";
    self.rentController.filter.ToID = @"0";
    self.rentController.filter.Count = @"10";
    self.sellController = [[HouseTableViewController alloc] initWithNibName:@"HouseTableViewController" bundle:[NSBundle mainBundle]];
    self.sellController.controllerType = HCT_SELL;
    self.sellController.container = self;
    self.sellController.filter = [[HouseFilter alloc] init];
//    self.sellController.filter.consignment_type = @"1"; // 委托类型：A-独家 是”0”、B-一般 是”1”、C-未签 是”2” * TODO
    self.sellController.filter.trade_type = @"100";
    self.sellController.filter.sale_trade_state = @"0";
//    self.sellController.filter.lease_trade_state = @"0";
    self.sellController.filter.FromID = @"0";
    self.sellController.filter.ToID = @"0";
    self.sellController.filter.Count = @"10";
    
#if 1
    [self.sellController.tableView setContentInset:UIEdgeInsetsMake(MENUBAR_HEIGHT, 0, 0, 0)];
    [self.rentController.tableView setContentInset:UIEdgeInsetsMake(MENUBAR_HEIGHT, 0, 0, 0)];
    

    _sellMenuBar = [[MJDropDownMenuBar alloc] initWithOrigin:CGPointMake(0, TABBAR_HEIGHT) andHeight:MENUBAR_HEIGHT];
    _sellMenuBar.dataSource = self;
    _sellMenuBar.delegate = self;
    
    _rentMenuBar = [[MJDropDownMenuBar alloc] initWithOrigin:CGPointMake(0, TABBAR_HEIGHT) andHeight:MENUBAR_HEIGHT];
    _rentMenuBar.dataSource = self;
    _rentMenuBar.delegate = self;
    
    [self.view addSubview:_sellMenuBar];
    [self.view addSubview:_rentMenuBar];
    
    _rentMenuBar.hidden = YES;
    
    [self initMenuData];
    
#endif
    // super fun
    [super viewDidLoad];
    
    
    
}

-(void)initMenuData
{
    _urbanArr = [[NSMutableArray alloc] initWithArray:@[@"不限",@"城北",@"城东",@"城南"]];
    _areaArr = [[NSMutableArray alloc] initWithArray: @[
                                                        @[@"不限"],
                                                        @[@"不限",@"北稍门",@"龙首村"],
                                                        @[@"不限",@"长乐东路",@"长乐坊",@"韩森寨"],
                                                        @[@"不限",@"南稍门",@"大雁塔",@"明德门",@"陕师大"]]];
    _priceArr = [[NSMutableArray alloc] initWithArray:@[@"不限",@"10-30万",@"30-50万",@"50-100万",@"100万－200万",@"200万以上"]];
    
    
    
    
    SHOWHUD(self.view);
    [MJMenuModel asyncGetUrbanAndAreaMenuItemList:^(BOOL success, NSArray *urbanArr) {
        _menu_urbanAreaArr = [urbanArr mutableCopy];
        HIDEHUD(self.view);
    }];
    _menu_sellPriceArr = [[MJMenuModel getSellPriceMenuItemList] mutableCopy];
    _menu_rentPriceArr = [[MJMenuModel getRentPriceMenuItemList]  mutableCopy];
    _menu_deptArr = [[MJMenuModel getDeptMenuItemList] mutableCopy];
    _menu_areaArr = [[MJMenuModel getAreaMenuItemList] mutableCopy];
    _menu_floorArr = [[MJMenuModel getFloorMenuItemList] mutableCopy];
    _menu_hallArr = [[MJMenuModel getHallMenuItemList] mutableCopy];
    _menu_orientArr = [[MJMenuModel getOrientMenuItemList] mutableCopy];
    
    _menu_FitTypeArr = [[MJMenuModel getFitTypeMenuItemList] mutableCopy];
    _menu_SellStausArr = [[MJMenuModel getSellStausMenuItemList] mutableCopy];
    _menu_LeaseStausArr = [[MJMenuModel getLeaseStausMenuItemList] mutableCopy];
    _menu_ConsignmentStausArr = [[MJMenuModel getConsignmentStausMenuItemList] mutableCopy];
    _menu_RoomTypeArr = [[MJMenuModel getRoomTypeMenuItemList] mutableCopy];
    _menu_OtherArr = [[MJMenuModel getOtherTypeMenuItemList] mutableCopy];
}

- (NSInteger)NumberOfColumns:(MJDropDownMenuBar*)menuBar
{
    return 4;
}

- (NSString *)MJDropDownMenuBar:(MJDropDownMenuBar *)menuBar TitleForColumn:(NSInteger)index
{
    switch (index)
    {
        case 0:return @"区域";break;
        case 1:return @"价格";break;
        case 2:return @"部门";break;
        case 3:return @"更多";break;
        default:return @"";break;
    }
}

- (void)MJDropDownMenuBar:(MJDropDownMenuBar*)menuBar TapedAtIndex:(NSInteger)index
{
    
    
}

- (MJDropDownMenu*)MJDropDownMenuBar:(MJDropDownMenuBar *)menuBar MenuForColumn:(NSInteger)index
{
    switch (index)
    {
        case 0:
        {
            if (menuBar == _sellMenuBar)
            {
                if(_sell_areaMenu == nil)
                    _sell_areaMenu = [self createDropDownMenuWithMode:NO];
                 return _sell_areaMenu;
            }
            else
            {
                if(_rent_areaMenu == nil)
                    _rent_areaMenu = [self createDropDownMenuWithMode:NO];
                 return _rent_areaMenu;
            }
        }
            break;
        case 1:
        {
            if (menuBar == _sellMenuBar)
            {
                if(_sell_priceMenu == nil)
                    _sell_priceMenu = [self createDropDownMenuWithMode:YES];
                return _sell_priceMenu;
            }
            else if (menuBar ==_rentMenuBar)
            {
                if(_rent_priceMenu == nil)
                    _rent_priceMenu = [self createDropDownMenuWithMode:YES];
                return _rent_priceMenu;
            }
        }
            break;
        case 2:
        {
            if (menuBar == _sellMenuBar)
            {
                if(_sell_DeptMenu == nil)
                    _sell_DeptMenu = [self createDropDownMenuWithMode:YES];
                return _sell_DeptMenu;
            }
            else
            {
                if(_rent_DeptMenu == nil)
                    _rent_DeptMenu = [self createDropDownMenuWithMode:YES];
                return _rent_DeptMenu;
            }
        }
            break;
        case 3:
        {
            if (menuBar == _sellMenuBar)
            {
                if(_sell_moreMenu == nil)
                    _sell_moreMenu = [self createDropDownMenuWithMode:NO];
                return _sell_moreMenu;
            }
            else if (menuBar ==_rentMenuBar)
            {
                if(_rent_moreMenu == nil)
                    _rent_moreMenu = [self createDropDownMenuWithMode:NO];
                return _rent_moreMenu;
            }
        }
            break;
            
        default:
            break;
    }
    return nil;
}

-(MJDropDownMenu*)createDropDownMenuWithMode:(BOOL)isSingle
{
    MJDropDownMenu* menu = [[MJDropDownMenu alloc] initWithOrigin:CGPointMake(_sellMenuBar.frame.origin.x, _sellMenuBar.frame.origin.y+_sellMenuBar.frame.size.height) andHeight:self.view.frame.size.height - (_sellMenuBar.frame.origin.y+_sellMenuBar.frame.size.height) - 50  SingleMode:isSingle];
    
    menu.dataSource = self;
    menu.delegate = self;
    return menu;
}




#pragma mark - MJDropDownMenu datasource & delegate

- (NSInteger)menu:(MJDropDownMenu *)menu tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    
#ifdef TESTDATA
    //if (menu == _sell_areaMenu)
    {
        if (tableView == menu.leftTableV)
        {
            return 20;
            if (_urbanArr)
            {
                return _urbanArr.count;
            }
        }
        else if(tableView == menu.rightTableV)
        {
            if (_areaArr)
            {
                if (section < [_areaArr count])
                {
                    return 50;
                    NSArray*areaArrInRow = [_areaArr objectAtIndex:section];
                    if (areaArrInRow)
                    {
                        return areaArrInRow.count;
                    }
                }
                
            }
        }
    }
    
#else
    if ((menu == _sell_areaMenu || menu == _rent_areaMenu)&& _menu_urbanAreaArr)
    {
        if (tableView == menu.leftTableV)
        {
            return [_menu_urbanAreaArr count];
        }
        else if (tableView == menu.rightTableV)
        {
            
            if(section < [_menu_urbanAreaArr count])
            {
                return ((MJMenuModel*)[_menu_urbanAreaArr objectAtIndex:section]).subMenuItems.count;
            }
            
        }
    }
    else if(menu == _sell_priceMenu && _menu_sellPriceArr)
    {
        if (tableView == menu.leftTableV)
        {
            return [_menu_sellPriceArr count];
        }
    }
    else if (menu == _rent_priceMenu && _menu_rentPriceArr)
    {
        if (tableView == menu.leftTableV)
        {
            return [_menu_rentPriceArr count];
        }
    }
    else if ((menu == _sell_DeptMenu || menu == _rent_DeptMenu) && _menu_deptArr)
    {
        if (tableView == menu.leftTableV)
        {
            return [_menu_deptArr count];
        }
    }
    else if(menu ==_sell_moreMenu || menu == _rent_moreMenu)
    {
        if (tableView == menu.leftTableV)
        {
            return 9;
        }
        else
        {
            switch (section)
            {
                case 0:
                {
                    return [_menu_areaArr count];
                }
                    break;
                case 1:
                {
                    return [_menu_hallArr count];
                }
                    break;
                case 2:
                {
                    return [_menu_floorArr count];
                }
                    break;
                case 3:
                {
                    return [_menu_orientArr count];
                }
                    break;
                case 4:
                {
                    return [_menu_FitTypeArr count];
                }
                    break;
                case 5:
                {
                    if (menu == _sell_moreMenu)
                    {
                        return [_menu_SellStausArr count];
                    }
                    else
                    {
                        return [_menu_LeaseStausArr count];
                    }
                    
                }
                    break;
                case 6:
                {
                    int count = [_menu_ConsignmentStausArr count];
                    return [_menu_ConsignmentStausArr count];
                }
                    break;
                case 7:
                {
                    return [_menu_RoomTypeArr count];
                }
                    break;
                case 8:
                {
                    return [_menu_OtherArr count];
                }
                    break;
                    
                default:
                    break;
            }
        }
    }
#endif
    
    return 0;
}


- (NSString *)menu:(MJDropDownMenu *)menu tableView:(UITableView*)tableView titleForRowAtIndexPath:(NSIndexPath *)indexPath
{
#ifdef TESTDATA
    if (menu == _sell_areaMenu)
    {
        if (tableView == menu.leftTableV)
        {
            if (_urbanArr && _urbanArr.count > indexPath.row)
            {
                return _urbanArr[indexPath.row];
            }
        }
        else if(tableView == menu.rightTableV)
        {
            if (_areaArr && _areaArr.count > indexPath.section)
            {
                NSArray*areaArrInRow = [_areaArr objectAtIndex:indexPath.section];
                if (areaArrInRow && areaArrInRow.count > indexPath.row)
                {
                    return areaArrInRow[indexPath.row];
                }
                
            }
        }
    }
    
#else
    if ((menu == _sell_areaMenu || menu == _rent_areaMenu)&& _menu_urbanAreaArr)
    {
        if (tableView == menu.leftTableV)
        {

            return ((MJMenuModel*)[_menu_urbanAreaArr objectAtIndex:indexPath.row]).menuItem.title;
        }
        else if (tableView == menu.rightTableV)
        {
            
            if(indexPath.section < [_menu_urbanAreaArr count])
            {
//                return ((MJMenuItem*)[[[_menu_urbanAreaArr objectAtIndex:indexPath.section] objectForKey:@"subMenuItem"] objectAtIndex:indexPath.row]).title;
//                
//                
                return ((MJMenuItem*)[((MJMenuModel*)[_menu_urbanAreaArr objectAtIndex:indexPath.section]).subMenuItems objectAtIndex:indexPath.row]).title;
            }
            
        }
    }
    else if(menu == _sell_priceMenu && _menu_sellPriceArr)
    {
        if (tableView == menu.leftTableV)
        {
            return [[[_menu_sellPriceArr objectAtIndex:indexPath.row] objectForKey:@"menuItem"] objectForKey:@"title"];
        }
    }
    else if (menu == _rent_priceMenu && _menu_rentPriceArr)
    {
        if (tableView == menu.leftTableV)
        {
            return [[[_menu_rentPriceArr objectAtIndex:indexPath.row] objectForKey:@"menuItem"] objectForKey:@"title"];
        }
    }
    else if ((menu == _sell_DeptMenu || menu == _rent_DeptMenu) && _menu_deptArr)
    {
        if (tableView == menu.leftTableV)
        {
            return [[[_menu_deptArr objectAtIndex:indexPath.row] objectForKey:@"menuItem"] objectForKey:@"title"];
        }
    }
    else if(menu ==_sell_moreMenu || menu == _rent_moreMenu)
    {
        if (tableView == menu.leftTableV)
        {
            switch (indexPath.row)
            {
                case 0:
                {
                    return @"面积";
                }
                    break;
                case 1:
                {
                    return @"客厅";
                }
                    break;
                case 2:
                {
                    return @"楼层";
                }
                    break;
                case 3:
                {
                    return  @"朝向";
                }
                    break;
                case 4:
                {
                    return  @"装修";
                }
                    break;
                case 5:
                {
                    return  @"状态";
                    
                }
                    break;
                case 6:
                {
                    return  @"委托";
                }
                    break;
                case 7:
                {
                    return  @"房型";
                }
                    break;
                case 8:
                {
                    return @"其他";
                }
                    break;
                    
                default:
                    break;
            }
        }
        else
        {
            switch (indexPath.section)
            {
                case 0:
                {
                    return [[[_menu_areaArr objectAtIndex:indexPath.row] objectForKey:@"menuItem"] objectForKey:@"title"];
                }
                    break;
                case 1:
                {
                    return [[[_menu_hallArr objectAtIndex:indexPath.row] objectForKey:@"menuItem"] objectForKey:@"title"];
                }
                    break;
                case 2:
                {
                    return [[[_menu_floorArr objectAtIndex:indexPath.row] objectForKey:@"menuItem"] objectForKey:@"title"];
                }
                    break;
                case 3:
                {
                    return [[[_menu_orientArr objectAtIndex:indexPath.row] objectForKey:@"menuItem"] objectForKey:@"title"];
                }
                    break;
                case 4:
                {
                    return [[[_menu_FitTypeArr objectAtIndex:indexPath.row] objectForKey:@"menuItem"] objectForKey:@"title"];
                }
                    break;
                case 5:
                {
                    if (menu == _sell_moreMenu)
                    {
                        return [[[_menu_SellStausArr objectAtIndex:indexPath.row] objectForKey:@"menuItem"] objectForKey:@"title"];
                    }
                    else
                    {
                        return [[[_menu_LeaseStausArr objectAtIndex:indexPath.row] objectForKey:@"menuItem"] objectForKey:@"title"];
                    }
                    
                }
                    break;
                case 6:
                {
                    return [[[_menu_ConsignmentStausArr objectAtIndex:indexPath.row] objectForKey:@"menuItem"] objectForKey:@"title"];
                }
                    break;
                case 7:
                {
                    return [[[_menu_RoomTypeArr objectAtIndex:indexPath.row] objectForKey:@"menuItem"] objectForKey:@"title"];
                }
                    break;
                case 8:
                {
                    return [[[_menu_OtherArr objectAtIndex:indexPath.row] objectForKey:@"menuItem"] objectForKey:@"title"];
                }
                    break;
                    
                default:
                    break;
            }
        }
    }
    
    
#endif
    
    
    return @"空";
}


- (MJMenuItemValueType)menu:(MJDropDownMenu *)menu tableView:(UITableView*)tableView valuetTypeForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ((menu == _sell_areaMenu || menu == _rent_areaMenu)&& _menu_urbanAreaArr)
    {
        if (tableView == menu.leftTableV)
        {
            
            return ((MJMenuModel*)[_menu_urbanAreaArr objectAtIndex:indexPath.row]).menuItem.value.valueType;
        }
        else if (tableView == menu.rightTableV)
        {
            
            if(indexPath.section < [_menu_urbanAreaArr count])
            {
                //                return ((MJMenuItem*)[[[_menu_urbanAreaArr objectAtIndex:indexPath.section] objectForKey:@"subMenuItem"] objectAtIndex:indexPath.row]).title;
                //
                //
                return ((MJMenuItem*)[((MJMenuModel*)[_menu_urbanAreaArr objectAtIndex:indexPath.section]).subMenuItems objectAtIndex:indexPath.row]).value.valueType;
            }
            
        }
    }
    else if(menu == _sell_priceMenu && _menu_sellPriceArr)
    {
        if (tableView == menu.leftTableV)
        {
            return [[[[_menu_sellPriceArr objectAtIndex:indexPath.row] objectForKey:@"menuItem"] objectForKey:@"valueType"] intValue];
        }
    }
    else if (menu == _rent_priceMenu && _menu_rentPriceArr)
    {
        if (tableView == menu.leftTableV)
        {
            return [[[[_menu_rentPriceArr objectAtIndex:indexPath.row] objectForKey:@"menuItem"] objectForKey:@"valueType"] intValue];
        }
    }
    else if ((menu == _sell_DeptMenu || menu == _rent_DeptMenu) && _menu_deptArr)
    {
        if (tableView == menu.leftTableV)
        {
            return [[[[_menu_deptArr objectAtIndex:indexPath.row] objectForKey:@"menuItem"] objectForKey:@"valueType"] intValue];
        }
    }
    else if(menu ==_sell_moreMenu || menu == _rent_moreMenu)
    {
        if (tableView == menu.leftTableV)
        {
            return MJMenuItemValueTypeSingle;
        }
        else
        {
            switch (indexPath.section)
            {
                case 0:
                {
                    return [[[[_menu_areaArr objectAtIndex:indexPath.row] objectForKey:@"menuItem"] objectForKey:@"valueType"] intValue];
                }
                    break;
                case 1:
                {
                    return [[[[_menu_hallArr objectAtIndex:indexPath.row] objectForKey:@"menuItem"] objectForKey:@"valueType"] intValue];
                }
                    break;
                case 2:
                {
                    return [[[[_menu_floorArr objectAtIndex:indexPath.row] objectForKey:@"menuItem"] objectForKey:@"valueType"] intValue];
                }
                    break;
                case 3:
                {
                    return [[[[_menu_orientArr objectAtIndex:indexPath.row] objectForKey:@"menuItem"] objectForKey:@"valueType"] intValue];
                }
                    break;
                case 4:
                {
                    return [[[[_menu_FitTypeArr objectAtIndex:indexPath.row] objectForKey:@"menuItem"] objectForKey:@"valueType"] intValue];
                }
                    break;
                case 5:
                {
                    if (menu == _sell_moreMenu)
                    {
                        return [[[[_menu_SellStausArr objectAtIndex:indexPath.row] objectForKey:@"menuItem"] objectForKey:@"valueType"] intValue];
                    }
                    else
                    {
                        return [[[[_menu_LeaseStausArr objectAtIndex:indexPath.row] objectForKey:@"menuItem"] objectForKey:@"valueType"] intValue];
                    }
                    
                }
                    break;
                case 6:
                {
                    return [[[[_menu_ConsignmentStausArr objectAtIndex:indexPath.row] objectForKey:@"menuItem"] objectForKey:@"valueType"] intValue];
                }
                    break;
                case 7:
                {
                    return [[[[_menu_RoomTypeArr objectAtIndex:indexPath.row] objectForKey:@"menuItem"] objectForKey:@"valueType"] intValue];
                }
                    break;
                case 8:
                {
                    return [[[[_menu_OtherArr objectAtIndex:indexPath.row] objectForKey:@"menuItem"] objectForKey:@"valueType"] intValue];
                }
                    break;
                    
                default:
                    break;
            }
        }
    }
    
    return MJMenuItemValueTypeSingle;
}


- (MJMenuItemValue*)menu:(MJDropDownMenu *)menu tableView:(UITableView*)tableView DefaultValueForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ((menu == _sell_areaMenu || menu == _rent_areaMenu)&& _menu_urbanAreaArr)
    {
        if (tableView == menu.leftTableV)
        {
            
            return ((MJMenuModel*)[_menu_urbanAreaArr objectAtIndex:indexPath.row]).menuItem.value;
        }
        else if (tableView == menu.rightTableV)
        {
            
            if(indexPath.section < [_menu_urbanAreaArr count])
            {
                //                return ((MJMenuItem*)[[[_menu_urbanAreaArr objectAtIndex:indexPath.section] objectForKey:@"subMenuItem"] objectAtIndex:indexPath.row]).title;
                //
                //
                return ((MJMenuItem*)[((MJMenuModel*)[_menu_urbanAreaArr objectAtIndex:indexPath.section]).subMenuItems objectAtIndex:indexPath.row]).value;
            }
            
        }
    }
    else if(menu == _sell_priceMenu && _menu_sellPriceArr)
    {
        if (tableView == menu.leftTableV)
        {
            MJMenuItemValue*value = [[MJMenuItemValue alloc] init];
            value.valueType = [[[[_menu_sellPriceArr objectAtIndex:indexPath.row] objectForKey:@"menuItem"] objectForKey:@"valueType"] intValue];
            value.valueArr = [[[_menu_sellPriceArr objectAtIndex:indexPath.row] objectForKey:@"menuItem"] objectForKey:@"value"];
            return value;
        }
    }
    else if (menu == _rent_priceMenu && _menu_rentPriceArr)
    {
        if (tableView == menu.leftTableV)
        {
            
            MJMenuItemValue*value = [[MJMenuItemValue alloc] init];
            value.valueType = [[[[_menu_rentPriceArr objectAtIndex:indexPath.row] objectForKey:@"menuItem"] objectForKey:@"valueType"] intValue];
            value.valueArr = [[[_menu_rentPriceArr objectAtIndex:indexPath.row] objectForKey:@"menuItem"] objectForKey:@"value"];
            return value;
        }
    }
    else if ((menu == _sell_DeptMenu || menu == _rent_DeptMenu) && _menu_deptArr)
    {
        if (tableView == menu.leftTableV)
        {
            MJMenuItemValue*value = [[MJMenuItemValue alloc] init];
            value.valueType = [[[[_menu_deptArr objectAtIndex:indexPath.row] objectForKey:@"menuItem"] objectForKey:@"valueType"] intValue];
            value.valueArr = [[[_menu_deptArr objectAtIndex:indexPath.row] objectForKey:@"menuItem"] objectForKey:@"value"];
            return value;
        }
    }
    else if(menu ==_sell_moreMenu || menu == _rent_moreMenu)
    {
        if (tableView == menu.leftTableV)
        {
            return MJMenuItemValueTypeSingle;
        }
        else
        {
            switch (indexPath.section)
            {
                case 0:
                {
                    MJMenuItemValue*value = [[MJMenuItemValue alloc] init];
                    value.valueType = [[[[_menu_areaArr objectAtIndex:indexPath.row] objectForKey:@"menuItem"] objectForKey:@"valueType"] intValue];
                    value.valueArr = [[[_menu_areaArr objectAtIndex:indexPath.row] objectForKey:@"menuItem"] objectForKey:@"value"];
                    return value;
                }
                    break;
                case 1:
                {
                    MJMenuItemValue*value = [[MJMenuItemValue alloc] init];
                    value.valueType = [[[[_menu_hallArr objectAtIndex:indexPath.row] objectForKey:@"menuItem"] objectForKey:@"valueType"] intValue];
                    value.valueArr = [[[_menu_hallArr objectAtIndex:indexPath.row] objectForKey:@"menuItem"] objectForKey:@"value"];
                    return value;

                }
                    break;
                case 2:
                {
                    MJMenuItemValue*value = [[MJMenuItemValue alloc] init];
                    value.valueType = [[[[_menu_floorArr objectAtIndex:indexPath.row] objectForKey:@"menuItem"] objectForKey:@"valueType"] intValue];
                    value.valueArr = [[[_menu_floorArr objectAtIndex:indexPath.row] objectForKey:@"menuItem"] objectForKey:@"value"];
                    return value;
                }
                    break;
                case 3:
                {
                    MJMenuItemValue*value = [[MJMenuItemValue alloc] init];
                    value.valueType = [[[[_menu_orientArr objectAtIndex:indexPath.row] objectForKey:@"menuItem"] objectForKey:@"valueType"] intValue];
                    value.valueArr = [[[_menu_orientArr objectAtIndex:indexPath.row] objectForKey:@"menuItem"] objectForKey:@"value"];
                    return value;
                    
                }
                    break;
                case 4:
                {
                    MJMenuItemValue*value = [[MJMenuItemValue alloc] init];
                    value.valueType = [[[[_menu_FitTypeArr objectAtIndex:indexPath.row] objectForKey:@"menuItem"] objectForKey:@"valueType"] intValue];
                    value.valueArr = [[[_menu_FitTypeArr objectAtIndex:indexPath.row] objectForKey:@"menuItem"] objectForKey:@"value"];
                    return value;
                }
                    break;
                case 5:
                {
                    if (menu == _sell_moreMenu)
                    {
                        MJMenuItemValue*value = [[MJMenuItemValue alloc] init];
                        value.valueType = [[[[_menu_SellStausArr objectAtIndex:indexPath.row] objectForKey:@"menuItem"] objectForKey:@"valueType"] intValue];
                        value.valueArr = [[[_menu_SellStausArr objectAtIndex:indexPath.row] objectForKey:@"menuItem"] objectForKey:@"value"];
                        return value;
                    }
                    else
                    {
                        MJMenuItemValue*value = [[MJMenuItemValue alloc] init];
                        value.valueType = [[[[_menu_LeaseStausArr objectAtIndex:indexPath.row] objectForKey:@"menuItem"] objectForKey:@"valueType"] intValue];
                        value.valueArr = [[[_menu_LeaseStausArr objectAtIndex:indexPath.row] objectForKey:@"menuItem"] objectForKey:@"value"];
                        return value;
                    }
                    
                }
                    break;
                case 6:
                {
                    MJMenuItemValue*value = [[MJMenuItemValue alloc] init];
                    value.valueType = [[[[_menu_ConsignmentStausArr objectAtIndex:indexPath.row] objectForKey:@"menuItem"] objectForKey:@"valueType"] intValue];
                    value.valueArr = [[[_menu_ConsignmentStausArr objectAtIndex:indexPath.row] objectForKey:@"menuItem"] objectForKey:@"value"];
                    return value;
                }
                    break;
                case 7:
                {
                    MJMenuItemValue*value = [[MJMenuItemValue alloc] init];
                    value.valueType = [[[[_menu_RoomTypeArr objectAtIndex:indexPath.row] objectForKey:@"menuItem"] objectForKey:@"valueType"] intValue];
                    value.valueArr = [[[_menu_RoomTypeArr objectAtIndex:indexPath.row] objectForKey:@"menuItem"] objectForKey:@"value"];
                    return value;

                }
                    break;
                case 8:
                {
                    MJMenuItemValue*value = [[MJMenuItemValue alloc] init];
                    value.valueType = [[[[_menu_OtherArr objectAtIndex:indexPath.row] objectForKey:@"menuItem"] objectForKey:@"valueType"] intValue];
                    value.valueArr = [[[_menu_OtherArr objectAtIndex:indexPath.row] objectForKey:@"menuItem"] objectForKey:@"value"];
                    return value;
                    
                }
                    break;
                    
                default:
                    break;
            }
        }
    }
    
    return nil;
}

- (void)menu:(MJDropDownMenu *)menu tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath CustomizedValue:(MJMenuItemValue *)value
{
    [_sellMenuBar makeMenuClosed];
    [_rentMenuBar makeMenuClosed];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    
    
    if (self.nowControllerType == HCT_SELL)
    {
        if (self.applyForRefresh)
        {
            [self.sellController refreshData];
        }
        
    }
    else if (self.nowControllerType == HCT_RENT)
    {
        if (self.applyForRefresh)
        {
            [self.rentController refreshData];
        }
       
    }
    self.applyForRefresh = NO;
    [super viewDidAppear:animated];
}

- (void)onFilterAction:(id)sender
{
    if (_houseFilterVC == nil)
    {
        _houseFilterVC = [[HouseFilterController alloc] initWithStyle:UITableViewStyleGrouped];
    }
    
    
    _houseFilterVC.hvc = self;
    _houseFilterVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:_houseFilterVC animated:YES];
}

- (void)onAddEstate:(id)sender
{
    HouseAddNewViewController*vc = [[HouseAddNewViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - ViewPagerDataSource
- (NSUInteger)numberOfTabsForViewPager:(ViewPagerController *)viewPager
{
    return 2;
}

- (UIView *)viewPager:(ViewPagerController *)viewPager viewForTabAtIndex:(NSUInteger)index
{
    CGSize sz =  [UIScreen mainScreen].bounds.size;
    UILabel*label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, sz.width/2.0, 30)];
    label.textAlignment = NSTextAlignmentCenter;
    [label setFont:[UIFont systemFontOfSize:14]];
    if (index == 0)
    {
        // default is sell controller
        label.text = @"出售";
    }
    else
    {
        label.text = @"出租";
    }
    return  label;
}

- (UIViewController *)viewPager:(ViewPagerController *)viewPager contentViewControllerForTabAtIndex:(NSUInteger)index
{
    if (index == 0)
    {
        return self.sellController;
    }
    else
    {
        return self.rentController;
    }
    return nil;
}

#pragma mark - ViewPagerDelegate
- (CGFloat)viewPager:(ViewPagerController *)viewPager valueForOption:(ViewPagerOption)option withDefault:(CGFloat)value
{
    switch (option)
    {
        case ViewPagerOptionStartFromSecondTab:
            return 0;
            break;
        case ViewPagerOptionCenterCurrentTab:
            return 0;
            break;
        case ViewPagerOptionTabLocation:
            return 1;
            break;
            case ViewPagerOptionTabHeight:
            return TABBAR_HEIGHT;
            break;
        case ViewPagerOptionTabWidth:
            return [UIScreen mainScreen].bounds.size.width / 2.0;
            break;
        default:
            break;
    }
    return value;
}

- (UIColor *)viewPager:(ViewPagerController *)viewPager colorForComponent:(ViewPagerComponent)component withDefault:(UIColor *)color
{
    switch (component)
    {
        case ViewPagerIndicator:
            return [UIColor redColor];
            break;
        case ViewPagerTabsView:
            return [UIColor whiteColor];
            break;
        case ViewPagerContent:
            return [UIColor whiteColor];
            break;
        default:
            break;
    }
    return color;
}

- (void)viewPager:(ViewPagerController *)viewPager didChangeTabToIndex:(NSUInteger)index
{
    if (index == 0)
    {
        self.nowControllerType = HCT_SELL;
        if (_sellMenuBar)
        {
            _sellMenuBar.hidden = NO;
        }
        
        
        
        if (_rentMenuBar) {
            _rentMenuBar.hidden = YES;
            [_rentMenuBar makeMenuClosed];
        }
        
    }
    else
    {
        self.nowControllerType = HCT_RENT;
        
        if (_sellMenuBar)
        {
            _sellMenuBar.hidden = YES;
            [_sellMenuBar makeMenuClosed];
        }
        
        if (_rentMenuBar)
        {
            _rentMenuBar.hidden = NO;
        }
        

        
    }
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


//-(void)sendMessage:(id)sender
//{
//    sendMessageViewController*ctrl = [[sendMessageViewController alloc] initWithNibName:@"sendMessageViewController" bundle:[NSBundle mainBundle]];
//    ctrl.msgObj = nil;
//    ctrl.msgType = MJMESSAGESENDTYPE_SEND;
//    [self.navigationController pushViewController:ctrl animated:YES];
//}

