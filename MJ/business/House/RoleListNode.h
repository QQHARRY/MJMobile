//
//  RoleListNode.h
//  MJ
//
//  Created by harry on 15/6/30.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//

#import "dic2Object.h"

@interface RoleListNode : dic2Object
//role_type
//int
//角色类型
//0：录入
//1：一般委托（可以继续点击只能上传独家委托）
//2：实勘
//3：钥匙
//4: 独家委托（独家委托就不让再委托了）
//如果此JSON NODE对应的role_type为空说明还没有人上传，可以显示出来进行上传，如果已经有值了就隐藏起来。
@property(strong,nonatomic)NSString*role_type;

//dept_name
//
//经纪人所属部门名称
@property(strong,nonatomic)NSString*dept_name;

//name_full
//
//经纪人姓名
@property(strong,nonatomic)NSString*name_full;

//obj_mobile
//
//经纪人电话
@property(strong,nonatomic)NSString*obj_mobile;

//photo
//
//经纪人头像
@property(strong,nonatomic)NSString*photo;

//role_commission_ratio
//
//业绩分配比例
@property(strong,nonatomic)NSString*role_commission_ratio;

//dept_current_no
//
//经纪人所属部门编号
@property(strong,nonatomic)NSString*dept_current_no;

//job_no
//
//经纪人工号
@property(strong,nonatomic)NSString*job_no;

@end
