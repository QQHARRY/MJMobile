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
#import "MJMenuModel.h"


#define SCREEN_WIDTH      CGRectGetWidth([UIScreen mainScreen].applicationFrame)
#define LEFT_TABLEV_COLOR [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1]
#define RIGHT_TABLEV_COLOR [UIColor whiteColor]
#define TEXT_HIGHLIGHT_COLOR [UIColor colorWithRed:0x01/255.0 green:0xAF/255.0 blue:0xE8/255.0 alpha:1]

#define BATCHSELECT_SPACE_HEIGHT 35
#define BATCHSELECT_BTN_HEIGHT 25

@interface MJDropDownMenu()<myTextFieldDelegate>


@property (nonatomic, assign) BOOL show;
@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, strong) UIView *backGroundView;
@property (nonatomic, assign) NSInteger selectedOnLeft;
@property (nonatomic, assign) NSIndexPath* selectedOnRight;
@property (nonatomic, strong) NSMutableArray*selectedIndexsOnRight;


@property (nonatomic, assign)NSArray*model;
@property (nonatomic, assign)NSString*title;
@property (nonatomic, assign)NSDictionary*titleLevel;
@end



@implementation MJDropDownMenu

#pragma mark - init method
- (instancetype)initWithOrigin:(CGPoint)origin andHeight:(CGFloat)height SingleMode:(BOOL)isSingleColumn BatchSelect:(BOOL)batch
{
    self = [self initWithFrame:CGRectMake(origin.x, origin.y, SCREEN_WIDTH, height)];
    if (self)
    {
        _origin = origin;
        _show = NO;
        _height = height;
        _singleColumn = isSingleColumn;
        _selectedOnLeft = 0;
        _batchSelect = batch&&(!_singleColumn);
        
        _selectedIndexsOnRight = [[NSMutableArray alloc] init];
        
        //tableView init
        CGFloat leftTVWidth,rightTVWidth;
        leftTVWidth = self.singleColumn?SCREEN_WIDTH:SCREEN_WIDTH/2.0;
        rightTVWidth = self.singleColumn?0:SCREEN_WIDTH-leftTVWidth;
        
        
        CGFloat tabH = batch?(self.frame.size.height-BATCHSELECT_SPACE_HEIGHT):self.frame.size.height;
        
        

        _leftTableV = [[UITableView alloc] initWithFrame:CGRectMake(0, 0 , leftTVWidth, tabH) style:UITableViewStylePlain];
        _leftTableV.rowHeight = 38;
        _leftTableV.dataSource = self;
        _leftTableV.delegate = self;
        _leftTableV.separatorStyle = self.singleColumn?UITableViewCellSeparatorStyleSingleLine:UITableViewCellSeparatorStyleNone;
        _leftTableV.backgroundColor = self.singleColumn?RIGHT_TABLEV_COLOR:LEFT_TABLEV_COLOR;
        [self addSubview:_leftTableV];
        
        if (!self.singleColumn)
        {
            _rightTableV = [[UITableView alloc] initWithFrame:CGRectMake(_leftTableV.frame.origin.x+_leftTableV.frame.size.width, 0, rightTVWidth, tabH) style:UITableViewStylePlain];
            _rightTableV.rowHeight = 38;
            _rightTableV.dataSource = self;
            _rightTableV.delegate = self;
            _rightTableV.backgroundColor = RIGHT_TABLEV_COLOR;
            [self addSubview:_rightTableV];
        }
        
        if (_batchSelect)
        {
            UIButton*btn = [[UIButton alloc] initWithFrame:CGRectMake(0, self.frame.size.height - BATCHSELECT_SPACE_HEIGHT/* + (BATCHSELECT_SPACE_HEIGHT - BATCHSELECT_BTN_HEIGHT)/2.0f*/, self.frame.size.width, BATCHSELECT_SPACE_HEIGHT)];
            [btn setTitle:@"确定" forState:UIControlStateNormal];
            [btn setTitleColor:TEXT_HIGHLIGHT_COLOR forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor greenColor] forState:UIControlStateHighlighted];
            btn.backgroundColor = [UIColor whiteColor];
            [btn addTarget:self action:@selector(batchSelectBtnTaped:) forControlEvents:UIControlEventTouchUpInside];
            
            
            [self addSubview:btn];
        }


        //add bottom shadow
        UIView *bottomShadow = [[UIView alloc] initWithFrame:CGRectMake(0,self.frame.size.height, SCREEN_WIDTH, 1)];
        bottomShadow.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:bottomShadow];
        
        
        [self setUpKeyBoardHander];
    }
    return self;
}

