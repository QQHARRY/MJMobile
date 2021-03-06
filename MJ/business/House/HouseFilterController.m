//
//  HouseFilterController.m
//  RETableViewManagerExample
//
//  Created by Roman Efimov on 2/28/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "HouseFilterController.h"
#import "dictionaryManager.h"
#import "Macro.h"
#import "HouseDataPuller.h"
#import "UtilFun.h"
#import <objc/runtime.h>

@interface HouseFilterController ()

@property (strong, readwrite, nonatomic) RETableViewManager *manager;

@property (strong, readwrite, nonatomic) RETableViewSection *keySearchSection;
@property (strong, readwrite, nonatomic) RETextItem *keySearchItem;

@property (strong, readwrite, nonatomic) RETableViewSection *exactQuerySection;
@property (strong, readwrite, nonatomic) RETextItem *buildItem;
@property (strong, readwrite, nonatomic) RETextItem *unitItem;
@property (strong, readwrite, nonatomic) RETextItem *floorItem;
@property (strong, readwrite, nonatomic) RETextItem *tabletItem;
@property (strong, readwrite, nonatomic) RETextItem *hallItem;
@property (strong, readwrite, nonatomic) RETextItem *roomItem;
@property (strong, readwrite, nonatomic) RETextItem *minAreaItem;
@property (strong, readwrite, nonatomic) RETextItem *maxAreaItem;
@property (strong, readwrite, nonatomic) RETextItem *minPriceItem;
@property (strong, readwrite, nonatomic) RETextItem *maxPriceItem;
@property (strong, readwrite, nonatomic) RETextItem *minFloorItem;
@property (strong, readwrite, nonatomic) RETextItem *maxFloorItem;
@property (strong, readwrite, nonatomic) RERadioItem *belongAreaItem;
@property (strong, readwrite, nonatomic) RERadioItem *belongSectionItem;
@property (strong, readwrite, nonatomic) RERadioItem *driectItem;
@property (strong, readwrite, nonatomic) RERadioItem *statusItem;
@property (strong, readwrite, nonatomic) RERadioItem *fitmentItem;
@property (strong, readwrite, nonatomic) RERadioItem *consignmentItem;

@property (strong, readwrite, nonatomic) RETableViewSection *commitSection;

@property (nonatomic, strong) NSArray *directDictList;
@property (nonatomic, strong) NSArray *leaseDictList;
@property (nonatomic, strong) NSArray *saleDictList;
@property (nonatomic, strong) NSArray *fitmentDictList;
@property (nonatomic, strong) NSArray *consignmentDictList;
@property (nonatomic, strong) NSArray *areaDictList;

@end

@implementation HouseFilterController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"房源筛选";
    
    // get dict
    self.fitmentDictList = [dictionaryManager getItemArrByType:DIC_FITMENT_TYPE];
    self.leaseDictList = [dictionaryManager getItemArrByType:DIC_LEASE_TRADE_STATE];
    self.saleDictList = [dictionaryManager getItemArrByType:DIC_SALE_TRADE_STATE];
    self.consignmentDictList = [dictionaryManager getItemArrByType:DIC_CONSIGNMENT_TYPE];
    self.directDictList = [dictionaryManager getItemArrByType:DIC_HOUSE_DIRECT_TYPE];
    self.areaDictList = [NSArray array];
    
    // Create manager
    self.manager = [[RETableViewManager alloc] initWithTableView:self.tableView delegate:self];

    // add section
    self.keySearchSection = [self addKeySearchControls];
    self.exactQuerySection = [self addExactQueryControls];
    self.commitSection = [self addCommitButton];
    
    
    UIBarButtonItem*resetBtn = [[UIBarButtonItem alloc] initWithTitle:@"清空" style:UIBarButtonItemStylePlain target:self action:@selector(clearBtnClicked)];
    self.navigationItem.rightBarButtonItem = resetBtn;
}

