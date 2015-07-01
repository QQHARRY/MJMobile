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
#import "ContactListTableViewController.h"
#import "AppDelegate.h"
#import "department.h"
#import <objc/runtime.h>
#import "EMSearchBar.h"
#import "EMSearchDisplayController.h"
#import "MJKeywordFectchViewController.h"
#import "MJKeywordManager.h"

#define MENUBAR_HEIGHT 32
#define TABBAR_HEIGHT 44

@interface HouseViewController ()<MJDropDownMenuBarDataSource,MJDropDownMenuBarDelegate,MJDropDownMenuDataSource,MJDropDownMenuDelegate,contacSelection,UISearchBarDelegate,UISearchDisplayDelegate,keywordSelectDelegate>


@property(strong,nonatomic)UISearchBar*searchBar;
@property(strong,nonatomic)EMSearchDisplayController*searchController;
@property(strong,nonatomic)HouseFilterController *houseFilterVC;
@property(strong,nonatomic)MJDropDownMenuBar*sellMenuBar;
@property(strong,nonatomic)MJDropDownMenuBar*rentMenuBar;

@property(strong,nonatomic)MJDropDownMenu*rent_urbanAreaMenu;
@property(strong,nonatomic)MJDropDownMenu*rent_priceMenu;
@property(strong,nonatomic)MJDropDownMenu*rent_DeptMenu;
@property(strong,nonatomic)MJDropDownMenu*rent_moreMenu;


@property(strong,nonatomic)MJDropDownMenu*sell_urbanAreaMenu;
@property(strong,nonatomic)MJDropDownMenu*sell_priceMenu;
@property(strong,nonatomic)MJDropDownMenu*sell_DeptMenu;
@property(strong,nonatomic)MJDropDownMenu*sell_moreMenu;




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

@property(strong,nonatomic)MJDropDownMenu*selectedDeptAtMenu;
@property(strong,nonatomic)HouseFilter*sellTmpFilter;
@property(strong,nonatomic)HouseFilter*rentTmpFilter;
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
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"筛选" style:UIBarButtonItemStylePlain target:self action:@selector(onFilterAction:)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(onAddEstate:)];
    
    // add table view controller
    self.rentController = [[HouseTableViewController alloc] initWithNibName:@"HouseTableViewController" bundle:[NSBundle mainBundle]];
    self.rentController.controllerType = HCT_RENT;
    self.rentController.container = self;
    self.rentController.filter = [[HouseFilter alloc] init];
//    self.rentController.filter.consignment_type = @"1"; // 委托类型：A-独家 是”0”、B-一般 是”1”、C-未签 是”2” * TODO
    self.rentController.filter.trade_type = @"101";
    self.rentController.filter.lease_state = @"0";
    self.rentController.filter.FromID = @"0";
    self.rentController.filter.ToID = @"0";
    self.rentController.filter.Count = @"10";
    self.sellController = [[HouseTableViewController alloc] initWithNibName:@"HouseTableViewController" bundle:[NSBundle mainBundle]];
    self.sellController.controllerType = HCT_SELL;
    self.sellController.container = self;
    self.sellController.filter = [[HouseFilter alloc] init];
//    self.sellController.filter.consignment_type = @"1"; // 委托类型：A-独家 是”0”、B-一般 是”1”、C-未签 是”2” * TODO
    self.sellController.filter.trade_type = @"100";
    self.sellController.filter.sale_state = @"0";
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
    
    [self setUpRightNavigationItemWithIsNormalType:YES];
    // super fun
    [super viewDidLoad];
    
    

}





-(void)setUpRightNavigationItemWithIsNormalType:(BOOL)normalType
{
    if (normalType)
    {
         self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"搜索" style:UIBarButtonItemStylePlain target:self action:@selector(OnSearchBtnClicked:)];
    }
    else
    {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"重置" style:UIBarButtonItemStylePlain target:self action:@selector(OnResetBtnClicked:)];
    }
}


-(void)OnSearchBtnClicked:(id)sender
{
    MJKeywordFectchViewController*kw = [[MJKeywordFectchViewController alloc]  init];
    kw.keywordType = HOUSE_SEARCH_KW;
    kw.placeHolderString = @"请输入小区名称或房源编号";
    kw.delegate = self;
    [self.navigationController pushViewController:kw animated:NO];
}