-(void)batchSelectBtnTaped:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didTapBatchSelectBtnOnMenu:)])
    {
        [self.delegate didTapBatchSelectBtnOnMenu:self];
    }
}

-(void)initTitle:(NSString *)title Model:(NSArray *)model TitleLevel:(NSDictionary *)dic
{
    self.title = title;
    self.model = model;
    self.titleLevel = dic;
}


-(void)setUpKeyBoardHander
{
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
            NSInteger batchBtnH = BATCHSELECT_BTN_HEIGHT;
            if (!weakSelf.batchSelect)
            {
                batchBtnH = 0;
            }
            CGRect tableViewFrame = weakSelf.leftTableV.frame;
            tableViewFrame.size.height = self.frame.size.height-batchBtnH;
            weakSelf.leftTableV.frame = tableViewFrame;
            
            
            tableViewFrame = weakSelf.rightTableV.frame;
            tableViewFrame.size.height = self.frame.size.height-batchBtnH;
            weakSelf.rightTableV.frame = tableViewFrame;
            
        }
    }];

}


#pragma mark - gesture handle

-(void)menuTappedOnView:(UIView*)view
{
    

    [self animateOnView:view show:!_show complete:^{
        _show = !_show;
        
        if (!self.batchSelect)
        {
            if (_selectedIndexsOnRight.count > 0)
            {
                if (self.singleColumn)
                {
                    _selectedOnLeft =  ((NSIndexPath*)_selectedIndexsOnRight[0]).row;
                }
                else
                {
                    _selectedOnLeft =  ((NSIndexPath*)_selectedIndexsOnRight[0]).section;
                }
                
            }
            
        }
        
        NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:_selectedOnLeft inSection:0];
        
        [self.leftTableV reloadData];
        if (_show && !self.batchSelect)
        {
            [self.leftTableV selectRowAtIndexPath:selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        }
        
        if (!self.singleColumn)
        {
            if (_show && !self.batchSelect)
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
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self numberOfItemsInTableview:tableView];
}

-(NSInteger)numberOfItemsInTableview:(UITableView*)tableView
{
    if (self.model)
    {
        if (tableView == self.leftTableV)
        {
            return self.model.count;
        }
        else if(tableView == self.rightTableV && self.singleColumn == NO)
        {
            if (_selectedOnLeft < self.model.count)
            {
                MJMenuModel*model = self.model[_selectedOnLeft];
                if ([model isKindOfClass:[MJMenuModel class]])
                {
                    if (model.subMenuItems)
                    {
                        return model.subMenuItems.count;
                    }
                }
                
            }
        }
        
        return 0;
    }
    else
    {
        if (self.dataSource && [self.dataSource respondsToSelector:@selector(menu:tableView:numberOfRowsInSection:)])
        {
            return [self.dataSource menu:self tableView:tableView numberOfRowsInSection:_selectedOnLeft];
        }
        else
        {
            return 0;
        }
    }
}


-(MJMenuItemValueType)valueTypeOfTableView:(UITableView*)tableView AtIndexPath:(NSIndexPath*)indexPath
{
    MJMenuItemValueType type = MJMenuItemValueTypeSingle;
    NSIndexPath*indexPathTmp = [NSIndexPath indexPathForRow:indexPath.row inSection:_selectedOnLeft];
    if (self.model)
    {
        if (tableView == self.leftTableV)
        {
            
        }
        else if(tableView == self.rightTableV)
        {
            
        }
    }
    else
    {
        if (self.dataSource && [self.dataSource respondsToSelector:@selector(menu:tableView:valuetTypeForRowAtIndexPath:)])
        {
            type = [self.dataSource menu:self tableView:tableView valuetTypeForRowAtIndexPath:indexPathTmp];
        }
    }
    return type;
}

//
//-(NSString*)identifierOfCellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSString *identifier = @"DropDownMenuCell";
//    MJMenuItemValueType type = MJMenuItemValueTypeSingle;
//    
//    NSIndexPath*indexPathTmp = [NSIndexPath indexPathForRow:indexPath.row inSection:_clickedIndexOnLeft];
//    if (self.dataSource && [self.dataSource respondsToSelector:@selector(menu:tableView:valuetTypeForRowAtIndexPath:)])
//    {
//        type = [self.dataSource menu:self tableView:tableView valuetTypeForRowAtIndexPath:indexPathTmp];
//        if (type == MJMenuItemValueTypeCustomizeSinge)
//        {
//            identifier = @"SingleValueCustomizedCell";
//        }
//        else if(type == MJMenuItemValueTypeCustomizeArea)
//        {
//            identifier = @"SectionValueCustomizedCell";
//        }
//        else
//        {
//            identifier = @"DropDownMenuCell";
//        }
//    }
//}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *identifier = @"DropDownMenuCell";
    
    MJMenuItemValueType type = MJMenuItemValueTypeSingle;
    
    NSIndexPath*indexPathTmp = [NSIndexPath indexPathForRow:indexPath.row inSection:_selectedOnLeft];
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(menu:tableView:valuetTypeForRowAtIndexPath:)])
    {
        type = [self.dataSource menu:self tableView:tableView valuetTypeForRowAtIndexPath:indexPathTmp];
        if (type == MJMenuItemValueTypeCustomizeSinge || type == MJMenuItemValueTypeMultiCustomizeSingle)
        {
            identifier = @"SingleValueCustomizedCell";
        }
        else if(type == MJMenuItemValueTypeCustomizeArea || type == MJMenuItemValueTypeMultiCustomizeArea)
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
    
    if ([self needHighlightCellOnTableView:tableView AtIndexPath:indexPath])
    {
        [cell.textLabel setTextColor:TEXT_HIGHLIGHT_COLOR];
    }
    else
    {
        [cell.textLabel setTextColor:[UIColor blackColor]];
    }

    if (tableView == _leftTableV)
    {
        
    }
    
    if (!self.singleColumn)
    {
        
        
        
        if(tableView == _rightTableV)
        {
            //if (indexPath.row == _selectedOnRight.row && _selectedOnLeft == _selectedOnRight.section && !self.batchSelect)
//            if ([self needHighlightCellOnTableView:tableView AtIndexPath:indexPath])
//            {
//                [cell.textLabel setTextColor:TEXT_HIGHLIGHT_COLOR];
//            }
//            else
//            {
//                [cell.textLabel setTextColor:[UIColor blackColor]];
//            }
            cell.backgroundColor = [UIColor whiteColor];
        }
        else
        {
//            if (indexPath.row == _selectedOnRight.section )
//            {
//                [cell.textLabel setTextColor:TEXT_HIGHLIGHT_COLOR];
//            }
//            else
//            {
//                [cell.textLabel setTextColor:[UIColor blackColor]];
//            }
            UIView *sView = [[UIView alloc] init];
            sView.backgroundColor = [UIColor whiteColor];
            cell.selectedBackgroundView = sView;
            [cell setSelected:NO animated:NO];
            cell.backgroundColor = [UIColor clearColor];
        }
        
    }
    else
    {
        
    }
    
    
    cell.textLabel.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    cell.separatorInset = UIEdgeInsetsZero;

    
    
    
    

    return cell;
}


