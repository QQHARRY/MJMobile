//
//  MessageTableViewController.m
//  MJ
//
//  Created by harry on 14/12/25.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import "MessageTableViewController.h"
#import "UtilFun.h"
#import "messageManager.h"
#import "messageObj.h"
#import "MessageBriefTableViewCell.h"
#import "MessageDetailsViewController.h"
#import "MJRefresh.h"

@interface MessageTableViewController ()

@end

@implementation MessageTableViewController
@synthesize msgArr;
@synthesize msgType;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
    {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    
    msgArr = [[NSMutableArray alloc ] init];
    [self.tableView addHeaderWithTarget:self action:@selector(refreshData)];
    [self.tableView addFooterWithTarget:self action:@selector(loadMore)];
    //[self getData:YES];
}


-(void)refreshData
{
    [self clearData];
    [self getData:NO];
}

-(void)loadMore
{
    [self getData:YES];
}

-(void)viewDidAppear:(BOOL)animated
{
    [self refreshData];
}
-(void)clearData
{
    [self.msgArr removeAllObjects];
}

-(void)getData:(BOOL)isFoot
{
    SHOWHUD(self.view);
    NSString*from = @"0";
    if ([self.msgArr count] > 0)
    {
        messageObj*obj = [self.msgArr objectAtIndex:self.msgArr.count-1];
        from = obj.msg_cno;
    }
    
    [messageManager getMsgByType:self.msgType ListFrom:from To:@"" Count:4 Success:^(id responseObject) {
        HIDEHUD(self.view);
        [self.msgArr addObjectsFromArray:responseObject];
        
        [self.tableView reloadData];
        [self endRefreshing:isFoot];
        
    } failure:^(NSError *error) {
        HIDEHUD(self.view);
        [self.tableView reloadData];
        [self endRefreshing:isFoot];
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return msgArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    messageObj*obj = [msgArr objectAtIndex:indexPath.row];
    MessageDetailsViewController*detailsView = [[MessageDetailsViewController alloc ] initWithNibName:@"MessageDetailsViewController" bundle:[NSBundle mainBundle]];
    
    detailsView.msg = obj;
    [self pushControllerToController:detailsView];
}

-(void)pushControllerToController:(UIViewController*)vc
{
    if ([self.navigationController respondsToSelector:@selector(pushViewController:animated:)])
    {
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    if ([((UIViewController*)(self.container)).navigationController respondsToSelector:@selector(pushViewController:animated:)])
    {
        [((UIViewController*)(self.container)).navigationController pushViewController:vc animated:YES];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    MessageBriefTableViewCell *cell = (MessageBriefTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"messageBriefTableViewCell" forIndexPath:indexPath];
    
    
    static NSString *CellIdentifier = @"messageBriefTableViewCell";
    
    MessageBriefTableViewCell *cell=(MessageBriefTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell==nil)
    {
        NSArray *nibs=[[NSBundle mainBundle] loadNibNamed:@"MessageBriefTableViewCell" owner:self options:nil];
        for(id oneObject in nibs)
        {
            if([oneObject isKindOfClass:[MessageBriefTableViewCell class]])
            {
                cell = (MessageBriefTableViewCell *)oneObject;
            }
        }
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    NSLog(@"row=%d",indexPath.row);
    
    if (indexPath.row >= msgArr.count)
    {
        return cell;
    }
    
    messageObj*obj = [msgArr objectAtIndex:indexPath.row];
    if (obj)
    {
        cell.receiver.text = obj.msg_opt_user_list_name;
        cell.msgSender.text = obj.view_user_list_name;
        cell.briefContent.text = obj.msg_title;
        cell.sendTime.text = obj.msg_save_date;
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
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
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
