//
//  CLClippingTool.h
//
//  Created by sho yakushiji on 2013/10/18.
//  Copyright (c) 2013年 CALACULU. All rights reserved.
//

#import "CLImageToolBase.h"

@interface CLRatio : NSObject
@property (nonatomic, assign) BOOL isLandscape;
@property (nonatomic, readonly) CGFloat ratio;
- (id)initWithValue1:(NSInteger)value1 value2:(NSInteger)value2;
- (NSString*)description;
@end



@interface CLClippingTool : CLImageToolBase

@end
