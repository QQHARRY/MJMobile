//
//  ContactPsnListViewController.m
//  MJ
//
//  Created by harry on 15/4/22.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//

#import "ContactPsnListViewController.h"
#import "ContactPathTableViewCell.h"
#import "ContactPsnVCCellTableViewCell.h"
#import "UtilFun.h"
#import "contactDataManager.h"
#import "person.h"
#import "PersonDetailsViewController.h"
#import "ContactPersonDetailsViewController.h"
#import "Macro.h"
#import "UIImageView+AFNetworking.h"
#import "UIImage+FX.h"
#import "UIImageView+RoundImage.h"

#define DEFAULT_PATH_IMAGE @"陕西住商不动产"
#define DEFAULT_PERSON_IAMGE @"个人icon"
#define DEFAULT_DEPT_IMAGE @"部门icon"
#define MAG_IMAGE @"放大镜icon-ios"

@interface ContactPsnListViewController ()

@end

@implementation ContactPsnListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
    [self prepareData];
}

-(void)prepareData
{
    SHOWHUD_WINDOW;
    [contactDataManager WaitForDataB4ExpandUnit:self.superUnt Success:^(id responseObject) {
        HIDEHUD_WINDOW
        
        self.listContent = [[NSMutableArray alloc] initWithArray:[self.superUnt subPerson]];
        
        
        
        
        // Sort data
        UILocalizedIndexedCollation *theCollation = [UILocalizedIndexedCollation currentCollation];
        for (person*unt in self.listContent)
        {
            NSInteger sect = [theCollation sectionForObject:unt collationStringSelector:@selector(name_full)];
            unt.sectionNum = sect;
        }
        
        NSInteger highSection = [[theCollation sectionTitles] count];
        NSMutableArray *sectionArrays = [NSMutableArray arrayWithCapacity:highSection];
        for (int i=0; i<=highSection; i++)
        {
            NSMutableArray *sectionArray = [NSMutableArray arrayWithCapacity:1];
            [sectionArrays addObject:sectionArray];
        }
        
        for (unit*unt in self.listContent)
        {
            [(NSMutableArray *)[sectionArrays objectAtIndex:unt.sectionNum] addObject:unt];
        }
        
        [self.listContent removeAllObjects];
        for (NSMutableArray *sectionArray in sectionArrays)
        {
            NSArray *sortedSection = [theCollation sortedArrayFromArray:sectionArray collationStringSelector:@selector(name_full)];
            [self.listContent addObject:sortedSection];
        }
        
        
        
    } failure:^(NSError *error) {
        HIDEHUD_WINDOW
    }];
}

-(void)initUI
{
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    
    UIImageView*imagV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:MAG_IMAGE]];
    self.searchTextField.leftViewMode = UITextFieldViewModeUnlessEditing;
    self.searchTextField.leftView = imagV;
    
    self.searchTextField.layer.cornerRadius = 10.0f;
    self.searchTextField.layer.borderColor = [UIColor colorWithRed:0xa7/225.0 green:0xab/225.0 blue:0xc6/225.0 alpha:1].CGColor;
    self.searchTextField.layer.borderWidth= 1.0f;
    
    
    self.tableview.sectionIndexColor = [UIColor blackColor];
    //self.tableview.sectionIndexMinimumDisplayRowCount = 3;
    self.tableview.sectionIndexBackgroundColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark UITableViewDataSource & UITableViewDelegate

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return nil;
    } else {
        NSArray*arr = [NSArray arrayWithObject:UITableViewIndexSearch];
        return [arr arrayByAddingObjectsFromArray:
                [[UILocalizedIndexedCollation currentCollation] sectionIndexTitles]];
    }
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return 0;
    } else {
        if (title == UITableViewIndexSearch) {
            [tableView scrollRectToVisible:self.searchDisplayController.searchBar.frame animated:NO];
            return -1;
        } else {
            return [[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:index-1];
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return 1;
    } else {
        return [_listContent count];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return nil;
    } else {
        return [[_listContent objectAtIndex:section] count] ? [[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:section] : nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView)
        return 0;
    return [[_listContent objectAtIndex:section] count] ? tableView.sectionHeaderHeight : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [_listContent count];
    } else {
        return [[_listContent objectAtIndex:section] count];
    }
}




-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"ContactPsnVCCellTableViewCell";
    ContactPsnVCCellTableViewCell *cell = nil;
    if(cell==nil)
    {
        NSArray *nibs=[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        for(id oneObject in nibs)
        {
            if([oneObject isKindOfClass:[ContactPsnVCCellTableViewCell class]])
            {
                cell = (ContactPsnVCCellTableViewCell *)oneObject;
            }
        }
    };
    
    person*psn = [[self.listContent objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.name.text = psn.name_full;
    

    
    if (psn.photo == nil || [psn.photo isEqualToString:@""])
    {
        cell.psnImage.image = [UIImage imageNamed:DEFAULT_PERSON_IAMGE];
    }
    else
    {
        NSString*strUrl = [SERVER_ADD stringByAppendingString:psn.photo];
        NSString*imgName =  [strUrl pathExtension];
        if (imgName != nil && imgName.length > 0)
        {
            __typeof (ContactPsnVCCellTableViewCell*) __weak weakCell = cell;
            [cell.psnImage setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:strUrl]] placeholderImage:[UIImage imageNamed:DEFAULT_PERSON_IAMGE] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image)
             {
                 [weakCell.psnImage setImageToRound:image];
                 
             } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                 
             }];
        }
        else
        {
            cell.psnImage.image = [UIImage imageNamed:DEFAULT_PERSON_IAMGE];
        }
        
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    person*psn = [[self.listContent objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    self.selectedUnt = psn;
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
#ifdef OLDDESIGN
    UIStoryboard* curStory = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    PersonDetailsViewController*vc =[curStory instantiateViewControllerWithIdentifier:@"PersonDetailsViewController"];
    if ([vc  isKindOfClass:[PersonDetailsViewController class]])
    {
        vc.psn = psn;
        [self.navigationController pushViewController:vc animated:YES];
    }
#else
    
    [self performSegueWithIdentifier:@"toShowPersonDetails" sender:self];
#endif
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
    
    
    if ([segue.identifier isEqual:@"toShowPersonDetails"])
    {
        if ([controller isKindOfClass:[ContactPersonDetailsViewController class]])
        {
            ContactPersonDetailsViewController *vc = (ContactPersonDetailsViewController *)controller;
            if ([self.selectedUnt isKindOfClass:[person class]])
            {
                vc.psn = (person*)self.selectedUnt;
            }
        }
        else
        {
            
        }
        
    }
}


- (IBAction)onSearch:(id)sender {
}
@end
