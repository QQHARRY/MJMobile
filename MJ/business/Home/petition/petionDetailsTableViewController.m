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

@interface petionDetailsTableViewController ()

@end

@implementation petionDetailsTableViewController
@synthesize petionDetails;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self getPetionDetails:self.petitionID];
    
    //[petitionDictionary petitionDicByDic:nil];
}


-(void)getPetionDetails:(NSString*)pttID
{

    SHOWHUD(self.view);
    
    [petitionManager getDetailsWithTaskID:self.petitionTaskID PetitionID:self.petitionID Success:^(id responseObject)
     {
         NSDictionary*dic = responseObject;
         
         
         self.petionDetails = [petitionDictionary petitionDicByDic:dic];
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

    if (petionDetails != nil)
    {
        return [petionDetails count];
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString*key = @"petionDetailsItemTableViewCell";
    petionDetailsItemTableViewCell *cell = (petionDetailsItemTableViewCell*)[tableView dequeueReusableCellWithIdentifier:key];
    if (cell == nil)
    {
        cell = [[petionDetailsItemTableViewCell alloc ] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:key];
    }
    
    if (petionDetails)
    {
        NSDictionary*dic = [petionDetails objectAtIndex:indexPath.row];
        
        NSString*key = [[dic allKeys] objectAtIndex:0];
        NSString*value = [[dic allValues ] objectAtIndex:0];
        
        cell.itemName.text = key;
        cell.itemValue.text = value;
        
        if ([key isEqualToString:@"当前节点"])
        {
            cell.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        else
        {
            cell.editingAccessoryType = UITableViewCellAccessoryNone;
        }
    }
    else
    {
        
    }
    
    
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

@end
