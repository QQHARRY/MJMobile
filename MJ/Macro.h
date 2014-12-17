


// Server
#define SERVER_URL @"http://115.28.76.58:9090/KWOA/device/"

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
#define API_PETITION_APPROVE @"petitionapproving"
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


#define DEVICE_IOS @"0"

//#define API_LOGIN @"applogin"
//#define API_LOGIN @"applogin"
//#define API_LOGIN @"applogin"
//#define API_LOGIN @"applogin"



#define SERVER_NONCOMPLIANCE @"服务器返回数据错误"
#define SERVER_NONCOMPLIANCE_INFO @"服务器返回的数据不符合要求"
#define SERVER_NONCOMPLIANCE_UNAVALIABLE @"连接服务器失败"