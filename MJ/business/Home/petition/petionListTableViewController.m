//
//  petionListTableViewController.m
//  MJ
//
//  Created by harry on 14/12/17.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import "petionListTableViewController.h"
#import "petitionManager.h"
#import "UtilFun.h"
#import "petiotionBrief.h"
#import "PetitionTableViewCell.h"
#import "LoadMoreTableViewCell.h"
#import "petionDetailsTableViewController.h"
#import "MJRefresh.h"

@interface petionListTableViewController ()

@end

@implementation petionListTableViewController

@synthesize petitionArr;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    petitionArr = [[NSMutableArray alloc ] init];
    
    __weak typeof(self) weakSelf = self;
    [self.tableView addHeaderWithCallback:^{
        [weakSelf refreshData];
    }];
    
    [self.tableView addFooterWithCallback:^{
        [weakSelf getData:YES];
    }];
}

-(void)endRefreshing:(BOOL)isFoot
{
    if (isFoot)
    {
        [self.tableView footerEndRefreshing];
    }
    else
    {
        [self.tableView headerEndRefreshing];
    }
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [self refreshData];
}

-(void)refreshData
{
    if (self.petitionArr)
    {
        [self.petitionArr removeAllObjects];
        [self getData:NO];
    }
}

-(void)getData:(BOOL)isFoot
{
    SHOWHUD(self.view);
    NSString*from = @"0";
    if ([self.petitionArr count] > 0)
    {
        petiotionBrief*pet = [self.petitionArr objectAtIndex:self.petitionArr.count-1];
        from = pet.id;
    }
    [petitionManager getListFrom:from To:@"" Count:6 Success:^(id responseObject) {
        HIDEHUD(self.view);
        [self.petitionArr addObjectsFromArray:responseObject];
        [self.tableView reloadData];
        [self endRefreshing:isFoot];
        
    } failure:^(NSError *error) {
        [self endRefreshing:isFoot];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    return [self.petitionArr count];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    long count = [self.petitionArr count];
    long row = indexPath.row;
    
    if (indexPath.section == 0)
    {
        if (count > row)
        {
            [self performSegueWithIdentifier:@"list2ViewPetitionDetails" sender:self];
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    long row = indexPath.row;
    long count = [self.petitionArr count];
    
    
    if (count > row)
    {
        NSString *CellIdentifier = @"PetitionTableViewCell";
        
        PetitionTableViewCell *cell=(PetitionTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell==nil)
        {
            NSArray *nibs=[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
            for(id oneObject in nibs)
            {
                if([oneObject isKindOfClass:[PetitionTableViewCell class]])
                {
                    cell = (PetitionTableViewCell *)oneObject;
                }
            }
        }
        if (self.petitionArr)
        {
            petiotionBrief*ptionBr = [self.petitionArr objectAtIndex:indexPath.row];
            if (ptionBr)
            {
                [cell initWithType:ptionBr.flowtype reason:ptionBr.reason person:ptionBr.username];
                
            }
            
        }
        
        return cell;
    }
//    else
//    {
//        NSString *CellIdentifier = @"LoadMoreTableViewCell";
//        
//        LoadMoreTableViewCell *cell=(LoadMoreTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//        if(cell==nil)
//        {
//            NSArray *nibs=[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
//            for(id oneObject in nibs)
//            {
//                if([oneObject isKindOfClass:[LoadMoreTableViewCell class]])
//                {
//                    cell = (LoadMoreTableViewCell *)oneObject;
//                }
//            }
//        }
//        return cell;
//    }
    
    return nil;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    NSLog(@"dfsdfds");
    UIViewController *controller;
    if ([segue.destinationViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navController = (UINavigationController *)segue.destinationViewController;
        controller = [navController.viewControllers objectAtIndex:0];
    } else {
        controller = segue.destinationViewController;
    }
    
    
    if ([segue.identifier isEqual:@"list2ViewPetitionDetails"])
    {
        if ([controller isKindOfClass:[petionDetailsTableViewController class]])
        {
            
            petionDetailsTableViewController*contactLst = (petionDetailsTableViewController*)controller;
            NSIndexPath *selectIndexPath = [self.tableView indexPathForSelectedRow];
            
            petiotionBrief*pt = [self.petitionArr objectAtIndex:selectIndexPath.row];
            contactLst.petitionID = ((petiotionBrief*)[self.petitionArr objectAtIndex:selectIndexPath.row]).id;
            contactLst.petitionTaskID = ((petiotionBrief*)[self.petitionArr objectAtIndex:selectIndexPath.row]).taskid;
            contactLst.petitionTypeString = ((petiotionBrief*)[self.petitionArr objectAtIndex:selectIndexPath.row]).flowtype;
            contactLst.task_state = [((petiotionBrief*)[self.petitionArr objectAtIndex:selectIndexPath.row]).task_state intValue] != 0;
        }
        else
        {
            
        }
    }
}


@end
