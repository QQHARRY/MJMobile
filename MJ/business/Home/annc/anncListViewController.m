//
//  anncListViewController.m
//  MJ
//
//  Created by harry on 14/12/13.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import "AnncListViewController.h"
#import "PublicAnncTableViewCell.h"
#import "announcement.h"
#import "UtilFun.h"
#import "annoucementManager.h"
#import "AnncDetailsViewController.h"
#import "LoadMoreTableViewCell.h"

@interface AnncListViewController ()

@end

@implementation AnncListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.mainAnncArr = [[NSMutableArray alloc] init];
    
    [self getAnncData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)getAnncData
{
    SHOWHUD(self.view);
    NSString*from = @"0";
    if ([self.mainAnncArr count] > 0)
    {
        announcement*annc = [self.mainAnncArr objectAtIndex:self.mainAnncArr.count-1];
        from = annc.notice_no;
    }
    [annoucementManager getListFrom:from To:@"" Count:6 Success:^(id responseObject) {
        HIDEHUD(self.view);
        [self.mainAnncArr addObjectsFromArray:responseObject];
        //self.mainAnncArr = responseObject;
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        HIDEHUD(self.view);
    }];
    
}


#pragma mark tableview about
#pragma mark  -

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    long count = [self.mainAnncArr count];
    long row = indexPath.row;
    
    if (indexPath.section == 0)
    {
        if (count > row)
        {
            [self performSegueWithIdentifier:@"list2ViewAnncDetails" sender:self];
        }
        else if(count ==  row)
        {
            [self getAnncData];
        }
    }
    
}





- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
 
    return [self.mainAnncArr count]+1;


}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    long row = indexPath.row;
    long count = [self.mainAnncArr count];
    
    
    if (count > row)
    {
        NSString *CellIdentifier = @"PublicAnncTableViewCell";
        
        PublicAnncTableViewCell *cell=(PublicAnncTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell==nil)
        {
            NSArray *nibs=[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
            for(id oneObject in nibs)
            {
                if([oneObject isKindOfClass:[PublicAnncTableViewCell class]])
                {
                    cell = (PublicAnncTableViewCell *)oneObject;
                }
            }
        }
        
        announcement*annc = [self.mainAnncArr objectAtIndex:row];
        NSString*title =nil;
        BOOL isNew = FALSE;
        if (annc)
        {
            title = annc.notice_title;
            isNew = annc.isNew;
        }
        
        [cell initWithTitle:title isNew:isNew];
        
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
    
    
    if ([segue.identifier isEqual:@"list2ViewAnncDetails"])
    {
        if ([controller isKindOfClass:[AnncDetailsViewController class]])
        {
            AnncDetailsViewController *detailController = (AnncDetailsViewController *)controller;
            NSIndexPath *selectIndexPath = [self.tableView indexPathForSelectedRow];
            
            detailController.annc = [self.mainAnncArr objectAtIndex:selectIndexPath.row];
            
            
        }
        else
        {
            
        }
        
    }
}


@end
