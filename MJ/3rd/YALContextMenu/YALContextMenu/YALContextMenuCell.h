//
//  YALContextMenuCell.h
//  ContextMenu
//
//  Created by Maksym Lazebnyi on 1/21/15.
//  Copyright (c) 2015 Yalantis. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol YALContextMenuCell <NSObject>

/*!
 @abstract
 Following methods called for cell when animation to be processed
 */
- (UIView *)animatedIcon;
- (UIView *)animatedContent;

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com