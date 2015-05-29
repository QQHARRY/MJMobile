//
//  MJDropDownMenu.m
//  MJ
//
//  Created by harry on 18/5/12.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//







#import "MJDropDownMenu.h"
#import "SingleValueCustomizedCell.h"
#import "SectionValueCustomizedCell.h"
#import "myTextFieldDelegate.h"
#import "DAKeyboardControl.h"
#import "UIView+FindFirstResponser.h"
#import "UIView+addToolBar2Keyboard.h"
#import "DoneToolbarButton.h"
#import "RFKeyboardToolbar.h"


#define SCREEN_WIDTH      CGRectGetWidth([UIScreen mainScreen].applicationFrame)
#define LEFT_TABLEV_COLOR [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1]
#define RIGHT_TABLEV_COLOR [UIColor whiteColor]
#define TEXT_HIGHLIGHT_COLOR [UIColor colorWithRed:0x01/255.0 green:0xAF/255.0 blue:0xE8/255.0 alpha:1]

@interface MJDropDownMenu()<myTextFieldDelegate>


@property (nonatomic, assign) BOOL show;
@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, strong) UIView *backGroundView;
@property (nonatomic, assign) NSInteger clickedIndexOnLeft;
@property (nonatomic, assign) NSIndexPath* selectedIndex;

@end



@implementation MJDropDownMenu

#pragma mark - init method
- (instancetype)initWithOrigin:(CGPoint)origin andHeight:(CGFloat)height SingleMode:(BOOL)isSingleColumn
{
    self = [self initWithFrame:CGRectMake(origin.x, origin.y, SCREEN_WIDTH, height)];
    if (self)
    {
        _origin = origin;
        _show = NO;
        _height = height;
        _singleColumn = isSingleColumn;
        _clickedIndexOnLeft = 0;
        
        //tableView init
        CGFloat leftTVWidth,rightTVWidth;
        leftTVWidth = self.singleColumn?SCREEN_WIDTH:SCREEN_WIDTH/2.0;
        rightTVWidth = self.singleColumn?0:SCREEN_WIDTH-leftTVWidth;

        _leftTableV = [[UITableView alloc] initWithFrame:CGRectMake(0, 0 , leftTVWidth, self.frame.size.height) style:UITableViewStylePlain];
        _leftTableV.rowHeight = 38;
        _leftTableV.dataSource = self;
        _leftTableV.delegate = self;
        _leftTableV.separatorStyle = self.singleColumn?UITableViewCellSeparatorStyleSingleLine:UITableViewCellSeparatorStyleNone;
        _leftTableV.backgroundColor = self.singleColumn?RIGHT_TABLEV_COLOR:LEFT_TABLEV_COLOR;
        [self addSubview:_leftTableV];
        
        if (!self.singleColumn)
        {
            _rightTableV = [[UITableView alloc] initWithFrame:CGRectMake(_leftTableV.frame.origin.x+_leftTableV.frame.size.width, 0, rightTVWidth, self.frame.size.height) style:UITableViewStylePlain];
            _rightTableV.rowHeight = 38;
            _rightTableV.dataSource = self;
            _rightTableV.delegate = self;
            _rightTableV.backgroundColor = RIGHT_TABLEV_COLOR;
            [self addSubview:_rightTableV];
        }


        //add bottom shadow
        UIView *bottomShadow = [[UIView alloc] initWithFrame:CGRectMake(0,self.frame.size.height, SCREEN_WIDTH, 1)];
        bottomShadow.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:bottomShadow];
        
#if 1
        __weak typeof(self)weakSelf = self;
        
        [self addKeyboardPanningWithActionHandler:^(CGRect keyboardFrameInView) {
            CGRect tableViewFrame = weakSelf.leftTableV.frame;
            tableViewFrame.size.height = keyboardFrameInView.origin.y;
            weakSelf.leftTableV.frame = tableViewFrame;
            
            tableViewFrame = weakSelf.rightTableV.frame;
            tableViewFrame.size.height = keyboardFrameInView.origin.y;
            weakSelf.rightTableV.frame = tableViewFrame;
        }];
        
        [self addKeyboardCompletionHandler:^(BOOL finished, BOOL isShowing) {
            if (!isShowing)
            {
                NSLog(@"finished=%d,isShowing=%d",finished,isShowing);
                CGRect tableViewFrame = weakSelf.leftTableV.frame;
                tableViewFrame.size.height = self.frame.size.height;
                weakSelf.leftTableV.frame = tableViewFrame;
                
                
                tableViewFrame = weakSelf.rightTableV.frame;
                tableViewFrame.size.height = self.frame.size.height;
                weakSelf.rightTableV.frame = tableViewFrame;
                
            }
        }];
        
#endif
        
       
        
    }
    return self;
}



#pragma mark - gesture handle

