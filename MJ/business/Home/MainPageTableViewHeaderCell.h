//
//  MainPageTableViewHeaderCell.h
//  MJ
//
//  Created by harry on 14-12-6.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainPageTableViewHeaderCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *titleLab;
- (IBAction)btnClicked:(id)sender;

@property(strong,nonatomic) void (^action)(UIButton*);

-(void)initWithTitle:(NSString*)title andAction:(void(^)(UIButton*))act;

@end
