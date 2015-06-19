//
//  CLClippingTool+CustomizeItems.h
//  CLImageEditorDemo
//
//  Created by harry on 15/6/17.
//  Copyright (c) 2015年 CALACULU. All rights reserved.
//

#import "CLClippingTool.h"
#import "CLImageToolBase.h"
#import "CliplingRatio.h"


@interface CLImageToolBase (CustomizeItems)

@end


@protocol CLClippingToolItemsDataSource <NSObject>

-(CliplingRatio*)CLClippingRatio;

@end



@interface CLClippingTool (CustomizeItems)

+(void)setupWithDataSource:(id<CLClippingToolItemsDataSource>)dataSource;
+(void)restore;
@end