-(void)menuTappedOnView:(UIView*)view
{
    NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:_selectedIndex.section inSection:0];

    [self animateOnView:view show:!_show complete:^{
        _show = !_show;
        
        _clickedIndexOnLeft = _selectedIndex.section;
        [self.leftTableV reloadData];
        if (_show)
        {
            [self.leftTableV selectRowAtIndexPath:selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        }
        
        if (!self.singleColumn)
        {
            if (_show)
            {
                [self tableView:self.leftTableV didSelectRowAtIndexPath:selectedIndexPath];
            }
            
        }
        
    }];

}


#pragma mark - animation method
- (void)animateOnView:(UIView *)view show:(BOOL)show complete:(void(^)())complete {

    if (show)
    {
        if (view)
        {
            [UIView animateWithDuration:0.2 animations:^{
                [view addSubview:self];
            }];
        }
    }
    else
    {
        UIView*superView = self.superview;
        if (superView)
        {
            [UIView animateWithDuration:0.2 animations:^{
                [self removeFromSuperview];
            }];
            
        }
    }
    complete();
}




#pragma mark - table datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(menu:tableView:numberOfRowsInSection:)])
    {
        
        return [self.dataSource menu:self tableView:tableView numberOfRowsInSection:_clickedIndexOnLeft];
    }
    else
    {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *identifier = @"DropDownMenuCell";
    
    MJMenuItemValueType type = MJMenuItemValueTypeSingle;
    
    NSIndexPath*indexPathTmp = [NSIndexPath indexPathForRow:indexPath.row inSection:_clickedIndexOnLeft];
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(menu:tableView:valuetTypeForRowAtIndexPath:)])
    {
        type = [self.dataSource menu:self tableView:tableView valuetTypeForRowAtIndexPath:indexPathTmp];
        if (type == MJMenuItemValueTypeCustomizeSinge)
        {
            identifier = @"SingleValueCustomizedCell";
        }
        else if(type == MJMenuItemValueTypeCustomizeArea)
        {
            identifier = @"SectionValueCustomizedCell";
        }
        else
        {
            identifier = @"DropDownMenuCell";
        }
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        if ([identifier isEqualToString:@"SingleValueCustomizedCell"])
        {
            NSArray *nibs=[[NSBundle mainBundle] loadNibNamed:identifier owner:self options:nil];
            for(id oneObject in nibs)
            {
                if([oneObject isKindOfClass:[SingleValueCustomizedCell class]])
                {
                    cell = (SingleValueCustomizedCell *)oneObject;
                    ((SingleValueCustomizedCell *)cell).textFieldDelegate = self;
                    
                }
            }
        }
        else if([identifier isEqualToString:@"SectionValueCustomizedCell"])
        {
            NSArray *nibs=[[NSBundle mainBundle] loadNibNamed:identifier owner:self options:nil];
            for(id oneObject in nibs)
            {
                if([oneObject isKindOfClass:[SectionValueCustomizedCell class]])
                {
                    cell = (SectionValueCustomizedCell *)oneObject;
                    ((SectionValueCustomizedCell *)cell).textFieldDelegate = self;
                }
            }
        }
        else
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        
        if (self.dataSource && [self.dataSource respondsToSelector:@selector(menu:tableView:DefaultValueForRowAtIndexPath:)])
        {
            MJMenuItemValue*value = [self.dataSource menu:self tableView:tableView DefaultValueForRowAtIndexPath:indexPathTmp];
            
            if (value != nil && value.valueArr == nil && [value.valueArr  count] != 0)
            {
                
                if (type == MJMenuItemValueTypeCustomizeSinge && [cell isKindOfClass:[SingleValueCustomizedCell class]] )
                {
                    ((SingleValueCustomizedCell*)cell).singleValueField.text = value.valueArr[0];
                }
                else if(type == MJMenuItemValueTypeCustomizeArea)
                {
                    ((SectionValueCustomizedCell*)cell).minValue.text = value.valueArr[0];
                    ((SectionValueCustomizedCell*)cell).maxValue.text = value.valueArr[1];
                }
                else
                {
                    
                }
            }
        }
        
    }

    if (self.dataSource && [self.dataSource respondsToSelector:@selector(menu:tableView:titleForRowAtIndexPath:)])
    {
        
        cell.textLabel.text = [self.dataSource menu:self tableView:tableView titleForRowAtIndexPath:indexPathTmp];
    }

    if (!self.singleColumn)
    {
        if(tableView == _rightTableV)
        {
            if (indexPath.row == _selectedIndex.row && _clickedIndexOnLeft == _selectedIndex.section)
            {
                [cell.textLabel setTextColor:TEXT_HIGHLIGHT_COLOR];
            }
            else
            {
                [cell.textLabel setTextColor:[UIColor blackColor]];
            }
            cell.backgroundColor = [UIColor whiteColor];
        }
        else
        {
            if (indexPath.row == _selectedIndex.section)
            {
                [cell.textLabel setTextColor:TEXT_HIGHLIGHT_COLOR];
            }
            else
            {
                [cell.textLabel setTextColor:[UIColor blackColor]];
            }
            UIView *sView = [[UIView alloc] init];
            sView.backgroundColor = [UIColor whiteColor];
            cell.selectedBackgroundView = sView;
            [cell setSelected:NO animated:NO];
            cell.backgroundColor = [UIColor clearColor];
        }
        
    }
    else
    {
        if (indexPath.row == _selectedIndex.section)
        {
            [cell.textLabel setTextColor:TEXT_HIGHLIGHT_COLOR];
        }
        else
        {
            [cell.textLabel setTextColor:[UIColor blackColor]];
        }
        
    }
    
    
    cell.textLabel.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    cell.separatorInset = UIEdgeInsetsZero;

    
    
    
    

    return cell;
}

