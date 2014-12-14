//
//  AlertListTableViewController.m
//  MJ
//
//  Created by harry on 14/12/13.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import "AlertListTableViewController.h"
#import "UtilFun.h"
#import "alert.h"
#import "alertManager.h"
#import "AlertDetailsTableViewCell.h"
#import "UtilFun.h"

#import "BFNavigationBarDrawer.h"
#import "LoadMoreTableViewCell.h"


@interface AlertListTableViewController ()

@end

@implementation AlertListTableViewController
{
    BFNavigationBarDrawer *drawer;
    long processedCnt;
}
@synthesize objArr;
@synthesize setToReadedOrUnReaded;
@synthesize ctrForReaded;


-(void)setCtrForReaded:(BOOL)forReaded
{
    ctrForReaded = forReaded;
    self.setToReadedOrUnReaded = ctrForReaded;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.objArr = [[NSMutableArray alloc] init];
    //self.selectArr = [[NSMutableArray alloc] init];
    [self initNavigationBar];
    [self getDataList];
}

-(void)getDataList
{
    SHOWHUD(self.view);
    NSString*from = @"0";
    if ([self.objArr count] > 0)
    {
        alert*obj = [self.objArr objectAtIndex:self.objArr.count-1];
        from = obj.task_follow_no;
    }
    [alertManager getListReaded:NO From:from To:@"" Count:6 Success:^(id responseObject) {
        HIDEHUD(self.view);
        [self.objArr addObjectsFromArray:responseObject];
        //self.mainAnncArr = responseObject;
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        HIDEHUD(self.view);
    }];
    
}

-(void)initNavigationBar
{
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.navigationItem.rightBarButtonItem.title = @"编辑";
    
    
    drawer = [[BFNavigationBarDrawer alloc] init];
    
    drawer.scrollView = self.tableView;
    
    
    UIBarButtonItem *btnSelectAll = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(CancelBtnClick:)];
    NSString*title =self.setToReadedOrUnReaded?@"设为未读":@"设为已读";
    UIBarButtonItem *itemButtonEmpty = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *btnSetReaded = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(setReadedOrUnread:)];
    drawer.items = @[btnSetReaded,itemButtonEmpty,btnSelectAll];

}


-(NSArray*)markSelection
{
    NSMutableArray*selectArr = [[NSMutableArray alloc ] init];
    for (int i = 0;i<self.objArr.count;i++)
    {
        UITableViewCell*cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        if (cell)
        {
            alert*alert = [objArr objectAtIndex:i];
            alert.selectedOnUI = cell.selected;
            if (alert.selectedOnUI)
            {
                [selectArr addObject:alert];
            }
        }
    }
    return selectArr;
}
-(void)clearSelection
{
    for (alert*alert in self.objArr)
    {
        alert.selectedOnUI = NO;
    }
}

-(void)CancelBtnClick:(id)sender
{

    [self hideDrawer];

    [self clearSelection];
}

-(void)setReadedOrUnread:(id)sender
{
    NSArray*selectedArr = [self markSelection];
    long count = [selectedArr count];
    processedCnt = 0;
    if (selectedArr == nil || count <=0 )
    {
        return;
    }
    [self hideDrawer];
    
    
    SHOWHUD(self.view);
    
    [alertManager setAlertSatus:!self.ctrForReaded Alerts:selectedArr Success:^(id responseObject)
    {
        processedCnt++;
        if (processedCnt >= count)
        {
            HIDEHUD(self.view);
            
            [self.objArr removeAllObjects];
            [self getDataList];
        }
    } failure:^(NSError *error)
     {
        processedCnt++;
         if (processedCnt >= count)
         {
             HIDEHUD(self.view);
             [self.objArr removeAllObjects];
             [self getDataList];
         }
    }];
    
    

    
    
    [self clearSelection];
    
}

-(void)showDrawer
{
    [super setEditing:YES animated:YES];
    self.navigationItem.rightBarButtonItem.title = @"完成";
    self.tableView.editing = YES;
    
    [drawer showFromNavigationBar:self.navigationController.navigationBar animated:YES];
}

-(void)hideDrawer
{
    [super setEditing:NO animated:YES];
    self.navigationItem.rightBarButtonItem.title = @"编辑";
    self.tableView.editing = NO;
    [drawer hideAnimated:YES];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [self clearSelection];
    if (editing)
    {
        [self showDrawer];
    }
    else
    {
        [self hideDrawer];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self hideDrawer];
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table View



- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 135;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.isEditing)
    {
        long count = [self.objArr count];
        long row = indexPath.row;
        
        if(count ==  row)
        {
            [self getDataList];
        }
    }
}





#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (self.isEditing)
    {
        return objArr.count;
    }
    return objArr.count + 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    long row = indexPath.row;
    long count = [self.objArr count];
    
    
    if (count > row)
    {
        NSString *CellIdentifier = @"AlertDetailsTableViewCell";
        
        AlertDetailsTableViewCell *cell=(AlertDetailsTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell==nil)
        {
            NSArray *nibs=[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
            for(id oneObject in nibs)
            {
                if([oneObject isKindOfClass:[AlertDetailsTableViewCell class]])
                {
                    cell = (AlertDetailsTableViewCell *)oneObject;
                }
            }
        }
        

        [cell setAlert:[objArr objectAtIndex:row]];
        return cell;
    }
    else
    {
        NSString *CellIdentifier = @"LoadMoreTableViewCell";
        
        LoadMoreTableViewCell *cell=(LoadMoreTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell==nil)
        {
            NSArray *nibs=[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
            for(id oneObject in nibs)
            {
                if([oneObject isKindOfClass:[LoadMoreTableViewCell class]])
                {
                    cell = (LoadMoreTableViewCell *)oneObject;
                }
            }
        }
        return cell;
    }
    
    return nil;

    
    
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
    
}

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
