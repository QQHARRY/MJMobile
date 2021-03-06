//
//  ContractAddController.m
//  RETableViewManagerExample
//
//  Created by Roman Efimov on 2/28/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "ContractAddController.h"
#import "dictionaryManager.h"
#import "Macro.h"
#import "ContractDataPuller.h"
#import "UtilFun.h"
#import "person.h"
#import <MobileCoreServices/UTCoreTypes.h>

@interface ContractAddController ()

@property (strong, readwrite, nonatomic) RETableViewManager *manager;

@property (strong, readwrite, nonatomic) RETableViewSection *contractSection;

@property (strong, readwrite, nonatomic) RERadioItem *typeItem;
@property (strong, readwrite, nonatomic) RERadioItem *consignItem;
@property (strong, readwrite, nonatomic) RERadioItem *payItem;
@property (strong, readwrite, nonatomic) RETextItem *regNo;
@property (strong, readwrite, nonatomic) RETextItem *valueTotal;

@property (strong, readwrite, nonatomic) REDateTimeItem *startItem;
@property (strong, readwrite, nonatomic) REDateTimeItem *endItem;

@property (strong, readwrite, nonatomic) RETableViewSection *wtSection;
@property (strong, readwrite, nonatomic) RETableViewSection *qcSection;
@property (strong, readwrite, nonatomic) RETableViewSection *sfSection;
@property (strong, readwrite, nonatomic) RETableViewSection *qtSection;
@property (weak, nonatomic) RETableViewSection *addPicSection;

@property (strong, readwrite, nonatomic) RETableViewSection *commitSection;

@property (nonatomic, strong) NSArray *typeDictList;
@property (nonatomic, strong) NSArray *consignDictList;
@property (nonatomic, strong) NSArray *payDictList;

@property (nonatomic, strong) NSMutableArray *wtImageList;
@property (nonatomic, strong) NSMutableArray *qcImageList;
@property (nonatomic, strong) NSMutableArray *sfImageList;
@property (nonatomic, strong) NSMutableArray *qtImageList;

@property (nonatomic) NSInteger uploadProgress;
@property (nonatomic, strong) NSString *attNo;

@end

@implementation ContractAddController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"添加委托";
    
    // get dict
    self.typeDictList = [dictionaryManager getItemArrByType:DIC_TRADE_TYPE];
    self.consignDictList = [dictionaryManager getItemArrByType:DIC_CONSIGNMENT_TYPE];
    self.payDictList = [dictionaryManager getItemArrByType:DIC_PAY_SORT];
    self.wtImageList = [NSMutableArray array];
    self.qcImageList = [NSMutableArray array];
    self.sfImageList = [NSMutableArray array];
    self.qtImageList = [NSMutableArray array];

    // Create manager
    self.manager = [[RETableViewManager alloc] initWithTableView:self.tableView delegate:self];

    // add section
    self.contractSection = [self addContractControls];
    self.wtSection = [RETableViewSection sectionWithHeaderTitle:@"委托协议"];
    [self.manager addSection:self.wtSection];
    self.qcSection = [RETableViewSection sectionWithHeaderTitle:@"产权证明"];
    [self.manager addSection:self.qcSection];
    self.sfSection = [RETableViewSection sectionWithHeaderTitle:@"身份证明"];
    [self.manager addSection:self.sfSection];
    self.qtSection = [RETableViewSection sectionWithHeaderTitle:@"其他图片"];
    [self.manager addSection:self.qtSection];
    self.commitSection = [self addCommitButton];
    [self reloadImages];
}

-(void)reloadImages
{
    [self.wtSection removeAllItems];
    [self addWtControls];
    [self.qcSection removeAllItems];
    [self addQcControls];
    [self.sfSection removeAllItems];
    [self addSfControls];
    [self.qtSection removeAllItems];
    [self addQtControls];
    [self.tableView reloadData];
}

