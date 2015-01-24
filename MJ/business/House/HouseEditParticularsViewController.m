//
//  HouseEditParticularsViewController.m
//  MJ
//
//  Created by harry on 15/1/12.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//

#import "HouseEditParticularsViewController.h"
#import "dictionaryManager.h"
#import "HouseDataPuller.h"
#import <objc/runtime.h>
#import "UtilFun.h"

@interface HouseEditParticularsViewController ()

@end

@implementation HouseEditParticularsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.housePtcl)
    {
        //[self prepareInfoSectionItems];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getData
{
    [self reloadUI];
}

-(void)reloadUI
{

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(sumitBtnClicked:)];

    [self prepareSections];
    [self prepareItems];
    [self.tableView reloadData];
}

//-(void)createSections
//{
//    CGFloat sectH = 1;
//    self.infoSection = [RETableViewSection sectionWithHeaderTitle:@""];
//    self.infoSection.headerHeight = sectH;
//}

-(void)prepareSections
{
    [self.manager removeAllSections];
    [self.manager addSection:self.infoSection];
    
}

-(void)prepareItems
{
    [self prepareInfoSectionItems];
    
}
-(void)prepareInfoSectionItems
{
    [super createInfoSectionItems];
    [super createSecretSectionItems];
    [self.infoSection removeAllItems];
    
    NSArray*arr = [super getEditAbleFields];

    for (NSString* name in arr)
    {
        id item = [self instanceOfName:name];
        if (item != nil && [item isKindOfClass:[RETableViewItem class]])
        {
            NSLog(@"add item =%@",name);
            [self.infoSection addItem:item];
        }
    }
    
    self.build_structure_area.value = self.housePtcl.build_structure_area;

    [self adjustByTeneApplication];
}




-(void)sumitBtnClicked:(id)sender
{
    if (self.housePtcl && self.houseSecretPtcl)
    {
         NSMutableDictionary*dic = [[NSMutableDictionary alloc] init];
        
        NSArray*arr = [self.infoSection items];
        
        for (RETableViewItem* item in arr)
        {
            NSString*name = [self nameOfInstance:item];
            if (name && [name hasPrefix:@"_"])
            {
                name = [name substringFromIndex:1];
                if ([name length] > 0)
                {
                    SEL sel =@selector(value);
                    if ([item respondsToSelector:sel])
                    {
                        NSString*vl = [item performSelector:sel];
                        NSString*tmp = [self convertToDicValueForItem:name FromValue:vl];
                        if ([tmp length] > 0)
                        {
                            vl = tmp;
                        }
                        [dic setValue:vl forKey:name];
                    }
                    
                }
            }
            
        }
        
        [dic setValue:self.houseDtl.house_trade_no forKey:@"house_trade_no"];
        SHOWHUD_WINDOW;
        [HouseDataPuller pushHouseEditedParticulars:dic Success:^(houseSecretParticulars *housePtl) {
            HIDEHUD_WINDOW;
            SEL sel = @selector(setNeedRefresh);
            if (self.delegate && [self.delegate respondsToSelector:sel])
            {
                [self.delegate performSelector:sel];
            }
            
            PRESENTALERTWITHHANDER(@"编辑成功",@"",@"OK",self,^(UIAlertAction *action)
                                  {
                                      [self.navigationController popViewControllerAnimated:YES];
                                  }
                                  );

            
        } failure:^(NSError *error) {
            HIDEHUD_WINDOW;
            NSString*errorStr = [NSString stringWithFormat:@"%@",error];
            PRESENTALERTWITHHANDER(@"编辑失败",errorStr,@"OK",self,^(UIAlertAction *action)
                                  {
                                      [self.navigationController popViewControllerAnimated:YES];
                                  }
                                  );  
        }];
    }
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView.title isEqualToString:@"编辑成功"]
        ||[alertView.title isEqualToString:@"编辑失败"] )
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
