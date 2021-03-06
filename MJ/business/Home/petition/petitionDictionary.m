//
//  petitionDictionary.m
//  MJ
//
//  Created by harry on 14/12/17.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import "petitionDictionary.h"

static NSMutableDictionary*patternDic = nil;

static NSArray*publicFiledsArray = nil;

@implementation petitionDictionary


+(NSDictionary*)getPatternDic
{
    static dispatch_once_t pred = 0;

    dispatch_once(&pred, ^{
        
        patternDic = [[NSMutableDictionary alloc]init];
      
        //        一、（门店/部门）事宜：  flowtype： Shop_Affairs或Department_Affairs
        {
            
            //
            //        QC 编号
            //        name_full 姓名
            //        department_name 部门
            //        acc_create_date 日期
            //        apply_category 主旨：关于XXX事宜
            //        dept_name 承办单位
            //        task_performer_no 汇办部门
            //        apply_reason 说明
            NSDictionary*shopOrDeptAffairs =
            @{
              @"affairTypes":
                  @[
                      @"Shop_Affairs",@"Department_Affairs"
                      ],
              
              @"Fields":
                  @[
                      @{@"QC":@"编号"},
                      @{@"name_full": @"姓名"},
                      @{@"department_name": @"部门"},
                      @{@"acc_create_date": @"日期"},
                      @{@"apply_category": @"主旨"},
                      @{@"dept_name": @"承办单位"},
                      @{@"task_performer_no": @"汇办部门"},
                      @{@"apply_reason": @"说明"}
                      ]
              };
            [patternDic setValue:shopOrDeptAffairs forKey:@"shopOrDeptAffairs"];
        }
        //        二、（门店/部门）停薪留职：flowtype：Shop_Suspend_Salary或Department_Suspend_Salary
        {
            //
            //        QC 编号
            //        person_units 单位
            //        job_no 工号
            //        fill_time 填表时间
            //        name_full 姓名
            //        department_name 部门
            //        suspension_date 停职时间
            //        person_jobs 职位
            //        entry_date 入职时间
            //        return_date 返岗时间
            //        apply_result申请事由请说明
            //        staff_sign 员工签名
            NSDictionary*suspendAffairs =
            @{
              @"affairTypes":
                  @[
                      @"Shop_Suspend_Salary",@"Department_Suspend_Salary"
                      ],
              
              @"Fields":
                  @[
                      @{@"QC": @"编号"},
                      @{@"person_units": @"单位"},
                      @{@"job_no": @"工号"},
                      @{@"fill_time": @"填表时间"},
                      @{@"name_full": @"姓名"},
                      @{@"department_name": @"部门"},
                      @{@"suspension_date": @"停职时间"},
                      @{@"person_jobs": @"职位"},
                      @{@"entry_date": @"入职时间"},
                      @{@"return_date": @"返岗时间"},
                      @{@"apply_result": @"申请事由请说明"},
                      @{@"staff_sign": @"员工签名"}
                      ]
              };
            
            [patternDic setValue:suspendAffairs forKey:@"suspendAffairs"];
        }
        
        
        //        三、区域调动：flowtype：Area_Transfer
        {
            //
            //        QC 编号
            //        person_units 单位
            //        bwage_user_jobno 工号
            //        acc_create_time 时间
            //        name_full 姓名
            //        original_department 原部门
            //        original_job_name 原岗位
            //        technical_post_name 原职称
            //        person_department_no 预调部门
            //        person_job_no 预调岗位
            //        person_technical_post_no 预调职称
            //        record_mod_date 生效日期
            //        bwage_user_level 调动薪酬
            //        old_wage 调动前薪酬
            //        bwage_user_value 调动后薪酬
            //        record_mod_result 调动原因
            
            NSDictionary*areaTransferAffairs =
            @{
              @"affairTypes":
                  @[
                      @"Area_Transfer"
                      ],
              
              @"Fields":
                  @[
                      @{@"QC" : @"编号"},
                      @{@"person_units" : @"单位"},
                      @{@"bwage_user_jobno" : @"工号"},
                      @{@"acc_create_time" : @"时间"},
                      @{@"name_full" : @"姓名"},
                      @{@"original_department" : @"原部门"},
                      @{@"original_job_name" : @"原岗位"},
                      @{@"technical_post_name" : @"原职称"},
                      @{@"person_department_no" : @"预调部门"},
                      @{@"person_job_no" : @"预调岗位"},
                      @{@"person_technical_post_no" : @"预调职称"},
                      @{@"record_mod_date" : @"生效日期"},
                      @{@"bwage_user_level" : @"调动薪酬"},
                      @{@"old_wage" : @"调动前薪酬"},
                      @{@"bwage_user_value" : @"调动后薪酬"},
                      @{@"record_mod_result" : @"调动原因"}
                      ]
              };
            
            [patternDic setValue:areaTransferAffairs forKey:@"areaTransferAffairs"];
        }
        
        
        //        四、（门店/部门）请假：flowtype：Shop_Leave或Department_Leave
        {
            //
            //        QC 编号
            //        job_no 工号
            //        fill_time 填表时间
            //        name_full 姓名
            //        department_name 部门
            //        person_jobs 职位
            //        attendance_vacrec_name 请假类别
            //        attendance_vacrec_reason 请假原因
            //        mortgage_begin 请假时间起始
            //        mortgage_end 请假时间截止
            //        date 请假共计天数
            NSDictionary*shopLeaveAffairs =
            @{
              @"affairTypes":
                  @[
                      @"Shop_Leave",@"Department_Leave"
                      ],
              
              @"Fields":
                  @[
                      @{@"QC" : @"编号"},
                      @{@"job_no" : @"工号"},
                      @{@"fill_time" : @"填表时间"},
                      @{@"name_full" : @"姓名"},
                      @{@"department_name" : @"部门"},
                      @{@"person_jobs" : @"职位"},
                      @{@"attendance_vacrec_name" : @"请假类别"},
                      @{@"attendance_vacrec_reason" : @"请假原因"},
                      @{@"mortgage_begin" : @"请假时间起始"},
                      @{@"mortgage_end" : @"请假时间截止"},
                      @{@"date" : @"请假共计天数"}
                      ]
              };
            
            [patternDic setValue:shopLeaveAffairs forKey:@"shopLeaveAffairs"];
        }
        
        
        
        //        五、（门店/部门）离职：flowtype：Shop_Resign或Department_Resign
        {
            //        
            //        QC 编号
            //        person_units 单位
            //        job_no 工号
            //        fill_time 填表时间
            //        name_full 姓名
            //        department_name 部门
            //        person_sign 本人签字
            //        job_name 职位
            //        join_date 入职时间
            //        left_date 离职时间
            //        left_category 离职类型
            //        left_reason_type 离职原因类型
            //        left_usual 辞职原因
            //        left_reason 离职（辞退）原因
            //        left_memo 离职员工对公司的发展建议
        
            NSDictionary*resignAffairs =
            @{
              @"affairTypes":
                  @[
                      @"Shop_Resign",@"Department_Resign"
                      ],
              
              @"Fields":
                  @[
                      @{@"QC" : @"编号"},
                      @{@"person_units" : @"单位"},
                      @{@"job_no" : @"工号"},
                      @{@"fill_time" : @"填表时间"},
                      @{@"name_full" : @"姓名"},
                      @{@"department_name" : @"部门"},
                      @{@"person_sign" : @"本人签字"},
                      @{@"job_name" : @"职位"},
                      @{@"join_date" : @"入职时间"},
                      @{@"left_date" : @"离职时间"},
                      @{@"left_category" : @"离职类型"},
                      @{@"left_reason_type" : @"离职原因类型"},
                      @{@"left_usual" : @"辞职原因"},
                      @{@"left_reason" : @"离职（辞退）原因"},
                      @{@"left_memo" : @"离职员工对公司的发展建议"}
                      ]
              };
            
            [patternDic setValue:resignAffairs forKey:@"resignAffairs"];
        }
        
        
        //        六、（门店/部门）请款：flowtype：ShopBorrowings或DepartmentBorrowings
        {
            //
            //        QC 编号
            //        department_name 店名/部门
            //        bills_reasons 事由
            //        bills_money 请款金额小写
            //        bills_money_capital 请款金额大写
            //        apply_name_full 申请人
            //        apply_date 申请日期
            NSDictionary*borrowingsAffairs =
            @{
              @"affairTypes":
                  @[
                      @"ShopBorrowings",@"DepartmentBorrowings"
                      ],
              
              @"Fields":
                  @[
                      @{@"QC" : @"编号"},
                      @{@"department_name" : @"店名/部门"},
                      @{@"bills_reasons" : @"事由"},
                      @{@"bills_money" : @"请款金额小写"},
                      @{@"bills_money_capital" : @"请款金额大写"},
                      @{@"apply_name_full" : @"申请人"},
                      @{@"apply_date" : @"申请日期"}
                      ]
              };
            
            [patternDic setValue:borrowingsAffairs forKey:@"borrowingsAffairs"];
        }
        
        
        
        //        七、案件签呈：flowtype：案件签呈__转定转佣（Case_ZDY），案件签呈__转违约（Case_ZWY），案件签呈__佣金打折（Case_YJDZ），案件签呈__意向金退款（Case_TKYXJ），案件签呈__佣金退款（Case_YJTK），案件签呈__转房款案件费（Case_ZFK_AJF）
        {
            //
            //        QC 编号
            //        DevelopShop 开发店
            //        store 销售店
            //        case 案名
            //        ownerName 出售/出租方姓名
            //        customerName 买/承租方姓名
            //        project 项目
            //        receipt_payment_date 收款时间
            //        receipt_money 收款金额小写
            //        receipt_money_capital 收款金额大写
            //        recycling 客户红联是否回收
            //        bills_reasons 事由
            //        bills_money 请款金额小写
            //        bills_money_capital 请款金额大写
            //        payment_date 付款时间
            //        payment_type 付款方式
            //        receipt_receiver 收款人姓名
            //        bank_account 账号
            //        bank 开户行
            //        apply_name_full 申请人
            //        apply_date 申请日期
            NSDictionary*caseAffairs =
            @{
              @"affairTypes":
                  @[
                      @"Case_ZDY",@"Case_ZWY",@"Case_YJDZ",@"Case_TKYXJ",@"Case_YJTK",@"Case_ZFK_AJF"
                      ],
              
              @"Fields":
                  @[
                      @{@"QC" : @"编号"},
                      @{@"DevelopShop" : @"开发店"},
                      @{@"store" : @"销售店"},
                      @{@"case" : @"案名"},
                      @{@"ownerName" : @"出售/出租方姓名"},
                      @{@"customerName" : @"买/承租方姓名"},
                      @{@"project" : @"项目"},
                      @{@"receipt_payment_date" : @"收款时间"},
                      @{@"receipt_money" : @"收款金额小写"},
                      @{@"receipt_money_capital" : @"收款金额大写"},
                      @{@"recycling" : @"客户红联是否回收"},
                      @{@"bills_reasons" : @"事由"},
                      @{@"bills_money" : @"请款金额小写"},
                      @{@"bills_money_capital" : @"请款金额大写"},
                      @{@"payment_date" : @"付款时间"},
                      @{@"payment_type" : @"付款方式"},
                      @{@"receipt_receiver" : @"收款人姓名"},
                      @{@"bank_account" : @"账号"},
                      @{@"bank" : @"开户行"},
                      @{@"apply_name_full" : @"申请人"},
                      @{@"apply_date" : @"申请日期"}
                      ]
              };
            
            [patternDic setValue:caseAffairs forKey:@"caseAffairs"];
        }
        
        
        //        八、房源委托：flowtype：House_Entrust
        {
            //        entrust_department_name 委托部门
            //        entrust_name_full 委托员工
            //        contract_target_object 交易编号 （注：要求点击此BUTTON可以查看此房源信息）
            //        contract_type 委托交易类型
            //        contract_summary 委托类型
            //        contract_pay_sort 付佣
            //        contract_start_date 委托日期起始
            //        contract_end_date 委托日期截止
            //        contract_attachment 委托附件ID
            //        房源委托四种附件类型URL：
            //        entrust_proto_attach 委托协议
            //        prorerty_attach 产权证明
            //        identy_attach 身份证明
            //        other_attach 其他
            NSDictionary*houseEntrustAffairs =
            @{
              @"affairTypes":
                  @[
                      @"House_Entrust"
                      ],
              
              @"Fields":
                  @[
                      @{@"entrust_department_name" : @"委托部门"},
                      @{@"entrust_name_full" : @"委托员工"},
                      @{@"contract_target_object" : @"交易编号"},
                      @{@"contract_type" : @"委托交易类型"},
                      @{@"contract_summary" : @"委托类型"},
                      @{@"contract_pay_sort" : @"付佣"},
                      @{@"contract_start_date" : @"委托日期起始"},
                      @{@"contract_end_date" : @"委托日期截止"},
                      @{@"contract_attachment" : @"委托附件ID"},
                      @{@"entrust_proto_attach" : @"委托协议"},
                      @{@"prorerty_attach" : @"产权证明"},
                      @{@"identy_attach" : @"身份证明"},
                      @{@"other_attach" : @"其他"}
                      ]
              };
            
            [patternDic setValue:houseEntrustAffairs forKey:@"houseEntrustAffairs"];
        }
        
        
     
        
    });
    
    return patternDic;
}