-(BOOL)isSelectedOnTableView:(UITableView*)tableView AtIndexPath:(NSIndexPath*)indexPath
{
    NSIndexPath*tmpIndex = [NSIndexPath indexPathForRow:indexPath.row inSection:_selectedOnLeft];
    
    
    for (NSIndexPath*index in _selectedIndexsOnRight)
    {
        if (index && index.section == tmpIndex.section && index.row == tmpIndex.row)
        {
            return YES;
        }
    }
    
    return NO;
}

-(void)clearSelection
{
    if (self.batchSelect)
    {
        if (_selectedIndexsOnRight)
        {
            [_selectedIndexsOnRight removeAllObjects];
        }
    }
    
    [self.rightTableV reloadData];
}

-(void)markSelectionOnTableView:(UITableView*)tableView AtIndexPath:(NSIndexPath*)indexPath
{
    NSIndexPath*tmpIndex = [NSIndexPath indexPathForRow:indexPath.row inSection:_selectedOnLeft];
    
    
    MJMenuItemValueType valueType = MJMenuItemValueTypeSingle;
    
    if (_dataSource && [_dataSource respondsToSelector:@selector(menu:tableView:valuetTypeForRowAtIndexPath:)])
    {
        valueType = [_dataSource menu:self tableView:tableView valuetTypeForRowAtIndexPath:tmpIndex];
    }
    
    if (_batchSelect)
    {
        
        if (_singleColumn)
        {//因为在初始化代码中:_batchSelect = batch&&(!_singleColumn) 所以如果batchSelect等于NO,singleColumn不可能是YES
         //故不考虑这种情况
        }
        else
        {
            if (tableView == _leftTableV)
            {
                _selectedOnLeft = indexPath.row;
            }
            else
            {
                
                                                                        //MJMenuItemValueTypeMultiCustomizeSingle
                if (valueType == MJMenuItemValueTypeMulti || valueType == MJMenuItemValueTypeMultiCustomizeSingle
                    || valueType == MJMenuItemValueTypeMultiCustomizeArea)
                {
                    BOOL bFound = NO;
                    for (NSIndexPath*index in _selectedIndexsOnRight)
                    {
                        //每个section同时选中一个，故删掉以前的。
                        if (index && index.section == tmpIndex.section && index.row == tmpIndex.row)
                        {
                            [_selectedIndexsOnRight removeObject:index];
                            bFound = YES;
                            break;
                        }
                    }
                    
                    if (!bFound)
                    {
                        [_selectedIndexsOnRight addObject:tmpIndex];
                    }
                }
                else
                {
                    NSMutableArray*tmpArr = [[NSMutableArray alloc] init];
                    
                    
                    for (NSIndexPath*index in _selectedIndexsOnRight)
                    {
                        //每个section同时选中一个，故删掉以前的。将不删除的加到临时容器中
                        if (index && index.section != tmpIndex.section)
                        {
                            [tmpArr addObject:index];
                        }
                    }
                    
                    [_selectedIndexsOnRight removeAllObjects];
                    [_selectedIndexsOnRight addObjectsFromArray:tmpArr];
                    [_selectedIndexsOnRight addObject:tmpIndex];
                }
            }
        }
        
       
    }
    else
    {
        if (self.singleColumn)
        {
            if (tableView == _leftTableV)
            {
                _selectedOnLeft = indexPath.row;
            }
            else
            {//singleColumn等于YES时，右tableview不显示
            }
        }
        else
        {
            if (tableView == _leftTableV)
            {
                _selectedOnLeft = indexPath.row;
            }
            else
            {
                
                [_selectedIndexsOnRight removeAllObjects];
                [_selectedIndexsOnRight addObject:tmpIndex];
            }
        }
        
    }
}




