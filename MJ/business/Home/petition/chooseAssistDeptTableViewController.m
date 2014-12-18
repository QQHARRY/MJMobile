//
//  chooseAssistDeptTableViewController.m
//  MJ
//
//  Created by harry on 14/12/18.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import "chooseAssistDeptTableViewController.h"

@interface chooseAssistDeptTableViewController ()

@end

@implementation chooseAssistDeptTableViewController
@synthesize deptArr;
@synthesize initialSelectArr;
@synthesize selectArr;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    selectArr = [[NSMutableArray alloc ] init];
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.navigationItem.rightBarButtonItem.title = @"选择";

    [self initData];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    if (editing)
    {
        [selectArr removeAllObjects];
        [super setEditing:editing animated:animated];
        self.navigationItem.rightBarButtonItem.title = @"确定";
        self.tableView.editing = editing;
    }
    else
    {
        if ([selectArr count] == 0)
        {
            [super setEditing:editing animated:animated];
            self.navigationItem.rightBarButtonItem.title = @"选择";
            self.tableView.editing = editing;
        }
        else
        {
            [self.navigationController popViewControllerAnimated:YES];
            if (self.delegate)
            {
                [self.delegate returnSelection:selectArr];
            }
        }
    }
    
}

-(void)initData
{
//    task_performer_no	人资部	DEPT_NO000041	100
//    task_performer_no	财务部	DEPT_NO000066	101
//    task_performer_no	培训部	DEPT_NO000040	102
//    task_performer_no	行政部	DEPT_NO000031	104
//    task_performer_no	网络部	DEPT_NO000039	105
//    task_performer_no	物流部	DEPT_NO0000000119	106
//    task_performer_no	权证部	DEPT_NO000068	107
//    task_performer_no	企划部	DEPT_NO000064	108
//    task_performer_no	签约部	DEPT_NO000067	109
//    task_performer_no	客服部	DEPT_NO000069	110
    deptArr = @[
                @{@"人资部":@"DEPT_NO000041"},
                @{@"财务部":@"DEPT_NO000066"},
                @{@"培训部":@"DEPT_NO000040"},
                @{@"行政部":@"DEPT_NO000031"},
                @{@"网络部":@"DEPT_NO000039"},
                @{@"物流部":@"DEPT_NO0000000119"},
                @{@"权证部":@"DEPT_NO000068"},
                @{@"企划部":@"DEPT_NO000064"},
                @{@"签约部":@"DEPT_NO000067"},
                @{@"客服部":@"DEPT_NO000069"},
                ];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return deptArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"chooseAssistDeptCell" forIndexPath:indexPath];
    
    // Configure the cell...
    NSDictionary*dic = [deptArr objectAtIndex:indexPath.row];
    NSString*name = [[dic allKeys] objectAtIndex:0];
    
    [cell.textLabel setFont:[UIFont systemFontOfSize:14]];
    cell.textLabel.text = name;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [selectArr addObject:[deptArr objectAtIndex:indexPath.row]];
}


-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [selectArr removeObject:[deptArr objectAtIndex:indexPath.row]];
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
