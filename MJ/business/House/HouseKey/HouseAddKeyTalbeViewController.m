//
//  HouseAddKeyTalbeViewController.m
//  MJ
//
//  Created by harry on 15/7/4.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//

#import "HouseAddKeyTalbeViewController.h"
#import "HouseProtectionInfo.h"
#import "houseProtectionDataPuller.h"
#import "UtilFun.h"
#import "RoleListNode.h"
#import "person.h"
#import "roleType.h"
#import "NetWorkManager.h"
#import "Macro.h"



@interface HouseAddKeyTalbeViewController()
@property (strong, readwrite, nonatomic) RETableViewManager *manager;
@property (strong, readwrite, nonatomic)RETableViewSection*section;
@property (strong, readwrite, nonatomic)RETextItem*keyNoItem;
@property (strong, readwrite, nonatomic)RELongTextItem*remark;


@end



@implementation HouseAddKeyTalbeViewController





-(void)viewDidLoad
{
    // Create manager
    [self initTableView];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [self checkProtection];
}

-(void)initTableView
{
    self.manager = [[RETableViewManager alloc] initWithTableView:self.tableView delegate:self];
    self.section = [[RETableViewSection alloc] initWithHeaderTitle:@"添加钥匙"];
    self.section.headerHeight = 44;
    
    
    self.keyNoItem = [[RETextItem alloc] initWithTitle:@"钥匙编号" value:@""];
    self.keyNoItem.placeholder = @"请输入钥匙编号";
    
    
    self.remark = [[RELongTextItem alloc] initWithValue:@"" placeholder:@"请输入备注"];
    
    self.remark.cellHeight = 80;
    
    [self.section addItem:self.keyNoItem];
    [self.section addItem:self.remark];
    
    
    RETableViewItem*item = [RETableViewItem itemWithTitle:@"提交" accessoryType:UITableViewCellAccessoryNone selectionHandler:^(RETableViewItem *item)
                            {
                                [item deselectRowAnimated:YES];
                                [self submitData];
                            }];
    item.textAlignment = NSTextAlignmentCenter;
    [self.section addItem:item];
    
    [self.manager addSection:self.section];
    
}

-(BOOL)isMeTheOwner:(NSArray*)roleList
{
    if (roleList && roleList.count > 0)
    {
        for (RoleListNode* roleNode in roleList)
        {
            if ([roleNode isKindOfClass:[RoleListNode class]])
            {
                if ([roleNode.role_type intValue] == MjHouseRoleTypeRecord && [roleNode.job_no isEqualToString:[person me].job_no])
                {
                    return YES;
                }
            }
        }
    }
    return NO;
}

-(void)checkProtection
{
    //检查房子是否在保护期内
    
    __weak typeof(self) weakSelf = self;
    void (^handle)() = ^{
        if (weakSelf.navigationController)
        {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    };
    SHOWHUD_WINDOW
    [self checkHouseProtection:self.trade_no Success:^(HouseProtectionInfo *info) {
        HIDEHUD_WINDOW
        
        if (info)
        {
            if ([info isInProtection] && ![self isMeTheOwner:self.roleList])
            {
                NSString*protectionInfo = [info getProtectionInfo];
                PRESENTALERT(@"对不起,该房源正在保护期内,目前只允许房源的录入人上传业绩.", protectionInfo, @"OK", handle, self);
            }
        }
        else
        {
            PRESENTALERT(@"获取房源保护期信息失败,请重试", nil, @"OK", handle, self);
        }
        
        
    } failure:^(NSError *error) {
        HIDEHUD_WINDOW
        PRESENTALERT(@"获取房源保护期信息失败,请重试", nil, @"OK", handle, self);
    }];

}


-(void)checkHouseProtection:(NSString*)tradeNo Success:(void(^)( HouseProtectionInfo* info))success failure:(void (^)(NSError *error))failure
{
    
    [houseProtectionDataPuller pullProtection:tradeNo Success:^(HouseProtectionInfo * info)
     {
         if (success)
         {
             success(info);
         }
     } failure:^(NSError *error) {
         if (failure)
         {
             failure(error);
         }
     }];
    
    
}

-(void)submitData
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:self.keyNoItem.value forKey:@"key_reg_no"];
    [param setValue:self.trade_no forKey:@"trade_no"];
    [param setValue:self.remark.value forKey:@"remark"];
    
    __weak typeof(self) weakSelf = self;
    void (^handle)() = ^{
        if (weakSelf.navigationController)
        {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    };
    
    SHOWWINDOWHUD(@"正在上传钥匙");
    [NetWorkManager PostWithApiName:API_ADD_HOUSE_KEY parameters:param success:^(id responseObject)
     {
         HIDEHUD_WINDOW
         NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         if ([[resultDic objectForKey:@"Status"] intValue] == 0)
         {
             PRESENTALERT(@"添加钥匙成功", @"", @"OK", handle, self);
         }
         else
         {
             NSString*errInfo = [resultDic objectForKey:@"ErrorInfo"];
             PRESENTALERT(@"添加失败,服务器错误,请重试.", errInfo, @"OK", handle, self);
         }
         
     }
                            failure:^(NSError *error)
     {
         HIDEHUD_WINDOW
         NSString*errStr = [error description];
         PRESENTALERT(@"添加失败,服务器错误,请重试.", errStr, @"OK", handle, self);
     }];
}
@end
