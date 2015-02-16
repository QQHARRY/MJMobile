//
//  SignDetailCell.h
//  MJ
//
//  Created by harry on 14-12-9.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignDetailCell : UITableViewCell

//meeting_sign_apply_no	String	预约签约编号
//buiding_no	String	交易编号
//building_name	Sting	物业地址
//person_apply_name	String	申请人
//room_name	String	签约室
//apply_date	String	申请时间
//apply_time	String	申请时段
//dept_name	String	部门
//person_name	String	签约人
//apply_status	String	申请状态
//0 待审核
//1 审核通过
//2 签约完成

@property (strong, nonatomic) IBOutlet UILabel *no;
@property (strong, nonatomic) IBOutlet UILabel *tno;
@property (strong, nonatomic) IBOutlet UILabel *addr;
@property (strong, nonatomic) IBOutlet UILabel *apper;
@property (strong, nonatomic) IBOutlet UILabel *room;
@property (strong, nonatomic) IBOutlet UILabel *time;
@property (strong, nonatomic) IBOutlet UILabel *block;
@property (strong, nonatomic) IBOutlet UILabel *dept;
@property (strong, nonatomic) IBOutlet UILabel *signer;
@property (strong, nonatomic) IBOutlet UILabel *status;

@end
