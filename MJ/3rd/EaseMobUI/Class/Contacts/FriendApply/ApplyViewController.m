/************************************************************
  *  * EaseMob CONFIDENTIAL 
  * __________________ 
  * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved. 
  *  
  * NOTICE: All information contained herein is, and remains 
  * the property of EaseMob Technologies.
  * Dissemination of this information or reproduction of this material 
  * is strictly forbidden unless prior written permission is obtained
  * from EaseMob Technologies.
  */

#import "ApplyViewController.h"

#import "ApplyFriendCell.h"
#import "InvitationManager.h"
#import "EaseMobFriendsManger.h"
#import "UtilFun.h"

static ApplyViewController *controller = nil;

@interface ApplyViewController ()<ApplyFriendCellDelegate>

@end

@implementation ApplyViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        _dataSource = [[NSMutableArray alloc] init];
    }
    return self;
}

+ (instancetype)shareController
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        controller = [[self alloc] initWithStyle:UITableViewStylePlain];
        controller.hidesBottomBarWhenPushed = YES;
    });
    
    return controller;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    self.title = NSLocalizedString(@"title.apply", @"Application and notification");
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [backButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    //UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    //[self.navigationItem setLeftBarButtonItem:backItem];
    
    SHOWHUD(self.view);
    [self loadDataSourceFromLocalDB];
    HIDEHUD(self.view);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    [self.tableView reloadData];
}

#pragma mark - getter

- (NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    
    return _dataSource;
}

- (NSString *)loginUsername
{
    NSDictionary *loginInfo = [[[EaseMob sharedInstance] chatManager] loginInfo];
    return [loginInfo objectForKey:kSDKUsername];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ApplyFriendCell";
    ApplyFriendCell *cell = (ApplyFriendCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[ApplyFriendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if(self.dataSource.count > indexPath.row)
    {
        ApplyEntity *entity = [self.dataSource objectAtIndex:indexPath.row];
        if (entity) {
            cell.indexPath = indexPath;
            ApplyStyle applyStyle = [entity.style intValue];
            if (applyStyle == ApplyStyleGroupInvitation) {
                cell.titleLabel.text = NSLocalizedString(@"title.groupApply", @"Group Notification");
                cell.headerImageView.image = [UIImage imageNamed:@"groupPrivateHeader"];
                cell.contentLabel.text = entity.reason;
                
            }
            else if (applyStyle == ApplyStyleJoinGroup)
            {
                cell.titleLabel.text = [NSString stringWithFormat:@"群:%@",entity.groupSubject];
                cell.headerImageView.image = [UIImage imageNamed:@"groupPrivateHeader"];
                cell.contentLabel.text = [NSString stringWithFormat:@"%@ 申请加入群",entity.applicantUsername];
                [[EaseMobFriendsManger sharedInstance] getFriendByUserName:[entity.applicantUsername uppercaseString] Success:^(BOOL success, person *psn) {
                    if (psn)
                    {
                        cell.contentLabel.text = [NSString stringWithFormat:@"%@ 申请加入群",psn.name_full];
                    }
                    
                }];
            }
            else if(applyStyle == ApplyStyleFriend){
                cell.titleLabel.text = entity.applicantUsername;
                cell.headerImageView.image = [UIImage imageNamed:@"chatListCellHead"];
                
                cell.contentLabel.text = [NSString stringWithFormat:@"%@ 申请添加好友",entity.applicantUsername];
                [[EaseMobFriendsManger sharedInstance] getFriendByUserName:[entity.applicantUsername uppercaseString] Success:^(BOOL success, person *psn) {
                    if (psn)
                    {
                        cell.contentLabel.text = [NSString stringWithFormat:@"%@ 申请添加好友",psn.name_full];
                    }
                    
                }];
            }
            
            
            
            
            
            
            
            
            
            
        }
    }
    
    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ApplyEntity *entity = [self.dataSource objectAtIndex:indexPath.row];
    return [ApplyFriendCell heightWithContent:entity.reason];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - ApplyFriendCellDelegate

- (void)applyCellAddFriendAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row < [self.dataSource count]) {
        [self showHudInView:self.view hint:NSLocalizedString(@"sendingApply", @"sending apply...")];
        
        ApplyEntity *entity = [self.dataSource objectAtIndex:indexPath.row];
        ApplyStyle applyStyle = [entity.style intValue];
        EMError *error;
        
        /*if (applyStyle == ApplyStyleGroupInvitation) {
            [[EaseMob sharedInstance].chatManager acceptInvitationFromGroup:entity.groupId error:&error];
        }
        else */if (applyStyle == ApplyStyleJoinGroup)
        {
            [[EaseMob sharedInstance].chatManager acceptApplyJoinGroup:entity.groupId groupname:entity.groupSubject applicant:entity.applicantUsername error:&error];
        }
        else if(applyStyle == ApplyStyleFriend){
            [[EaseMob sharedInstance].chatManager acceptBuddyRequest:entity.applicantUsername error:&error];
        }
        
        [self hideHud];
        if (!error) {
            [self.dataSource removeObject:entity];
            NSString *loginUsername = [[[EaseMob sharedInstance].chatManager loginInfo] objectForKey:kSDKUsername];
            [[InvitationManager sharedInstance] removeInvitation:entity loginUser:loginUsername];
            [self.tableView reloadData];
        }
        else{
            [self showHint:NSLocalizedString(@"acceptFail", @"accept failure")];
        }
        
         [[NSNotificationCenter defaultCenter] postNotificationName:@"setupUntreatedApplyCount" object:nil];
    }
    
   
}

- (void)applyCellRefuseFriendAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row < [self.dataSource count]) {
        [self showHudInView:self.view hint:NSLocalizedString(@"sendingApply", @"sending apply...")];
        ApplyEntity *entity = [self.dataSource objectAtIndex:indexPath.row];
        ApplyStyle applyStyle = [entity.style intValue];
        EMError *error;
        
        if (applyStyle == ApplyStyleGroupInvitation) {
            [[EaseMob sharedInstance].chatManager rejectInvitationForGroup:entity.groupId toInviter:entity.applicantUsername reason:@""];
        }
        else if (applyStyle == ApplyStyleJoinGroup)
        {
            NSString *reason = [NSString stringWithFormat:NSLocalizedString(@"group.beRefusedToJoin", @"be refused to join the group\'%@\'"), entity.groupSubject];
            [[EaseMob sharedInstance].chatManager rejectApplyJoinGroup:entity.groupId groupname:entity.groupSubject toApplicant:entity.applicantUsername reason:reason];
        }
        else if(applyStyle == ApplyStyleFriend){
            [[EaseMob sharedInstance].chatManager rejectBuddyRequest:entity.applicantUsername reason:@"" error:&error];
        }
        
        [self hideHud];
        if (!error) {
            [self.dataSource removeObject:entity];
            NSString *loginUsername = [[[EaseMob sharedInstance].chatManager loginInfo] objectForKey:kSDKUsername];
            [[InvitationManager sharedInstance] removeInvitation:entity loginUser:loginUsername];
            
            [self.tableView reloadData];
        }
        else{
            [self showHint:NSLocalizedString(@"rejectFail", @"reject failure")];
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"setupUntreatedApplyCount" object:nil];
    }
    
    
}

