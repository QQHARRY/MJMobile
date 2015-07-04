//
//  roleType.h
//  MJ
//
//  Created by harry on 15/6/30.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//

#ifndef MJ_roleType_h
#define MJ_roleType_h

//role_type
//int
//角色类型
//0：录入
//1：一般委托（可以继续点击只能上传独家委托）
//2：实勘
//3：钥匙
//4: 独家委托（独家委托就不让再委托了）
//如果此JSON NODE对应的role_type为空说明还没有人上传，可以显示出来进行上传，如果已经有值了就隐藏起来。


typedef NS_ENUM(NSInteger, MjHouseRoleType) {
    MjHouseRoleTypeRecord=0,
    MjHouseRoleTypeRegularConsignation,
    MjHouseRoleTypeHouseSurvey,
    MjHouseRoleTypeKey,
    MjHouseRoleTypeSoleConsignation
} ;




#endif
