//
//  houseSecretParticulars.h
//  MJ
//
//  Created by harry on 15/1/10.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//

#import "dic2Object.h"

@interface houseSecretParticulars : dic2Object


@property(nonatomic,strong)NSString* client_name;
//业主（姓名）
//String

@property(nonatomic,strong)NSString* obj_mobile;
//手机号码（业主）
//String

@property(nonatomic,strong)NSString* client_gender;
//性别（业主）
//String

@property(nonatomic,strong)NSString* obj_fixtel;
//固定电话（业主）
//String

@property(nonatomic,strong)NSString* client_identity;
//身份证号（业主）
//String

@property(nonatomic,strong)NSString* obj_address;
//联系地址（业主）
//String

@property(nonatomic,strong)NSString* buildname;
//栋座（房源的）
//Int

@property(nonatomic,strong)NSString* unit_name;
//单元（房源的）
//Int

@property(nonatomic,strong)NSString* house_tablet;
//门牌号（房
//的）
//Int

@property(nonatomic,strong)NSString* client_remark;
//备注
//String


@property(nonatomic,strong)NSString*client_salutation;
//业主称呼

@end