-(void)clearBtnClicked
{
    [_keySearchItem setValue:@""];
    [_buildItem setValue:@""];
    [_unitItem setValue:@""];
    [_floorItem setValue:@""];
    [_tabletItem setValue:@""];
    [_hallItem setValue:@""];
    [_roomItem setValue:@""];
    [_minAreaItem setValue:@""];
    [_maxAreaItem setValue:@""];
    [_minPriceItem setValue:@""];
    [_maxPriceItem setValue:@""];
    [_minFloorItem setValue:@""];
    [_maxFloorItem setValue:@""];
    [_belongAreaItem setValue:@""];
    [_belongSectionItem setValue:@""];
    [_driectItem setValue:@""];
    [_statusItem setValue:@""];
    [_fitmentItem setValue:@""];
    [_consignmentItem setValue:@""];
    [self.tableView reloadData];

}

- (RETableViewSection *)addKeySearchControls
{
    RETableViewSection *section = [RETableViewSection sectionWithHeaderTitle:@"关键字"];
    [self.manager addSection:section];
    self.keySearchItem = [RETextItem itemWithTitle:nil value:nil placeholder:@"请输入楼盘名或交易编号"];
    [section addItem:self.keySearchItem];
    return section;
}

- (RETableViewSection *)addExactQueryControls
{
    __typeof (&*self) __weak weakSelf = self;

    RETableViewSection *section = [RETableViewSection sectionWithHeaderTitle:@"精确查询"];
    [self.manager addSection:section];
    self.buildItem = [RETextItem itemWithTitle:@"栋座" value:nil placeholder:@"如：05号楼"];
    [section addItem:self.buildItem];
    self.unitItem = [RETextItem itemWithTitle:@"单元" value:nil placeholder:@"如：2单元"];
    self.unitItem.keyboardType = UIKeyboardTypeNumberPad;
    [section addItem:self.unitItem];
    self.floorItem = [RETextItem itemWithTitle:@"楼层" value:nil placeholder:@"如：6楼"];
    self.floorItem.keyboardType = UIKeyboardTypeNumberPad;
    [section addItem:self.floorItem];
    self.tabletItem = [RETextItem itemWithTitle:@"房号" value:nil placeholder:@"如：3号"];
    self.tabletItem.keyboardType = UIKeyboardTypeNumberPad;
    [section addItem:self.tabletItem];
    self.hallItem = [RETextItem itemWithTitle:@"厅数" value:nil placeholder:@"如：2厅"];
    self.hallItem.keyboardType = UIKeyboardTypeNumberPad;
    [section addItem:self.hallItem];
    self.roomItem = [RETextItem itemWithTitle:@"室数" value:nil placeholder:@"如：3室"];
    self.roomItem.keyboardType = UIKeyboardTypeNumberPad;
    [section addItem:self.roomItem];
    self.minAreaItem = [RETextItem itemWithTitle:@"最小面积" value:nil placeholder:@"单位：m²"];
    self.minAreaItem.keyboardType = UIKeyboardTypeNumberPad;
    [section addItem:self.minAreaItem];
    self.maxAreaItem = [RETextItem itemWithTitle:@"最大面积" value:nil placeholder:@"单位：m²"];
    self.maxAreaItem.keyboardType = UIKeyboardTypeNumberPad;
    [section addItem:self.maxAreaItem];
    self.minPriceItem = [RETextItem itemWithTitle:@"最小价格" value:nil placeholder:(self.hvc.nowControllerType == HCT_SELL) ? @"单位：万元" : @"单位：元/月"];
    self.minPriceItem.keyboardType = UIKeyboardTypeNumberPad;
    [section addItem:self.minPriceItem];
    self.maxPriceItem = [RETextItem itemWithTitle:@"最大价格" value:nil placeholder:(self.hvc.nowControllerType == HCT_SELL) ? @"单位：万元" : @"单位：元/月"];
    self.maxPriceItem.keyboardType = UIKeyboardTypeNumberPad;
    [section addItem:self.maxPriceItem];
    self.minFloorItem = [RETextItem itemWithTitle:@"最低楼层" value:nil placeholder:@""];
    self.minFloorItem.keyboardType = UIKeyboardTypeNumberPad;
    [section addItem:self.minFloorItem];
    self.maxFloorItem = [RETextItem itemWithTitle:@"最高楼层" value:nil placeholder:@""];
    self.maxFloorItem.keyboardType = UIKeyboardTypeNumberPad;
    [section addItem:self.maxFloorItem];
    self.belongAreaItem = [RERadioItem itemWithTitle:@"所属城区" value:@"" selectionHandler:^(RERadioItem *item)
                           {
                               if (!self.areaDictList || self.areaDictList.count <= 0)
                               {
                                   SHOWHUD_WINDOW;
                                   [HouseDataPuller pullAreaListDataSuccess:^(NSArray *areaList)
                                    {
                                        HIDEHUD_WINDOW;
                                        self.areaDictList = areaList;
                                        [item deselectRowAnimated:YES]; // same as [weakSelf.tableView deselectRowAtIndexPath:item.indexPath animated:YES];
                                        NSMutableArray *options = [[NSMutableArray alloc] init];
                                        for (NSInteger i = 0; i < self.areaDictList.count; i++)
                                        {
                                            [options addObject:[[[self.areaDictList objectAtIndex:i] objectForKey:@"dict"] objectForKey:@"area_name"]];
                                        }
                                        RETableViewOptionsController *optionsController = [[RETableViewOptionsController alloc] initWithItem:item options:options multipleChoice:NO completionHandler:^(RETableViewItem *selectedItem)
                                                                                           {
                                                                                               [weakSelf.navigationController popViewControllerAnimated:YES];
                                                                                               [item reloadRowWithAnimation:UITableViewRowAnimationNone]; // same as [weakSelf.tableView reloadRowsAtIndexPaths:@[item.indexPath] withRowAnimation:UITableViewRowAnimationNone];
                                                                                               self.belongSectionItem.value = @"";
                                                                                               [self.tableView reloadData];
                                                                                           }];
                                        // Adjust styles
                                        optionsController.delegate = weakSelf;
                                        optionsController.style = section.style;
                                        if (weakSelf.tableView.backgroundView == nil)
                                        {
                                            optionsController.tableView.backgroundColor = weakSelf.tableView.backgroundColor;
                                            optionsController.tableView.backgroundView = nil;
                                        }
                                        // Push the options controller
                                        [weakSelf.navigationController pushViewController:optionsController animated:YES];
                                    }
                                                                    failure:^(NSError *error)
                                    {
                                        HIDEHUD_WINDOW;
                                    }];
                               }
                               else
                               {
                                   [item deselectRowAnimated:YES]; // same as [weakSelf.tableView deselectRowAtIndexPath:item.indexPath animated:YES];
                                   NSMutableArray *options = [[NSMutableArray alloc] init];
                                   for (NSInteger i = 0; i < self.areaDictList.count; i++)
                                   {
                                       [options addObject:[[[self.areaDictList objectAtIndex:i] objectForKey:@"dict"] objectForKey:@"area_name"]];
                                   }
                                   RETableViewOptionsController *optionsController = [[RETableViewOptionsController alloc] initWithItem:item options:options multipleChoice:NO completionHandler:^(RETableViewItem *selectedItem)
                                                                                      {
                                                                                          [weakSelf.navigationController popViewControllerAnimated:YES];
                                                                                          [item reloadRowWithAnimation:UITableViewRowAnimationNone]; // same as [weakSelf.tableView reloadRowsAtIndexPaths:@[item.indexPath] withRowAnimation:UITableViewRowAnimationNone];
                                                                                          self.belongSectionItem.value = @"";
                                                                                          [self.tableView reloadData];
                                                                                      }];
                                   // Adjust styles
                                   optionsController.delegate = weakSelf;
                                   optionsController.style = section.style;
                                   if (weakSelf.tableView.backgroundView == nil)
                                   {
                                       optionsController.tableView.backgroundColor = weakSelf.tableView.backgroundColor;
                                       optionsController.tableView.backgroundView = nil;
                                   }
                                   // Push the options controller
                                   [weakSelf.navigationController pushViewController:optionsController animated:YES];
                               }
                           }];
    [section addItem:self.belongAreaItem];
    self.belongSectionItem = [RERadioItem itemWithTitle:@"所属片区" value:@"" selectionHandler:^(RERadioItem *item)
                              {
                                  [item deselectRowAnimated:YES]; // same as [weakSelf.tableView deselectRowAtIndexPath:item.indexPath animated:YES];
                                  NSMutableArray *options = [[NSMutableArray alloc] init];
                                  NSDictionary *dstDict = nil;
                                  for (NSDictionary *areaDict in self.areaDictList)
                                  {
                                      if ([[[areaDict objectForKey:@"dict"] objectForKey:@"area_name"] isEqualToString:self.belongAreaItem.value])
                                      {
                                          dstDict = areaDict;
                                          break;
                                      }
                                  }
//                                  if (dstDict && dstDict.count > 0)
//                                  {
//                                      for (NSInteger i = 0; i < dstDict.count; i++)
//                                      {
//                                          [options addObject:[[[dstDict objectForKey:@"sections"] objectAtIndex:i] objectForKey:@"area_name"]];
//                                      }
//                                  }
                                  if (dstDict && dstDict.count > 0)
                                  {
                                      NSArray*sectionArr = [dstDict objectForKey:@"sections"];
                                      for (NSInteger i = 0; i < sectionArr.count; i++)
                                      {
                                          [options addObject:[[sectionArr objectAtIndex:i] objectForKey:@"area_name"]];
                                      }
                                  }
                                  
                                  
                                  RETableViewOptionsController *optionsController = [[RETableViewOptionsController alloc] initWithItem:item options:options multipleChoice:NO completionHandler:^(RETableViewItem *selectedItem)
                                                                                     {
                                                                                         [weakSelf.navigationController popViewControllerAnimated:YES];
                                                                                         [item reloadRowWithAnimation:UITableViewRowAnimationNone]; // same as [weakSelf.tableView reloadRowsAtIndexPaths:@[item.indexPath] withRowAnimation:UITableViewRowAnimationNone];
                                                                                     }];
                                  // Adjust styles
                                  optionsController.delegate = weakSelf;
                                  optionsController.style = section.style;
                                  if (weakSelf.tableView.backgroundView == nil)
                                  {
                                      optionsController.tableView.backgroundColor = weakSelf.tableView.backgroundColor;
                                      optionsController.tableView.backgroundView = nil;
                                  }
                                  
                                  // Push the options controller
                                  [weakSelf.navigationController pushViewController:optionsController animated:YES];
                              }];
    [section addItem:self.belongSectionItem];
    self.driectItem = [RERadioItem itemWithTitle:@"朝向" value:@"" selectionHandler:^(RERadioItem *item)
                           {
                               [item deselectRowAnimated:YES]; // same as [weakSelf.tableView deselectRowAtIndexPath:item.indexPath animated:YES];
                               NSMutableArray *options = [[NSMutableArray alloc] init];
                               for (NSInteger i = 0; i < self.directDictList.count; i++)
                               {
                                   DicItem *di = [self.directDictList objectAtIndex:i];
                                   [options addObject:di.dict_label];
                               }
                               RETableViewOptionsController *optionsController = [[RETableViewOptionsController alloc] initWithItem:item options:options multipleChoice:NO completionHandler:^(RETableViewItem *selectedItem)
                                                                                  {
                                                                                      [weakSelf.navigationController popViewControllerAnimated:YES];
                                                                                      [item reloadRowWithAnimation:UITableViewRowAnimationNone]; // same as [weakSelf.tableView reloadRowsAtIndexPaths:@[item.indexPath] withRowAnimation:UITableViewRowAnimationNone];
                                                                                  }];
                               // Adjust styles
                               optionsController.delegate = weakSelf;
                               optionsController.style = section.style;
                               if (weakSelf.tableView.backgroundView == nil)
                               {
                                   optionsController.tableView.backgroundColor = weakSelf.tableView.backgroundColor;
                                   optionsController.tableView.backgroundView = nil;
                               }
                               // Push the options controller
                               [weakSelf.navigationController pushViewController:optionsController animated:YES];
                           }];
    [section addItem:self.driectItem];
    self.statusItem = [RERadioItem itemWithTitle:@"状态" value:@"" selectionHandler:^(RERadioItem *item)
                           {
                               [item deselectRowAnimated:YES]; // same as [weakSelf.tableView deselectRowAtIndexPath:item.indexPath animated:YES];
                               NSMutableArray *options = [[NSMutableArray alloc] init];
                               NSArray *dictList = (self.hvc.nowControllerType == HCT_SELL) ? self.saleDictList : self.leaseDictList;
                               for (NSInteger i = 0; i < dictList.count; i++)
                               {
                                   DicItem *di = [dictList objectAtIndex:i];
                                   [options addObject:di.dict_label];
                               }
                               RETableViewOptionsController *optionsController = [[RETableViewOptionsController alloc] initWithItem:item options:options multipleChoice:NO completionHandler:^(RETableViewItem *selectedItem)
                                                                                  {
                                                                                      [weakSelf.navigationController popViewControllerAnimated:YES];
                                                                                      [item reloadRowWithAnimation:UITableViewRowAnimationNone]; // same as [weakSelf.tableView reloadRowsAtIndexPaths:@[item.indexPath] withRowAnimation:UITableViewRowAnimationNone];
                                                                                  }];
                               // Adjust styles
                               optionsController.delegate = weakSelf;
                               optionsController.style = section.style;
                               if (weakSelf.tableView.backgroundView == nil)
                               {
                                   optionsController.tableView.backgroundColor = weakSelf.tableView.backgroundColor;
                                   optionsController.tableView.backgroundView = nil;
                               }
                               // Push the options controller
                               [weakSelf.navigationController pushViewController:optionsController animated:YES];
                           }];
    [section addItem:self.statusItem];
    self.fitmentItem = [RERadioItem itemWithTitle:@"装修" value:@"" selectionHandler:^(RERadioItem *item)
                           {
                               [item deselectRowAnimated:YES]; // same as [weakSelf.tableView deselectRowAtIndexPath:item.indexPath animated:YES];
                               NSMutableArray *options = [[NSMutableArray alloc] init];
                               for (NSInteger i = 0; i < self.fitmentDictList.count; i++)
                               {
                                   DicItem *di = [self.fitmentDictList objectAtIndex:i];
                                   [options addObject:di.dict_label];
                               }
                               RETableViewOptionsController *optionsController = [[RETableViewOptionsController alloc] initWithItem:item options:options multipleChoice:NO completionHandler:^(RETableViewItem *selectedItem)
                                                                                  {
                                                                                      [weakSelf.navigationController popViewControllerAnimated:YES];
                                                                                      [item reloadRowWithAnimation:UITableViewRowAnimationNone]; // same as [weakSelf.tableView reloadRowsAtIndexPaths:@[item.indexPath] withRowAnimation:UITableViewRowAnimationNone];
                                                                                  }];
                               // Adjust styles
                               optionsController.delegate = weakSelf;
                               optionsController.style = section.style;
                               if (weakSelf.tableView.backgroundView == nil)
                               {
                                   optionsController.tableView.backgroundColor = weakSelf.tableView.backgroundColor;
                                   optionsController.tableView.backgroundView = nil;
                               }
                               // Push the options controller
                               [weakSelf.navigationController pushViewController:optionsController animated:YES];
                           }];
    [section addItem:self.fitmentItem];
    self.consignmentItem = [RERadioItem itemWithTitle:@"委托" value:@"" selectionHandler:^(RERadioItem *item)
                           {
                               [item deselectRowAnimated:YES]; // same as [weakSelf.tableView deselectRowAtIndexPath:item.indexPath animated:YES];
                               NSMutableArray *options = [[NSMutableArray alloc] init];
                               for (NSInteger i = 0; i < self.consignmentDictList.count; i++)
                               {
                                   DicItem *di = [self.consignmentDictList objectAtIndex:i];
                                   [options addObject:di.dict_label];
                               }
                               RETableViewOptionsController *optionsController = [[RETableViewOptionsController alloc] initWithItem:item options:options multipleChoice:NO completionHandler:^(RETableViewItem *selectedItem)
                                                                                  {
                                                                                      [weakSelf.navigationController popViewControllerAnimated:YES];
                                                                                      [item reloadRowWithAnimation:UITableViewRowAnimationNone]; // same as [weakSelf.tableView reloadRowsAtIndexPaths:@[item.indexPath] withRowAnimation:UITableViewRowAnimationNone];
                                                                                  }];
                               // Adjust styles
                               optionsController.delegate = weakSelf;
                               optionsController.style = section.style;
                               if (weakSelf.tableView.backgroundView == nil)
                               {
                                   optionsController.tableView.backgroundColor = weakSelf.tableView.backgroundColor;
                                   optionsController.tableView.backgroundView = nil;
                               }
                               // Push the options controller
                               [weakSelf.navigationController pushViewController:optionsController animated:YES];
                           }];
    [section addItem:self.consignmentItem];

    return section;
}