- (void)addWtControls
{
    for (UIImage *img in self.wtImageList)
    {
        RETableViewItem *item = [[RETableViewItem alloc] init];
        CGFloat scale =  (self.view.frame.size.width - 30) / img.size.width;
        item.cellHeight = img.size.height * scale + 5;
        item.image = [UtilFun scaleImage:img toScale:scale];
        [self.wtSection addItem:item];
    }
    RETableViewItem *addItem = [RETableViewItem itemWithTitle:@"添加委托协议图片" accessoryType:UITableViewCellAccessoryNone selectionHandler:^(RETableViewItem *item)
                                {
                                    self.addPicSection = self.wtSection;
                                    [self addPhoto];
                                }];
    addItem.textAlignment = NSTextAlignmentCenter;
    [self.wtSection addItem:addItem];
}

- (void)addQcControls
{
    for (UIImage *img in self.qcImageList)
    {
        RETableViewItem *item = [[RETableViewItem alloc] init];
        CGFloat scale =  (self.view.frame.size.width - 30) / img.size.width;
        item.cellHeight = img.size.height * scale + 5;
        item.image = [UtilFun scaleImage:img toScale:scale];
        [self.qcSection addItem:item];
    }
    RETableViewItem *addItem = [RETableViewItem itemWithTitle:@"添加产权证明图片" accessoryType:UITableViewCellAccessoryNone selectionHandler:^(RETableViewItem *item)
                                {
                                    self.addPicSection = self.qcSection;
                                    [self addPhoto];
                                }];
    addItem.textAlignment = NSTextAlignmentCenter;
    [self.qcSection addItem:addItem];
}

- (void)addSfControls
{
    for (UIImage *img in self.sfImageList)
    {
        RETableViewItem *item = [[RETableViewItem alloc] init];
        CGFloat scale =  (self.view.frame.size.width - 30) / img.size.width;
        item.cellHeight = img.size.height * scale + 5;
        item.image = [UtilFun scaleImage:img toScale:scale];
        [self.sfSection addItem:item];
    }
    RETableViewItem *addItem = [RETableViewItem itemWithTitle:@"添加身份证明图片" accessoryType:UITableViewCellAccessoryNone selectionHandler:^(RETableViewItem *item)
                                {
                                    self.addPicSection = self.sfSection;
                                    [self addPhoto];
                                }];
    addItem.textAlignment = NSTextAlignmentCenter;
    [self.sfSection addItem:addItem];
}

- (void)addQtControls
{
    for (UIImage *img in self.qtImageList)
    {
        RETableViewItem *item = [[RETableViewItem alloc] init];
        CGFloat scale =  (self.view.frame.size.width - 30) / img.size.width;
        item.cellHeight = img.size.height * scale + 5;
        item.image = [UtilFun scaleImage:img toScale:scale];
        [self.qtSection addItem:item];
    }
    RETableViewItem *addItem = [RETableViewItem itemWithTitle:@"添加其他图片" accessoryType:UITableViewCellAccessoryNone selectionHandler:^(RETableViewItem *item)
                                {
                                    self.addPicSection = self.qtSection;
                                    [self addPhoto];
                                }];
    addItem.textAlignment = NSTextAlignmentCenter;
    [self.qtSection addItem:addItem];
}

