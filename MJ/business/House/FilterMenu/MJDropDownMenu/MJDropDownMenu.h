//
//  MJDropDownMenu.h
//  MJ
//
//  Created by harry on 18/5/12.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJMenuItemValue.h"






@class MJDropDownMenu;


@protocol MJDropDownMenuDataSource <NSObject>

@required
- (NSInteger)menu:(MJDropDownMenu *)menu tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section;
- (NSString *)menu:(MJDropDownMenu *)menu tableView:(UITableView*)tableView titleForRowAtIndexPath:(NSIndexPath *)indexPath;
- (MJMenuItemValueType)menu:(MJDropDownMenu *)menu tableView:(UITableView*)tableView valuetTypeForRowAtIndexPath:(NSIndexPath *)indexPath;

- (MJMenuItemValue*)menu:(MJDropDownMenu *)menu tableView:(UITableView*)tableView DefaultValueForRowAtIndexPath:(NSIndexPath *)indexPath;
@end

#pragma mark - delegate
@protocol MJDropDownMenuDelegate <NSObject>
@optional
- (void)menu:(MJDropDownMenu *)menu tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath CustomizedValue:(MJMenuItemValue*)value;
@end


@interface MJDropDownMenu : UIView<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *rightTableV;
@property (nonatomic, strong) UITableView *leftTableV;

@property (nonatomic, strong) UIView *transformView;

@property (nonatomic, weak) id <MJDropDownMenuDataSource> dataSource;
@property (nonatomic, weak) id <MJDropDownMenuDelegate> delegate;
@property (nonatomic, assign) BOOL singleColumn;

- (instancetype)initWithOrigin:(CGPoint)origin andHeight:(CGFloat)height  SingleMode:(BOOL)isSingleColumn;

-(void)menuTappedOnView:(UIView*)view;

@end