-(BOOL)needHighlightCellOnTableView:(UITableView*)tableView AtIndexPath:(NSIndexPath*)indexPath
{
    if (self.batchSelect)
    {
        if (_singleColumn)
        {//因为在初始化代码中:_batchSelect = batch&&(!_singleColumn) 所以如果batchSelect等于NO,singleColumn不可能是YES
            //故不考虑这种情况
            
        }
        else
        {
            if (tableView == self.rightTableV)
            {
                for (NSIndexPath*index in _selectedIndexsOnRight)
                {
                    if (index && index.row == indexPath.row && _selectedOnLeft ==index.section)
                    {
                        return YES;
                    }
                }
            }
        }
        
    }
    else
    {
        if (_singleColumn)
        {
            if (tableView == _leftTableV)
            {
                if (_selectedOnLeft == indexPath.row)
                {
                    return YES;
                }
            }
            else
            {//singleColumn等于YES时，右tableview不显示
                
            }
        }
        else
        {
            if (tableView == _leftTableV)
            {
                if (_selectedOnLeft == indexPath.row)
                {
                    return YES;
                }
            }
            else
            {
                for (NSIndexPath*index in _selectedIndexsOnRight)
                {
                    if (index && index.row == indexPath.row && _selectedOnLeft ==index.section)
                    {
                        return YES;
                    }
                }
            }
        }
    }
    
    return NO;
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

       // _selectedOnRight = [NSIndexPath indexPathForRow:0 inSection:indexPath.row];
        [self markSelectionOnTableView:tableView AtIndexPath:indexPath];
    }
    else
    {
        if (tableView == self.leftTableV)
        {
            //_selectedOnLeft = indexPath.row;
            [self markSelectionOnTableView:tableView AtIndexPath:indexPath];
            [self.rightTableV reloadData];
        }
        else
        {
            
            //_selectedOnRight = [NSIndexPath indexPathForRow:indexPath.row inSection:_selectedOnLeft];
            
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(menu:tableView:didSelectRowAtIndexPath:CustomizedValue:)])
            {
                
                MJMenuItemValue*value = nil;
                
                BOOL isSelectedAlready = [self isSelectedOnTableView:tableView AtIndexPath:indexPath];
                
                NSIndexPath*indexTmp = [NSIndexPath indexPathForRow:indexPath.row inSection:_selectedOnLeft];
                
                
                if (!isSelectedAlready)
                {
                    if(self.dataSource && [self.dataSource respondsToSelector:@selector(menu:tableView:valuetTypeForRowAtIndexPath:)])
                    {
                        MJMenuItemValueType type = [self.dataSource menu:self tableView:tableView valuetTypeForRowAtIndexPath:indexTmp];
                        
                        if (( (type == MJMenuItemValueTypeMultiCustomizeSingle) || (type == MJMenuItemValueTypeCustomizeSinge)) && [cell isKindOfClass:[SingleValueCustomizedCell class]])
                        {
                            value = [[MJMenuItemValue alloc] init];
                            value.valueType = type;
                            value.valueArr = @[((SingleValueCustomizedCell*)cell).singleValueField.text];
                            
                        }
                        else if (((type == MJMenuItemValueTypeMultiCustomizeArea) || (type == MJMenuItemValueTypeCustomizeArea)) && [cell isKindOfClass:[SectionValueCustomizedCell class]])
                        {
                            value = [[MJMenuItemValue alloc] init];
                            value.valueType = type;
                            value.valueArr = @[((SectionValueCustomizedCell*)cell).minValue.text,((SectionValueCustomizedCell*)cell).maxValue.text];
                        }
                    }
                }
                
                

                
                
                [self.delegate menu:self tableView:tableView didSelectRowAtIndexPath:indexTmp CustomizedValue:value];
            }
            
            [self markSelectionOnTableView:tableView AtIndexPath:indexPath];
            
            if (self.batchSelect == NO)
            {
                
                [self animateOnView:nil show:NO complete:^{
                    _show = NO;
                    
                }];
            }
            else
            {
                [tableView reloadData];
            }
            
        }
    }
    

   
}



@end