-(void)didSelectKeyword:(NSString*)keyWord
{
    HouseFilter*filter = (_nowControllerType == HCT_SELL)?_sellController.filter:_rentController.filter;
    
    filter.Keyword = keyWord;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self wannaRefresh];
    });
    
}



-(void)OnResetBtnClicked:(id)sender
{
    if (_nowControllerType == HCT_SELL)
    {
        if (_sell_moreMenu)
        {
            [_sell_moreMenu clearSelection];
        }
        
        if (_sellTmpFilter)
        {
            [self cleanFilter:_sellTmpFilter];
        }

    }
    else
    {
        if (_rent_moreMenu)
        {
            [_rent_moreMenu clearSelection];
        }
        
        if (_rentTmpFilter)
        {
            [self cleanFilter:_rentTmpFilter];
        }
    }
}

-(void)initMenuData
{

    SHOWHUD(self.view);
    [MJMenuModel asyncGetUrbanAndAreaMenuItemList:^(BOOL success, NSArray *urbanArr) {
        _menu_urbanAreaArr = urbanArr;
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
    
    
    _sellTmpFilter = [[HouseFilter alloc] init];
    _rentTmpFilter = [[HouseFilter alloc] init];
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

- (void)MJDropDownMenuBar:(MJDropDownMenuBar*)menuBar WillDismissView:(id)view atIndex:(NSInteger)index
{
    [self setUpRightNavigationItemWithIsNormalType:YES];
}

- (void)MJDropDownMenuBar:(MJDropDownMenuBar*)menuBar WillPresentView:(id)view atIndex:(NSInteger)index
{
    if (index == 3)
    {
        [self setUpRightNavigationItemWithIsNormalType:NO];
    }
}

- (MJDropDownMenu*)MJDropDownMenuBar:(MJDropDownMenuBar *)menuBar MenuForColumn:(NSInteger)index
{
    switch (index)
    {
        case 0:
        {
            if (menuBar == _sellMenuBar)
            {
                if(_sell_urbanAreaMenu == nil)
                    _sell_urbanAreaMenu = [self createDropDownMenuWithMode:NO BatchSelect:NO];
                 return _sell_urbanAreaMenu;
            }
            else
            {
                if(_rent_urbanAreaMenu == nil)
                    _rent_urbanAreaMenu = [self createDropDownMenuWithMode:NO BatchSelect:NO];
                 return _rent_urbanAreaMenu;
            }
        }
            break;
        case 1:
        {
            if (menuBar == _sellMenuBar)
            {
                if(_sell_priceMenu == nil)
                    _sell_priceMenu = [self createDropDownMenuWithMode:YES BatchSelect:NO];
                return _sell_priceMenu;
            }
            else if (menuBar ==_rentMenuBar)
            {
                if(_rent_priceMenu == nil)
                    _rent_priceMenu = [self createDropDownMenuWithMode:YES BatchSelect:NO];
                return _rent_priceMenu;
            }
        }
            break;
        case 2:
        {
            if (menuBar == _sellMenuBar)
            {
                if(_sell_DeptMenu == nil)
                    _sell_DeptMenu = [self createDropDownMenuWithMode:YES BatchSelect:NO];
                return _sell_DeptMenu;
            }
            else
            {
                if(_rent_DeptMenu == nil)
                    _rent_DeptMenu = [self createDropDownMenuWithMode:YES BatchSelect:NO];
                return _rent_DeptMenu;
            }
        }
            break;
        case 3:
        {
            if (menuBar == _sellMenuBar)
            {
                if(_sell_moreMenu == nil)
                    _sell_moreMenu = [self createDropDownMenuWithMode:NO BatchSelect:YES];
                return _sell_moreMenu;
            }
            else if (menuBar ==_rentMenuBar)
            {
                if(_rent_moreMenu == nil)
                    _rent_moreMenu = [self createDropDownMenuWithMode:NO BatchSelect:YES];
                return _rent_moreMenu;
            }
        }
            break;
            
        default:
            break;
    }
    return nil;
}

-(MJDropDownMenu*)createDropDownMenuWithMode:(BOOL)isSingle BatchSelect:(BOOL)batch
{
    MJDropDownMenu* menu = [[MJDropDownMenu alloc] initWithOrigin:CGPointMake(_sellMenuBar.frame.origin.x, _sellMenuBar.frame.origin.y+_sellMenuBar.frame.size.height) andHeight:self.view.frame.size.height - (_sellMenuBar.frame.origin.y+_sellMenuBar.frame.size.height) - 50  SingleMode:isSingle BatchSelect:batch];
    
    menu.dataSource = self;
    menu.delegate = self;
    return menu;
}




#pragma mark - MJDropDownMenu datasource & delegate

- (UIKeyboardType)menu:(MJDropDownMenu *)menu tableView:(UITableView*)tableView keyboardTyeAtIndexpath:(NSIndexPath *)indexPath;
{
   
    
    return UIKeyboardTypeNumberPad;
}
- (NSInteger)menu:(MJDropDownMenu *)menu tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    if ((menu == _sell_urbanAreaMenu || menu == _rent_urbanAreaMenu)&& _menu_urbanAreaArr)
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
    
    return 0;
}


- (NSString *)menu:(MJDropDownMenu *)menu tableView:(UITableView*)tableView titleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ((menu == _sell_urbanAreaMenu || menu == _rent_urbanAreaMenu)&& _menu_urbanAreaArr)
    {
        if (tableView == menu.leftTableV)
        {

            return ((MJMenuModel*)[_menu_urbanAreaArr objectAtIndex:indexPath.row]).menuItem.title;
        }
        else if (tableView == menu.rightTableV)
        {
            
            if(indexPath.section < [_menu_urbanAreaArr count])
            {
                MJMenuModel*model = [_menu_urbanAreaArr objectAtIndex:indexPath.section];
                if (model && [model isKindOfClass:[MJMenuModel class]] && model.subMenuItems && model.subMenuItems.count > indexPath.row)
                {
                    return ((MJMenuItem*)[model.subMenuItems objectAtIndex:indexPath.row]).title;
                }
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
    
    
    return @"";
}


- (MJMenuItemValueType)menu:(MJDropDownMenu *)menu tableView:(UITableView*)tableView valuetTypeForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ((menu == _sell_urbanAreaMenu || menu == _rent_urbanAreaMenu)&& _menu_urbanAreaArr)
    {
        if (tableView == menu.leftTableV)
        {
            
            return ((MJMenuModel*)[_menu_urbanAreaArr objectAtIndex:indexPath.row]).menuItem.value.valueType;
        }
        else if (tableView == menu.rightTableV)
        {
            
            if(indexPath.section < [_menu_urbanAreaArr count])
            {
                
                MJMenuModel* model = [_menu_urbanAreaArr objectAtIndex:indexPath.section];
                if (model && model.subMenuItems && model.subMenuItems.count > indexPath.row)
                {
                    return ((MJMenuItem*)model.subMenuItems[indexPath.row]).value.valueType;
                }
                else
                {
                    int a  = 0;
                }
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


-(MJMenuItemValue*)getMenuItemDefaultValueForRowAtIndexPath:(NSIndexPath*)indexPath FromMenuDataArr:(NSArray*)arr
{
    if (indexPath && arr && indexPath.row < arr.count)
    {
        MJMenuItemValueType type = [[[[arr objectAtIndex:indexPath.row] objectForKey:@"menuItem"] objectForKey:@"valueType"] intValue];
        
        if (type == MJMenuItemValueTypeCustomizeArea || type == MJMenuItemValueTypeCustomizeSinge)
        {
            MJMenuItemValue*value = [[MJMenuItemValue alloc] init];
            value.valueType = type;
            value.valueArr = [[[arr objectAtIndex:indexPath.row] objectForKey:@"menuItem"] objectForKey:@"value"];
            return value;
        }
    }
    
    return nil;
}




- (MJMenuItemValue*)menu:(MJDropDownMenu *)menu tableView:(UITableView*)tableView DefaultValueForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if(menu == _sell_priceMenu && _menu_sellPriceArr)
    {
        if (tableView == menu.leftTableV)
        {
            return [self getMenuItemDefaultValueForRowAtIndexPath:indexPath FromMenuDataArr:_menu_sellPriceArr];
        }
    }
    else if (menu == _rent_priceMenu && _menu_rentPriceArr)
    {
        if (tableView == menu.leftTableV)
        {
            
            return [self getMenuItemDefaultValueForRowAtIndexPath:indexPath FromMenuDataArr:_menu_rentPriceArr];
        }
    }
    else if ((menu == _sell_DeptMenu || menu == _rent_DeptMenu) && _menu_deptArr)
    {
        if (tableView == menu.leftTableV)
        {
            return [self getMenuItemDefaultValueForRowAtIndexPath:indexPath FromMenuDataArr:_menu_deptArr];
        }
    }
    else if(menu ==_sell_moreMenu || menu == _rent_moreMenu)
    {
        if (tableView == menu.rightTableV)
        {
            switch (indexPath.section)
            {
                case 0:
                case 1:
                    break;
                case 2:
                {
                    return [self getMenuItemDefaultValueForRowAtIndexPath:indexPath FromMenuDataArr:_menu_floorArr];
                }
                    break;
                case 3:
                case 4:
                case 5:
                case 6:
                case 7:
                    break;
                case 8:
                {
                    return [self getMenuItemDefaultValueForRowAtIndexPath:indexPath FromMenuDataArr:_menu_OtherArr];
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
    if (menu.batchSelect == NO)
    {
        [self closeMenu];
    }
    
    MJDropDownMenuBar*menubar = nil;
    if (menu == _sell_urbanAreaMenu || menu == _rent_urbanAreaMenu)
    {
        HouseFilter*filter = (menu == _sell_urbanAreaMenu)?_sellController.filter:_rentController.filter;
        menubar = (menu == _sell_urbanAreaMenu)?_sellMenuBar:_rentMenuBar;
        if(filter && indexPath.section < [_menu_urbanAreaArr count])
        {
            MJMenuModel*model = [_menu_urbanAreaArr objectAtIndex:indexPath.section];
            
            filter.house_urban = [model.menuItem.value getSingleValue];
            
            
            if (model && [model isKindOfClass:[MJMenuModel class]] && model.subMenuItems && model.subMenuItems.count > indexPath.row)
            {
                MJMenuItem*item = [model.subMenuItems objectAtIndex:indexPath.row];
                filter.house_area = [item.value getSingleValue];
                
                //NSString*urbanTitle = model.menuItem.title;
                NSString*areaTitle = item.title;
                [menubar updateTitle:[NSString stringWithFormat:@"%@",areaTitle] ForIndex:0];
            }
        }
        [self wannaRefresh];
    }
    else if(menu == _sell_priceMenu || menu == _rent_priceMenu)
    {
        HouseFilter*filter = (menu == _sell_priceMenu)?_sellController.filter:_rentController.filter;
        menubar = (menu == _sell_priceMenu)?_sellMenuBar:_rentMenuBar;
        NSArray*priceArr = (menu == _sell_priceMenu)?_menu_sellPriceArr:_menu_rentPriceArr;
        
        if(filter && indexPath.row < [priceArr count]-1)
        {
            NSDictionary*dic = [priceArr objectAtIndex:indexPath.row];
            
            NSArray*valueArr = [[dic objectForKey:@"menuItem"] objectForKey:@"value"];
            if (valueArr && valueArr.count > 1)
            {
                NSString* minPrice = valueArr[0];
                NSString* maxPrice = valueArr[1];
                
                filter.sale_value_from = minPrice;
                filter.sale_value_to = maxPrice;
            }
            
            NSString*title = [[dic objectForKey:@"menuItem"] objectForKey:@"title"];
            [menubar updateTitle:[NSString stringWithFormat:@"%@",title] ForIndex:1];
        }
        else if (filter && indexPath.row == [priceArr count]-1)
        {
            if (value && value.valueArr && value.valueArr.count > 1)
            {
                
                NSString* minPrice = value.valueArr[0];
                NSString* maxPrice = value.valueArr[1];
                
                CGFloat floatMin = [minPrice floatValue];
                CGFloat floatMax = [maxPrice floatValue];
                
                filter.sale_value_from = minPrice;
                filter.sale_value_to = maxPrice;
                
                if(floatMin == 0)
                {
                    filter.sale_value_from = @"";
                }
                if (floatMax == 0)
                {
                    filter.sale_value_to = @"";
                }
            }
            [menubar updateTitle:@"自定义" ForIndex:1];
        }
        [self wannaRefresh];
    }
    else if (menu == _sell_DeptMenu || menu == _rent_DeptMenu)
    {
        HouseFilter*filter = (menu == _sell_DeptMenu)?_sellController.filter:_rentController.filter;
        menubar = (menu == _sell_DeptMenu)?_sellMenuBar:_rentMenuBar;
        
        
        if(filter)
        {
            switch (indexPath.row)
            {
                case 0:
                {
                    [menubar updateTitle:@"不限" ForIndex:2];
                    filter.search_job_no = @"";
                    filter.search_dept_no = @"";
                    [self wannaRefresh];
                }
                    break;
                case 1:
                {
                    [menubar updateTitle:@"我的房源" ForIndex:2];
                    filter.search_job_no = [person me].job_no;
                    filter.search_dept_no = [person me].department_no;
                    [self wannaRefresh];
                }
                    break;
                default:
                {
                    _selectedDeptAtMenu = menu;
                    [self showContactVC];
                    return;
                }
                    break;
            }
        }
    }
    else if (menu == _sell_moreMenu || menu == _rent_moreMenu)
    {
        menubar = (menu == _sell_moreMenu)?_sellMenuBar:_rentMenuBar;
        
        [self setFilterByClickedMoreMenu:menu AtIndexPath:indexPath WithCustomizedValue:value];
    }

}


-(void)setFilterByClickedMoreMenu:(MJDropDownMenu*)menu AtIndexPath:(NSIndexPath*)indexPath WithCustomizedValue:(MJMenuItemValue*)cusValue
{
        HouseFilter*filter = (menu == _sell_moreMenu)?_sellTmpFilter:_rentTmpFilter;
    
        NSArray*modelArr = nil;
        
        switch (indexPath.section)
        {
            case 0:
            {
                //return @"面积";
                if (indexPath.row < _menu_areaArr.count )
                {
                    NSArray*valueArr =  [[[_menu_areaArr objectAtIndex:indexPath.row] objectForKey:@"menuItem"] objectForKey:@"value"];
                    filter.structure_area_from = valueArr[0];
                    filter.structure_area_to = valueArr[1];
                }
            }
                break;
            case 1:
            {
                //return @"客厅";
                NSArray*valueArr =  [[[_menu_hallArr objectAtIndex:indexPath.row] objectForKey:@"menuItem"] objectForKey:@"value"];
                filter.hall_num = valueArr[0];
            }
                break;
            case 2:
            {
                //return @"楼层";
                NSArray*valueArr =  [[[_menu_floorArr objectAtIndex:indexPath.row] objectForKey:@"menuItem"] objectForKey:@"value"];
                NSInteger valueType =  [[[[_menu_floorArr objectAtIndex:indexPath.row] objectForKey:@"menuItem"] objectForKey:@"valueType"] intValue];
                
                filter.house_floor_from = valueArr[0];
                filter.house_floor_to = valueArr[0];
                if (valueType == MJMenuItemValueTypeCustomizeArea && cusValue && cusValue.valueArr && cusValue.valueArr.count > 1)
                {
                    if (cusValue == nil || cusValue.valueArr == nil || cusValue.valueArr.count < 2)
                    {
                        filter.house_floor_from = @"";
                        filter.house_floor_to =  @"";
                    }
                    else
                    {
                        NSString* min = cusValue.valueArr[0];
                        NSString* max = cusValue.valueArr[1];
                        
                        int iMin = [min intValue];
                        int iMax = [max intValue];
                        
                        filter.house_floor_from = min;
                        filter.house_floor_to = max;
                        
                        if(iMin == 0)
                        {
                            filter.house_floor_from = @"";
                        }
                        if (iMax == 0)
                        {
                            filter.house_floor_to = @"";
                        }
                    }
                    
                }

                
            }
                break;
            case 3:
            {
                //return  @"朝向";
                NSArray*valueArr =  [[[_menu_orientArr objectAtIndex:indexPath.row] objectForKey:@"menuItem"] objectForKey:@"value"];
                
                filter.house_driect = valueArr[0];
            }
                break;
            case 4:
            {
                //return  @"装修";
                NSArray*valueArr =  [[[_menu_FitTypeArr objectAtIndex:indexPath.row] objectForKey:@"menuItem"] objectForKey:@"value"];
                
                filter.fitment_type = valueArr[0];
            }
                break;
            case 5:
            {
                //return  @"状态";
                modelArr =  (menu==_sell_moreMenu)?_menu_SellStausArr:_menu_LeaseStausArr;
                
                if (menu == _sell_moreMenu)
                {
                    NSArray*valueArr =  [[[_menu_SellStausArr objectAtIndex:indexPath.row] objectForKey:@"menuItem"] objectForKey:@"value"];
                    
                    filter.sale_state = valueArr[0];
                }
                else if(menu == _rent_moreMenu)
                {
                    NSArray*valueArr =  [[[_menu_LeaseStausArr objectAtIndex:indexPath.row] objectForKey:@"menuItem"] objectForKey:@"value"];
                     filter.lease_state = valueArr[0];
                    if ([filter.lease_state isEqualToString:@""])
                    {
                        filter.lease_state = @"0";
                    }
                }
            }
                break;
            case 6:
            {
                //return  @"委托";
                NSArray*valueArr =  [[[_menu_ConsignmentStausArr objectAtIndex:indexPath.row] objectForKey:@"menuItem"] objectForKey:@"value"];
                
                filter.consignment_type = valueArr[0];
            }
                break;
            case 7:
            {
                //return  @"房型";
                NSArray*valueArr =  [[[_menu_RoomTypeArr objectAtIndex:indexPath.row] objectForKey:@"menuItem"] objectForKey:@"value"];
                filter.room_num = valueArr[0];
            }
                break;
            case 8:
            {
                
                //return @"其他";
                switch (indexPath.row)
                {
                    case 0:
                    {
                        if (cusValue != nil)
                        {
                            if (cusValue.valueArr && cusValue.valueArr.count > 0)
                            filter.buildname = cusValue.valueArr[0];
                        }
                        else
                        {
                            filter.buildname = @"";
                        }
                    }
                        break;
                    case 1:
                    {
                        if (cusValue != nil)
                        {
                            if (cusValue.valueArr && cusValue.valueArr.count > 0)
                            filter.unit_name = cusValue.valueArr[0];
                        }
                        else
                        {
                            filter.unit_name = @"";
                        }
                    }
                        break;
                    case 2:
                    {
                        if (cusValue != nil)
                        {
                            if (cusValue.valueArr && cusValue.valueArr.count > 0)
                            filter.house_tablet = cusValue.valueArr[0];
                        }
                        else
                        {
                            filter.house_tablet = @"";
                        }
                    }
                        break;
                        
                    default:
                        break;
                }
            }
                break;
                
            default:
                break;
        }
    

}


-(void)showContactVC
{
    AppDelegate*app = [[UIApplication sharedApplication] delegate];
    
    ContactListTableViewController*ctrl =[app instantiateViewControllerWithIdentifier:@"ContactListTableViewController" AndClass:[ContactListTableViewController class]];
    ctrl.selectMode = YES;
    ctrl.singleSelect = YES;
    ctrl.singleSelectCanSelectDepart = YES;
    ctrl.selectResultDelegate = self;
    [self.navigationController pushViewController:ctrl animated:YES];
}


-(void)returnSelection:(NSArray*)curSelection
{
    [self closeMenu];
    if (curSelection && curSelection.count > 0)
    {
        id unt = [curSelection objectAtIndex:0];
        NSString*deptNo = nil;
        NSString*displayName = nil;
        NSString*jobNo = nil;
        
        if ([unt isKindOfClass:[person class]])
        {
            jobNo = ((person*)unt).job_no;
            displayName = ((person*)unt).name_full;
        }
        else if([unt isKindOfClass:[department class]])
        {
            deptNo = ((department*)unt).dept_current_no;
            displayName = ((department*)unt).dept_name;
        }
        
        
        
        if (_selectedDeptAtMenu && (_selectedDeptAtMenu == _sell_DeptMenu || _selectedDeptAtMenu == _rent_DeptMenu))
        {
            HouseFilter*filter = (_selectedDeptAtMenu == _sell_DeptMenu)?_sellController.filter:_rentController.filter;
            MJDropDownMenuBar*menubar = (_selectedDeptAtMenu == _sell_DeptMenu)?_sellMenuBar:_rentMenuBar;
            
            if (deptNo)
            {
                filter.search_dept_no = deptNo;
                filter.search_job_no = @"";
            }
            else if(jobNo)
            {
                filter.search_job_no = jobNo;
                filter.search_dept_no = @"";
            }
        
            dispatch_async(dispatch_get_main_queue(), ^{
                [menubar updateTitle:displayName ForIndex:2];
                [self wannaRefresh];
            });
            
        }
        
        
        
        
        
        
    }
    
}

-(void)closeMenu
{
    [_sellMenuBar closeCurrentMenu];
    [_rentMenuBar closeCurrentMenu];
}


- (void)didTapBatchSelectBtnOnMenu:(MJDropDownMenu *)menu
{
    if (menu.batchSelect == YES)
    {
        [self closeMenu];
        
        if (self.nowControllerType == HCT_SELL)
        {
            [self mergeFilterFrom:_sellTmpFilter ToFilter:_sellController.filter];
        }
        else
        {
            [self mergeFilterFrom:_rentTmpFilter ToFilter:_rentController.filter];
        }
        //self.men
        [self wannaRefresh];
    }
}


-(id)cleanFilter:(id)filter
{
    if (filter != nil)
    {
        unsigned int fromIvarsCnt = 0;
        
        Class clsFrom = [filter class];
        Ivar *fromIvars = class_copyIvarList(clsFrom, &fromIvarsCnt);
        for (const Ivar *fromP = fromIvars; fromP < fromIvars + fromIvarsCnt; ++fromP)
        {
            id value = object_getIvar(filter, *fromP);
            if (value != nil && [value isKindOfClass:[NSString class]])
            {
                object_setIvar(filter, *fromP, @"");
            }
            
        }
        
        free(fromIvars);
        
    }
    
    return filter;
}

-(id)mergeFilterFrom:(id)fromFilter ToFilter:(id)toFilter
{
    if (fromFilter == nil && toFilter == nil)
    {
        return nil;
    }
    else if(toFilter  == nil)
    {
        return toFilter;
    }
    else if(fromFilter == nil && toFilter != nil)
    {
        return toFilter;
    }
    
    Class clsTo = [toFilter class];
    Class clsFrom = [fromFilter class];
    
    if (clsTo != clsFrom)
    {
        return toFilter;
    }
   
    unsigned int fromIvarsCnt = 0;
    unsigned int toIvarsCnt = 0;
    Ivar *fromIvars = class_copyIvarList(clsFrom, &fromIvarsCnt);
    Ivar *toIvars = class_copyIvarList(clsTo, &toIvarsCnt);
    
    if (fromIvars > 0 && fromIvarsCnt == toIvarsCnt && fromIvars != NULL && toIvars != NULL)
    {
        for (const Ivar *fromP = fromIvars; fromP < fromIvars + fromIvarsCnt; ++fromP)
        {
            //Ivar const ivar = ;
            NSString *keyFrom = [NSString stringWithUTF8String:ivar_getName(*fromP)];
            id value = object_getIvar(fromFilter, *fromP);
            if (value != nil && [value isKindOfClass:[NSString class]])
            {
                for (const Ivar* toP = toIvars; toP < toIvars + toIvarsCnt; ++toP)
                {
                    NSString *keyTo = [NSString stringWithUTF8String:ivar_getName(*toP)];
                    if ([keyFrom isEqualToString:keyTo])
                    {
                        object_setIvar(toFilter, *toP, value);
                        break;
                    }
                }
            }
            
        }
    }
    
    
    if(fromIvars)
    {
        free(fromIvars);
    }

    if (toIvars) {
        free(toIvars);
    }

    return toFilter;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)wannaRefresh
{
    self.applyForRefresh = YES;
    [self refreshData];
}

-(void)refreshData
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
}

- (void)viewDidAppear:(BOOL)animated
{
    [self refreshData];
    [super viewDidAppear:animated];
    
}

-(void)viewDidDisappear:(BOOL)animated
{
    
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
            [_rentMenuBar closeCurrentMenu];
        }
        
    }
    else
    {
        self.nowControllerType = HCT_RENT;
        
        if (_sellMenuBar)
        {
            _sellMenuBar.hidden = YES;
            [_sellMenuBar closeCurrentMenu];
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

