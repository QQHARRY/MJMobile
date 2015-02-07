//
//  petionDetailsItemTableViewCell.m
//  MJ
//
//  Created by harry on 14/12/17.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import "petionDetailsItemTableViewCell.h"

@implementation petionDetailsItemTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    CGSize sz =  [UIScreen mainScreen].bounds.size;
    
    [self setFrame:CGRectMake(0, 0, sz.width,self.frame.size.height)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)initWithValue:(NSString*)value
{
    return;
    self.itemValue.lineBreakMode = NSLineBreakByWordWrapping;
    self.itemValue.numberOfLines = 0;
    CGRect oldFrame = [self frame];
    CGRect itemFrame =  self.itemValue.frame;
    self.itemValue.text = value;
    CGSize sz = [self labelAutoCalculateRectWith:value FontSize:self.itemValue.font.pointSize MaxSize:CGSizeMake(self.itemValue.frame.size.width, 1000)];
    if (sz.height > itemFrame.size.height)
    {
        itemFrame.size.height = 44;
        itemFrame.origin.y = 0;
        [self.itemValue setFrame:itemFrame];
    }
    return;
    
    if (sz.height > 44)
    {
        oldFrame.size.height = sz.height + 10;
        [self setFrame:oldFrame];
    }
    
    
    itemFrame.size = sz;
    itemFrame.origin.y = 5;
    [self.itemValue setFrame:itemFrame];
    
    
    
    
}

- (CGSize)labelAutoCalculateRectWith:(NSString*)text FontSize:(CGFloat)fontSize MaxSize:(CGSize)maxSize

{
    
    NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    
    paragraphStyle.lineBreakMode=NSLineBreakByWordWrapping;
    
    NSDictionary* attributes =@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize],NSParagraphStyleAttributeName:paragraphStyle.copy};
//    [text boundingRectWithSize:<#(CGSize)#> options:<#(NSStringDrawingOptions)#> attributes:<#(NSDictionary *)#> context:<#(NSStringDrawingContext *)#>]
    CGSize labelSize = [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;
    
    
    labelSize.height=ceil(labelSize.height);
    
    labelSize.width=ceil(labelSize.width);
    
    return labelSize;
    
}


@end
