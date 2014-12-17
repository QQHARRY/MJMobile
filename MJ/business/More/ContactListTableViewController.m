//
//  ContactListTableViewController.m
//  MJ
//
//  Created by harry on 14/12/14.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import "ContactListTableViewController.h"
#import "unit.h"
#import "person.h"
#import "department.h"

#import "contactDataManager.h"
#import "UtilFun.h"
#import "ContactsListTableViewCell.h"

@interface ContactListTableViewController ()

@end

@implementation ContactListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.contactListTreeHead = [department rootUnit];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    NSInteger num = [self.contactListTreeHead numberOfSubUnits]+1;
    return num;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger num = [self.contactListTreeHead numberOfSubUnits]+1;
   
    NSInteger row = [indexPath row];
    
    if(num == 12 && row == 9)
    {
        NSLog(@"sdfdsfs");
    }
    
    NSString *CellIdentifier = @"ContactsListTableViewCell";
    
    //ContactsListTableViewCell *cell=(ContactsListTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    ContactsListTableViewCell *cell= nil;
    //if(cell==nil)
    {
        NSArray *nibs=[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        for(id oneObject in nibs)
        {
            if([oneObject isKindOfClass:[ContactsListTableViewCell class]])
            {
                cell = (ContactsListTableViewCell *)oneObject;
            }
        }
    }
    

    
    unit* unt = [_contactListTreeHead findSubUnitByIndex:&row];
    [cell  setUnit:unt withTag:row delegate:self action:@selector(expandBtnClicked:)];
    
    return cell;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)expandBtnClicked:(id)sender
{
    
    NSInteger tag = ((UIButton*)sender).tag;
    unit* unt = [_contactListTreeHead findSubUnitByIndex:&tag];
    if (unt.closed)
    {
        unt.closed = !unt.closed;
        [UtilFun showHUD:self.view];
        [contactDataManager WaitForDataB4ExpandUnit:unt Success:^(id responseObject)
        {
            [UtilFun hideHUD:self.view];
            [self.tableView reloadData];
        }
                                            failure:^(NSError *error)
        {
            [UtilFun hideHUD:self.view];
            [self.tableView reloadData];
        }];
    }
    else
    {
        unt.closed = !unt.closed;
        [self.tableView reloadData];
    }
    
    
    
    
    
    
}
@end
