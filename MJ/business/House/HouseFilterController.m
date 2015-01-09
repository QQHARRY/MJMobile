//
//  HouseFilterController.m
//  RETableViewManagerExample
//
//  Created by Roman Efimov on 2/28/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "HouseFilterController.h"
//#import "MultilineTextItem.h"

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

@end

@implementation HouseFilterController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"房源筛选";
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Values" style:UIBarButtonItemStyleBordered target:self action:@selector(valuesButtonPressed:)];
    
    // Create manager
    self.manager = [[RETableViewManager alloc] initWithTableView:self.tableView delegate:self];

    self.keySearchSection = [self addKeySearchControls];
    self.exactQuerySection = [self addExactQueryControls];
    self.commitSection = [self addCommitButton];
}

- (void)valuesButtonPressed:(id)sender
{
//    NSLog(@"fullLengthFieldItem.value = %@", self.fullLengthFieldItem.value);
//    NSLog(@"textItem.value = %@", self.textItem.value);
//    NSLog(@"numberItem.value = %@", self.numberItem.value);
//    NSLog(@"passwordItem.value = %@", self.passwordItem.value);
//    NSLog(@"boolItem.value = %@", self.boolItem.value ? @"YES" : @"NO");
//    NSLog(@"floatItem.value = %f", self.floatItem.value);
//    NSLog(@"dateTimeItem = %@", self.dateTimeItem.value);
//    NSLog(@"radioItem.value = %@", self.radioItem.value);
//    NSLog(@"multipleChoiceItem.value = %@", self.multipleChoiceItem.value);
//    NSLog(@"longTextItem.value = %@", self.longTextItem.value);
//    NSLog(@"creditCardItem.number = %@, creditCardItem.expirationDate = %@, creditCardItem.cvv = %@", self.creditCardItem.number, self.creditCardItem.expirationDate, self.creditCardItem.cvv);
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
    self.buildItem = [RETextItem itemWithTitle:@"栋座" value:nil placeholder:@"如：1栋"];
    [section addItem:self.buildItem];
    self.unitItem = [RETextItem itemWithTitle:@"单元" value:nil placeholder:@"如：2单元"];
    [section addItem:self.unitItem];
    self.floorItem = [RETextItem itemWithTitle:@"楼层" value:nil placeholder:@"如：6楼"];
    [section addItem:self.floorItem];
    self.tabletItem = [RETextItem itemWithTitle:@"房号" value:nil placeholder:@"如：3号"];
    [section addItem:self.tabletItem];
    self.hallItem = [RETextItem itemWithTitle:@"厅数" value:nil placeholder:@"如：2厅"];
    [section addItem:self.hallItem];
    self.roomItem = [RETextItem itemWithTitle:@"室数" value:nil placeholder:@"如：3室"];
    [section addItem:self.roomItem];
    self.minAreaItem = [RETextItem itemWithTitle:@"最小面积" value:nil placeholder:@""];
    [section addItem:self.minAreaItem];
    self.maxAreaItem = [RETextItem itemWithTitle:@"最大面积" value:nil placeholder:@""];
    [section addItem:self.maxAreaItem];
    self.minPriceItem = [RETextItem itemWithTitle:@"最小价格" value:nil placeholder:@""];
    [section addItem:self.minPriceItem];
    self.maxPriceItem = [RETextItem itemWithTitle:@"最大价格" value:nil placeholder:@""];
    [section addItem:self.maxPriceItem];
    self.minFloorItem = [RETextItem itemWithTitle:@"最低楼层" value:nil placeholder:@""];
    [section addItem:self.minFloorItem];
    self.maxFloorItem = [RETextItem itemWithTitle:@"最高楼层" value:nil placeholder:@""];
    [section addItem:self.maxFloorItem];
    self.belongAreaItem = [RERadioItem itemWithTitle:@"所属城区" value:@"Option 4" selectionHandler:^(RERadioItem *item)
                           {
                               [item deselectRowAnimated:YES]; // same as [weakSelf.tableView deselectRowAtIndexPath:item.indexPath animated:YES];
                               NSMutableArray *options = [[NSMutableArray alloc] init];
                               // TODO
                               for (NSInteger i = 1; i < 40; i++)
                                   [options addObject:[NSString stringWithFormat:@"Option %li", (long) i]];
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
    [section addItem:self.belongAreaItem];
    self.belongSectionItem = [RERadioItem itemWithTitle:@"所属片区" value:@"11Option 4" selectionHandler:^(RERadioItem *item)
                              {
                                  [item deselectRowAnimated:YES]; // same as [weakSelf.tableView deselectRowAtIndexPath:item.indexPath animated:YES];
                                  NSMutableArray *options = [[NSMutableArray alloc] init];
                                  // TODO
                                  for (NSInteger i = 1; i < 17; i++)
                                      [options addObject:[NSString stringWithFormat:@"11Option %li", (long) i]];
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
    self.driectItem = [RERadioItem itemWithTitle:@"朝向" value:@"vvOption 4" selectionHandler:^(RERadioItem *item)
                           {
                               [item deselectRowAnimated:YES]; // same as [weakSelf.tableView deselectRowAtIndexPath:item.indexPath animated:YES];
                               NSMutableArray *options = [[NSMutableArray alloc] init];
                               // TODO
                               for (NSInteger i = 1; i < 4; i++)
                                   [options addObject:[NSString stringWithFormat:@"vvOption %li", (long) i]];
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
    self.statusItem = [RERadioItem itemWithTitle:@"状态" value:@"xxxOption 4" selectionHandler:^(RERadioItem *item)
                           {
                               [item deselectRowAnimated:YES]; // same as [weakSelf.tableView deselectRowAtIndexPath:item.indexPath animated:YES];
                               NSMutableArray *options = [[NSMutableArray alloc] init];
                               // TODO
                               for (NSInteger i = 1; i < 3; i++)
                                   [options addObject:[NSString stringWithFormat:@"xxxOption %li", (long) i]];
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
    self.fitmentItem = [RERadioItem itemWithTitle:@"装修" value:@"qOption 4" selectionHandler:^(RERadioItem *item)
                           {
                               [item deselectRowAnimated:YES]; // same as [weakSelf.tableView deselectRowAtIndexPath:item.indexPath animated:YES];
                               NSMutableArray *options = [[NSMutableArray alloc] init];
                               // TODO
                               for (NSInteger i = 1; i < 2; i++)
                                   [options addObject:[NSString stringWithFormat:@"qOption %li", (long) i]];
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
    self.consignmentItem = [RERadioItem itemWithTitle:@"委托" value:@"pOption 4" selectionHandler:^(RERadioItem *item)
                           {
                               [item deselectRowAnimated:YES]; // same as [weakSelf.tableView deselectRowAtIndexPath:item.indexPath animated:YES];
                               NSMutableArray *options = [[NSMutableArray alloc] init];
                               // TODO
                               for (NSInteger i = 1; i < 2; i++)
                                   [options addObject:[NSString stringWithFormat:@"pOption %li", (long) i]];
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
        item.title = @"TODO：开始查询!";
        [item reloadRowWithAnimation:UITableViewRowAnimationAutomatic];
    }];
    buttonItem.textAlignment = NSTextAlignmentCenter;
    [section addItem:buttonItem];
    return section;
}

@end
