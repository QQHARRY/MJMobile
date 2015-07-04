//
//  houseSurveyTableViewController.m
//  MJ
//
//  Created by harry on 15/6/30.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//

#import "houseSurveyTableViewController.h"
#import "UtilFun.h"
#import "Macro.h"
#import "UIImageView+AFNetworking.h"
#import "person.h"
#import "postFileUtils.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import "imageStorageInfo.h"


@interface houseSurveyTableViewController()<UIAlertViewDelegate>

@property (strong, readwrite, nonatomic) RETableViewSection *remarkSection;
@property (strong, readwrite, nonatomic) RELongTextItem*remark;
@property (strong, nonatomic)UIImage*lastImage;
@end

@implementation houseSurveyTableViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createRemarkSection];
    [self createSubmitBtn];
}


-(void)createRemarkSection
{
    self.remarkSection = [RETableViewSection sectionWithHeaderTitle:@"备注"];
    self.remarkSection.headerHeight = 22;
    [self.manager addSection:self.remarkSection];

    self.remark = [RELongTextItem itemWithValue:nil placeholder:@"请输入备注内容"];
    self.remark.cellHeight = 80;
    [self.remarkSection addItem:self.remark];
}

-(void)createSubmitBtn
{
    __weak typeof(self) weakSelf = self;
    RETableViewItem*addBtn = [RETableViewItem itemWithTitle:@"提交实勘" accessoryType:UITableViewCellAccessoryNone selectionHandler:^(RETableViewItem *item)
                              {
                                  PRESENTALERTWITHHANDER_WITHDEFAULTCANCEL(@"您是否确定要提交实勘",@"提交后将发起实勘审批签呈",@"确定", ^()
                                                                           {
                                                                               [self submitSurvey];
                                                                           },@"取消",nil, weakSelf);
                              }];
    addBtn.textAlignment = NSTextAlignmentCenter;
    [self.remarkSection addItem:addBtn];
}



