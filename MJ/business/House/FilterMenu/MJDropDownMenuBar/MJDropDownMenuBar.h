//
//  MJDropDownMenuBar.h
//  MJ
//
//  Created by harry on 15/5/12.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MJDropDownMenuBar;
@class MJDropDownMenu;

@protocol MJDropDownMenuBarDataSource <NSObject>

@required
- (NSString *)MJDropDownMenuBar:(MJDropDownMenuBar*)menuBar TitleForColumn:(NSInteger)index;
- (NSInteger)NumberOfColumns:(MJDropDownMenuBar*)menuBar;
- (MJDropDownMenu*)MJDropDownMenuBar:(MJDropDownMenuBar*)menuBar MenuForColumn:(NSInteger)index;
@end


@class MJDropDownMenuBar;

@protocol MJDropDownMenuBarDelegate <NSObject>

- (void)MJDropDownMenuBar:(MJDropDownMenuBar*)menuBar TapedAtIndex:(NSInteger)index;

@end


@interface MJDropDownMenuBar : UIView

@property (nonatomic, weak) id <MJDropDownMenuBarDataSource> dataSource;
@property (nonatomic, weak) id <MJDropDownMenuBarDelegate>delegate;

@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIColor *separatorColor;
@property (nonatomic, strong) UIColor *indicatorColor;
@property (nonatomic, strong) UIColor *bgColor;
-(instancetype)initWithOrigin:(CGPoint)origin andHeight:(CGFloat)height;
-(void)updateTitle:(NSString*)title ForIndex:(NSInteger)index;
-(void)makeMenuClosed;
@end