#pragma mark - tableview delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell*cell = [tableView cellForRowAtIndexPath:indexPath];
    if (self.singleColumn)
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(menu:tableView:didSelectRowAtIndexPath:CustomizedValue:)])
        {
            MJMenuItemValue*value = nil;
            
            if(self.dataSource && [self.dataSource respondsToSelector:@selector(menu:tableView:valuetTypeForRowAtIndexPath:)])
            {
                MJMenuItemValueType type = [self.dataSource menu:self tableView:tableView valuetTypeForRowAtIndexPath:indexPath];
                
                if (type == MJMenuItemValueTypeCustomizeSinge && [cell isKindOfClass:[SingleValueCustomizedCell class]])
                {
                    value = [[MJMenuItemValue alloc] init];
                    value.valueType = type;
                    value.valueArr = @[((SingleValueCustomizedCell*)cell).singleValueField.text];
                    
                }
                else if (type == MJMenuItemValueTypeCustomizeArea && [cell isKindOfClass:[SectionValueCustomizedCell class]])
                {
                    value = [[MJMenuItemValue alloc] init];
                    value.valueType = type;
                    value.valueArr = @[((SectionValueCustomizedCell*)cell).minValue.text,((SectionValueCustomizedCell*)cell).maxValue.text];
                }
            }
            
            
            [self.delegate menu:self tableView:tableView didSelectRowAtIndexPath:indexPath CustomizedValue:value];
        }
        
        [self animateOnView:nil show:NO complete:^{
            _show = NO;
            
        }];

        _selectedIndex = [NSIndexPath indexPathForRow:0 inSection:indexPath.row];
    }
    else
    {
        if (tableView == self.leftTableV)
        {
            _clickedIndexOnLeft = indexPath.row;
            [self.rightTableV reloadData];
        }
        else
        {
            _selectedIndex = [NSIndexPath indexPathForRow:indexPath.row inSection:_clickedIndexOnLeft];
            if (self.delegate && [self.delegate respondsToSelector:@selector(menu:tableView:didSelectRowAtIndexPath:CustomizedValue:)])
            {
                
                MJMenuItemValue*value = nil;
                
                if(self.dataSource && [self.dataSource respondsToSelector:@selector(menu:tableView:valuetTypeForRowAtIndexPath:)])
                {
                    MJMenuItemValueType type = [self.dataSource menu:self tableView:tableView valuetTypeForRowAtIndexPath:indexPath];
                    
                    if (type == MJMenuItemValueTypeCustomizeSinge && [cell isKindOfClass:[SingleValueCustomizedCell class]])
                    {
                        value = [[MJMenuItemValue alloc] init];
                        value.valueType = type;
                        value.valueArr = @[((SingleValueCustomizedCell*)cell).singleValueField.text];
                        
                    }
                    else if (type == MJMenuItemValueTypeCustomizeArea && [cell isKindOfClass:[SectionValueCustomizedCell class]])
                    {
                        value = [[MJMenuItemValue alloc] init];
                        value.valueType = type;
                        value.valueArr = @[((SectionValueCustomizedCell*)cell).minValue.text,((SectionValueCustomizedCell*)cell).maxValue.text];
                    }
                }
                

                
                NSIndexPath*indexTmp = [NSIndexPath indexPathForRow:indexPath.row inSection:_clickedIndexOnLeft];
                [self.delegate menu:self tableView:tableView didSelectRowAtIndexPath:indexTmp CustomizedValue:value];
            }
            
            [self animateOnView:nil show:NO complete:^{
                _show = NO;
                
            }];
        }
    }
    

    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //[self hideKeyBoard];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
   
}

-(void)myTextFieldShouldReturn
{

}


-(void)myTextFieldDidBeginEditing
{


}
- (void)hideKeyBoard
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}
-(BOOL) dismissAllKeyBoardInView:(UIView *)view
{
    if([view isFirstResponder])
    {
        [view resignFirstResponder];
        return YES;
    }
    for(UIView *subView in view.subviews)
    {
        if([self dismissAllKeyBoardInView:subView])
        {
            return YES;
        }
    }
    return NO;
}




@end


