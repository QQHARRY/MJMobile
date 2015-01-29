//
//  CustomerFilter
//  MJ
//
//  Created by harry on 14-11-23.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomerFilter : NSObject


//job_no	String	用户名 *
//acc_password	String	密码 *
//所属员工工号,表示要查找谁的客户(通 过接口 39 获取的 job_no)
@property (nonatomic, strong) NSString *user_no;
//部 门 编 号( 通 过 接 口38 获 取 的 )dept_current_no
@property (nonatomic, strong) NSString *dept_no;
//区域:比如城内
@property (nonatomic, strong) NSString *house_urban;
//片区:比如钟楼
@property (nonatomic, strong) NSString *house_area;
//需求类型,求租或求购
//求购 200
//求租 201 (此参数在默认客源列表查询时必须有)
@property (nonatomic, strong) NSString *business_requirement_type;
//客源状态
//(此参数在默认客源列表查询时必须有(默 认查有效),字典表里有)
//成交2
//无效3
//暂缓1 有效0
@property (nonatomic, strong) NSString *requirement_status;
//客户姓名
@property (nonatomic, strong) NSString *client_name;
// 客户电话号码
@property (nonatomic, strong) NSString *obj_mobile;
// 最早登记日期
@property (nonatomic, strong) NSString *start_date;
// 最迟登记日期
@property (nonatomic, strong) NSString *end_date;
//FromID	String	若指定此参数，则返回ID比FromID小的记录（即比FromID时间早的公告），默认为0 Database: Customer_trade_no *
@property (nonatomic, strong) NSString *FromID;
//ToID	String	若指定此参数，则返回ID小于或等于ToID的记录，默认为0 *
@property (nonatomic, strong) NSString *ToID;
//Count	Int	单页返回的录条数，最大不超过100，默认为10 *
@property (nonatomic, strong) NSString *Count;

@end

