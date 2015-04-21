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


#import "BFNavigationBarDrawer.h"

#import "PersonDetailsViewController.h"


static NSMutableDictionary*selctions = nil;

@interface ContactListTableViewController ()
{
     BFNavigationBarDrawer *drawer;
}
@end

@implementation ContactListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    if (selctions == nil)
    {
        selctions = [[NSMutableDictionary alloc ] init];
    }
    else
    {
        [selctions  removeAllObjects];
    }
    self.contactListTreeHead = [department rootUnit];
    
    [self initNavigationBar];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewWillAppear:(BOOL)animated
{
    CGFloat height = [UIScreen mainScreen].bounds.size.height - 100;
    [self.tableView setFrame:CGRectMake(0, 100, self.tableView.frame.size.width, height)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)initNavigationBar
{
    if (self.selectMode && !self.singleSelect)
    {
        UIBarButtonItem*selectBtn = [[UIBarButtonItem alloc] initWithTitle:@"选择" style:UIBarButtonItemStylePlain target:self action:@selector(selectBtnClicked:)];
        self.navigationItem.rightBarButtonItem = selectBtn;
        
        
        drawer = [[BFNavigationBarDrawer alloc] init];
        
        drawer.scrollView = self.tableView;
        
        
        UIBarButtonItem *btnSelectAll = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(CancelBtnClick:)];
        
        UIBarButtonItem *itemButtonEmpty = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        UIBarButtonItem *btnSetReaded = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(objSelected:)];
        drawer.items = @[btnSetReaded,itemButtonEmpty,btnSelectAll];
    }

}


-(void)showDrawer
{
    return;
    self.navigationItem.rightBarButtonItem.title = @"取消";

    [drawer showFromNavigationBar:self.navigationController.navigationBar animated:YES];
}

-(void)hideDrawer
{
    return;
    self.navigationItem.rightBarButtonItem.title = @"选择";
    self.tableView.editing = NO;
    [drawer hideAnimated:YES];
}

-(void)selectBtnClicked:(id)sender
{
    if (self.selectResultDelegate)
    {
        [self.selectResultDelegate returnSelection:[selctions allValues]];
    }
    [self.navigationController popViewControllerAnimated:YES];
    return;
    
    
    NSString*title = ((UIBarButtonItem*)sender).title;
    if ([title isEqualToString:@"选择"])
    {
        ((UIBarButtonItem*)sender).title = @"取消";
        [self showDrawer];
    }
    else
    {
        ((UIBarButtonItem*)sender).title = @"选择";
        [self hideDrawer];
        
    }
}

-(void)CancelBtnClick:(id)sender
{
    [self hideDrawer];
}

-(void)objSelected:(id)sender
{
    [self hideDrawer];
    if (self.selectResultDelegate)
    {
        [self.selectResultDelegate returnSelection:[selctions allValues]];
    }
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    NSInteger num = [self.contactListTreeHead numberOfSubUnits]+1;
    return num;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSInteger row = [indexPath row];
    
    
    NSString *CellIdentifier = @"ContactsListTableViewCell";
    

    ContactsListTableViewCell *cell = nil;
    if(cell==nil)
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
    NSString*key = [NSString stringWithFormat:@"%@",unt];

    
    
    BOOL selected = ([selctions objectForKey:key]!=nil);
    
    [cell  setUnit:unt withTag:row delegate:self action:@selector(expandBtnClicked:) Selected:selected];
    
    return cell;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.selectMode)
    {
        if (self.singleSelect)
        {
            ContactsListTableViewCell*cell = (ContactsListTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
            unit*unt = cell.unitKeeped;
            if (self.singleSelectCanSelectDepart && [unt isKindOfClass:[person class]])
            {
                if (self.selectResultDelegate)
                {
                    NSMutableArray*arr = [[NSMutableArray alloc] init];
                    [arr addObject:unt];
                    
                    [self.selectResultDelegate returnSelection:arr];
                }
                [self.navigationController popViewControllerAnimated:YES];
            }
            else
            {
                if (self.selectResultDelegate)
                {
                    NSMutableArray*arr = [[NSMutableArray alloc] init];
                    [arr addObject:unt];
                    
                    [self.selectResultDelegate returnSelection:arr];
                }
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
        else
        {
            ContactsListTableViewCell*cell = (ContactsListTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
            unit*unt = cell.unitKeeped;
            NSString*key =[NSString stringWithFormat:@"%@",unt];
            
            
            if ([selctions objectForKey:key] == unt)
            {
                [selctions removeObjectForKey:key];
                [cell setBeSelected:NO];
            }
            else
            {
                NSArray*allSelectKey = [selctions allKeys];
                for (int i = 0; i < allSelectKey.count; i++)
                {
                    id tmpUnt = [selctions objectForKey:[allSelectKey objectAtIndex:i]];
                    if ([tmpUnt class] != [unt class])
                    {
                        return;
                    }
                }
                [selctions setObject:unt forKey:key];
                [cell setBeSelected:YES];
            }
        }
    }
    else
    {
        ContactsListTableViewCell*cell = (ContactsListTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
        unit*unt = cell.unitKeeped;
        
        if (unt && [unt isKindOfClass:[person class]])
        {
            self.curSelected = unt;
            [self performSegueWithIdentifier:@"showPersonDetailsFromContactsList" sender:self];
        }
        
        
    }
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    UIViewController *controller;
    if ([segue.destinationViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navController = (UINavigationController *)segue.destinationViewController;
        controller = [navController.viewControllers objectAtIndex:0];
    } else {
        controller = segue.destinationViewController;
    }
    
    
    if ([segue.identifier isEqual:@"showPersonDetailsFromContactsList"])
    {
        if ([controller isKindOfClass:[PersonDetailsViewController class]])
        {
            PersonDetailsViewController *detailController = (PersonDetailsViewController *)controller;
            
            
            detailController.psn = self.curSelected;
        }
        else
        {
            
        }
        
    }
}


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
