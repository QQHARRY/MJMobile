//
//  CustomerViewController.m
//  MJ
//
//  Created by harry on 14-11-23.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import "CustomerViewController.h"
#import "NetWorkManager.h"
#import "UtilFun.h"
#import "Macro.h"
#import "person.h"
#import "CustomerFilter.h"
#import "CustomerFilterController.h"
#import "addCustomerTableViewController.h"
#import "MJDropDownMenuBar.h"
#import "MJDropDownMenu.h"
#import "MJMenuModel.h"
#import "AppDelegate.h"
#import "department.h"
#import "person.h"
#import <objc/runtime.h>


#define MENUBAR_HEIGHT 32
#define TABBAR_HEIGHT 44


@interface CustomerViewController ()<MJDropDownMenuBarDataSource,MJDropDownMenuBarDelegate,MJDropDownMenuDataSource,MJDropDownMenuDelegate,contacSelection>

@property(strong,nonatomic)CustomerFilterController*filter;

@property(strong,nonatomic)MJDropDownMenuBar*sellMenuBar;
@property(strong,nonatomic)MJDropDownMenuBar*rentMenuBar;
@property(strong,nonatomic)MJDropDownMenu*rent_areaMenu;
@property(strong,nonatomic)MJDropDownMenu*rent_DateMenu;
@property(strong,nonatomic)MJDropDownMenu*rent_DeptMenu;
@property(strong,nonatomic)MJDropDownMenu*rent_moreMenu;


@property(strong,nonatomic)MJDropDownMenu*sell_areaMenu;
@property(strong,nonatomic)MJDropDownMenu*sell_DateMenu;
@property(strong,nonatomic)MJDropDownMenu*sell_DeptMenu;
@property(strong,nonatomic)MJDropDownMenu*sell_moreMenu;




@property(strong,nonatomic)NSMutableArray*menu_urbanAreaArr;
@property(strong,nonatomic)NSMutableArray*menu_DateArr;
@property(strong,nonatomic)NSMutableArray*menu_deptArr;

@property(strong,nonatomic)NSMutableArray*menu_customerProArr;
@property(strong,nonatomic)NSMutableArray*menu_customerStatusArr;

@property(strong,nonatomic)MJDropDownMenu*selectDeptMenu;
@property(strong,nonatomic)CustomerFilter*sellTmpFilter;
@property(strong,nonatomic)CustomerFilter*rentTmpFilter;


@end

@implementation CustomerViewController
@synthesize applyForRefresh;

