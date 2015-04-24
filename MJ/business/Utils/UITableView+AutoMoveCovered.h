//
//  UITableView+AutoMoveCovered.h
//  MJ
//
//  Created by harry on 15/4/24.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface  UITableView(UITableView_AutoMoveCovered)

-(void) scrollViewIfControlCoveredByKeyboard:(UIView *)control atIndexPath:(NSIndexPath *)indexPath  hasStatusBar:(BOOL)hasStatusBar hasNavigationBar:(BOOL)hasNavBar  KeyBoardHeight:(NSInteger)kbHeight;
- (void) restoreViewPosition;

@end