+(NSArray*)getPublicDic
{
    static dispatch_once_t pred = 0;
    
    dispatch_once(&pred, ^{
        
        publicFiledsArray = @[
                      @{@"Version":@"版本"},
                      @{@"StatusDesc": @"状态描述"},
                      @{@"FlowChart": @"状态图"},
                      @{@"nowNode": @"当前节点"},
                      @{@"tkey": @"节点"},
                      @{@"task_status": @"办理状态"}
                      ];
    });
    
    return publicFiledsArray;
}




+(NSArray*)petitionArrByDic:(NSDictionary*)dic
{
    NSMutableArray*retArr = [[NSMutableArray alloc] init];
    NSMutableArray*retArr1 =[[NSMutableArray alloc] init];
    
    NSString*dicFollowType = [dic objectForKey:@"flowtype"];
    if (dicFollowType == nil || [dicFollowType length] == 0)
    {
        return nil;
    }
    
    
    
    
    
    
    NSArray*pubFieldsArr = [self getPublicDic];
    
    for (NSDictionary*filedApairDic in pubFieldsArr)
    {
        NSString*keyString = [[filedApairDic allKeys] objectAtIndex:0];
        keyString = [keyString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSString*valueString = [[filedApairDic allValues] objectAtIndex:0];
        valueString = [valueString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        NSString*findValueInDic = [dic valueForKey:keyString];
        if (findValueInDic)
        {
            NSDictionary*finalKeyPair =@{valueString:findValueInDic};
            [retArr1 addObject:finalKeyPair];
        }
        else
        {
            NSDictionary*finalKeyPair =@{valueString:@"服务器未返回该字段"};
            [retArr1 addObject:finalKeyPair];
        }
        
        
    }
    
    
    NSDictionary*patternDic = [self getPatternDic];
    NSEnumerator*enumerator = [patternDic objectEnumerator];
    for (NSDictionary*patternDic in enumerator.allObjects)
    {
        NSArray*affairTypeArr = [patternDic objectForKey:@"affairTypes"];
        for (NSString*affairType in affairTypeArr)
        {
            if ([affairType isEqualToString:dicFollowType])
            {
                NSArray*affairFieldsArr = [patternDic objectForKey:@"Fields"];
                
                for (NSDictionary*filedApairDic in affairFieldsArr)
                {
                    NSString*keyString = [[filedApairDic allKeys] objectAtIndex:0];
                    keyString = [keyString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                    NSString*valueString = [[filedApairDic allValues] objectAtIndex:0];
                    valueString = [valueString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

                    NSString*findValueInDic = [dic valueForKey:keyString];
                    if (findValueInDic)
                    {
                        NSDictionary*finalKeyPair =@{valueString:findValueInDic};
                        [retArr addObject:finalKeyPair];
                    }
                    else
                    {
                        NSDictionary*finalKeyPair =@{valueString:@"服务器未返回该字段"};
                        [retArr addObject:finalKeyPair];
                    }
                    
                   
                    
                    
                }
                
                [retArr addObjectsFromArray:retArr1];
                
                return retArr;
                
                
            }
        }
    }
    return nil;
}

@end
