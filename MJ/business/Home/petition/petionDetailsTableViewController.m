//
//  petionDetailsTableViewController.m
//  MJ
//
//  Created by harry on 14/12/17.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import "petionDetailsTableViewController.h"
#import "petionDetailsItemTableViewCell.h"
#import "UtilFun.h"
#import "petitionManager.h"
#import "petitionDictionary.h"
#import "Macro.h"
#import "petitionFollowChartViewController.h"
#import "petitionAgreementViewController.h"
#import "UtilFun.h"

@interface petionDetailsTableViewController ()

@end

@implementation petionDetailsTableViewController
@synthesize petDetail;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    petDetail = [[petitionDetail alloc]init];
    [self getPetionDetails:self.petitionID];
    
    if (self.task_state)
    {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc ] initWithTitle:@"审批" style:UIBarButtonItemStylePlain target:self action:@selector(agreenBtnClicked:)  ];
    }
    else
    {
         self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc ] initWithTitle:@"签收" style:UIBarButtonItemStylePlain target:self action:@selector(assignBtnClicked:)  ];
    }
    
    //[petitionDictionary petitionDicByDic:nil];
}



-(void)assignBtnClicked:(id)sender
{
    SHOWHUD_WINDOW;
    [petitionManager approveID:self.petitionID TaskID:self.petitionTaskID ActionType:3 Reason:@"" AssistDepts:[[NSArray alloc]init] Success:^(id responseObject)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:MAINPAGE_INDICATOR_NUMBER_CHANGED object:nil];
        HIDEHUD_WINDOW;
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc ] initWithTitle:@"审批" style:UIBarButtonItemStylePlain target:self action:@selector(agreenBtnClicked:)  ];
        
        
        PRESENTALERT(@"签收成功", nil, @"OK", ^()
                     {

                     }, self);
        
    } failure:^(NSError *error) {
        HIDEHUD_WINDOW;
        PRESENTALERT(@"签收失败", nil, @"OK", ^()
                     {
                         
                     }, self);
    }];
}


-(void)agreenBtnClicked:(id)sender
{
    [self performSegueWithIdentifier:@"toAgreementPage" sender:self];
}


-(void)getPetionDetails:(NSString*)pttID
{

    SHOWHUD(self.view);
    
    [petitionManager getDetailsWithTaskID:self.petitionTaskID PetitionID:self.petitionID Success:^(id responseObject)
     {
         NSDictionary*dic = responseObject;
         NSArray*arr = [dic objectForKey:@"PetitionDetails"];
         NSDictionary*dicDetails  =[arr objectAtIndex:0];
         
         NSArray*hisArr = [dic objectForKey:@"PetitionHistories"];
         
         self.petDetail.allDetails = dicDetails;
         NSArray*tmpArr = [petitionDictionary petitionArrByDic:dicDetails];
         NSMutableArray*mutArr = [[NSMutableArray alloc] init];
         for (NSDictionary*dic in tmpArr)
         {
             NSString*key = [[dic allKeys] objectAtIndex:0];
             if (![key isEqualToString:@"节点"] && ![key isEqualToString:@"办理状态"])
             {
                 [mutArr addObject:dic];
             }
         }
         
         self.petDetail.details = mutArr;
         
         self.petDetail.historyNodes = hisArr;
         
         
         
         
         
         
         
         HIDEHUD(self.view);
         [self.tableView reloadData];
    } failure:^(NSError *error) {
        HIDEHUD(self.view);
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if (petDetail.details != nil)
    {
        return [petDetail.details count]+1;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSDictionary*dic = [petDetail.details objectAtIndex:indexPath.row];
//    NSString*key = [[dic allKeys] objectAtIndex:0];
//    if ([key isEqualToString:@"说明"])
//    {
//        return 88;
//    }
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString*key = @"petionDetailsItemTableViewCell";
    petionDetailsItemTableViewCell *cell = (petionDetailsItemTableViewCell*)[tableView dequeueReusableCellWithIdentifier:key];
    if (cell == nil)
    {
        cell = [[petionDetailsItemTableViewCell alloc ] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:key];
    }
    
    if (petDetail.details)
    {
        if (indexPath.row == 0)
        {
            cell.itemName.text = @"流程类型";
            cell.itemTextViewValue.text = self.petitionTypeString;
        }
        else
        {
            NSDictionary*dic = [petDetail.details objectAtIndex:indexPath.row-1];
            
            NSString*key = [[dic allKeys] objectAtIndex:0];
            NSString*value = [[dic allValues ] objectAtIndex:0];
            if([key isEqualToString:@"版本"])
            {
                NSString* tmp = @"V";
                value = [tmp stringByAppendingString:value];
            }
            
            cell.itemName.text = key;
            cell.itemValue.text = value;
            cell.itemTextViewValue.text = value;
            
            if ([key isEqualToString:@"状态图"])
            {
                cell.AccessoryType = UITableViewCellAccessoryDetailButton;
                cell.itemValue.text = @"";
                cell.itemTextViewValue.text = @"";
                petDetail.chartUrl = [NSString stringWithFormat:@"%@/%@", SERVER_URL_NOAPI, value];
            }
            else
            {
                cell.AccessoryType = UITableViewCellAccessoryNone;
            }
            
            if ([key isEqualToString:@"说明"])
            {
                //[cell initWithValue:value];
                
            }
        }
       
    }
    else
    {
        
    }
    
    
    return cell;
}


-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    petionDetailsItemTableViewCell *cell = ( petionDetailsItemTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (cell && [cell.itemName.text isEqualToString:@"状态图"])
    {
        [self performSegueWithIdentifier:@"showFollowChart" sender:self];
        
    }
   
}




#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    
    UIViewController *controller;
    if ([segue.destinationViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navController = (UINavigationController *)segue.destinationViewController;
        controller = [navController.viewControllers objectAtIndex:0];
    } else {
        controller = segue.destinationViewController;
    }
    
    
    if ([segue.identifier isEqual:@"showFollowChart"])
    {
        if ([controller isKindOfClass:[petitionFollowChartViewController class]])
        {
            petitionFollowChartViewController *fController = (petitionFollowChartViewController *)controller;
            
            fController.url = self.petDetail.chartUrl;
            
        }
        else
        {
            
        }
        
    }
    else if ([segue.identifier isEqual:@"toAgreementPage"])
    {
        if ([controller isKindOfClass:[petitionAgreementViewController class]])
        {
            petitionAgreementViewController *agreeController = (petitionAgreementViewController *)controller;
            
            agreeController.petition = self.petDetail;
            agreeController.petitionTaskID = self.petitionTaskID;
        }
        else
        {
            
        }
        
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
