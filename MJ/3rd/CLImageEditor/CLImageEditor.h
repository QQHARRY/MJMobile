//
//  CLImageEditor.h
//
//  Created by sho yakushiji on 2013/10/17.
//  Copyright (c) 2013年 CALACULU. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CLImageEditorDelegate;

@interface CLImageEditor : UIViewController
{
    
}
@property (nonatomic, weak) id<CLImageEditorDelegate> delegate;

- (id)initWithImage:(UIImage*)image;
- (id)initWithImage:(UIImage*)image SingleEditting:(BOOL)singEdit SingleEdittingClass:(Class)cls;
@end



@protocol CLImageEditorDelegate <NSObject>
@required
- (void)imageEditor:(CLImageEditor*)editor didFinishEdittingWithImage:(UIImage*)image;

@optional
- (void)imageEditorDidCancel:(CLImageEditor*)editor;

@end