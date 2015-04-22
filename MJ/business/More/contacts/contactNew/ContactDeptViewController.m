//
//  ContactDeptViewController.m
//  MJ
//
//  Created by harry on 15/4/20.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//

#import "ContactDeptViewController.h"
#import "ContactsListTableViewCell.h"
#import "contactDataManager.h"
#import "UtilFun.h"
#import "person.h"
#import "department.h"
#import "ContactDeptVCCell.h"
#import "ContactPathTableViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "UIImage+FX.h"
#import "Macro.h"
#import "PersonDetailsViewController.h"

#define DEFAULT_PATH_IMAGE @"陕西住商不动产"
#define DEFAULT_PERSON_IAMGE @"个人icon"
#define DEFAULT_DEPT_IMAGE @"部门icon"
#define MAG_IMAGE @"放大镜icon-ios"


@interface ContactDeptViewController ()

@end

@implementation ContactDeptViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    [self initUI];
    [self loadData];
}

-(void)loadData
{
    SHOWHUD_WINDOW
    [contactDataManager WaitForDataB4ExpandUnit:self.superUnit Success:^(id responseObject)
     {
         
         HIDEHUD_WINDOW
         [self.tableview reloadData];
         
     }
                                        failure:^(NSError *error)
     {
         HIDEHUD_WINDOW
         [self.tableview reloadData];
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = 0;
    if ([self.superUnit isEqual:[department rootUnit]])
    {
        if ([self.superUnit subDept] != nil && [[self.superUnit subDept] count] > 0 &&[[[self.superUnit subDept] objectAtIndex:0] subDept] != nil)
        {
            count = [[[[self.superUnit subDept] objectAtIndex:0] subDept] count];
        }
        
    }
    else
    {
        count = [[self.superUnit subDept] count] + [[self.superUnit subPerson] count];
    }
    return count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([self.superUnit isKindOfClass:[department class]] && ![(department*)(self.superUnit) isCompany] && ![self.superUnit isEqual:[department rootUnit]])
    {
        return 44;
    }
    else
    {
        return 0;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if ([self.superUnit isKindOfClass:[department class]] && ![(department*)(self.superUnit) isCompany])
    {
        NSString *CellIdentifier = @"ContactPathTableViewCell";
        ContactPathTableViewCell *cell = nil;
        if(cell==nil)
        {
            NSArray *nibs=[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
            for(id oneObject in nibs)
            {
                if([oneObject isKindOfClass:[ContactPathTableViewCell class]])
                {
                    cell = (ContactPathTableViewCell *)oneObject;
                }
            }
        }
        
        NSString*path = @"";
        
        department*superUnit = (department*)self.superUnit;
        while (superUnit != nil && [superUnit isKindOfClass:[department class]] && ![superUnit isCompany])
        {
            if ([path isEqualToString:@""])
            {
                path = [NSString stringWithFormat:@"%@",superUnit.dept_name];
            }
            else
            {
                path = [NSString stringWithFormat:@"%@>%@",superUnit.dept_name,path];
            }
            
            unit* tmp = [superUnit superUnit];
            if ([tmp isKindOfClass:[department class]])
            {
                superUnit = (department*)tmp;
            }
            else
            {
                superUnit = nil;
            }
        }
        cell.image.image = [UIImage imageNamed:DEFAULT_PATH_IMAGE];
        cell.name.text = path;
        
        return cell;
    }
    else
    {
        return nil;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    
    NSString *CellIdentifier = @"ContactDeptVCCell";
    ContactDeptVCCell *cell = nil;
    if(cell==nil)
    {
        NSArray *nibs=[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        for(id oneObject in nibs)
        {
            if([oneObject isKindOfClass:[ContactDeptVCCell class]])
            {
                cell = (ContactDeptVCCell *)oneObject;
            }
        }
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    unit* unt = nil;
    
    if ([self.superUnit isEqual:[department rootUnit]])
    {
        if ([self.superUnit subDept] != nil && [[self.superUnit subDept] count] > 0 &&[[[self.superUnit subDept] objectAtIndex:0] subDept] != nil)
        {
            unt = [[[[self.superUnit subDept] objectAtIndex:0] subDept] objectAtIndex:row];
        }
        
    }
    else
    {
        if (row < [[self.superUnit subDept] count])
        {
            unt = [[self.superUnit subDept] objectAtIndex:row];
        }
        else
        {
            unt = [[self.superUnit subPerson] objectAtIndex:(row-[[self.superUnit subDept] count])];
        }
    }
    
    if (unt != nil)
    {
       
        if ([unt isKindOfClass:[department class]])
        {
            cell.image.image = [self getImage:(department *)unt];
            cell.name.text = ((department*)unt).dept_name;
            
        }
        else
        {
            if ([unt isKindOfClass:[person class]])
            {
                person*psn = (person*)unt;
                cell.name.text = psn.name_full;
                
                if (psn.photo == nil || [psn.photo isEqualToString:@""])
                {
                    cell.image.image = [UIImage imageNamed:DEFAULT_PERSON_IAMGE];
                }
                else
                {
                    NSString*strUrl = [SERVER_ADD stringByAppendingString:psn.photo];
                    NSString*imgName =  [strUrl pathExtension];
                    if (imgName != nil && imgName.length > 0)
                    {
                        __typeof (ContactDeptVCCell*) __weak weakCell = cell;
                        [cell.image setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:strUrl]] placeholderImage:[UIImage imageNamed:DEFAULT_PERSON_IAMGE] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image)
                         {
                             CGFloat size = image.size.height > image.size.width?image.size.width:image.size.height;
                             UIImage*scaledImag = [image imageScaledToSize:CGSizeMake(size, size)];
                             UIImage*roundImage = [scaledImag imageWithCornerRadius:scaledImag.size.width];
                             weakCell.image.image = roundImage;
                            
                        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                            
                        }];
                    }
                    else
                    {
                        cell.image.image = [UIImage imageNamed:DEFAULT_PERSON_IAMGE];
                    }
                    
                }
            }
        }
    }
    
    return cell;
}

-(UIImage*)getImage:(department*)dept
{
    UIImage*image = nil;
    if (dept != nil && dept.dept_name!= nil)
    {
        image = [UIImage imageNamed:dept.dept_name];
    }
    
    if (image == nil)
    {
        image = [UIImage imageNamed:DEFAULT_DEPT_IMAGE];
    }
    
    return image;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 53.5;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    unit* unt = nil;
    
    
    
    if ([self.superUnit isEqual:[department rootUnit]])
    {
        if ([self.superUnit subDept] != nil && [[self.superUnit subDept] count] > 0 &&[[[self.superUnit subDept] objectAtIndex:0] subDept] != nil)
        {
            unt = [[[[self.superUnit subDept] objectAtIndex:0] subDept] objectAtIndex:row];
        }
        
    }
    else
    {
        if (row < [[self.superUnit subDept] count])
        {
            unt = [[self.superUnit subDept] objectAtIndex:row];
        }
        else
        {
            unt = [[self.superUnit subPerson] objectAtIndex:(row-[[self.superUnit subDept] count])];
        }
    }
    
    
    
    if (unt != nil)
    {
        if ([unt isKindOfClass:[department class]])
        {
            SHOWHUD_WINDOW
            [contactDataManager WaitForDataB4ExpandUnit:unt Success:^(id responseObject)
             {
                 HIDEHUD_WINDOW
                 if ([[unt subDept] count] > 0)
                 {
                     UIStoryboard* curStory = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                     
                     ContactDeptViewController*vc =[curStory instantiateViewControllerWithIdentifier:@"Contact Dept View Controller"];
                     if ([vc  isKindOfClass:[ContactDeptViewController class]])
                     {
                         vc.superUnit = unt;
                         [self.navigationController pushViewController:vc animated:YES];
                     }
                 }
                 else if([unt.subPerson count] > 0)
                 {
                     [self performSegueWithIdentifier:@"toViewPsnListVC" sender:self];
                 }
             }
                                                failure:^(NSError *error)
             {
                 HIDEHUD_WINDOW
                 return;
             }];
            
            
        }
        else
        {
            UIStoryboard* curStory = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
            
            PersonDetailsViewController*vc =[curStory instantiateViewControllerWithIdentifier:@"PersonDetailsViewController"];
            if ([vc  isKindOfClass:[PersonDetailsViewController class]])
            {
                vc.psn = (person*)unt;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)onSearch:(id)sender {
    
    
    
}
@end
