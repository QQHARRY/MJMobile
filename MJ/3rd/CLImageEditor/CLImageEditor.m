//
//  CLImageEditor.m
//
//  Created by sho yakushiji on 2013/10/17.
//  Copyright (c) 2013年 CALACULU. All rights reserved.
//

#import "CLImageEditor.h"

#import "ViewController/_CLImageEditorViewController.h"

@interface CLImageEditor ()

@end


@implementation CLImageEditor

- (id)initWithImage:(UIImage*)image
{
    return [[_CLImageEditorViewController alloc] initWithImage:image];
}

- (id)initWithImage:(UIImage*)image SingleEditting:(BOOL)singleEdit SingleEdittingClass:(Class)cls
{
    _CLImageEditorViewController* editor = [[_CLImageEditorViewController alloc] initWithImage:image];
    editor.singleEditting = singleEdit;
	if (singleEdit)
	{
		editor.singleEdittingClass = cls;
	}
	else
	{
		editor.singleEdittingClass = NULL;
	}
	
    return editor;
}

@end