#pragma mark - public

- (void)addNewApply:(NSDictionary *)dictionary
{
    if (dictionary && [dictionary count] > 0) {
        NSString *applyUsername = [dictionary objectForKey:@"username"];
        ApplyStyle style = [[dictionary objectForKey:@"applyStyle"] intValue];
        
        if (applyUsername && applyUsername.length > 0)
        {
            for (int i = ((int)[_dataSource count] - 1); i >= 0; i--)
            {
                ApplyEntity *oldEntity = [_dataSource objectAtIndex:i];
                ApplyStyle oldStyle = [oldEntity.style intValue];
                if (oldStyle == style && [applyUsername isEqualToString:oldEntity.applicantUsername])
                {
                    if(style != ApplyStyleFriend)
                    {
                        NSString *newGroupid = [dictionary objectForKey:@"groupname"];
                        if (newGroupid || [newGroupid length] > 0 || [newGroupid isEqualToString:oldEntity.groupId])
                        {
                            break;
                        }
                    }
                    
                    oldEntity.reason = [dictionary objectForKey:@"applyMessage"];
                    [_dataSource removeObject:oldEntity];
                    [_dataSource insertObject:oldEntity atIndex:0];
                    [self.tableView reloadData];
                    
                    return;
                }
            }
            
            //new apply
            ApplyEntity * newEntity= [[ApplyEntity alloc] init];
            newEntity.applicantUsername = [dictionary objectForKey:@"username"];
            newEntity.style = [dictionary objectForKey:@"applyStyle"];
            newEntity.reason = [dictionary objectForKey:@"applyMessage"];
            
            NSDictionary *loginInfo = [[[EaseMob sharedInstance] chatManager] loginInfo];
            NSString *loginName = [loginInfo objectForKey:kSDKUsername];
            newEntity.receiverUsername = loginName;
            
            NSString *groupId = [dictionary objectForKey:@"groupId"];
            newEntity.groupId = (groupId && groupId.length > 0) ? groupId : @"";
            
            NSString *groupSubject = [dictionary objectForKey:@"groupname"];
            newEntity.groupSubject = (groupSubject && groupSubject.length > 0) ? groupSubject : @"";
            
            NSString *loginUsername = [[[EaseMob sharedInstance].chatManager loginInfo] objectForKey:kSDKUsername];
            [[InvitationManager sharedInstance] addInvitation:newEntity loginUser:loginUsername];
            
            [_dataSource insertObject:newEntity atIndex:0];
            [self.tableView reloadData];

        }
    }
}

- (void)loadDataSourceFromLocalDB
{
    [_dataSource removeAllObjects];
    NSDictionary *loginInfo = [[[EaseMob sharedInstance] chatManager] loginInfo];
    NSString *loginName = [loginInfo objectForKey:kSDKUsername];
    if(loginName && [loginName length] > 0)
    {
        
        NSArray * applyArray = [[InvitationManager sharedInstance] applyEmtitiesWithloginUser:loginName];
        [self.dataSource addObjectsFromArray:applyArray];
        
        [self.tableView reloadData];
    }
}

- (void)back
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"setupUntreatedApplyCount" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)clear
{
    [_dataSource removeAllObjects];
    [self.tableView reloadData];
}

@end