- (RETableViewSection *)addContractControls
{
    __typeof (&*self) __weak weakSelf = self;

    RETableViewSection *section = [RETableViewSection sectionWithHeaderTitle:@"委托信息"];
    [self.manager addSection:section];
    self.typeItem = [RERadioItem itemWithTitle:@"交易类型" value:@"" selectionHandler:^(RERadioItem *item)
                     {
                         [item deselectRowAnimated:YES]; // same as [weakSelf.tableView deselectRowAtIndexPath:item.indexPath animated:YES];
                         NSMutableArray *options = [[NSMutableArray alloc] init];
                         if ([self.type isEqualToString:@"出售"])
                         {
                             [options addObject:@"出售"];
                         }
                         else if ([self.type isEqualToString:@"出租"])
                         {
                             [options addObject:@"出租"];
                         }
                         else if ([self.type isEqualToString:@"租售"])
                         {
                             [options addObject:@"出售"];
                             [options addObject:@"出租"];
                         }
//                         for (NSInteger i = 0; i < self.typeDictList.count; i++)
//                         {
//                             DicItem *di = [self.typeDictList objectAtIndex:i];
//                             [options addObject:di.dict_label];
//                         }
                         RETableViewOptionsController *optionsController = [[RETableViewOptionsController alloc] initWithItem:item options:options multipleChoice:NO completionHandler:^(RETableViewItem *selectedItem)
                                                                            {
                                                                                [weakSelf.navigationController popViewControllerAnimated:YES];
                                                                                [item reloadRowWithAnimation:UITableViewRowAnimationNone]; // same as [weakSelf.tableView reloadRowsAtIndexPaths:@[item.indexPath] withRowAnimation:UITableViewRowAnimationNone];
                                                                            }];
                         // Adjust styles
                         optionsController.delegate = weakSelf;
                         optionsController.style = section.style;
                         if (weakSelf.tableView.backgroundView == nil)
                         {
                             optionsController.tableView.backgroundColor = weakSelf.tableView.backgroundColor;
                             optionsController.tableView.backgroundView = nil;
                         }
                         // Push the options controller
                         [weakSelf.navigationController pushViewController:optionsController animated:YES];
                     }];
    [section addItem:self.typeItem];
    self.consignItem = [RERadioItem itemWithTitle:@"委托类型" value:@"" selectionHandler:^(RERadioItem *item)
                     {
                         [item deselectRowAnimated:YES]; // same as [weakSelf.tableView deselectRowAtIndexPath:item.indexPath animated:YES];
                         NSMutableArray *options = [[NSMutableArray alloc] init];
                         for (NSInteger i = 0; i < self.consignDictList.count; i++)
                         {
                             DicItem *di = [self.consignDictList objectAtIndex:i];
                             [options addObject:di.dict_label];
                         }
                         RETableViewOptionsController *optionsController = [[RETableViewOptionsController alloc] initWithItem:item options:options multipleChoice:NO completionHandler:^(RETableViewItem *selectedItem)
                                                                            {
                                                                                [weakSelf.navigationController popViewControllerAnimated:YES];
                                                                                [item reloadRowWithAnimation:UITableViewRowAnimationNone]; // same as [weakSelf.tableView reloadRowsAtIndexPaths:@[item.indexPath] withRowAnimation:UITableViewRowAnimationNone];
                                                                            }];
                         // Adjust styles
                         optionsController.delegate = weakSelf;
                         optionsController.style = section.style;
                         if (weakSelf.tableView.backgroundView == nil)
                         {
                             optionsController.tableView.backgroundColor = weakSelf.tableView.backgroundColor;
                             optionsController.tableView.backgroundView = nil;
                         }
                         // Push the options controller
                         [weakSelf.navigationController pushViewController:optionsController animated:YES];
                     }];
    [section addItem:self.consignItem];
    self.payItem = [RERadioItem itemWithTitle:@"付佣类型" value:@"" selectionHandler:^(RERadioItem *item)
                        {
                            [item deselectRowAnimated:YES]; // same as [weakSelf.tableView deselectRowAtIndexPath:item.indexPath animated:YES];
                            NSMutableArray *options = [[NSMutableArray alloc] init];
                            for (NSInteger i = 0; i < self.payDictList.count; i++)
                            {
                                DicItem *di = [self.payDictList objectAtIndex:i];
                                [options addObject:di.dict_label];
                            }
                            RETableViewOptionsController *optionsController = [[RETableViewOptionsController alloc] initWithItem:item options:options multipleChoice:NO completionHandler:^(RETableViewItem *selectedItem)
                                                                               {
                                                                                   [weakSelf.navigationController popViewControllerAnimated:YES];
                                                                                   [item reloadRowWithAnimation:UITableViewRowAnimationNone]; // same as [weakSelf.tableView reloadRowsAtIndexPaths:@[item.indexPath] withRowAnimation:UITableViewRowAnimationNone];
                                                                               }];
                            // Adjust styles
                            optionsController.delegate = weakSelf;
                            optionsController.style = section.style;
                            if (weakSelf.tableView.backgroundView == nil)
                            {
                                optionsController.tableView.backgroundColor = weakSelf.tableView.backgroundColor;
                                optionsController.tableView.backgroundView = nil;
                            }
                            // Push the options controller
                            [weakSelf.navigationController pushViewController:optionsController animated:YES];
                        }];
    [section addItem:self.payItem];
    
    self.regNo = [RETextItem itemWithTitle:@"委托注册编号" value:@"" placeholder:@""];
    self.valueTotal = [RETextItem itemWithTitle:@"委托价格" value:@"" placeholder:@"单位:元"];
    self.valueTotal.keyboardType = UIKeyboardTypeDecimalPad;
    
    [section addItem:self.regNo];
    [section addItem:self.valueTotal];
    
    
    self.startItem = [REDateTimeItem itemWithTitle:@"委托开始日期" value:nil placeholder:nil format:@"yyyy-MM-dd" datePickerMode:UIDatePickerModeDate];
    [section addItem:self.startItem];
    self.endItem = [REDateTimeItem itemWithTitle:@"委托结束日期" value:nil placeholder:nil format:@"yyyy-MM-dd" datePickerMode:UIDatePickerModeDate];
    [section addItem:self.endItem];

    return section;
}

