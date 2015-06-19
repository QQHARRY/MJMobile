//
//  CLClippingTool+CustomizeItems.m
//  CLImageEditorDemo
//
//  Created by harry on 15/6/17.
//  Copyright (c) 2015年 CALACULU. All rights reserved.
//

#import "CLClippingTool+CustomizeItems.h"
#import <objc/runtime.h>
#import "SwizzleClassMethod.h"
#import "UIImage+Utility.h"
#import "CliplingRatio.h"





@implementation CLImageToolBase(CustomizeItems)

//+(BOOL)resolveInstanceMethod:(SEL)sel
//{
//    return [super resolveInstanceMethod:sel];
//}
//
//-(id)forwardingTargetForSelector:(SEL)aSelector
//{
//    return [super forwardingTargetForSelector:aSelector];
//}
//-(NSMethodSignature*)methodSignatureForSelector:(SEL)aSelector
//{
//    NSString*sel = NSStringFromSelector(aSelector);
//    if ([sel isEqualToString:@"setupReplace"])
//    {
//        return [NSMethodSignature signatureWithObjCTypes:"v@:"];
//    }
//    return [super methodSignatureForSelector:aSelector];
//}
//
//-(void)forwardInvocation:(NSInvocation *)anInvocation
//{
//    SEL selector = [anInvocation selector];
//#pragma clang diagnostic push
//#pragma clang diagnostic ignored "-Wundeclared-selector"
//    if (selector == @selector(setupReplace))
//    {
//        anInvocation.selector = @selector(setup);
//        selector = @selector(setup);
//    }
//#pragma clang diagnostic pop
//    
//    if ([self respondsToSelector:selector])
//    {
//        [anInvocation invoke];
//    }
//}
@end


static __weak id<CLClippingToolItemsDataSource> dataSource;
static IMP storedSetCropMenu = NULL;
static IMP storedSetUp = NULL;

id getRatioObjWith2Value(NSInteger v1,NSInteger v2)
{
    
    CLRatio*ratio = [[CLRatio alloc] initWithValue1:v1 value2:v2];
    return ratio;
    
#if 0
    id ratio = nil;
    Class CLRatioClass =  objc_getClass("CLRatio");
    if (CLRatioClass != NULL)
    {
        ratio = [CLRatioClass alloc];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
        SEL initSelector = @selector(initWithValue1: value2:);
#pragma clang diagnostic pop
        IMP initImp = class_getMethodImplementation(CLRatioClass, initSelector);
        if (initImp)
        {
            @try {
                ratio = ((id (*)(id, SEL, ...))initImp)(ratio,initSelector,v1,v2);
            }
            @catch (NSException *exception) {
                ratio = nil;
            }
        }
        
    }
    
    return ratio;
#endif
}

void setCropMenuCustomized(id SELF, SEL _cmd)
{
    id ratio = nil;
    if (dataSource && [dataSource respondsToSelector:@selector(CLClippingRatio)])
    {
        CliplingRatio*MJRatio = [dataSource performSelector:@selector(CLClippingRatio)];
        if (MJRatio)
        {
            ratio = getRatioObjWith2Value(MJRatio.widthSide, MJRatio.heightSide);
        }
    }
    else
    {
        ratio = getRatioObjWith2Value(0, 0);
    }
    
        
    if (ratio == nil)
    {
        return;
    }
    
    Ivar GridViewIvr = class_getInstanceVariable([SELF class], "_gridView");
    if (GridViewIvr != NULL)
    {
        id GridViewObj = object_getIvar(SELF, GridViewIvr);
        if (GridViewObj)
        {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
            SEL setClippingRatio = @selector(setClippingRatio:);
            if ([GridViewObj respondsToSelector:setClippingRatio])
            {
                [GridViewObj performSelector:setClippingRatio withObject:ratio];
            }
            

   
#pragma clang diagnostic pop
        }
        
        

    }
}


void setupCustomized(id SELF, SEL _cmd)
{
    if (storedSetUp != NULL)
    {
        ((id (*)(id, SEL, ...))storedSetUp)(SELF,_cmd);
        
        if (storedSetCropMenu != NULL)
        {
             ((id (*)(id, SEL, ...))storedSetCropMenu)(SELF,_cmd);
        }
    }
}


@implementation CLClippingTool (CustomizeItems)

+(void)setupWithDataSource:(id<CLClippingToolItemsDataSource>)ds
{
    if(ds && [ds respondsToSelector:@selector(CLClippingRatio)])
    {
        dataSource = ds;
        [CLClippingTool swizzleSetCropMenu];
        //[CLClippingTool swizzleSetup];
    }
}

+(void)restore
{
    dataSource = nil;
    [CLClippingTool restoreCropMenu];
}


+(void)swizzleSetCropMenu
{
    if (storedSetCropMenu == NULL)
    {
        IMP tmp = (IMP)setCropMenuCustomized;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
        SEL selBeRelpaced = @selector(setCropMenu);
#pragma clang diagnostic pop
        
        [CLClippingTool swizzle:selBeRelpaced with:tmp store:&storedSetCropMenu];
    }
    
}

+(void)restoreCropMenu
{
    if (storedSetCropMenu != NULL)
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
        SEL selBeRelpaced = @selector(setCropMenu);
#pragma clang diagnostic pop
        
        [CLClippingTool swizzle:selBeRelpaced with:storedSetCropMenu store:nil];
        storedSetCropMenu = NULL;
    }
}

+(void)swizzleSetup
{
    IMP tmp = (IMP)setupCustomized;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    SEL selBeRelpaced = @selector(setup);
#pragma clang diagnostic pop
    
    [CLClippingTool swizzle:selBeRelpaced with:tmp store:&storedSetUp];
}


+ (BOOL)swizzle:(SEL)original with:(IMP)replacement store:(IMPPointer)store
{
    return class_swizzleMethodAndStore(self, original, replacement, store);
}




@end
