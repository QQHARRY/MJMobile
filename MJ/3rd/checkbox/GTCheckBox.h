//
//  GTCheckBox.h
//  MemberShip
//
//  Created by harry on 14-6-26.
//  Copyright (c) 2014年 harry.he. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GTCheckBoxDelegate;

@interface GTCheckBox : UIButton {
    id<GTCheckBoxDelegate> __unsafe_unretained _delegate;
    BOOL _checked;
    id _userInfo;
}

@property(nonatomic, unsafe_unretained)id<GTCheckBoxDelegate> delegate;
@property(nonatomic, assign)BOOL checked;
@property(nonatomic, strong)id userInfo;

- (id)initWithDelegate:(id)delegate;

@end

@protocol GTCheckBoxDelegate <NSObject>

@optional

- (void)didSelectedCheckBox:(GTCheckBox *)checkbox checked:(BOOL)checked;

@end
