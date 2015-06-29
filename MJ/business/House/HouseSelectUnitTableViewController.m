//
//  HouseSelectUnitTableViewController.m
//  MJ
//
//  Created by harry on 15/6/29.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//

#import "HouseSelectUnitTableViewController.h"
#import "UtilFun.h"
#import "HouseDataPuller.h"
#import "HouseUnitCell.h"

@interface HouseSelectUnitTableViewController()

@property(nonatomic,strong)NSMutableArray*houseUnitsArr;

@end


@implementation HouseSelectUnitTableViewController



+(id)ctrlWithDelegate:(id)dele BuildingNo:(NSString*)bldingNo AndCompleteHandler:(void (^)(houseUnit*houseUnt))hdl
{
    HouseSelectUnitTableViewController* ctrlStatic = [self sharedInstance];
    if (![ctrlStatic.buildingNO isEqualToString:bldingNo])
    {
        ctrlStatic.buildingNO = bldingNo;
        ctrlStatic.houseUnitsArr = nil;
    }
    
    ctrlStatic.weakDelegate = dele;
    ctrlStatic.handler = hdl;

    return ctrlStatic;
}

+(id)sharedInstance
{
    static dispatch_once_t pred;
    static id singleton = nil;
    
    dispatch_once(&pred, ^{
        singleton = [[HouseSelectUnitTableViewController alloc] initWithStyle:UITableViewStylePlain];
    });
    
    return singleton;
}


- (void)viewDidLoad {
    [super viewDidLoad];


    
    
}


-(void)viewDidAppear:(BOOL)animated
{
    [self refreshData];
}




-(void)refreshData
{
    if (self.houseUnitsArr)
    {
        return;
    }
    SHOWHUD_WINDOW;
    
    NSDictionary*filterDic = filterDic = [[NSMutableDictionary alloc] init];
    [HouseDataPuller pullHouseUnitDetailsByBuilding:self.buildingNO Success:^(NSArray *houseUntArr) {

        if (houseUntArr && [houseUntArr count] > 0)
        {
            self.houseUnitsArr = [[NSMutableArray alloc] initWithArray:houseUntArr];
        }
        [self.tableView reloadData];
        HIDEHUD_WINDOW;
    } failure:^(NSError *error) {
        PRESENTALERT(@"加载栋座单元详细信息失败,请重重试",nil, nil, nil);
        HIDEHUD_WINDOW;
    }
     ];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_houseUnitsArr)
    {
        return _houseUnitsArr.count;
    }
    
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"houseUnitCell";
    HouseUnitCell *cell = (HouseUnitCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        for(id oneObject in nibs)
        {
            if([oneObject isKindOfClass:[HouseUnitCell class]])
            {
                cell = (HouseUnitCell *)oneObject;
            }
        }
    }
    // Configure the cell...
    houseUnit*houseUnit = [self.houseUnitsArr objectAtIndex:indexPath.row];
    
    if (houseUnit && cell)
    {
        cell.unitName.text = houseUnit.unit_name;
        cell.floorCount.text = houseUnit.floor_count;
        cell.elevatorCount.text = houseUnit.elevator_count;
        cell.houseCount.text = houseUnit.house_count;
    }
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    houseUnit*houseUnt = [self.houseUnitsArr objectAtIndex:indexPath.row];
    if (houseUnt  && self.handler)
    {
        self.handler(houseUnt);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
@end
