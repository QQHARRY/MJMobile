//
//  petitionAgreementViewController.m
//  MJ
//
//  Created by harry on 14/12/18.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import "petitionAgreementViewController.h"
#import "petitionHistoryNodeTableViewCell.h"
#import "UtilFun.h"
#import "petitionManager.h"
#import "petionListTableViewController.h"
#import "MainPageViewController.h"
#import "person.h"
#import "Macro.h"

@interface petitionAgreementViewController ()

@end

@implementation petitionAgreementViewController
@synthesize opinionForAgreement;
@synthesize petition;
@synthesize historyNodeTableView;
@synthesize opinionLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.opinionForAgreement.delegate = self;
    opinionForAgreement.layer.cornerRadius=1;
    opinionForAgreement.layer.masksToBounds=YES;
    opinionForAgreement.layer.borderColor=[[UIColor darkGrayColor]CGColor];
    opinionForAgreement.layer.borderWidth= 1.0f;
    
    [self initUI];
    
    if(self.view.frame.size.height == 480)
    {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
        [self.opinionForAgreement setTranslatesAutoresizingMaskIntoConstraints:YES];
        [self.opinionLabel setTranslatesAutoresizingMaskIntoConstraints:YES];
#endif

        [self.opinionForAgreement setFrame:CGRectMake(10, 310, 300, 55)];
        
        
        [self.opinionLabel setFrame:CGRectMake(10, 310, 300, 21)];
    }
    
}
-(void)viewWillAppear:(BOOL)animated
{

    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.opinionForAgreement resignFirstResponder];
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if ([text isEqualToString:@"\n"]) {
        
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}
-(void)initUI
{
    [self initTableView];
    if ([self.petition getPetitionStatus] == 0)
    {
        self.agreeBtn.hidden = NO;
        self.disAgreeBtn.hidden = NO;
        self.cancelBtn.hidden = YES;
    }
    else
    {
        self.agreeBtn.hidden = YES;
        self.disAgreeBtn.hidden = YES;
        self.cancelBtn.hidden = NO;
    }
}
-(void)initTableView
{
    historyNodeTableView = [[UITableView alloc ]initWithFrame:CGRectMake(0, 62, self.view.frame.size.width,self.view.frame.size.height/2.0) style:UITableViewStylePlain];
    [self.view addSubview:historyNodeTableView];
    historyNodeTableView.delegate = self;
    historyNodeTableView.dataSource = self;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.petition)
    {
        if (petition.allDetails)
        {
            if ([petition hasAssistDept])
            {
                return 3;
            }
            else
            {
                return 2;
            }
        }
    }
    else
    {
        return 0;
    }
        return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"历史节点:";
    }
    else if (section == 1) {
        return @"当前节点:";
    }
    else if (section == 2) {
        return @"汇办部门:";
    }
    return @"";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        if (self.petition && self.petition.historyNodes && self.petition.historyNodes.count > 0)
        {
            return petition.historyNodes.count;
        }
        else
        {
            return 1;
        }
    }
    else if(section == 1)
    {
        return 1;
    }
    else if(section == 2)
    {
        return 1;
    }
    
        

    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString*key = @"cell";
    UITableViewCell *cell = nil;
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:key];
    //if (cell == nil)
    {
        cell = [[UITableViewCell alloc ] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:key];
    }
    
    [cell.textLabel setFont:[UIFont systemFontOfSize:12]];
    if (indexPath.section == 0)
    {
        if (self.petition && self.petition.historyNodes && self.petition.historyNodes.count > 0)
        {
            NSDictionary*dic = [self.petition.historyNodes objectAtIndex:indexPath.row];
            NSString*key = [dic objectForKey:@"key"];
            NSString*value = [dic objectForKey:@"value"];
           
            value =[[key stringByAppendingString:@"  "] stringByAppendingString:value];

            cell.textLabel.text =value;
            cell.textLabel.hidden = YES;
            CGRect frame = cell.frame;
            frame.origin.x = 12;
            frame.size.width -= 24;
            UITextView*textV = [[UITextView alloc] initWithFrame:frame];
            [textV setFont:[UIFont systemFontOfSize:12]];
            textV.text = value;
            textV.editable = NO;
            textV.selectable = NO;
            textV.scrollEnabled = YES;
            
            [cell addSubview:textV];
            
        }
        else
        {
            cell.textLabel.text =@"";
        }
       

    }
    else if(indexPath.section == 1)
    {
        cell.textLabel.text =[petition nowNodeName];

    }
    else if(indexPath.section == 2)
    {
        NSString*str = [petition assistDepts];
        if ([str isEqualToString:@""] || str.length == 0)
        {
            str = @"点击选择汇办部门";
        }
        cell.textLabel.text = str;
        if ([petition isAffordDeptNow])
        {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.opinionForAgreement resignFirstResponder];
    if (indexPath.section == 2 && indexPath.row == 0)
    {
        if ([petition isAffordDeptNow])
        {
            [self performSegueWithIdentifier:@"toChooseAssistDepartment" sender:self];
        }
        else
        {
            [tableView deselectRowAtIndexPath:indexPath animated:NO];
            PRESENTALERT(@"对不起您不能添加汇办部门", @"只有承办部门才能添加汇办部门", nil,nil, nil);
        }
    }
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIViewController *controller;
    if ([segue.destinationViewController isKindOfClass:[UINavigationController class]])
    {
        UINavigationController *navController = (UINavigationController *)segue.destinationViewController;
        controller = [navController.viewControllers objectAtIndex:0];
    }
    else {
        controller = segue.destinationViewController;
    }
    
    
    if ([segue.identifier isEqual:@"toChooseAssistDepartment"])
    {
        if ([controller isKindOfClass:[chooseAssistDeptTableViewController class]])
        {
            chooseAssistDeptTableViewController *detailController = (chooseAssistDeptTableViewController *)controller;

            detailController.delegate = self;
        }
        else
        {
            
        }
        
    }
}

