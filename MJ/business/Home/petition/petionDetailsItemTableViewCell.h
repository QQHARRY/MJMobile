//
//  petionDetailsItemTableViewCell.h
//  MJ
//
//  Created by harry on 14/12/17.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface petionDetailsItemTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *itemName;
@property (strong, nonatomic) IBOutlet UILabel *itemValue;
@property (strong, nonatomic) IBOutlet UITextView *itemTextViewValue;

-(void)initWithValue:(NSString*)value;
@end
