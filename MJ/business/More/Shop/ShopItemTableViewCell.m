//
//  ShopItemTableViewCell.m
//  MJ
//
//  Created by harry on 14/12/24.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import "ShopItemTableViewCell.h"

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
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)subBtnClicked:(id)sender
{
    if (selectedCount <= 0)
    {
        return;
    }
    selectedCount--;
    totalPrice = unitPrice*selectedCount;
    
    goodTotalPrice.text = [NSString stringWithFormat:@"订购金额:%.4f",totalPrice];
    
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
    
    goodTotalPrice.text = [NSString stringWithFormat:@"订购金额:%.4f",totalPrice];
    
    totalCountSelected.text = [NSString stringWithFormat:@"%ld",(long)selectedCount];
}
- (IBAction)BuyBtnClicked:(id)sender
{
    if (self.delegate)
    {
        [self.delegate addShopItemToCart:self.item Count:selectedCount TotalPrice:totalPrice];
    }
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.totalCountSelected resignFirstResponder];
}

-(void)setWidthAndWidth:(CGFloat)width Height:(CGFloat)height
{
    //    self.frame.size.width = rct.size.width/2.0;
    //    self.frame.size.height = rct.si.width/2.0;
}

@end