- (RETableViewSection *)addCommitButton
{
    RETableViewSection *section = [RETableViewSection section];
    [self.manager addSection:section];
    
    RETableViewItem *buttonItem = [RETableViewItem itemWithTitle:@"查询" accessoryType:UITableViewCellAccessoryNone selectionHandler:^(RETableViewItem *item)
    {
        HouseFilter *filter = (self.hvc.nowControllerType == HCT_SELL) ? self.hvc.sellController.filter : self.hvc.rentController.filter;
        filter.FromID = @"0";
        filter.ToID = @"0";
        filter.Keyword = self.keySearchItem.value;
        filter.buildname = self.buildItem.value;
        filter.unit_name = self.unitItem.value;
        filter.house_floor = self.floorItem.value;
        filter.house_tablet = self.tabletItem.value;
        filter.hall_num = self.hallItem.value;
        filter.room_num = self.roomItem.value;
        filter.structure_area_from = self.minAreaItem.value;
        filter.structure_area_to = self.maxAreaItem.value;
        filter.house_floor_from = self.minFloorItem.value;
        filter.house_floor_to = self.maxFloorItem.value;
        if (self.hvc.nowControllerType == HCT_SELL)
        {
            filter.lease_value_from = @"";
            filter.lease_value_to = @"";
            filter.lease_state = @"";
            filter.sale_value_from = self.minPriceItem.value;
            filter.sale_value_to = self.maxPriceItem.value;
            filter.sale_state = @"";
            for (DicItem *di in self.saleDictList)
            {
                if ([di.dict_label isEqualToString:self.statusItem.value])
                {
                    filter.sale_state = di.dict_value;
                    break;
                }
            }
        }
        else
        {
            filter.sale_value_from = @"";
            filter.sale_value_to = @"";
            filter.sale_state = @"";
            filter.lease_value_from = self.minPriceItem.value;
            filter.lease_value_to = self.maxPriceItem.value;
            filter.lease_state = @"";
            for (DicItem *di in self.leaseDictList)
            {
                if ([di.dict_label isEqualToString:self.statusItem.value])
                {
                    filter.lease_state = di.dict_value;
                    break;
                }
            }
        }
        filter.house_driect = @"";
        for (DicItem *di in self.directDictList)
        {
            if ([di.dict_label isEqualToString:self.driectItem.value])
            {
                filter.house_driect = di.dict_value;
                break;
            }
        }
        filter.fitment_type = @"";
        for (DicItem *di in self.fitmentDictList)
        {
            if ([di.dict_label isEqualToString:self.fitmentItem.value])
            {
                filter.fitment_type = di.dict_value;
                break;
            }
        }
        filter.consignment_type = @"";
        for (DicItem *di in self.consignmentDictList)
        {
            if ([di.dict_label isEqualToString:self.consignmentItem.value])
            {
                filter.consignment_type = di.dict_value;
                break;
            }
        }
        filter.house_area = @"";
        for (NSDictionary *areaDict in self.areaDictList)
        {
            if ([[[areaDict objectForKey:@"dict"] objectForKey:@"area_name"] isEqualToString:self.belongAreaItem.value])
            {
                filter.house_urban = [areaDict objectForKey:@"no"];
                break;
            }
        }
        filter.house_urban = @"";
        for (NSDictionary *areaDict in self.areaDictList)
        {
            NSArray *sectionList = [areaDict objectForKey:@"sections"];
            BOOL bFind = false;
            for (NSDictionary *sectionDict in sectionList)
            {
                if ([[sectionDict objectForKey:@"area_name"] isEqualToString:self.belongSectionItem.value])
                {
                    filter.house_area = [sectionDict objectForKey:@"area_cno"];
                    bFind = true;
                    break;
                }
            }
            if (bFind)
            {
                break;
            }
        }
        _hvc.applyForRefresh = YES;
        [self.navigationController popViewControllerAnimated:YES];
    }];
    buttonItem.textAlignment = NSTextAlignmentCenter;
    [section addItem:buttonItem];
    return section;
}

@end
