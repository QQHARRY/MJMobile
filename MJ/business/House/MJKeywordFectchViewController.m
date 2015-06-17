//
//  MJKeywordFectchViewController.m
//  MJ
//
//  Created by harry on 15/6/13.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//

#import "MJKeywordFectchViewController.h"
#import "MJKeywordManager.h"
#import "MJKeywordPersistence.h"
#import "RealtimeSearchUtil.h"

@interface MJKeywordFectchViewController ()<UISearchBarDelegate>

@property(nonatomic,strong)UISearchBar*searchBar;
@property(nonatomic,strong)NSMutableArray*historyArr;
@property(nonatomic,strong)NSMutableArray*resultArr;
@property(nonatomic,strong)NSString*curSearchKW;

@end

@implementation MJKeywordFectchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _curSearchKW = @"";
    [self searchBar];
    [self refreshKeyword];
    
}

-(NSMutableArray*)historyArr
{
    
    if (_historyArr == nil)
    {
        _historyArr = [[NSMutableArray alloc] init];
    }
    
    return _historyArr;
}


-(NSMutableArray*)resultArr
{
    if (_resultArr == nil)
    {
        _resultArr = [[NSMutableArray alloc] init];
    }
    
    return _resultArr;
}

-(void)refreshKeyword
{
    
    [self.historyArr removeAllObjects];
    [self.historyArr addObjectsFromArray:[[MJKeywordPersistenceFactory getPersistenceImp] getHistoryKeyWordByKey:_keywordType]];
    
    
    [[RealtimeSearchUtil currentUtil] realtimeSearchWithSource:_historyArr searchText:_curSearchKW collationStringSelector:nil resultBlock:^(NSArray *results)
     {
         [self.resultArr removeAllObjects];
         if (results)
         {
             [self.resultArr addObjectsFromArray:results];
         }
         [self.tableView reloadData];
         
     }];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    
    [self.navigationController.navigationBar addSubview:self.searchBar];
}

-(void)viewDidAppear:(BOOL)animated
{
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    
    [self.searchBar removeFromSuperview];
}


- (UISearchBar *)searchBar
{
    
    if (_searchBar == nil)
    {
        
        _searchBar = [[UISearchBar alloc] init];
        [self customizeSearchBar:_searchBar];
        [_searchBar becomeFirstResponder];
        
        
    }
    
    return _searchBar;
}

-(void)customizeSearchBar:(UISearchBar*)schBar
{
    
    schBar.delegate = self;
    schBar.placeholder =self.placeHolderString;
    schBar.backgroundColor = [UIColor clearColor];
    schBar.barTintColor = [UIColor clearColor];
    schBar.showsCancelButton = YES;
    
    schBar.bounds = CGRectMake(0, 0, self.navigationController.navigationBar.frame.size.width-70 , 40);
    schBar.center = CGPointMake(CGRectGetWidth(self.navigationController.navigationBar.frame)/2.0f+35, CGRectGetHeight(self.navigationController.navigationBar.frame)/2.0f);
    
    
    UIButton *cancelButton;
    UITextField*textFiled;
    UIView *topView = schBar.subviews[0];
    for (UIView *subView in topView.subviews)
    {
        if ([subView isKindOfClass:NSClassFromString(@"UINavigationButton")])
        {
            cancelButton = (UIButton*)subView;
        }
        if ([subView isKindOfClass:NSClassFromString(@"UISearchBarTextField")])
        {
            textFiled = (UITextField*)subView;
        }
    }
    if (cancelButton)
    {
        [cancelButton setTitle:@"搜索" forState:UIControlStateNormal];
        cancelButton.tintColor = [UIColor whiteColor];
        
    }
    if (textFiled)
    {
        //textFiled.backgroundColor = [UIColor clearColor];
        //textFiled.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.75].CGColor;
        //textFiled.layer.borderWidth = 0.5;
        //textFiled.layer.cornerRadius = 10;
        //textFiled.textColor = [UIColor whiteColor];
        textFiled.font = [UIFont systemFontOfSize:13];
        textFiled.keyboardType  = UIKeyboardTypeDefault;
        textFiled.returnKeyType = UIReturnKeyDone;
        textFiled.enablesReturnKeyAutomatically = NO;
    }
    
}



- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    NSInteger count = self.resultArr.count;
    if (count != 0)
    {
        count += 1;
    }
    return count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString*reUseIndefier = @"reuseIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reUseIndefier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reUseIndefier];
    }
    
    
    NSInteger count = self.resultArr.count;
    
    if (count != 0)
    {
        if (indexPath.row < self.resultArr.count)
        {
            cell.textLabel.text = self.resultArr[indexPath.row];
            cell.textLabel.textAlignment = NSTextAlignmentLeft;
        }
        else if(indexPath.row == self.resultArr.count)
        {
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.textLabel.text = @"清除搜索记录";
        }
    }
    
    
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger count = self.resultArr.count;
    if (count != 0)
    {
        if (indexPath.row < count)
        {
            _curSearchKW = self.resultArr[indexPath.row];
            [self notifyDelegate];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else if (indexPath.row == count)
        {
            [[MJKeywordPersistenceFactory getPersistenceImp] clearHistoryKeyWordArrByKey:_keywordType];
            [self.historyArr removeAllObjects];
            [self.resultArr removeAllObjects];
            [self.tableView reloadData];
        }
    }
    
    
}




#pragma mark - UISearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    
    _curSearchKW = searchText;
    [[RealtimeSearchUtil currentUtil] realtimeSearchWithSource:_historyArr searchText:(NSString *)searchText collationStringSelector:@selector(lowercaseString) resultBlock:^(NSArray *results)
     {
        if (results)
        {
            [self.resultArr removeAllObjects];
            [self.resultArr addObjectsFromArray:results];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
            
        }
     }];
     
    
    
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
    
    [[RealtimeSearchUtil currentUtil] realtimeSearchStop];
    [searchBar resignFirstResponder];
    [self notifyDelegate];
    [self synAndPullSelf];
}

-(void)synAndPullSelf
{
    
    NSString*tmp = [_curSearchKW stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (tmp.length > 0)
    {
        BOOL bFound = NO;
        for (NSString*str in self.historyArr)
        {
            if ([[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:tmp])
            {
                bFound = YES;
            }
        }
        if (!bFound)
        {
            NSMutableArray*arr = [[NSMutableArray alloc] init];
            [arr addObjectsFromArray:self.historyArr];
            [arr addObject:_curSearchKW];
            [[MJKeywordPersistenceFactory getPersistenceImp] synHistoryKeyWordArr:arr ByKey:_keywordType];
        }
        
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)notifyDelegate
{
    
    if (self.delegate)
    {
        if ([self.delegate respondsToSelector:@selector(didSelectKeyword:)])
        {
            [self.delegate performSelector:@selector(didSelectKeyword:) withObject:_curSearchKW];
        }
    }
    
}

@end
