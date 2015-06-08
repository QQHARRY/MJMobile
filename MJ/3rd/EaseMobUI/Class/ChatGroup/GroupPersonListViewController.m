//
//  GroupPersonListViewController.m
//  MJ
//
//  Created by harry on 15/6/4.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//

#import "GroupPersonListViewController.h"
#import "EMSearchDisplayController.h"
#import "EMSearchBar.h"
#import "EMBuddy+namefull.h"
#import "SRRefreshView.h"
#import "EaseMobFriendsManger.h"
#import "UIImageView+LoadPortraitOfPerson.h"
#import "RealtimeSearchUtil.h"
#import "ChineseToPinyin.h"
#import "UtilFun.h"
#import "NSString+GetNamefull.h"
#import "UIViewController+ViewPersonDetails.h"
#import "ContactSelectionViewController.h"

@interface GroupPersonListViewController()<UITableViewDataSource,UITableViewDelegate,SRRefreshDelegate,UISearchDisplayDelegate,UISearchBarDelegate,BaseTableCellDelegate,EMChooseViewDelegate>
@property(strong,nonatomic)UITableView*tableView;
@property (strong, nonatomic) EMSearchDisplayController *searchController;
@property (strong, nonatomic) EMSearchBar *searchBar;
@property (strong, nonatomic) SRRefreshView *slimeView;
@property (nonatomic,assign) BOOL isGroupOwner;
@property (strong, nonatomic) NSMutableArray*dataSource;
@property (strong, nonatomic) NSMutableArray *sectionTitles;
@property (strong, nonatomic) NSMutableArray *allContacListInGroup;
@end

@implementation GroupPersonListViewController
@synthesize group;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _dataSource = [NSMutableArray array];
        _allContacListInGroup = [NSMutableArray array];
        _sectionTitles = [NSMutableArray array];
    }
    return self;
}

-(void)viewDidLoad
{
    
    [super viewDidLoad];
    
    [self searchController];
    self.searchBar.frame = CGRectMake(0, 0, self.view.frame.size.width, 44);
    [self.view addSubview:self.searchBar];
    
    self.tableView.frame = CGRectMake(0, self.searchBar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - self.searchBar.frame.size.height);
    [self.view addSubview:self.tableView];
    [self.tableView addSubview:self.slimeView];
    
    
    
    [self reloadDataSource];

}

- (void)reloadDataSource
{
    [_dataSource removeAllObjects];
    [_allContacListInGroup removeAllObjects];
    
    if (self.group)
    {
        
        SHOWHUD(self.view);
        
        __weak typeof(self) weakSelf = self;
        [[EaseMobFriendsManger sharedInstance] addEMFriends:self.group.occupants isFriend:NO WaitForSuccess:^(BOOL bSuccess) {
            if (bSuccess)
            {
                [_allContacListInGroup addObjectsFromArray:weakSelf.group.occupants];
                [_dataSource addObjectsFromArray:[self sortDataArray:_allContacListInGroup]];
                weakSelf.isGroupOwner = NO;
                NSDictionary *loginInfo = [[[EaseMob sharedInstance] chatManager] loginInfo];
                NSString *loginUsername = [loginInfo objectForKey:kSDKUsername];
                if ([weakSelf.group.owner isEqualToString:loginUsername]) {
                    weakSelf.isGroupOwner = YES;
                }
                
                if (_isGroupOwner == YES)
                {
                    for (NSString *str in weakSelf.group.members) {
                        if ([str isEqualToString:loginUsername]) {
                            weakSelf.isGroupOwner = NO;
                            break;
                        }
                    }
                }
                
                
                
                HIDEHUD(self.view);
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if (weakSelf.isGroupOwner)
                    {
                        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addMember)];
                    }
                    
                    [weakSelf.slimeView endRefresh];
                    [_tableView reloadData];
                });
            }
            else
            {
                HIDEHUD(self.view);
            }
        }];
        
        
    }
    
}

-(void)addMember
{
    ContactSelectionViewController *selectionController = [[ContactSelectionViewController alloc] initWithBlockSelectedUsernames:group.occupants];
    selectionController.delegate = self;
    [self.navigationController pushViewController:selectionController animated:YES];
}

- (UISearchBar *)searchBar
{
    if (_searchBar == nil) {
        _searchBar = [[EMSearchBar alloc] init];
        _searchBar.delegate = self;
        _searchBar.placeholder = NSLocalizedString(@"search", @"Search");
        _searchBar.backgroundColor = [UIColor colorWithRed:0.747 green:0.756 blue:0.751 alpha:1.000];
    }
    
    return _searchBar;
}

