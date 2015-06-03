//
//  RFToolbarButton.m
//
//  Created by Rex Finn on 12/3/13.
//  Copyright (c) 2013 Rex Finn. All rights reserved.
//

#import "RFToolbarButton.h"

@implementation RFToolbarButton

static UITextView *textView = NULL;
static UITextField *textField = NULL;

- (id)init
{
    CGSize sizeOfText = [[self titleForButton] sizeWithAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:14.f]}];
    
    self = [super initWithFrame:CGRectMake(0, 0, sizeOfText.width + 18.104, sizeOfText.height + 10.298)];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:1 alpha:1.0];
        
        self.layer.cornerRadius = 5.0f;
        self.layer.borderWidth = 0.5f;
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
        
        [self setTitle:[self titleForButton] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor colorWithRed:0x01/255.0 green:0xAF/255.0 blue:0xE8/255.0 alpha:1] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor greenColor] forState:UIControlStateHighlighted];
        
        self.titleLabel.font = [UIFont systemFontOfSize:14.f];
        self.titleLabel.textColor = [UIColor colorWithWhite:0.500 alpha:1.0];
        
        [self addTarget:self action:@selector(buttonTarget) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

+ (void)setTextViewForButton:(UITextView*)textViewPassed {
    textView = textViewPassed;
}

+ (UITextView*)textView {
    return textView;
}

+ (void)setTextFieldForButton:(UITextField*)textFieldPassed {
    textField = textFieldPassed;
}

+ (UITextField*)textField {
    return textField;
}

- (NSString*)titleForButton {
    return nil;
}

-(void)buttonTarget {}

@end