- (void)viewDidLoad
{
    // init controller base info
    self.title = @"客源";
    self.dataSource = self;
    self.delegate = self;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    // default is sell controller
    self.nowControllerType = CCT_SELL;
    
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
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(onAddCus:)];
    
    // add table view controller
    self.rentController = [[CustomerTableViewController alloc] initWithNibName:@"CustomerTableViewController" bundle:[NSBundle mainBundle]];
    self.rentController.controllerType = CCT_RENT;
    self.rentController.container = self;
    self.rentController.filter = [[CustomerFilter alloc] init];
    self.rentController.filter.business_requirement_type = @"201";
    self.rentController.filter.requirement_status = @"0";
    self.rentController.filter.FromID = @"0";
    self.rentController.filter.ToID = @"0";
    self.rentController.filter.Count = @"10";
    self.sellController = [[CustomerTableViewController alloc] initWithNibName:@"CustomerTableViewController" bundle:[NSBundle mainBundle]];
    self.sellController.controllerType = CCT_SELL;
    self.sellController.container = self;
    self.sellController.filter = [[CustomerFilter alloc] init];
    self.sellController.filter.business_requirement_type = @"200";
    self.sellController.filter.requirement_status = @"0";
    self.sellController.filter.FromID = @"0";
    self.sellController.filter.ToID = @"0";
    self.sellController.filter.Count = @"10";
    self.applyForRefresh = NO;
    
    
    
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
    
    SHOWHUD(self.view);
    [MJMenuModel asyncGetUrbanAndAreaMenuItemList:^(BOOL success, NSArray *urbanArr) {
        _menu_urbanAreaArr = urbanArr;
        HIDEHUD(self.view);
    }];
    _menu_DateArr = [[MJMenuModel getDateSectionMenuItemList] mutableCopy];
    _menu_deptArr = [[MJMenuModel getCusDeptMenuItemList] mutableCopy];
    
    _menu_customerProArr = [[MJMenuModel getCustomerPropertyMenuItemList] mutableCopy];
    _menu_customerStatusArr = [[MJMenuModel getCustomerStatusMenuItemList] mutableCopy];
    _sellTmpFilter = [[CustomerFilter alloc] init];
    _rentTmpFilter = [[CustomerFilter alloc] init];
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
        case 1:return @"日期";break;
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
                if(_sell_areaMenu == nil)
                    _sell_areaMenu = [self createDropDownMenuWithMode:NO BatchSelect:NO];
                return _sell_areaMenu;
            }
            else
            {
                if(_rent_areaMenu == nil)
                    _rent_areaMenu = [self createDropDownMenuWithMode:NO BatchSelect:NO];
                return _rent_areaMenu;
            }
        }
            break;
        case 1:
        {
            if (menuBar == _sellMenuBar)
            {
                if(_sell_DateMenu == nil)
                    _sell_DateMenu = [self createDropDownMenuWithMode:YES BatchSelect:NO];
                return _sell_DateMenu;
            }
            else if (menuBar ==_rentMenuBar)
            {
                if(_rent_DateMenu == nil)
                    _rent_DateMenu = [self createDropDownMenuWithMode:YES BatchSelect:NO];
                return _rent_DateMenu;
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

- (NSInteger)menu:(MJDropDownMenu *)menu tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
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
    else if(menu == _sell_DateMenu && _menu_DateArr)
    {
        if (tableView == menu.leftTableV)
        {
            return [_menu_DateArr count];
        }
    }
    else if (menu == _rent_DateMenu && _menu_DateArr)
    {
        if (tableView == menu.leftTableV)
        {
            return [_menu_DateArr count];
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
            return 2;
        }
        else
        {
            switch (section)
            {
                case 0:
                {
                    return [_menu_customerProArr count];
                }
                    break;
                case 1:
                {
                    return [_menu_customerStatusArr count];
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
                MJMenuModel*model = [_menu_urbanAreaArr objectAtIndex:indexPath.section];
                if (model && [model isKindOfClass:[MJMenuModel class]] && model.subMenuItems && model.subMenuItems.count > indexPath.row)
                {
                    return ((MJMenuItem*)[model.subMenuItems objectAtIndex:indexPath.row]).title;
                }
            }
            
        }
    }
    else if(menu == _sell_DateMenu && _menu_DateArr)
    {
        if (tableView == menu.leftTableV)
        {
            return [[[_menu_DateArr objectAtIndex:indexPath.row] objectForKey:@"menuItem"] objectForKey:@"title"];
        }
    }
    else if (menu == _rent_DateMenu && _menu_DateArr)
    {
        if (tableView == menu.leftTableV)
        {
            return [[[_menu_DateArr objectAtIndex:indexPath.row] objectForKey:@"menuItem"] objectForKey:@"title"];
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
                    return @"客户信息";
                }
                    break;
                case 1:
                {
                    return @"客户状态";
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
                    return [[[_menu_customerProArr objectAtIndex:indexPath.row] objectForKey:@"menuItem"] objectForKey:@"title"];
                }
                    break;
                case 1:
                {
                    return [[[_menu_customerStatusArr objectAtIndex:indexPath.row] objectForKey:@"menuItem"] objectForKey:@"title"];
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
    else if(menu == _sell_DateMenu && _menu_DateArr)
    {
        if (tableView == menu.leftTableV)
        {
            return [[[[_menu_DateArr objectAtIndex:indexPath.row] objectForKey:@"menuItem"] objectForKey:@"valueType"] intValue];
        }
    }
    else if (menu == _rent_DateMenu && _menu_DateArr)
    {
        if (tableView == menu.leftTableV)
        {
            return [[[[_menu_DateArr objectAtIndex:indexPath.row] objectForKey:@"menuItem"] objectForKey:@"valueType"] intValue];
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
                    return [[[[_menu_customerProArr objectAtIndex:indexPath.row] objectForKey:@"menuItem"] objectForKey:@"valueType"] intValue];
                }
                    break;
                case 1:
                {
                    return [[[[_menu_customerStatusArr objectAtIndex:indexPath.row] objectForKey:@"menuItem"] objectForKey:@"valueType"] intValue];
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
    
   if(menu ==_sell_moreMenu || menu == _rent_moreMenu)
    {
        if (tableView == menu.rightTableV)
        {
            switch (indexPath.section)
            {
                case 0:
                {
                    
                }
                case 1:
                {
                    
                }
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
    if (menu == _sell_areaMenu || menu == _rent_areaMenu)
    {
        CustomerFilter*filter = (menu == _sell_areaMenu)?_sellController.filter:_rentController.filter;
        menubar = (menu == _sell_areaMenu)?_sellMenuBar:_rentMenuBar;
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
    else if(menu == _sell_DateMenu || menu == _rent_DateMenu)
    {
        CustomerFilter*filter = (menu == _sell_DateMenu)?_sellController.filter:_rentController.filter;
        menubar = (menu == _sell_DateMenu)?_sellMenuBar:_rentMenuBar;
        NSArray*priceArr = _menu_DateArr;
        
        if(filter && indexPath.row < [priceArr count])
        {
            NSDictionary*dic = [priceArr objectAtIndex:indexPath.row];
            
            NSArray*valueArr = [[dic objectForKey:@"menuItem"] objectForKey:@"value"];
            if (valueArr && valueArr.count > 1)
            {
                NSString* minPrice = valueArr[0];
                NSString* maxPrice = valueArr[1];
                
                filter.start_date = minPrice;
                filter.end_date = maxPrice;
            }
            
            NSString*title = [[dic objectForKey:@"menuItem"] objectForKey:@"title"];
            [menubar updateTitle:[NSString stringWithFormat:@"%@",title] ForIndex:1];
            [self wannaRefresh];
        }
        
        
    }
    else if (menu == _sell_DeptMenu || menu == _rent_DeptMenu)
    {
        CustomerFilter*filter = (menu == _sell_DeptMenu)?_sellController.filter:_rentController.filter;
        menubar = (menu == _sell_DeptMenu)?_sellMenuBar:_rentMenuBar;
        
        
        if(filter)
        {
            switch (indexPath.row)
            {
                case 0:
                {
                    [menubar updateTitle:@"不限" ForIndex:2];
                    filter.user_no = @"";
                    filter.dept_no = @"";
                    [self wannaRefresh];
                }
                    break;
                case 1:
                {
                    [menubar updateTitle:@"我的部门" ForIndex:2];
                    filter.user_no = [person me].job_no;
                    filter.dept_no = [person me].department_no;
                    [self wannaRefresh];
                }
                    break;
                default:
                {
                    _selectDeptMenu = menu;
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


-(void)wannaRefresh
{
    self.applyForRefresh = YES;
    [self refreshData];
}

-(void)refreshData
{
    if (self.nowControllerType == CCT_SELL)
    {
        if (self.applyForRefresh)
        {
            [self.sellController refreshData];
        }
        
    }
    else if (self.nowControllerType == CCT_RENT)
    {
        if (self.applyForRefresh)
        {
            [self.rentController refreshData];
        }
        
    }
    self.applyForRefresh = NO;
}


-(void)setFilterByClickedMoreMenu:(MJDropDownMenu*)menu AtIndexPath:(NSIndexPath*)indexPath WithCustomizedValue:(MJMenuItemValue*)cusValue
{
    CustomerFilter*filter = (menu == _sell_moreMenu)?_sellTmpFilter:_rentTmpFilter;
    
    //NSArray*modelArr = nil;
    
    switch (indexPath.section)
    {
        case 0:
        {
            NSInteger valueType =  [[[[_menu_customerProArr objectAtIndex:indexPath.row] objectForKey:@"menuItem"] objectForKey:@"valueType"] intValue];
            switch (indexPath.row)
            {
                case 0:
                {
                    //return @"姓名";
                    
                    filter.client_name = @"";
                    
                    if (cusValue)
                    {
                        if (cusValue.valueArr && cusValue.valueArr.count > 0 &&
                            valueType == MJMenuItemValueTypeMultiCustomizeSingle)
                        {
                            filter.client_name = cusValue.valueArr[0];
                        }
                    }
                }
                    break;
                case 1:
                {
                    filter.obj_mobile = @"";
                    //return @"电话";
                    if (cusValue)
                    {
                        if (cusValue.valueArr && cusValue.valueArr.count > 0 &&
                            valueType == MJMenuItemValueTypeMultiCustomizeSingle)
                        {
                            filter.obj_mobile = cusValue.valueArr[0];
                        }
                    }

                }
                    break;
                    
                default:
                    break;
            }
            
        }
            break;
        case 1:
        {
            //return @"状态";
            if (indexPath.row < _menu_customerStatusArr.count )
            {
                NSArray*valueArr =  [[[_menu_customerStatusArr objectAtIndex:indexPath.row] objectForKey:@"menuItem"] objectForKey:@"value"];
                filter.client_name = valueArr[0];
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
        NSString*deptName = nil;
        
        if ([unt isKindOfClass:[person class]])
        {
            deptNo = ((person*)unt).department_no;
            deptName = ((person*)unt).dept_name;
        }
        else if([unt isKindOfClass:[department class]])
        {
            deptNo = ((department*)unt).dept_current_no;
            deptName = ((department*)unt).dept_name;
        }
        
        if (deptNo && deptName)
        {
            if (_selectDeptMenu && (_selectDeptMenu == _sell_DeptMenu || _selectDeptMenu == _rent_DeptMenu))
            {
                CustomerFilter*filter = (_selectDeptMenu == _sell_DeptMenu)?_sellController.filter:_rentController.filter;
                MJDropDownMenuBar*menubar = (_selectDeptMenu == _sell_DeptMenu)?_sellMenuBar:_rentMenuBar;
                
                filter.dept_no = deptNo;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [menubar updateTitle:deptName ForIndex:2];
                    [self wannaRefresh];
                });
                
            }
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
        
        if (self.nowControllerType == CCT_SELL)
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

- (void)viewDidAppear:(BOOL)animated
{
//    if (self.nowControllerType == CCT_SELL)
//    {
//        if (applyForRefresh)
//        {
//            [self.sellController refreshData];
//        }
//        
//    }
//    else if (self.nowControllerType == CCT_RENT)
//    {
//        if (applyForRefresh) {
//            [self.rentController refreshData];
//        }
//        
//    }
//    applyForRefresh = NO;
    
    [self refreshData];
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onFilterAction:(id)sender
{
    if (_filter == nil)
    {
        _filter = [[CustomerFilterController alloc] initWithStyle:UITableViewStyleGrouped];
        _filter.hvc = self;
        _filter.hidesBottomBarWhenPushed = YES;
    }
    
    [self.navigationController pushViewController:_filter animated:YES];
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
        label.text = @"求购";
    }
    else
    {
        label.text = @"求租";
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
        self.nowControllerType = CCT_SELL;
    }
    else
    {
        self.nowControllerType = CCT_RENT;
    }
}


- (void)onAddCus:(id)sender
{
    addCustomerTableViewController*vc = [[addCustomerTableViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
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