- (RETableViewSection *)addCommitButton
{
    RETableViewSection *section = [RETableViewSection section];
    [self.manager addSection:section];
    
    RETableViewItem *buttonItem = [RETableViewItem itemWithTitle:@"提交" accessoryType:UITableViewCellAccessoryNone selectionHandler:^(RETableViewItem *item)
    {
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        [param setValue:[person me].job_no forKey:@"job_no"];
        [param setValue:[person me].password forKey:@"acc_password"];
        [param setValue:[UtilFun getUDID] forKey:@"DeviceID"];
        [param setValue:self.sid forKey:@"trade_no"];
        if (!self.typeItem.value || self.typeItem.value.length <= 0)
        {
            PRESENTALERT(@"错 误", @"请选择交易类型", @"O K", nil,self);
            return;
        }
        for (DicItem *di in self.typeDictList)
        {
            if ([di.dict_label isEqualToString:self.typeItem.value])
            {
                [param setValue:di.dict_value forKey:@"trade_type"];
                break;
            }
        }
        if (!self.consignItem.value || self.consignItem.value.length <= 0)
        {
            PRESENTALERT(@"错 误", @"请选择委托类型", @"O K",nil, self);
            return;
        }
        for (DicItem *di in self.consignDictList)
        {
            if ([di.dict_label isEqualToString:self.consignItem.value])
            {
                [param setValue:di.dict_value forKey:@"entrust_type"];
                break;
            }
        }
        if (!self.payItem.value || self.payItem.value.length <= 0)
        {
            PRESENTALERT(@"错 误", @"请选择付佣类型", @"O K", nil,self);
            return;
        }

        for (DicItem *di in self.payDictList)
        {
            if ([di.dict_label isEqualToString:self.payItem.value])
            {
                [param setValue:di.dict_value forKey:@"brokerage_sort"];
                break;
            }
        }
        
        if (!self.regNo.value || self.regNo.value.length ==0
            ||!self.valueTotal.value || self.valueTotal.value.length == 0)
        {
            PRESENTALERT(@"错 误", @"注册编号和委托价格不能为空", @"O K", nil,self);
            return;
        }
        {
            [param setValue:self.regNo.value forKey:@"entrust_reg_no"];
            [param setValue:self.valueTotal.value forKey:@"value_total"];
        }
        
        if (!self.startItem.value)
        {
            PRESENTALERT(@"错 误", @"请选择委托开始日期", @"O K",nil, self);
            return;
        }
        {
            NSDateFormatter* fmt = [[NSDateFormatter alloc] init];
            fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
            fmt.dateFormat = @"yyyy-MM-dd";
            NSString* dateString = [fmt stringFromDate:self.startItem.value];
            [param setValue:dateString forKey:@"start_date"];
        }
        if (!self.endItem.value)
        {
            PRESENTALERT(@"错 误", @"请选择委托结束日期", @"O K",nil, self);
            return;
        }
        {
            NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
            NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
            NSDateComponents *components = [calendar components:unitFlags fromDate:self.startItem.value toDate:self.endItem.value options:unitFlags];
            if (components.year == 0 &&
                (components.month == 0 || components.month == 1 || components.month == 2) &&
                components.day >= 0 &&
                components.hour >= 0 &&
                components.minute >= 0 &&
                components.second >= 0)
            {
                NSDateFormatter* fmt = [[NSDateFormatter alloc] init];
                fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
                fmt.dateFormat = @"yyyy-MM-dd";
                NSString* dateString = [fmt stringFromDate:self.endItem.value];
                [param setValue:dateString forKey:@"end_date"];
            }
            else
            {
                PRESENTALERT(@"错 误", @"委托结束时间应大于开始时间且不能超过三个月", @"O K", nil,self);
                return;
            }
        }
        if (self.wtImageList.count <= 0)
        {
            PRESENTALERT(@"错 误", @"请立刻上传委托协议图片", @"O K",nil, self);
            return;
        }
        if (self.qcImageList.count <= 0)
        {
            PRESENTALERT(@"错 误", @"请立刻上传产权证明图片", @"O K",nil, self);
            return;
        }
        if (self.sfImageList.count <= 0)
        {
            PRESENTALERT(@"错 误", @"请立刻上传身份证明图片", @"O K", nil,self);
            return;
        }
        SHOWWINDOWHUD(@"正在尝试创建委托，请稍候...");
        [ContractDataPuller pushNewContractWithParam:param Success:^(NSString *att)
        {
            HIDEALLWINDOWHUD;
            self.attNo = att;
            self.uploadProgress = 0;
            [self uploadPic];
        }
                                         failure:^(NSError *error)
        {
            HIDEALLWINDOWHUD;
            PRESENTALERT(@"失败", @"创建委托失败，请稍后再试！",@"OK",  ^()
                                   {
//                                       [self.navigationController popViewControllerAnimated:YES];
                                   },self);
            return;
        }];
    }];
    buttonItem.textAlignment = NSTextAlignmentCenter;
    [section addItem:buttonItem];
    return section;
}

