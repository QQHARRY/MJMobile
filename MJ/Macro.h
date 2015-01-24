


// Server
#define SERVER_ADD @"http://115.28.76.58:9090/KWOA/"
#define SERVER_URL @"http://115.28.76.58:9090/KWOA/device/"
#define SERVER_URL_NOAPI @"http://115.28.76.58:9090/KWOA"
// API
// 1.申请绑定设备
#define API_REG @"login/regDevice"
// 2.登录
#define API_LOGIN @"login/appLogin"
// 4.获取公告列表
#define API_ANNC_LIST @"home/getPublicANNCList"
// 6.获取签呈列表
#define API_PETITION_LIST @"home/getPetitionList"
// 7.获取签呈详情
#define API_PETITION_DETAIL @"home/getPetitionDetails"
// 10.签呈审批
#define API_PETITION_APPROVE @"home/petitionApproving"
// 11.获取未读跟进提醒数量
#define API_ALERT_COUNT @"home/getAlertCount"
// 12.获取跟进提醒列表
#define API_ALERT_LIST @"home/getAlertList"
// 13.标记跟进提醒
#define API_ALERT_FINISH @"home/alertFinished"
//未读站内信
#define API_UNREAD_MSG_COUNT @"home/getUnreadMessageCount"
//获取部门的子部门
#define API_GET_SUB_DEPT @"person/getContractDeptSubDept"
//获取部门的直接下属人员
#define API_GET_SUB_PERSON @"person/getContractDeptUsrlist"

//编辑个人信息
#define EDIT_STAFF_INFO @"person/editStaffInfo"
//修改密码
#define EDIT_PIN_NO @"person/editPinNo"
//意见反馈
#define SUGGESTION_FEEDBACK @"other/sendAdvise"

//商店
//获取个人/门店物品列表
#define GET_SHOP_ITEM_LIST @"shopping/getPersonalDeptGoodsList"
#define ADD_ITEM_TO_CART @"shopping/addPersonalDeptOrder"
#define GET_ORDER_LIST @"shopping/getPersonalDeptOrderList"
#define CANCEL_ORDER_LIST @"shopping/cancelPersonalDeptOrderBill"
#define CONFIRM_ORDER_LIST @"shopping/addPersonalDeptBill"
#define GET_ALL_KINDS_ORDER_LIST @"shopping/getPersonalDeptBillList"
#define GET_SIGN_ORDER_LIST @"shopping/signPersonalDeptBill"
#define EDIT_ORDER_BY_NUMBER @"shopping/editPersonalDeptOrder"
//站内信
#define GET_INNER_MESSAGE_LIST @"home/getMessageList"
#define SEND_INNER_MESSAGE @"home/sendMessage"
#define SET_INNER_MESSAGE_READ_STATUS @"home/setMessageReadAlready"

//推送
#define REG_PUSH_NOTIFICATION @"login/uploadDeviceToken"


//  19.获取房源简要信息列表
#define API_HOUSE_LIST @"business/getRealEstateBriefList"

#define API_HOUSE_PARTICULARS @"business/getRealEstateDetails"
#define API_HOUSE_SECRET_PARTICULARS @"business/getRealEstateSecretInfo"
#define API_HOUSE_EDIT_PARTICULARS @"business/editRealEstateDetails"
#define API_HOUSE_GET_BUILDINGS_LIST @"business/getBuildingsList"


//   44.获取城区片区列表
#define API_AREA_LIST @"business/getAreaList"
// 45.获取客源简要信息列表
#define API_CUSTOMER_LIST @"business/getCustomerBriefList"
// 29.获取某房源或客源的跟进列表
#define API_FOLLOW_LIST @"business/getFollowList"
// 31.某房源或客源新增跟进
#define API_CREATE_FOLLOW @"business/createFollow"
// 32.获取带看列表
#define API_APPOINT_LIST @"business/getAppointList"
// 34.获取委托列表
#define API_CONTRACT_LIST @"business/getContractList"
// 36.添加委托
#define API_CREATE_CONSTRACT @"business/newEntrusting"
// 37.新增预约签约
#define API_CREATE_SIGN @"business/appointmentSigning"
// 41.获取所有签约室和签约人列表
#define API_SIGN_CONDITION @"business/getAllPersonRoomList"
// 42获取已占用签约室和签约人以及时段列 表
#define API_SIGN_CONDITION_BUSY @"business/getSigningPersonRoomList"


//字典表
#define GET_DICTIONARY @"business/getDictionary"
//字典表数据库名称
#define DIC_DB_NAME @"dictable.db"
#define DIC_TABLE_NAME @"dictable"

// 字典表类型
#define DIC_FITMENT_TYPE @"fitment_type"
#define DIC_SALE_TRADE_STATE @"sale_trade_state"
#define DIC_LEASE_TRADE_STATE @"lease_trade_state"
#define DIC_CONSIGNMENT_TYPE @"consignment_type"
#define DIC_REQUIREMENT_STATE @"requirement_status"
#define DIC_FOLLOW_TASK_TYPE @"follow_task_type"
#define DIC_APPOINT_EVALUATE @"appoint_evaluate"
#define DIC_TRADE_TYPE @"trade_type"
#define DIC_PAY_SORT @"brokerage_pay_sort"
#define DIC_TENE_APPLICATION @"tene_application"
#define DIC_TENE_TYPE @"tene_type"
#define DIC_HOUSE_DIRECT_TYPE @"house_driect"
#define DIC_USE_SITUATION_TYPE @"use_situation"
#define DIC_CLIENT_SOURCE_TYPE @"client_source"
#define DIC_LOOK_PERMIT_TYPE @"look_permit"
#define DIC_SHOP_RANK_TYPE @"shop_rank"
#define DIC_OFFICE_RANK_TYPE @"office_rank"
#define DIC_CARPORT_RANK_TYPE @"carport_rank"
#define DIC_SEX_TYPE @"sex"


//添加图片
#define ADD_IMAGE @"business/addImage"
#define EDIT_PERSON_PHOTO @"person/editStaffPhoto"


#define DEVICE_IOS @"0"


#define SERVER_NONCOMPLIANCE @"服务器返回错误"
#define SERVER_NONCOMPLIANCE_INFO @"服务器返回的数据不符合要求"
#define SERVER_NONCOMPLIANCE_UNAVALIABLE @"连接服务器失败"