-(void)submitSurvey
{
    if (self.xqtArr == nil || self.xqtArr.count < 1)
    {
        PRESENTALERT(@"必须有一张主图", nil, nil,nil, nil);
    }
    else  if (self.hxtArr == nil || self.hxtArr.count < 1)
    {
        PRESENTALERT(@"必须至少有一张户型图", nil, nil,nil, nil);
    }
    else if (self.sntArr == nil || self.sntArr.count < 1)
    {
        PRESENTALERT(@"必须至少有一张室内图", nil, nil,nil, nil);
    }
    else  if (self.zqtArr == nil || self.zqtArr.count < 1)
    {
        PRESENTALERT(@"必须至少有一张自拍图", nil, nil,nil, nil);
    }
    else  if (self.remark.value == nil || [self.remark.value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length < 1)
    {
        PRESENTALERT(@"备注不能为空", nil, nil,nil, nil);
    }
    else
    {
        if(self.delegate && [self.delegate respondsToSelector:@selector(hasSelectZt:Snt:Hxt:Zpt:Remark:ForHouse:)])
        {
//            NSMutableArray*xqtImageArr = [[NSMutableArray alloc] init];
//            NSMutableArray*sntImageArr = [[NSMutableArray alloc] init];
//            NSMutableArray*hxtImageArr = [[NSMutableArray alloc] init];
//            NSMutableArray*zptImageArr = [[NSMutableArray alloc] init];
//            
//            for (NSDictionary*dic in self.xqtArr)
//            {
//                NSArray*imageArr = [dic allValues];
//                [xqtImageArr addObjectsFromArray:imageArr];  
//            }
//            
//            for (NSDictionary*dic in self.hxtArr)
//            {
//                NSArray*imageArr = [dic allValues];
//                [hxtImageArr addObjectsFromArray:imageArr];
//                
//            }
//            
//            for (NSDictionary*dic in self.sntArr)
//            {
//                NSArray*imageArr = [dic allValues];
//                [sntImageArr addObjectsFromArray:imageArr];
//                
//            }
//            for (NSDictionary*dic in self.zqtArr)
//            {
//                NSArray*imageArr = [dic allValues];
//                [zptImageArr addObjectsFromArray:imageArr];
//                
//            }
            
            [self.delegate hasSelectZt:self.xqtArr Snt:self.sntArr Hxt:self.hxtArr Zpt:self.zqtArr Remark:self.remark.value ForHouse:self.houseDtl];
        }
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
        
    
}

-(NSString*)keyForSection:(RETableViewSection*)section
{
    NSString*strImageFor = @"";
    if (self.curSection == self.xqtSection)
    {
        strImageFor = @"zt";
    }
    else if (self.curSection == self.hxtSection)
    {
        strImageFor = @"hxt";
    }
    else if (self.curSection == self.sntSection)
    {
        strImageFor = @"snt";
    }
    else if (self.curSection == self.zptSection)
    {
        strImageFor = @"zpt";
    }
    
    return strImageFor;
}

-(void)adjustCurSectionItemsAfterAddNewImage:(UIImage*)image
{
    
    RETableViewItem*item = [[RETableViewItem alloc] init];
    CGFloat scale =  (self.view.frame.size.width-30)/image.size.width;
    UIImage*covertedImg = [UtilFun scaleImage:image toScale:scale];
    item.cellHeight = image.size.height * scale;
    item.image = covertedImg;
    
    if (self.curSection == self.hxtSection)
    {
        [self.hxtSection removeLastItem];
        [self.hxtSection addItem:item ];
        [self createAddImageButton:self.hxtSection];
    }
    else if (self.curSection == self.sntSection)
    {
        [self.sntSection removeLastItem];
        [self.sntSection addItem:item];
        [self createAddImageButton:self.sntSection];
    }
    else if (self.curSection == self.xqtSection)
    {
        [self.xqtSection removeAllItems];
        [self.xqtSection addItem:item];
        [self createAddImageButton:self.xqtSection];
    }
    else if(self.curSection == self.zptSection)
    {
        [self.zptSection removeLastItem];
        [self.zptSection addItem:item];
        [self createAddImageButton:self.zptSection];
    }

}

-(NSMutableArray*)arrForCurSection
{
    NSMutableArray*arr = nil;
    if (self.curSection == self.hxtSection)
    {
        if (self.hxtArr ==nil)
        {
            self.hxtArr = [[NSMutableArray alloc] init];
        }
        arr = self.hxtArr;
    }
    else if (self.curSection == self.sntSection)
    {
        if (self.sntArr ==nil)
        {
            self.sntArr = [[NSMutableArray alloc] init];
        }
        arr = self.sntArr;
    }
    else if (self.curSection == self.zptSection)
    {
        if (self.zqtArr ==nil)
        {
            self.zqtArr = [[NSMutableArray alloc] init];
        }
        arr = self.zqtArr;
    }
    else
    {
        if (self.xqtArr ==nil)
        {
            self.xqtArr = [[NSMutableArray alloc] init];
        }
        
        [self.xqtArr removeAllObjects];
        arr = self.xqtArr;
    }
    return arr;
}

-(void)saveAddedImage:(UIImage*)image
{
    NSMutableArray*arr = [self arrForCurSection];
    
    NSString*key = [self keyForSection:self.curSection];
    [arr addObject:[NSDictionary dictionaryWithObject:image forKey:key]];
}
-(void)saveAddedImageInfo:(imageStorageInfo*)info
{
    NSMutableArray*arr = [self arrForCurSection];
    
    NSString*key = [self keyForSection:self.curSection];
    
    [arr addObject:info];
}

-(void)imageEditor:(CLImageEditor *)editor didFinishEdittingWithImage:(UIImage *)image
{
    __weak typeof(self) weakSelf = self;
    if (image && [weakSelf.lastestMimeType isEqualToString:(NSString *)kUTTypeImage])
    {
        //这里必须在alert dismiss之后显示hud，否则在alert消失的时候，hud也会跟随消失
        
        _lastImage = image;
        UIAlertView*alert = [[UIAlertView alloc] initWithTitle:@"确定添加图片?" message:@"点击 确定 上传保存图片" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        [alert show];
    }
}


-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            SHOWWINDOWHUD(@"正在上传图片");
        });
        
        NSString*strImageFor = [self keyForSection:self.curSection];
        
        [self uploadImage:_lastImage WithStorageNo:self.parentPictureID Topic:strImageFor Success:^(imageStorageInfo *info) {
            
            [self adjustCurSectionItemsAfterAddNewImage:_lastImage];
            [self saveAddedImageInfo:info];
            _lastImage = nil;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                HIDEHUD_WINDOW;
            });
        } failure:^(NSError *error) {
            __block NSString*err = [error description
                                    ];
            dispatch_async(dispatch_get_main_queue(), ^{
                PRESENTALERT(@"上传失败,请稍候重试.",err, nil,nil, nil);
                HIDEHUD_WINDOW;
                
            });
        }];
    }
    else
    {
        _lastImage = nil;
    }
}


-(void)uploadImage:(UIImage*)image WithStorageNo:(NSString*)storageNo Topic:(NSString*)topic Success:(void(^)(imageStorageInfo* info))success failure:(void (^)(NSError *error))failure
{

    NSMutableDictionary*paramDic = [[NSMutableDictionary alloc] init];
    NSURL*url = [NSURL URLWithString:IMAGE_SERVER_URL];
    NSData*data = UIImageJPEGRepresentation(image, 1.0);
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit |
    NSMonthCalendarUnit |
    NSDayCalendarUnit |
    NSWeekdayCalendarUnit |
    NSHourCalendarUnit |
    NSMinuteCalendarUnit |
    NSSecondCalendarUnit;
    comps = [calendar components:unitFlags fromDate:date];
    int year= (int)[comps year];
    int month = (int)[comps month];
    int day = (int)[comps day];
    
    NSString*filePath = [NSString stringWithFormat:@"surveyPhotos/%d/%d/%d/%@/%@/",year,month,day,storageNo,topic];
    [paramDic setValue:filePath forKey:@"filePath"];
    [paramDic setValue:@"600,450" forKey:@"fileSize"];
    [paramDic setValue:@"260,195" forKey:@"thumbSize"];
    
    
    [postFileUtils postFileWithURL:url data:data  Parameter:paramDic ServerParamName:@"upload_file" FileName:@"upload_file" MimeType:@"image/jpeg" Success:^(id responseObj){
        imageStorageInfo*info = [[imageStorageInfo alloc] init];
        
        info.fileName = [responseObj objectForKey:@"fileName"];
        info.filePath = [responseObj objectForKey:@"file_path"];
        
        info.thumbPath = [responseObj objectForKey:@"thumb_path"];
        info.topic = topic;
        
        info.storageNo = storageNo;

        
        success(info);
    } failure:^(NSError *error) {
        failure(error);
    }];
}





@end