- (SRRefreshView *)slimeView
{
    if (_slimeView == nil) {
        _slimeView = [[SRRefreshView alloc] init];
        _slimeView.delegate = self;
        _slimeView.upInset = 0;
        _slimeView.slimeMissWhenGoingBack = YES;
        _slimeView.slime.bodyColor = [UIColor grayColor];
        _slimeView.slime.skinColor = [UIColor grayColor];
        _slimeView.slime.lineWith = 1;
        _slimeView.slime.shadowBlur = 4;
        _slimeView.slime.shadowColor = [UIColor grayColor];
    }
    
    return _slimeView;
}

#pragma mark - slimeRefresh delegate
//刷新列表
- (void)slimeRefreshStartRefresh:(SRRefreshView *)refreshView
{
    [self reloadDataSource];
}

- (UITableView *)tableView
{
    if (_tableView == nil)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] init];
    }
    
    return _tableView;
}

- (EMSearchDisplayController *)searchController
{
    if (_searchController == nil)
    {
        _searchController = [[EMSearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
        _searchController.delegate = self;
        _searchController.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _searchController.editingStyle = UITableViewCellEditingStyleDelete;
        
        
        
        __weak GroupPersonListViewController *weakSelf = self;
        
        
        [_searchController setCanEditRowAtIndexPath:^BOOL(UITableView *tableView, NSIndexPath *indexPath) {
            BOOL bCanEdit = weakSelf.isGroupOwner;
            return bCanEdit;
        }];
        
        
        [_searchController setCellForRowAtIndexPathCompletion:^UITableViewCell *(UITableView *tableView, NSIndexPath *indexPath) {
            static NSString *CellIdentifier = @"ContactListCell";
            BaseTableViewCell *cell = (BaseTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            // Configure the cell...
            if (cell == nil) {
                cell = [[BaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
            NSString *buddy = [weakSelf.searchController.resultsSource objectAtIndex:indexPath.row];
            cell.imageView.image = [UIImage imageNamed:@"chatListCellHead.png"];
//            if (buddy)
//            {
//                cell.textLabel.text = [buddy getNamefull];
//            }
//            else
//            {
//                cell.textLabel.text = @"unknown";
//            }
            
            
            __weak __typeof(cell) weakChatCell = cell;
            
            [[EaseMobFriendsManger sharedInstance] getFriendByUserName:buddy Success:^(BOOL success, person *psn) {
                if (weakChatCell!=nil && psn != nil)
                {
                    weakChatCell.textLabel.text = psn.name_full;
                    [weakChatCell.imageView loadPortraitOfPerson:psn round:YES];
                }
                
            }];
            
            
            return cell;
        }];
        
        [_searchController setHeightForRowAtIndexPathCompletion:^CGFloat(UITableView *tableView, NSIndexPath *indexPath) {
            return 50;
        }];
        
        
        [_searchController setDidSelectRowAtIndexPathCompletion:^(UITableView *tableView, NSIndexPath *indexPath) {
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            
            if (indexPath.row < weakSelf.searchController.resultsSource.count)
            {
                NSString *buddy = [weakSelf.searchController.resultsSource objectAtIndex:indexPath.row];
                NSDictionary *loginInfo = [[[EaseMob sharedInstance] chatManager] loginInfo];
                NSString *loginUsername = [loginInfo objectForKey:kSDKUsername];
                if (loginUsername && loginUsername.length > 0) {
                    if ([loginUsername isEqualToString:buddy]) {
                        
                        return;
                    }
                }
                [weakSelf.searchController.searchBar endEditing:YES];

                [weakSelf.searchController.searchContentsController ViewPersonDetails:buddy];

                
            }
        }];
        
        
        
        [_searchController setCommitEditingStyle:^(UITableView *tableView, UITableViewCellEditingStyle editStyle, NSIndexPath *indexPath)
        {
            if (editStyle == UITableViewCellEditingStyleDelete)
            {
                if (indexPath.section < _dataSource.count)
                {
                    [weakSelf removeOccupantsAtIndexPath:indexPath];
                }
            }
        }];
    }
    
    return _searchController;
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [self.dataSource count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section < [_dataSource count])
    {
        NSArray*arr = [self.dataSource objectAtIndex:section];
        if (arr && ([arr isKindOfClass:[NSArray class]] || [arr isKindOfClass:[NSMutableArray class]]))
        {
            return arr.count;
        }
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BaseTableViewCell *cell;
    
    
    static NSString *CellIdentifier = @"ContactListCell";
    cell = (BaseTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // Configure the cell...
    if (cell == nil) {
        cell = [[BaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.delegate = self;
    }
    
    cell.indexPath = indexPath;

    {
        NSString *buddy = [[self.dataSource objectAtIndex:(indexPath.section)] objectAtIndex:indexPath.row];
        cell.imageView.image = [UIImage imageNamed:@"chatListCellHead.png"];
        cell.textLabel.text = buddy;
        
        __weak __typeof(cell) weakChatCell = cell;
        
        [[EaseMobFriendsManger sharedInstance] getFriendByUserName:buddy Success:^(BOOL success, person *psn) {
            if (weakChatCell!=nil && psn != nil)
            {
                weakChatCell.textLabel.text = psn.name_full;
                [weakChatCell.imageView loadPortraitOfPerson:psn round:YES];
            }

        }];
        
    }
    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        if (indexPath.section < _dataSource.count)
        {
            [self removeOccupantsAtIndexPath:indexPath];
        }
    }
}

-(void)removeOccupantsAtIndexPath:(NSIndexPath*)indexPath
{
    if (indexPath)
    {
        NSArray*arr =  [_dataSource objectAtIndex:indexPath.section];
        if (arr && arr.count > indexPath.row)
        {
            NSString *buddy = [arr objectAtIndex:indexPath.row];
            if (buddy == nil)
            {
                return;
            }
            
            if ([self.group.owner isEqualToString:buddy])
            {
                PRESENTALERT(@"", @"不能删除群主", nil, nil);
            }
            else
            {
                [self showHudInView:self.view hint:NSLocalizedString(@"group.removingOccupant", @"deleting member...")];
                
                NSArray *occupants = [NSArray arrayWithObject:buddy];
                
                __weak typeof(self) weakSelf = self;
                [[EaseMob sharedInstance].chatManager asyncRemoveOccupants:occupants fromGroup:self.group.groupId completion:^(EMGroup *groupObj, EMError *error)
                 {
                     [self hideHud];
                     if (!error)
                     {
                         weakSelf.group = groupObj;
                         [self.tableView beginUpdates];
                         [[self.dataSource objectAtIndex:indexPath.section] removeObjectAtIndex:indexPath.row];
                         [self.allContacListInGroup removeObject:buddy];
                         
                         [self.tableView  deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                         [self.tableView  endUpdates];
                     }
                     else
                     {
                         [weakSelf showHint:error.description];
                     }
                 } onQueue:nil];
            }
        }
    }
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([[self.dataSource objectAtIndex:section] count] == 0)
    {
        return 0;
    }
    return 22;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if ([[self.dataSource objectAtIndex:section] count] == 0)
    {
        return nil;
    }
    
    UIView *contentView = [[UIView alloc] init];
    [contentView setBackgroundColor:[UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:1.0]];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 22)];
    label.backgroundColor = [UIColor clearColor];
    [label setText:[self.sectionTitles objectAtIndex:section]];
    [contentView addSubview:label];
    return contentView;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSMutableArray * existTitles = [NSMutableArray array];
    //section数组为空的title过滤掉，不显示
    for (int i = 0; i < [self.sectionTitles count]; i++)
    {
        if ([[self.dataSource objectAtIndex:i] count] > 0)
        {
            [existTitles addObject:[self.sectionTitles objectAtIndex:i]];
        }
    }
    return existTitles;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isGroupOwner)
    {
        return UITableViewCellEditingStyleDelete;
    }
    return UITableViewCellEditingStyleNone;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *loginInfo = [[[EaseMob sharedInstance] chatManager] loginInfo];
    NSString *loginUsername = [loginInfo objectForKey:kSDKUsername];
    
    if (indexPath.section < _dataSource.count)
    {
        NSArray*arr = _dataSource[indexPath.section];
        if ( arr && ([arr isKindOfClass:[NSArray class]] || [arr isKindOfClass:[NSMutableArray class]]))
        {
            if (arr.count > indexPath.row)
            {
                NSString*buddy = [[self.dataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
                if ([buddy isEqualToString:loginUsername])
                {
                    return;
                }
                else
                {
                    [self ViewPersonDetails:buddy];
                }
                
                
            }
        }
    }
    
}

#pragma mark - scrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_slimeView scrollViewDidScroll];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_slimeView scrollViewDidEndDraging];
}

#pragma mark - UISearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
    
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (group)
    {
        [[RealtimeSearchUtil currentUtil] realtimeSearchWithSource:_allContacListInGroup searchText:(NSString *)searchText collationStringSelector:@selector(getNamefull) resultBlock:^(NSArray *results) {
        if (results) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
                [self.searchController.resultsSource removeAllObjects];
                [self.searchController.resultsSource addObjectsFromArray:results];
                
                [self.searchController.searchResultsTableView reloadData];
//                [self.searchController.searchResultsTableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];

            });
        }
    }];
        
    }
    
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar.text = @"";
    [[RealtimeSearchUtil currentUtil] realtimeSearchStop];
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
}

#pragma mark - UIActionSheetDelegate


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
//    if (buttonIndex != actionSheet.cancelButtonIndex && _currentLongPressIndex)
//    {
//        EMBuddy *buddy = [[self.dataSource objectAtIndex:(_currentLongPressIndex.section - 1)] objectAtIndex:_currentLongPressIndex.row];
//        [self.tableView beginUpdates];
//        [[self.dataSource objectAtIndex:(_currentLongPressIndex.section - 1)] removeObjectAtIndex:_currentLongPressIndex.row];
//        [self.contactsSource removeObject:buddy];
//        [self.tableView  deleteRowsAtIndexPaths:[NSArray arrayWithObject:_currentLongPressIndex] withRowAnimation:UITableViewRowAnimationFade];
//        [self.tableView  endUpdates];
//        
//        [[EaseMob sharedInstance].chatManager blockBuddy:buddy.username relationship:eRelationshipBoth];
//    }
//    
//    _currentLongPressIndex = nil;
}


#pragma mark - BaseTableCellDelegate

- (void)cellImageViewLongPressAtIndexPath:(NSIndexPath *)indexPath
{

}

-(void)didTapImageOnCell:(NSIndexPath *)indexPath
{
}

#pragma mark - private

- (NSMutableArray *)sortDataArray:(NSArray *)dataArray
{
    //建立索引的核心
    UILocalizedIndexedCollation *indexCollation = [UILocalizedIndexedCollation currentCollation];
    
    [self.sectionTitles removeAllObjects];
    [self.sectionTitles addObjectsFromArray:[indexCollation sectionTitles]];
    
    //返回27，是a－z和＃
    NSInteger highSection = [self.sectionTitles count];
    //tableView 会被分成27个section
    NSMutableArray *sortedArray = [NSMutableArray arrayWithCapacity:highSection];
    for (int i = 0; i <= highSection; i++) {
        NSMutableArray *sectionArray = [NSMutableArray arrayWithCapacity:1];
        [sortedArray addObject:sectionArray];
    }
    
    //名字分section
    for (NSString *buddy in dataArray)
    {
        //getUserName是实现中文拼音检索的核心，见NameIndex类
        person*psn = [[EaseMobFriendsManger sharedInstance] getFriendByUserName:buddy];
        NSString*tmp = @"";
        if (psn)
        {
            tmp = psn.name_full;
        }
        else
        {
            tmp = buddy;
        }
        NSString *firstLetter = [ChineseToPinyin pinyinFromChineseString:tmp];
        NSInteger section = [indexCollation sectionForObject:[firstLetter substringToIndex:1] collationStringSelector:@selector(uppercaseString)];
        
        NSMutableArray *array = [sortedArray objectAtIndex:section];
        [array addObject:buddy];
    }
    
    //每个section内的数组排序
    for (int i = 0; i < [sortedArray count]; i++) {
        NSArray *array = [[sortedArray objectAtIndex:i] sortedArrayUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
            NSString *firstLetter1 = [ChineseToPinyin pinyinFromChineseString:obj1];
            firstLetter1 = [[firstLetter1 substringToIndex:1] uppercaseString];
            
            NSString *firstLetter2 = [ChineseToPinyin pinyinFromChineseString:obj2];
            firstLetter2 = [[firstLetter2 substringToIndex:1] uppercaseString];
            
            return [firstLetter1 caseInsensitiveCompare:firstLetter2];
        }];
        
        
        [sortedArray replaceObjectAtIndex:i withObject:[NSMutableArray arrayWithArray:array]];
    }
    
    return sortedArray;
}

#pragma mark - EMChooseViewDelegate
- (void)viewController:(EMChooseViewController *)viewController didFinishSelectedSources:(NSArray *)selectedSources
{
    [self showHudInView:self.view hint:NSLocalizedString(@"group.addingOccupant", @"add a group member...")];
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableArray *source = [NSMutableArray array];
        for (EMBuddy *buddy in selectedSources) {
            [source addObject:buddy.username];
        }
        
        NSDictionary *loginInfo = [[[EaseMob sharedInstance] chatManager] loginInfo];
        NSString *username = [loginInfo objectForKey:kSDKUsername];
        NSString *messageStr = [NSString stringWithFormat:NSLocalizedString(@"group.somebodyInvite", @"%@ invite you to join group \'%@\'"), username, weakSelf.group.groupSubject];
//        EMError *error = nil;
//        weakSelf.group = [[EaseMob sharedInstance].chatManager addOccupants:source toGroup:weakSelf.group.groupId welcomeMessage:messageStr error:&error];
        
        
        
        
        [[EaseMob sharedInstance].chatManager asyncAddOccupants:source toGroup:weakSelf.group.groupId welcomeMessage:messageStr completion:^(NSArray *occupants, EMGroup *group, NSString *welcomeMessage, EMError *error) {
            [self hideHud];
            if (!error) {
                [weakSelf reloadDataSource];
            }
        } onQueue:nil];
        
        
        
        
    });
}

@end
