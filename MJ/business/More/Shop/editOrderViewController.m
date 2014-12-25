//
//  editOrderViewController.m
//  MJ
//
//  Created by harry on 14/12/25.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import "editOrderViewController.h"
#import "shopBizManager.h"
#import "UtilFun.h"


@interface editOrderViewController ()

@end

@implementation editOrderViewController

@synthesize odr;
@synthesize delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.storeNum.text = odr.goods_num;
    self.goodName.text = odr.bill_name;
    self.goodType.text = odr.bill_spec;
    self.price.text = odr.bill_price;
    self.count.text = odr.bill_num;
    self.total.text = odr.bill_sum;
    self.date.text = odr.bill_date;
    
    
    self.editCount.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.editCount resignFirstResponder];
}


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField             // may be called if forced even if shouldEndEditing returns
{
    
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string  // return NO to not change text
{
    
    if (string.length == 0)
    {
        return YES;
    }
    if ([self isPureInt:string])
    {
        NSMutableString*oldStr = [[NSMutableString alloc] initWithString:textField.text];
        [oldStr insertString:string atIndex:range.location];
        
        if ([self isPureInt:oldStr])
        {
            int value = [oldStr intValue];
            if (value <= [self.storeNum.text  intValue])
            {
                return YES;
            }
        }
        

    }
    return NO;
}

- (IBAction)editCountChanged:(id)sender
{
    
    
}

- (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}



- (BOOL)isPureFloat:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return[scan scanFloat:&val] && [scan isAtEnd];
}



- (IBAction)onCancelEdit:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onSaveEdit:(id)sender
{
    SHOWHUD(self.view);
    
    [shopBizManager editOrder:self.odr WithNewCount:[self.editCount.text integerValue] Success:^(id responseObject) {
        HIDEHUD(self.view);
        [self.navigationController popViewControllerAnimated:YES];
        [delegate dataHasEditd];
    } failure:^(NSError *error) {
        [self.navigationController popViewControllerAnimated:YES];
        HIDEHUD(self.view);
    }];
}
@end
