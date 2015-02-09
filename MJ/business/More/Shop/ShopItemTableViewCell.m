//
//  ShopItemTableViewCell.m
//  MJ
//
//  Created by harry on 14/12/24.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import "ShopItemTableViewCell.h"
#import "UtilFun.h"
#import "UIImageView+AFNetworking.h"

@implementation ShopItemTableViewCell

@synthesize goodName;
@synthesize goodType;
@synthesize goodPrice;
@synthesize goodTotalPrice;
@synthesize totalCountRestore;
@synthesize totalCountSelected;

@synthesize unitPrice;
@synthesize totalPrice;
@synthesize selectedCount;
@synthesize maximunNumInStore;


- (void)awakeFromNib {
    // Initialization code
    unitPrice = 0;
    selectedCount = 0;
    totalPrice = 0;
    self.totalCountSelected.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.totalCountSelected resignFirstResponder];
    
}
- (IBAction)subBtnClicked:(id)sender
{
    if (selectedCount <= 0)
    {
        return;
    }
    selectedCount--;
    totalPrice = unitPrice*selectedCount;
    
    goodTotalPrice.text = [NSString stringWithFormat:@"订购金额:%.2f",totalPrice];
    
    totalCountSelected.text = [NSString stringWithFormat:@"%ld",(long)selectedCount];
}
- (IBAction)addBtnClicked:(id)sender
{
    if (selectedCount >= maximunNumInStore)
    {
        return;
    }
    selectedCount++;
    
    totalPrice = unitPrice*selectedCount;
    
    goodTotalPrice.text = [NSString stringWithFormat:@"订购金额:%.2f",totalPrice];
    
    totalCountSelected.text = [NSString stringWithFormat:@"%ld",(long)selectedCount];
}
- (IBAction)BuyBtnClicked:(id)sender
{
    if (self.delegate)
    {
        [self.delegate addShopItemToCart:self.item Count:selectedCount TotalPrice:totalPrice];
    }
}



- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string  // return NO to not change text
{
    if (textField != self.totalCountSelected)
    {
        return YES;
    }
    if (string.length == 0)
    {
        self.selectedCount = [[self.totalCountSelected text] intValue];
        return YES;
    }
    if ([UtilFun isPureInt:string])
    {
        NSMutableString*oldStr = [[NSMutableString alloc] initWithString:textField.text];
        [oldStr insertString:string atIndex:range.location];
        
        if ([UtilFun isPureInt:oldStr])
        {
            int value = [oldStr intValue];
            if (value <= maximunNumInStore)
            {
                self.selectedCount = value;
                return YES;
            }
        }
        
        
    }
    
    return NO;
}

-(void)downLoadImage:(NSURL*)url
{
    [self.goodImage setImageWithURL:url];
}

@end
