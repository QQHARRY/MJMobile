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
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
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
            if ([name isEqualToString:@"obj_mobile"])
            {
                //只有特殊编辑权限(edit_permit 等于"1")才可以修改手机号码
                if ([self.housePtcl.edit_permit isEqualToString:@"1"])
                {
                    [self.infoSection addItem:item];
                }
            }
            else
            {
                [self.infoSection addItem:item];
            }
            
        }
    }
    
    self.structure_area.value = self.housePtcl.structure_area;

    [self adjustByTeneApplication];
    
    //[self createWatchImageBtn];
}

- (void)createWatchImageBtn
{
    __typeof (&*self) __weak weakSelf = self;
    self.watchHouseImages = [RETableViewItem itemWithTitle:@"点击查看并编辑图片" accessoryType:UITableViewCellAccessoryNone selectionHandler:^(RETableViewItem *item)
                             {
                                 if(self.houseImageCtrl == nil)
                                 {
                                     self.houseImageCtrl = [[houseImagesTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
                                     self.houseImageCtrl.housePtcl = self.housePtcl;
                                     self.houseImageCtrl.houseDtl = self.houseDtl;
                                     self.houseImageCtrl.watchMode = EDITMODE;
                                 }
                                 
                                 
                                 [weakSelf.navigationController pushViewController:self.houseImageCtrl animated:YES];
                             }];
    self.watchHouseImages.textAlignment = NSTextAlignmentCenter;
    [self.infoSection addItem:self.watchHouseImages];
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
        
        [dic setValue:self.houseDtl.trade_no forKey:@"trade_no"];
        [dic setValue:self.housePtcl.edit_permit forKey:@"edit_permit"];
        SHOWHUD_WINDOW;
        [HouseDataPuller pushHouseEditedParticulars:dic Success:^(houseSecretParticulars *housePtl) {
            HIDEHUD_WINDOW;
            SEL sel = @selector(setNeedRefresh);
            if (self.delegate && [self.delegate respondsToSelector:sel])
            {
                [self.delegate performSelector:sel];
            }
            
            PRESENTALERT(@"编辑成功",@"",@"OK",^()
                                  {
                                      [self.navigationController popViewControllerAnimated:YES];
                                  }
                         ,self);

            
        } failure:^(NSError *error) {
            HIDEHUD_WINDOW;
            NSString*errorStr = [NSString stringWithFormat:@"%@",error];
            PRESENTALERT(@"编辑失败",errorStr,@"OK",^()
                                  {
                                      [self.navigationController popViewControllerAnimated:YES];
                                  }
                                  ,self);  
        }];
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