-(BOOL)fieldVerification
{
    NSString*str = opinionForAgreement.text;
    if ([str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0)
    {
        PRESENTALERT(@"审批意见不能为空", @"请填写审批意见", @"OK", nil, self);
        return NO;
    }
    return YES;
}

- (IBAction)agreeBtnClicked:(id)sender {

    if ([self fieldVerification])
    {
        NSMutableArray*arr = [[NSMutableArray alloc] init];
        for (NSDictionary*dic in self.selectedAssistDepts)
        {
            NSString*value = [[dic allValues] objectAtIndex:0];
            [arr addObject:value];
        }
        
        //[arr addObject:@"DPT000041"];
        SHOWHUD_WINDOW;
        [petitionManager approveID:[self.petition getID] TaskID:self.petitionTaskID ActionType:0 Reason:opinionForAgreement.text AssistDepts:arr Success:^(id responseObject)
         {
            [[NSNotificationCenter defaultCenter] postNotificationName:MAINPAGE_INDICATOR_NUMBER_CHANGED object:nil];
            HIDEHUD_WINDOW
             
             
             PRESENTALERT(@"审批成功", nil, @"OK", ^()
                          {
                              [self quit];
                          }, self);

            
        } failure:^(NSError *error) {
            HIDEHUD_WINDOW
            PRESENTALERT(@"审批失败", nil, @"OK", ^()
                         {
                             [self quit];
                         }, self);
        }];
    }
    
}

- (IBAction)disAgreeBtnClicked:(id)sender {
    
    if ([self fieldVerification])
    {
        NSMutableArray*arr = [[NSMutableArray alloc] init];
        for (NSDictionary*dic in self.selectedAssistDepts)
        {
            NSString*value = [[dic allValues] objectAtIndex:0];
            [arr addObject:value];
        }
        [petitionManager approveID:[self.petition getID] TaskID:self.petitionTaskID ActionType:1 Reason:opinionForAgreement.text AssistDepts:arr Success:^(id responseObject)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:MAINPAGE_INDICATOR_NUMBER_CHANGED object:nil];
            PRESENTALERT(@"审批成功", nil, @"OK", ^()
                         {
                             [self quit];
                         }, self);
        } failure:^(NSError *error) {
            PRESENTALERT(@"审批失败", nil, @"OK", ^()
                         {
                             [self quit];
                         }, self);
        }];
    }
}

-(void)quit
{
    NSArray*ctrlArr = [self.navigationController viewControllers];
    
    for (NSInteger i = [ctrlArr count]-1; i >=0; i--)
    {
        UIViewController*ctrl = [ctrlArr objectAtIndex:i];
        if ([ctrl isKindOfClass:[petionListTableViewController class]] || [ctrl isKindOfClass:[MainPageViewController class]] )
        {
            [self.navigationController popToViewController:ctrl animated:YES];
            break;
        }
    }
}

- (IBAction)cancelBtnClicked:(id)sender {
    if ([self fieldVerification])
    {
        NSMutableArray*arr = [[NSMutableArray alloc] init];
        for (NSDictionary*dic in self.selectedAssistDepts)
        {
            NSString*value = [[dic allValues] objectAtIndex:0];
            [arr addObject:value];
        }
        [petitionManager approveID:[self.petition getID] TaskID:self.petitionTaskID ActionType:2 Reason:opinionForAgreement.text AssistDepts:arr Success:^(id responseObject)
         {
             [[NSNotificationCenter defaultCenter] postNotificationName:MAINPAGE_INDICATOR_NUMBER_CHANGED object:nil];

             PRESENTALERT(@"取消成功", nil, @"OK", ^()
                          {
                              [self quit];
                          }, self);
             
            
        } failure:^(NSError *error) {
            PRESENTALERT(@"取消失败", nil, @"OK", ^()
                         {
                             [self quit];
                         }, self);
        }];
    }
}


-(void)returnSelection:(NSArray *)curSelection
{
    if (curSelection == nil || curSelection.count <= 0)
    {
        return;
    }
    self.selectedAssistDepts = curSelection;
    
    
    
    UITableViewCell*cell = [self.historyNodeTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
    if (cell)
    {
        NSString*str =@"";
        for (int i=0;i < self.selectedAssistDepts.count; i++)
        {
            NSDictionary*dic = [self.selectedAssistDepts objectAtIndex:i];
            if (dic)
            {
                NSString*key = [[dic allKeys ] objectAtIndex:0];
                str = [str stringByAppendingString:key];

                if (i < self.selectedAssistDepts.count -1)
                {
                    str = [str stringByAppendingString:@","];
                }
            }
            
        }
        
        cell.textLabel.text = str;
    }
}
@end