-(void)uploadPic
{
    UIImage *image = nil;
    NSString *type = @"";
    NSString *tip = @"";
    if (self.uploadProgress < self.wtImageList.count)
    {
        image = [self.wtImageList objectAtIndex:self.uploadProgress];
        type = @"wt";
        tip = [NSString stringWithFormat:@"正在上传委托协议第%lu张(共%lu张)...", (unsigned long)(self.uploadProgress + 1), (unsigned long)self.wtImageList.count];
    }
    else if (self.uploadProgress < (self.qcImageList.count + self.wtImageList.count) )
    {
        image = [self.qcImageList objectAtIndex:(self.uploadProgress - self.wtImageList.count) ];
        type = @"qc";
        tip = [NSString stringWithFormat:@"正在上传产权证明第%lu张(共%lu张)...",(unsigned long)(self.uploadProgress + 1 - self.wtImageList.count), (unsigned long)self.qcImageList.count];
    }
    else if (self.uploadProgress < (self.qcImageList.count + self.wtImageList.count + self.sfImageList.count) )
    {
        image = [self.sfImageList objectAtIndex:(self.uploadProgress - self.wtImageList.count - self.qcImageList.count) ];
        type = @"sf";
        tip = [NSString stringWithFormat:@"正在上传身份证明第%lu张(共%lu张)...", (unsigned long)(self.uploadProgress + 1 - self.wtImageList.count - self.qcImageList.count), (unsigned long)self.sfImageList.count];
    }
    else if (self.uploadProgress < (self.qcImageList.count + self.wtImageList.count + self.sfImageList.count + self.qtImageList.count) )
    {
        image = [self.qtImageList objectAtIndex:(self.uploadProgress - self.wtImageList.count - self.qcImageList.count - self.sfImageList.count) ];
        type = @"qt";
        tip = [NSString stringWithFormat:@"正在上传其他图片第%lu张(共%lu张)...", (unsigned long)(self.uploadProgress + 1 - self.wtImageList.count - self.qcImageList.count - self.sfImageList.count), (unsigned long)self.qtImageList.count];
    }
    else
    {
        PRESENTALERT(@"成功", @"添加委托成功！",@"OK", ^()
                               {
                                   [self.navigationController popViewControllerAnimated:YES];
                               }, self);
        return;
    }
    SHOWWINDOWHUD(tip);
    [ContractDataPuller pushImage:image No:self.attNo Type:type Success:^(id responseObject)
    {
         HIDEALLWINDOWHUD;
         self.uploadProgress++;
         [self uploadPic];
    }
                          failure:^(NSError *error)
    {
        HIDEALLWINDOWHUD;
        PRESENTALERT(@"失败", @"上传图片时失败，请稍后再试！",@"OK", ^()
                               {
                                   [self.navigationController popViewControllerAnimated:YES];
                               }
                     ,self);
        return;
    }];
}



