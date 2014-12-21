//
//  HouseViewController.m
//  MJ
//
//  Created by harry on 14-11-23.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import "HouseViewController.h"
#import "NetWorkManager.h"
#import "UtilFun.h"
#import "Macro.h"
#import "person.h"

@interface HouseViewController ()

@end

@implementation HouseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
//    public void getPublicANNCList(RealEstateBriefListSelect mSelect,String trade_type
//                                  ,String sale_trade_state,String lease_trade_state
//                                  ,String FromID,String ToID,String Count) {
//        // TODO Auto-generated method stub
//        if (!mNetword.isNetworkConnected()) {
//            Toast.makeText(mContext, "网络未连接,请连接网络！", Toast.LENGTH_LONG).show();
//        } else {
//            RequestParams mMap = new RequestParams();
//            String usename = abSharedPreferences.getString(Cont.KEY_PERSONAL_USENAME, "");
//            String pass = abSharedPreferences.getString(Cont.KEY_PERSONAL_PASSWORD, "");
//            mMap.put("job_no", usename);
//            mMap.put("acc_password", pass);
//            mMap.put("FromID", FromID);
//            mMap.put("ToID", ToID);
//            mMap.put("Count", Count);
//            mMap.put("trade_type", trade_type);
//            mMap.put("sale_trade_state", sale_trade_state);
//            mMap.put("lease_trade_state", lease_trade_state);
//            mMap.put("consignment_type", mSelect.getConsignment_type());
//            mMap.put("hall_num", mSelect.getHall_num());
//            mMap.put("room_num", mSelect.getRoom_num());
//            mMap.put("buildname", mSelect.getBuildname());
//            mMap.put("house_unit", mSelect.getHouse_unit());
//            mMap.put("house_floor", mSelect.getHouse_floor());
//            mMap.put("house_tablet", mSelect.getHouse_tablet());
//            mMap.put("house_driect", mSelect.getHouse_driect());
//            mMap.put("structure_area_from", mSelect.getStructure_area_from());
//            mMap.put("structure_area_to", mSelect.getStructure_area_to());
//            mMap.put("housearea", mSelect.getHousearea());
//            mMap.put("houseurban", mSelect.getHouseurban());
//            mMap.put("fitment_type", mSelect.getFitment_type());
//            mMap.put("house_floor_from", mSelect.getHouse_floor_from());
//            mMap.put("house_floor_to", mSelect.getHouse_floor_to());
//            mMap.put("sale_value_from", mSelect.getSale_value_from());
//            mMap.put("sale_value_to", mSelect.getSale_value_to());
//            mMap.put("lease_value_rom", mSelect.getLease_value_rom());
//            mMap.put("lease_value_to", mSelect.getLease_value_to());
//            mMap.put("Keyword", mSelect.getKeyword());
//            if(Cont.DEBUG) {
//                Log.e("wop", "房源简要信息列表 上传  mMap  =  " + mMap);
//            }
//            Alur  10:35:32
//            getPublicANNCList(mSelect, "101", "0", "0", "0", "","20");
    
            
            
    NSString* strID = [person me].job_no;
    NSString* strPwd = [person me].password;
    NSDictionary *parameters = @{@"job_no" : strID, @"acc_password" : strPwd, @"DeviceID" : [UtilFun getUDID], @"DeviceType" : DEVICE_IOS};
    [NetWorkManager PostWithApiName:API_HOUSE_LIST parameters:parameters success:
     ^(id responseObject)
     {
         HIDEHUD(self.view);
         NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         NSString*Status = [resultDic objectForKey:@"Status"];
         
         
//         if (Status == nil || [Status  length] <= 0)
//         {
//             [UtilFun presentPopViewControllerWithTitle:SERVER_NONCOMPLIANCE Message:SERVER_NONCOMPLIANCE_INFO SimpleAction:@"OK" Sender:self];
//         }
//         else
//         {
//             NSInteger iStatus = [Status intValue];
//             switch (iStatus)
//             {
//                 case 0:
//                 {
//                     [UtilFun setFirstBinded];
//                     [UtilFun presentPopViewControllerWithTitle:@"绑定成功" Message:@"请等待审核通过或联系管理员" SimpleAction:@"OK"  Handler:^(UIAlertAction *action)
//                      {
//                          [self performSegueWithIdentifier:@"bindOk" sender:self];
//                      }
//                                                         Sender:self];
//                     
//                     return;
//                 }
//                     break;
//                 case 1:
//                 {
//                     [UtilFun presentPopViewControllerWithTitle:@"绑定失败" Message:@"用户名或密码错误,请重新输入" SimpleAction:@"OK" Sender:self];
//                     return;
//                 }
//                     break;
//                 case 2:
//                 {
//                     
//                     [UtilFun setFirstBinded];
//                     [UtilFun presentPopViewControllerWithTitle:@"绑定成功" Message:@"管理员已审核通过,可登陆进入系统" SimpleAction:@"OK"  Handler:^(UIAlertAction *action)
//                      {
//                          [self performSegueWithIdentifier:@"bindOk" sender:self];
//                      }
//                                                         Sender:self];
//                     
//                 }
//                     break;
//                 default:
//                     break;
//             }
//         }
     }
                            failure:^(NSError *error)
     {
         HIDEHUD(self.view);
         NSString*errorStr = [NSString stringWithFormat:@"%@",error];
         [UtilFun presentPopViewControllerWithTitle:SERVER_NONCOMPLIANCE Message:errorStr SimpleAction:@"OK" Sender:self];
         
     }];
    
    SHOWHUD(self.view);

}

- (void)didReceiveMemoryWarning
{
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

@end