- (void)addPhoto
{
    UIActionSheet *sheet;
    NSString* take = @"照相";
    NSString* choose = @"从相册选择";
    NSString* cancel = @"取消";
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        
        sheet  = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:nil destructiveButtonTitle:cancel otherButtonTitles:take,choose, nil];
    }
    else
    {
        sheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:nil destructiveButtonTitle:cancel otherButtonTitles:choose, nil];
    }
    
    sheet.tag = 28123;
    [sheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag != 28123)
    {
        return;
    }
    NSUInteger sourceType = 0;
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        
        switch (buttonIndex)
        {
            case 0:
                return;
            case 1:
                sourceType = UIImagePickerControllerSourceTypeCamera;
                break;
            case 2:
                sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                break;
        }
    }
    else
    {
        if (buttonIndex == 0)
        {
            
            return;
        }
        else
        {
            sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        }
    }
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    imagePickerController.sourceType = sourceType;
    [self presentViewController:imagePickerController animated:YES completion:^{}];
}


#pragma mark - image picker delegte
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
//    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    UIImage *image = [UIImage imageWithData:UIImageJPEGRepresentation([info objectForKey:UIImagePickerControllerEditedImage], 0.5)];
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if (image && [type isEqualToString:(NSString *)kUTTypeImage])
    {
        if (self.addPicSection == self.wtSection)
        {
            [self.wtImageList addObject:image];
        }
        else if (self.addPicSection == self.qcSection)
        {
            [self.qcImageList addObject:image];
        }
        else if (self.addPicSection == self.sfSection)
        {
            [self.sfImageList addObject:image];
        }
        else if (self.addPicSection == self.qtSection)
        {
            [self.qtImageList addObject:image];
        }
        else
        {
        }
        [self reloadImages];
        //save image to album
        if (picker.sourceType == UIImagePickerControllerSourceTypeCamera)
        {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
        }
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}

@end
