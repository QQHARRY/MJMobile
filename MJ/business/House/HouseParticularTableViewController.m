//
//  HouseParticularTableViewController.m
//  MJ
//
//  Created by harry on 15/1/10.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//
//给维护者的说明:为了实现元编程，重中之重,变量名一定要和接口JSON字段名完全相同!否则。。。

#import "HouseParticularTableViewController.h"
#import "UtilFun.h"
#import "HouseDataPuller.h"
#import "FollowTableViewController.h"
#import "AppointTableViewController.h"
#import "ContractTableViewController.h"
#import "SignAddController.h"
#import <objc/runtime.h>
#import "dictionaryManager.h"
#import "Macro.h"
#import "HouseEditParticularsViewController.h"
#import "BuildingsSelectTableViewController.h"
#import "houseDescribeViewController.h"
#import "ImagePlayerView.h"
#import "MessageReadManager.h"
#import "UIImageView+AFNetworking.h"
#import "YALContextMenuTableView.h"
#import "YALContextMenuCell.h"
#import "ContextMenuCell.h"
#import "UIViewController+ContactsFunction.h"
#import "contactDataManager.h"
#import "UIViewController+addGaussianBlurView.h"
#import "HouseSurvey.h"


#define ITEMBARHEIGHT 44
#define NAVGATIONBAR_H 64
static NSString *const menuCellIdentifier = @"ContextMenuCell";

@interface HouseParticularTableViewController ()<ImagePlayerViewDelegate,YALContextMenuTableViewDelegate,ContextMenuCellImageViewTapDelegate>

@property(strong,nonatomic)ImagePlayerView*houseImagePlayer;
@property(strong,nonatomic)UIToolbar*toolBar;
@property(strong,nonatomic)MessageReadManager*messageReadManager;
@property(strong,nonatomic)NSMutableArray*housePhotoArr;

@property (nonatomic, strong) NSArray *menuTitles;
@property (nonatomic, strong) NSArray *menuIcons;
@property (nonatomic, strong) YALContextMenuTableView*contextMenuTableView;
@property (nonatomic, strong)person*owner;
@property (nonatomic, strong)UIBarButtonItem*moreBtn;
@property (nonatomic, strong)UIVisualEffectView* effectview;
@property (nonatomic, strong)UIImageView* bluringView;
@property (nonatomic, strong)NSArray*roleListOfHouse;
@property (nonatomic, strong)HouseSurvey*survey;
@end

@implementation HouseParticularTableViewController
@synthesize houseDtl;
@synthesize housePtcl;
@synthesize houseSecretPtcl;
@synthesize mode;

@synthesize refreshAfterEdit;


#pragma mark ---------------viewDidLoad----------------
#pragma mark
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    

    self.refreshAfterEdit = NO;
    //self.houseImageCtrl = [[houseImagesTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    self.manager = [[RETableViewManager alloc] initWithTableView:self.tableView delegate:self];
    [self createSections];
    [self initDic];
    [self initiateMenuOptions];
    
    [self getData];
    

}




-(void)viewDidAppear:(BOOL)animated
{
    if (self.refreshAfterEdit)
    {
        self.refreshAfterEdit = NO;
        self.housePtcl = nil;
        self.houseSecretPtcl = nil;
        [self getData];
        //[self prepareSections];
        //[self prepareItems];
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.toolbarHidden = NO;
}

-(void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.toolbarHidden = YES;
}

#pragma mark ---------------viewDidLoad----------------
#pragma mark



-(ImagePlayerView*)houseImagePlayer
{
    if (_houseImagePlayer == nil)
    {
        CGFloat h = self.view.frame.size.width*3.0f/4.0f;
        [self.tableView setContentInset:UIEdgeInsetsMake(h, 0, 0, 0)];
        _houseImagePlayer = [[ImagePlayerView alloc] initWithFrame:CGRectMake(0, -h, self.view.frame.size.width, h)];
        
        _houseImagePlayer.pageControlPosition = ICPageControlPosition_BottomCenter;
        
        _houseImagePlayer.imagePlayerViewDelegate = self;
        
        _houseImagePlayer.autoScroll = NO;
        _houseImagePlayer.hidePageControl = YES;
        [_houseImagePlayer setPageIndicatorLabelHidden:NO];
        [self.tableView insertSubview:_houseImagePlayer atIndex:0];
        
    }
    return _houseImagePlayer;
}

- (MessageReadManager *)messageReadManager
{
    if (_messageReadManager == nil) {
        _messageReadManager = [MessageReadManager defaultManager];
        _messageReadManager.vc = self;
    }
    
    return _messageReadManager;
}

-(void)setUpTableView
{
    [self.tableView setShowsVerticalScrollIndicator:NO];
    [self.tableView setShowsHorizontalScrollIndicator:NO];
}

-(UIToolbar*)toolBar
{
    //if (_toolBar == nil)
    {
//        _toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.navigationController.view.frame.size.height-ITEMBARHEIGHT, self.view.frame.size.width, ITEMBARHEIGHT)];
//        
//        
//        
//        
//        [self.navigationController.view addSubview:_toolBar];
        
        NSMutableArray *items = [[NSMutableArray alloc] init];
        
        UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        
        
        
        UIBarButtonItem* callBtn =  [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(onBtnClicked:)];
        [callBtn setBackgroundImage:[UIImage imageNamed:@"房源详情_打电话"] forState:UIControlStateNormal style:UIBarButtonItemStylePlain barMetrics:UIBarMetricsDefault];
        [callBtn setBackgroundImage:[UIImage imageNamed:@"房源详情_打电话"] forState:UIControlStateHighlighted style:UIBarButtonItemStylePlain barMetrics:UIBarMetricsDefault];
        callBtn.enabled = [self.housePtcl.owner_mobile length] > 0;
        callBtn.tag = 10001;
        
        
        UIBarButtonItem* imbtn =  [self imBtn];
        imbtn.tag = callBtn.tag+1;
        
        
        UIBarButtonItem* moreBtn =  [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(onBtnClicked:)];
        [moreBtn setBackgroundImage:[UIImage imageNamed:@"房源详情_更多"] forState:UIControlStateNormal style:UIBarButtonItemStylePlain barMetrics:UIBarMetricsDefault];
        [moreBtn setBackgroundImage:[UIImage imageNamed:@"房源详情_更多"] forState:UIControlStateHighlighted style:UIBarButtonItemStylePlain barMetrics:UIBarMetricsDefault];
        moreBtn.tag = imbtn.tag+1;
        
        _moreBtn = moreBtn;
        
        [items addObjectsFromArray:[NSArray arrayWithObjects:flexSpace,callBtn,flexSpace,imbtn,flexSpace,moreBtn,flexSpace,nil]];
        
        
        [self setToolbarItems:items];
    }
    
    return nil;
}


-(UIBarButtonItem*)imBtn
{
    UIBarButtonItem*imBtn = nil;
    
    if (self.owner == nil)
    {
        UIBarButtonItem* imNotOpenBtn = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
        //[imNotOpenBtn setImage:[UIImage imageNamed:@"房源详情_未开通"]];
        [imNotOpenBtn setBackgroundImage:[UIImage imageNamed:@"房源详情_未开通"] forState:UIControlStateNormal style:UIBarButtonItemStylePlain barMetrics:UIBarMetricsDefault];
        [imNotOpenBtn setBackgroundImage:[UIImage imageNamed:@"房源详情_未开通"] forState:UIControlStateHighlighted style:UIBarButtonItemStylePlain barMetrics:UIBarMetricsDefault];
        imNotOpenBtn.enabled = NO;
        return imNotOpenBtn;
    }
    IMSTATE imState = [self.owner imState];
    [[person me] isImOpened];
    
    switch (imState)
    {
        case IM_NOT_OPEN:
        {
            UIBarButtonItem* imNotOpenBtn = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
            //[imNotOpenBtn setImage:[UIImage imageNamed:@"房源详情_未开通"]];
            [imNotOpenBtn setBackgroundImage:[UIImage imageNamed:@"房源详情_未开通"] forState:UIControlStateNormal style:UIBarButtonItemStylePlain barMetrics:UIBarMetricsDefault];
            [imNotOpenBtn setBackgroundImage:[UIImage imageNamed:@"房源详情_未开通"] forState:UIControlStateHighlighted style:UIBarButtonItemStylePlain barMetrics:UIBarMetricsDefault];
            imNotOpenBtn.enabled = NO;
            imBtn = imNotOpenBtn;
        }
            break;
        case IM_OPENED_NOT_FRIEND:
        {
            UIBarButtonItem* imNotFriendBtn = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(onAddFriend)];
            //[imNotFriendBtn setImage:[UIImage imageNamed:@"房源详情_加好友"]];
            [imNotFriendBtn setBackgroundImage:[UIImage imageNamed:@"房源详情_加好友"] forState:UIControlStateNormal style:UIBarButtonItemStylePlain barMetrics:UIBarMetricsDefault];
            [imNotFriendBtn setBackgroundImage:[UIImage imageNamed:@"房源详情_加好友"] forState:UIControlStateHighlighted style:UIBarButtonItemStylePlain barMetrics:UIBarMetricsDefault];
            imBtn = imNotFriendBtn;
        }
            break;
        case IM_FRIEND:
        {
            UIBarButtonItem* imFriend = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(onImMessage)];
            //[imFriend setImage:[UIImage imageNamed:@"房源详情_发消息"]];
            [imFriend setBackgroundImage:[UIImage imageNamed:@"房源详情_发消息"] forState:UIControlStateNormal style:UIBarButtonItemStylePlain barMetrics:UIBarMetricsDefault];
            [imFriend setBackgroundImage:[UIImage imageNamed:@"房源详情_发消息"] forState:UIControlStateHighlighted style:UIBarButtonItemStylePlain barMetrics:UIBarMetricsDefault];
            imBtn = imFriend;
        }
            break;
        default:
        {
            UIBarButtonItem* imNotOpenBtn = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(onImMessage)];
            //[imNotOpenBtn setImage:[UIImage imageNamed:@"房源详情_未开通"]];
            [imNotOpenBtn setBackgroundImage:[UIImage imageNamed:@"房源详情_未开通"] forState:UIControlStateNormal style:UIBarButtonItemStylePlain barMetrics:UIBarMetricsDefault];
            [imNotOpenBtn setBackgroundImage:[UIImage imageNamed:@"房源详情_未开通"] forState:UIControlStateHighlighted style:UIBarButtonItemStylePlain barMetrics:UIBarMetricsDefault];
            imNotOpenBtn.enabled = NO;
            imBtn = imNotOpenBtn;
        }
            break;
    }
    return imBtn;
}

-(void)onImMessage
{
    if ([self isView:self.contextMenuTableView ShowingInSuperView:self.navigationController.view])
    {
        [self dismissContextMenuTableView];
    }
    [self ct_onImMessage:self.owner];
}

-(void)onAddFriend
{
    if ([self isView:self.contextMenuTableView ShowingInSuperView:self.navigationController.view])
    {
        [self dismissContextMenuTableView];
    }
    [self ct_onAddFriend:self.owner];
    
}


-(void)onBtnClicked:(UIBarButtonItem*)sender
{
    switch (sender.tag)
    {
        case 10001:
        {
            if ([self isView:self.contextMenuTableView ShowingInSuperView:self.navigationController.view])
            {
                [self dismissContextMenuTableView];
            }
            [self ct_onCallWithPhoneNumber:self.housePtcl.owner_mobile];
        }
            break;
//        case 10002:
//        {
//            if ([self isView:self.contextMenuTableView ShowingInSuperView:self.navigationController.view])
//            {
//                [self dismissContextMenuTableView];
//            }
//            [self weiTuoAction];
//
//        }
            break;
        case 10003:
        {
            
            [self dismissContextMenuTableView];
        }
            break;
            
        default:
        {
            //[self dismissContextMenuTableView];
        }
            break;
    }
}

-(void)dismissContextMenuTableView
{
    if ([self isView:self.contextMenuTableView ShowingInSuperView:self.navigationController.view])
    {
        
        [self removeBlurView];
        [_bluringView removeFromSuperview];
        [_moreBtn setBackgroundImage:[UIImage imageNamed:@"房源详情_更多"] forState:UIControlStateNormal style:UIBarButtonItemStylePlain barMetrics:UIBarMetricsDefault];
        [_moreBtn setBackgroundImage:[UIImage imageNamed:@"房源详情_更多"] forState:UIControlStateHighlighted style:UIBarButtonItemStylePlain barMetrics:UIBarMetricsDefault];
        [self.contextMenuTableView dismisWithIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    }
    else
    {
        
        
        [self addBlurViewWithCompletion:nil];
        if (!_bluringView)
        {
            CIContext *context = [CIContext contextWithOptions:nil];
            CIImage *inputImage = [[CIImage alloc] initWithImage:[UIImage imageNamed:@"待办签呈"]];
            // create gaussian blur filter
            CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
            [filter setValue:inputImage forKey:kCIInputImageKey];
            [filter setValue:[NSNumber numberWithFloat:1.0] forKey:@"inputRadius"];
            // blur image
            CIImage *result = [filter valueForKey:kCIOutputImageKey];
            CGImageRef cgImage = [context createCGImage:result fromRect:[result extent]];
            UIImage *image = [UIImage imageWithCGImage:cgImage];
            CGImageRelease(cgImage);
            
            _bluringView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height)];
            _bluringView.contentMode = UIViewContentModeScaleToFill;
            _bluringView.image = image;
        }
        
        
        
        [_moreBtn setBackgroundImage:[UIImage imageNamed:@"房源详情_取消"] forState:UIControlStateNormal style:UIBarButtonItemStylePlain barMetrics:UIBarMetricsDefault];
        [_moreBtn setBackgroundImage:[UIImage imageNamed:@"房源详情_取消"] forState:UIControlStateHighlighted style:UIBarButtonItemStylePlain barMetrics:UIBarMetricsDefault];
        UIEdgeInsets insect = UIEdgeInsetsMake(0, 0, -44-1, 0);
        [self.contextMenuTableView showInView:self.navigationController.view withEdgeInsets:insect animated:YES];
        
    }
}

-(BOOL)isView:(UIView*)view ShowingInSuperView:(UIView*)superView
{
    for (UIView* subView in superView.subviews) {
        if (subView == view)
        {
            return YES;
        }
    }
    return NO;
}


#pragma mark - ImagePlayerViewDelegate
- (void)imagePlayerView:(ImagePlayerView *)imagePlayerView loadImageForImageView:(UIImageView *)imageView index:(NSInteger)index
{
    
    if (self.housePhotoArr.count == 0)
    {
        imageView.image = [UIImage imageNamed:@"banner_no.jpg"];
    }
    else
    {
        if (index < self.housePhotoArr.count)
        {
            __weak typeof(imageView) weakImgV = imageView;
            
            [imageView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.housePhotoArr[index]]] placeholderImage:[UIImage imageNamed:@"banner_no.jpg"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                if (image)
                {
                    weakImgV.image = image;
                }
                else
                {
                    
                    weakImgV.image = [UIImage imageNamed:@"banner_fail.jpg"];
                }
            } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                weakImgV.image = [UIImage imageNamed:@"banner"];
                //weakImgV.image = [UIImage imageNamed:@"banner_fail.jpg"];
            }];
        }
        
    }
}

- (void)imagePlayerView:(ImagePlayerView *)imagePlayerView didTapAtIndex:(NSInteger)index
{
    if (self.housePhotoArr.count > 0)
    {
        NSMutableArray*arr = [[NSMutableArray alloc] initWithCapacity:self.housePhotoArr.count];
        for (NSString*strUrl in self.housePhotoArr)
        {
            MWPhoto*photo = [[MWPhoto alloc] initWithURL:[NSURL URLWithString:strUrl]];
            if ([strUrl rangeOfString:@"/zt/"].location != NSNotFound)
            {
                photo.caption = @"主图";
            }
            else if ([strUrl rangeOfString:@"/hxt/"].location != NSNotFound)
            {
                photo.caption = @"户型图";
            }
            else if([strUrl rangeOfString:@"/snt/"].location != NSNotFound)
            {
                photo.caption = @"室内图";
            }
            [arr addObject:photo];
        }
        
        [self.messageReadManager showBrowserWithImages:arr];
    }
    
}



#pragma mark ---------------initDic----------------
#pragma mark
-(void)initDic
{
    self.tene_application_dic_arr = [dictionaryManager getItemArrByType:DIC_TENE_APPLICATION];
    self.tene_type_dic_arr = [dictionaryManager getItemArrByType:DIC_TENE_TYPE];
    self.fitment_type_dic_arr = [dictionaryManager getItemArrByType:DIC_FITMENT_TYPE];
    self.house_driect_dic_arr = [dictionaryManager getItemArrByType:DIC_HOUSE_DIRECT_TYPE];
    self.use_situation_dic_arr = [dictionaryManager getItemArrByType:DIC_USE_SITUATION_TYPE];
    self.client_source_dic_arr = [dictionaryManager getItemArrByType:DIC_CLIENT_SOURCE_TYPE];
    self.look_permit_dic_arr = [dictionaryManager getItemArrByType:DIC_LOOK_PERMIT_TYPE];
    
    self.shop_rank_dic_arr = [dictionaryManager getItemArrByType:DIC_SHOP_RANK_TYPE];
    self.office_rank_dic_arr = [dictionaryManager getItemArrByType:DIC_OFFICE_RANK_TYPE];
    self.carport_rank_dic_arr = [dictionaryManager getItemArrByType:DIC_CARPORT_RANK_TYPE];
    self.sex_dic_arr = [dictionaryManager getItemArrByType:DIC_SEX_TYPE];
    
    
    self.cons_elevator_brand_dic_arr = [dictionaryManager getItemArrByType:DIC_ELEVATOR_BRAND_TYPE];
    self.facility_gas_dic_arr = [dictionaryManager getItemArrByType:DIC_GAS_TYPE];
    self.facility_heating_dic_arr = [dictionaryManager getItemArrByType:DIC_HEATING_TYPE];
    self.build_property_dic_arr = [dictionaryManager getItemArrByType:DIC_BUILD_PROPERTY];
    
    self.build_year_arr = [[NSMutableArray alloc] init];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSInteger unitFlags = NSYearCalendarUnit;
    NSDateComponents *comps  = [calendar components:unitFlags fromDate:[NSDate date]];
    NSInteger tmpYear= [comps year];

    while (tmpYear>= 1901)
    {
        NSString*strYear = [NSString stringWithFormat:@"%ld",(long)tmpYear];
        [self.build_year_arr addObject:strYear];
        tmpYear--;
    }
}
#pragma mark ---------------initDic----------------
#pragma mark


#pragma mark ---------------getEditAbleFields----------------
#pragma mark
-(NSArray*)getEditAbleFields
{
    if (self.editFieldsArr == nil || self.editFieldsArr.count == 0)
    {
        self.editFieldsArr = @[
                               @"hall_num",
                               @"room_num",
                               @"kitchen_num",
                               @"toilet_num",
                               @"balcony_num",
                               @"house_driect",
                               @"fitment_type",
                               @"build_year",
                               @"property_term",
                               @"use_situation",
                               @"structure_area",
                               @"client_name",
                               @"obj_mobile",
                               @"client_gender",
                               @"obj_fixtel",
                               @"client_identity",
                               @"obj_address",
                               @"client_remark",
                               @"b_staff_describ",
                               @"look_permit",
                               @"client_source",
                               @"house_depth",
                               @"floor_height",
                               @"floor_num",
                               @"efficiency_rate"
                               ];
    }
    
    
    return self.editFieldsArr;
}
#pragma mark ---------------getEditAbleFields----------------
#pragma mark





#pragma mark ---------------reloadUI----------------
#pragma mark
-(void)reloadUI
{
    if ([self.housePtcl.edit_permit isEqualToString:@"1"])
    {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editBtnClicked:)];
    }
    
    [self setUpTableView];
    
    [self toolBar];
    [self prepareSections];
    [self prepareItems];
    [self resetImagePlayerAbout];
    [self.tableView reloadData];
}

-(void)resetImagePlayerAbout
{
    [self resetHousePhotoArr];

    NSInteger count = self.housePhotoArr.count;
    if (count == 0)
    {
        count = 1;
    }

    [self.houseImagePlayer initWithCount:count delegate:self];
}

-(NSMutableArray*)housePhotoArr
{
    if (_housePhotoArr == nil)
    {
        _housePhotoArr = [[NSMutableArray alloc] init];
    }
    return _housePhotoArr;
}



-(NSMutableArray*)resetHousePhotoArr
{
    [self.housePhotoArr removeAllObjects];
    if (self.housePtcl)
    {
        NSMutableArray*arrPhotoTmp = [[NSMutableArray alloc] init];
        [arrPhotoTmp addObjectsFromArray:[self.housePtcl.xqt componentsSeparatedByString:@", "]];
        [arrPhotoTmp addObjectsFromArray:[self.housePtcl.hxt componentsSeparatedByString:@", "]];
        [arrPhotoTmp addObjectsFromArray:[self.housePtcl.snt componentsSeparatedByString:@", "]];

        for (NSString*imgName in arrPhotoTmp)
        {
            NSString *imgStr = [SERVER_ADD stringByAppendingString:imgName];
            [[self housePhotoArr] addObject:imgStr];
        }
        
    }
    
    return [self housePhotoArr];
}



-(void)adjustForMode
{
    if (mode == PAICULARMODE_READ)
    {
        [self.infoSection removeItem:self.room_num];
        [self.infoSection removeItem:self.hall_num];
        [self.infoSection removeItem:self.kitchen_num];
        [self.infoSection removeItem:self.toilet_num];
        [self.infoSection removeItem:self.balcony_num];
        [self.infoSection removeItem:self.house_floor];
        [self.infoSection removeItem:self.floor_count];
    }
}



-(void)adjustUI
{
    if (mode == PAICULARMODE_READ)
    {
        [self adjustByTradeType];
    }
}

-(void)adjustByTradeType
{
    if (self.housePtcl)
    {
        if ([self.housePtcl.trade_type isEqualToString:@"出售"])
        {
            [self.infoSection removeItem:self.lease_state];
            [self.infoSection removeItem:self.rent_listing];
            [self.infoSection removeItem:self.rent_single];
        }
        else if ([self.housePtcl.trade_type isEqualToString:@"出租"])
        {
            [self.infoSection removeItem:self.sale_state];
            [self.infoSection removeItem:self.sale_listing];
            [self.infoSection removeItem:self.sale_single];
            [self.infoSection removeItem:self.sale_bottom];
        }
        else if ([self.housePtcl.trade_type isEqualToString:@"租售"])
        {
            
        }
    }
}

-(void)enableOrDisableItems
{
    NSArray* arr = [self.infoSection items];
    for (RETableViewItem*item in arr)
    {
        if ([item isKindOfClass:[RETextItem class]] || [item isKindOfClass:[ReMultiTextItem class]] || [item isKindOfClass:[RERadioItem class]])
        {
            ((RETextItem*)item).enabled = NO;
        }
    }
    arr = [self.secretSection items];
    for (RETableViewItem*item in arr)
    {
        if ([item isKindOfClass:[RETextItem class]] || [item isKindOfClass:[ReMultiTextItem class]] || [item isKindOfClass:[RERadioItem class]])
        {
            ((RETextItem*)item).enabled = NO;
        }
    }
    self.domain_address.enabled = NO;
    self.b_staff_describ_to_view_html.enabled = YES;
}


-(void)adjustByTeneApplication
{
    NSString*teneApplycation = self.house_application.value;
   
    if (teneApplycation && teneApplycation.length > 0)
    {
        if ([teneApplycation  isEqualToString:@"商铺"])
        {
            [self.infoSection removeItem:self.efficiency_rate];
            [self.infoSection removeItem:self.room_num];
            [self.infoSection removeItem:self.hall_num];
            [self.infoSection removeItem:self.kitchen_num];
            [self.infoSection removeItem:self.toilet_num];
            [self.infoSection removeItem:self.balcony_num];
        }
        else if([teneApplycation  isEqualToString:@"商住"])
        {
            [self.infoSection removeItem:self.efficiency_rate];
            [self.infoSection removeItem:self.room_num];
            [self.infoSection removeItem:self.hall_num];
            [self.infoSection removeItem:self.kitchen_num];
            [self.infoSection removeItem:self.toilet_num];
            [self.infoSection removeItem:self.balcony_num];
        }
        else if([teneApplycation  isEqualToString:@"厂房"])
        {
            [self.infoSection removeItem:self.house_depth];
            [self.infoSection removeItem:self.floor_height];
            [self.infoSection removeItem:self.efficiency_rate];
            [self.infoSection removeItem:self.room_num];
            [self.infoSection removeItem:self.hall_num];
            [self.infoSection removeItem:self.kitchen_num];
            [self.infoSection removeItem:self.toilet_num];
            [self.infoSection removeItem:self.balcony_num];
        }
        else if([teneApplycation  isEqualToString:@"仓库"])
        {
            [self.infoSection removeItem:self.house_depth];
            [self.infoSection removeItem:self.efficiency_rate];
            [self.infoSection removeItem:self.room_num];
            [self.infoSection removeItem:self.hall_num];
            [self.infoSection removeItem:self.kitchen_num];
            [self.infoSection removeItem:self.toilet_num];
            [self.infoSection removeItem:self.balcony_num];
        }
        else if([teneApplycation  isEqualToString:@"地皮"])
        {
            [self.infoSection removeItem:self.house_depth];
            [self.infoSection removeItem:self.efficiency_rate];
            [self.infoSection removeItem:self.room_num];
            [self.infoSection removeItem:self.hall_num];
            [self.infoSection removeItem:self.kitchen_num];
            [self.infoSection removeItem:self.toilet_num];
            [self.infoSection removeItem:self.balcony_num];
        }
        else if([teneApplycation  isEqualToString:@"车位"])
        {
            [self.floor_height setTitle:@"宽度"];
            [self.infoSection removeItem:self.floor_num];
            [self.infoSection removeItem:self.efficiency_rate];
            [self.infoSection removeItem:self.room_num];
            [self.infoSection removeItem:self.hall_num];
            [self.infoSection removeItem:self.kitchen_num];
            [self.infoSection removeItem:self.toilet_num];
            [self.infoSection removeItem:self.balcony_num];
            [self.infoSection removeItem:self.house_driect];
        }
        else if([teneApplycation  isEqualToString:@"写字楼"])
        {

            [self.infoSection removeItem:self.house_rank];
            [self.infoSection removeItem:self.house_depth];
            [self.infoSection removeItem:self.room_num];
            [self.infoSection removeItem:self.hall_num];
            [self.infoSection removeItem:self.kitchen_num];
            [self.infoSection removeItem:self.toilet_num];
            [self.infoSection removeItem:self.balcony_num];
        }
        else
        {
            [self.infoSection removeItem:self.house_rank];
            [self.infoSection removeItem:self.house_depth];
            [self.infoSection removeItem:self.floor_height];
            [self.infoSection removeItem:self.floor_num];
            [self.infoSection removeItem:self.efficiency_rate];
        }
    }
}


#pragma mark ---------------reloadUI----------------
#pragma mark


#pragma mark ---------------Prepare UI----------------
#pragma mark
-(void)prepareSections
{
    [self.manager removeAllSections];
    [self.manager addSection:self.infoSection];
    //[self.manager addSection:self.actionSection];
}

-(void)prepareItems
{
    [self createInfoSectionItems];
    [self createAddInfoSectionItems];
    [self prepareInfoSectionItems];
    [self prepareAddInfoSectionItems];
    //[self prepareActionSectionsItems];
    [self enableOrDisableItems];
    [self adjustByTeneApplication];
}

-(void)prepareInfoSectionItems
{
    [self.infoSection removeAllItems];
    
    //[self.infoSection addItem:self.watchHouseImages];
    
    //    @property (strong, readwrite, nonatomic) RERadioItem * domain_name;
    //    //String
    //    //楼盘名称
    [self.infoSection addItem:self.domain_name];
    //    @property (strong, readwrite, nonatomic) RETextItem * urbanname;
    //    //String
    //    //区域
    [self.infoSection addItem:self.house_urban];
    
    //
    //    @property (strong, readwrite, nonatomic) RETextItem * areaname;
    //    //String
    //    //片区
    [self.infoSection addItem:self.house_area];
    
    //
    //    @property (strong, readwrite, nonatomic) RETextItem *domain_address;
    //    //String
    //    //地址
    [self.infoSection addItem:self.domain_address];
    
    
    //
    //    @property (strong, readwrite, nonatomic) RENumberItem * structure_area;
    //    //float
    //    //面积
    [self.infoSection addItem:self.structure_area];
    
    //
    //    @property (strong, readwrite, nonatomic) RETextItem * house_model_type;
    //    //户型
    //    //比如几室内几厅
    [self.infoSection addItem:self.house_model_type];
    
    
    //
    //    @property (strong, readwrite, nonatomic) RETextItem * house_application;
    //    //Int
    //    //物业用途（用来区分是住宅还是车位等）
    //    //不同的物业用途有不同的属性字段，详见其他说明
    [self.infoSection addItem:self.house_application];
    
    
    [self.infoSection addItem:self.house_rank];
    [self.infoSection addItem:self.house_depth];
    [self.infoSection addItem:self.floor_height];
    [self.infoSection addItem:self.floor_num];
    [self.infoSection addItem:self.efficiency_rate];
    
    //
    //    @property (strong, readwrite, nonatomic) RETextItem * house_tene_type;
    //    //Int
    //    //物业类型
    [self.infoSection addItem:self.house_tene_type];
    
    //
    //    @property (strong, readwrite, nonatomic) RERadioItem * fitment_type;
    //    //Int
    //    //装修
    [self.infoSection addItem:self.fitment_type];
    
    //
    //    @property (strong, readwrite, nonatomic) RERadioItem * house_driect;
    //    //Int
    //    //朝向
    [self.infoSection addItem:self.house_driect];
    
    //
    //    @property (strong, readwrite, nonatomic) RETextItem * cons_elevator_brand;
    //    //String
    //    //电梯（如奥旳斯
    [self.infoSection addItem:self.cons_elevator_brand];
    
    //
    //    @property (strong, readwrite, nonatomic) RETextItem * facility_heating;
    //    //String
    //    //暖气
    [self.infoSection addItem:self.facility_heating];
    
    //
    //    @property (strong, readwrite, nonatomic) RETextItem * facility_gas;
    //    //String
    //    //燃气
    [self.infoSection addItem:self.facility_gas];
    
    //
    //    @property (strong, readwrite, nonatomic) RERadioItem * build_year;
    //    //Int
    //    //建房年代
    [self.infoSection addItem:self.build_year];
    
    //
    //    @property (strong, readwrite, nonatomic) RERadioItem * property_term;
    //    //Int
    //    //产权年限
    [self.infoSection addItem:self.property_term];
    
    //
    //    @property (strong, readwrite, nonatomic) RERadioItem * use_situation;
    //    //Int
    //    //现状
    [self.infoSection addItem:self.use_situation];
    
    [self.infoSection addItem:self.building_name];
    
    //
    //    @property (strong, readwrite, nonatomic) RETextItem * house_and_build_floor;
    //    //在第几层，共几层
    [self.infoSection addItem:self.house_and_build_floor];
    
    
    
    //
    //    @property (strong, readwrite, nonatomic) RENumberItem * sale_listing;
    //    //Float
    //    //总价(出售 万)
    [self.infoSection addItem:self.sale_listing];
    
    //
    //    @property (strong, readwrite, nonatomic) RENumberItem * sale_single;
    //    //Float
    //    //单价(出售 元/平米)
    //todo 处理出租还是出售
    [self.infoSection addItem:self.sale_single];
    
    //
    //    @property (strong, readwrite, nonatomic) RENumberItem * sale_bottom;
    //    //Float
    //    //底价（出售 万）
    //todo 处理出租还是出售
    [self.infoSection addItem:self.sale_bottom];
    
    //
    //    @property (strong, readwrite, nonatomic) RENumberItem * rent_listing;
    //    //Float
    //    //总价(出租 元/月)
    //todo 处理出租还是出售
    [self.infoSection addItem:self.rent_listing];
    
    //
    //    @property (strong, readwrite, nonatomic) RENumberItem * lease_value_single;
    //    //Float
    //    //单价(出租 元/月/平米)
    //todo 处理出租还是出售
    [self.infoSection addItem:self.rent_single];

    //
    //    @property (strong, readwrite, nonatomic) RETextItem * client_remark;
    //    //String
    //    //备注
    [self.infoSection addItem:self.client_remark];
    
    
   
    
    //
    //    @property (strong, readwrite, nonatomic) RETextItem * b_staff_describ;
    //    //String
    //    //房源描述
    //[self.infoSection addItem:self.b_staff_describ];
    
     [self.infoSection addItem:self.b_staff_describ_to_view_html];
    
    //
    //    @property (strong, readwrite, nonatomic) RETextItem * owner_staff_name;
    //    //String
    //    //经纪人姓名
    [self.infoSection addItem:self.owner_staff_name];
    
    //
    //    @property (strong, readwrite, nonatomic) RETextItem * owner_staff_dept;
    //    //String
    //    //经纪人所属部门
    [self.infoSection addItem:self.owner_staff_dept];
    
    //
    //    @property (strong, readwrite, nonatomic) RETextItem * owner_company_no;
    //    //String
    //    //经纪人所属公司编号
    //[self.infoSection addItem:self.owner_company_no];
    
    //
    //    @property (strong, readwrite, nonatomic) RETextItem * owner_compony_name;
    //    //String
    //    //经纪人所属公司名称
    [self.infoSection addItem:self.owner_company_name];
    
    //
    //    @property (strong, readwrite, nonatomic) RETextItem * owner_mobile;
    //    //String
    //    //经纪人电话
    [self.infoSection addItem:self.owner_mobile];
    
    //
    //    @property (strong, readwrite, nonatomic) RERadioItem * client_source;
    //    //String
    //    //信息来源
    [self.infoSection addItem:self.client_source];
    
    
    //@property (strong, readwrite, nonatomic) RERadioItem * look_permit;
    //String
    //看房:
    //预约
    //有钥匙
    //借钥匙
    //直接
    [self.infoSection addItem:self.look_permit];

    //@property (strong, readwrite, nonatomic) RERadioItem * sale_state;
    //
    //
    // String
    // 状态（出售）
   [self.infoSection addItem:self.sale_state];
    
    
    //@property (strong, readwrite, nonatomic) RERadioItem * lease_state;
    //
    // String
    // 状态（出租）
    [self.infoSection addItem:self.lease_state];
    
    //[self.infoSection addItem:self.lookSecretItem];
    
    
    [self adjustUI];
}

-(void)prepareSecretSectionItems
{
    if (self.client_name == nil)
    {
        [self createSecretSectionItems];
        [self.secretSection removeAllItems];
        [self.secretSection addItem:self.client_name];
        [self.secretSection addItem:self.obj_mobile];
        [self.secretSection addItem:self.client_gender];
        [self.secretSection addItem:self.obj_fixtel];
        [self.secretSection addItem:self.client_identity];
        [self.secretSection addItem:self.obj_address];
        [self.secretSection addItem:self.house_unit];
        [self.secretSection addItem:self.house_secrect_tablet];
    }
    
    
    
}

-(void)prepareActionSectionsItems
{
    [self createActionSectionItems];
    [self.actionSection removeAllItems];
    [self.actionSection addItem:self.addGenJinActions];
    //[self.actionSection addItem:self.addDaiKanActions];
    [self.actionSection addItem:self.addWeiTuoActions];
    [self.actionSection addItem:self.addQianYueActions];
}

-(void)prepareAddInfoSectionItems
{
    NSArray*arr = [self.infoSection items];
    int i = 0;
    for (id item in arr)
    {
        if ([item isEqual:self.sale_listing])
        {
            [self.infoSection insertItem:self.trade_type atIndex:i];
            break;
        }
        i++;
    }
    
}


#pragma mark ---------------Prepare UI----------------
#pragma mark






#pragma mark ---------------CreateSection&Items----------------
#pragma mark

-(void)createSections
{
    CGFloat sectH = 22;
    self.addInfoSection = [RETableViewSection sectionWithHeaderTitle:@"地区和位置信息"];
    self.addInfoSection.headerHeight = sectH;
    self.infoSection = [RETableViewSection sectionWithHeaderTitle:@""];
    self.infoSection.headerHeight = 0.5;
    self.secretSection = [RETableViewSection sectionWithHeaderTitle:@"保密信息"];
    self.secretSection.headerHeight =sectH;
    self.actionSection = [RETableViewSection sectionWithHeaderTitle:@"相关操作"];
    self.actionSection.headerHeight = sectH;
}

-(void)createAddInfoSectionItems
{
    NSString*value = @"";
    
    __typeof (&*self) __weak weakSelf = self;
    
    //@property(strong,nonatomic)RERadioItem* builds_dict_no;
    //楼盘编号
    self.builds_dict_no = [[RERadioItem alloc] initWithTitle:@"楼盘编号:" value:value selectionHandler:^(RERadioItem *item)
    {
        //todo
    }];
    
    //@property(strong,nonatomic)RERadioItem* house_dict_no;
    //栋座编号
//    self.house_dict_no = [[RERadioItem alloc] initWithTitle:@"栋座编号:" value:value selectionHandler:^(RERadioItem *item)
//                           {
//                               //todo
//                           }];
    
    
    
    //@property(strong,nonatomic)RERadioItem* house_floor;
    //楼层
    value = @"";
    if (housePtcl)
    {
        value = self.housePtcl.house_floor;
    }
    self.house_floor = [[RERadioItem alloc] initWithTitle:@"楼层:" value:value selectionHandler:^(RERadioItem *item)
                       {
                           //todo
                       }];
    
    //@property(strong,nonatomic)RETextItem* house_tablet;
    //门牌号
    value = @"";
    if (houseSecretPtcl)
    {
        value = houseSecretPtcl.house_tablet;
    }
    self.house_tablet = [[RENumberItem alloc] initWithTitle:@"门牌号:" value:value];
    
    //@property(strong,nonatomic)RETableViewItem* judgementBtn;
    //判重按钮
    self.judgementBtn = [RETableViewItem itemWithTitle:@"判重" accessoryType:UITableViewCellAccessoryNone selectionHandler:^(RETableViewItem *item)
                             {
                                 
                             }];
    //self.judgementBtn.textAlignment = NSTextAlignmentCenter;
    
    //@property (strong, readwrite, nonatomic) RERadioItem * trade_type;
    //String
    //房源类型:比如出售 是”100”，出租 是”101”
    //租售 是"102"
    //(这里和跟进的对象状态有关
    // 出售：出售状态
    // 出租：出租状态
    // 租售：出售状态
    value = @"";
    if (housePtcl)
    {
        value = housePtcl.trade_type;
    }
    self.trade_type = [[RERadioItem alloc] initWithTitle:@"交易类型:" value:value selectionHandler:^(RERadioItem *item) {
        if (self.housePtcl && self.housePtcl.trade_type)
        {
            NSInteger tradeType = [self.housePtcl.trade_type intValue];
            NSMutableArray *options = [[NSMutableArray alloc] init];
            switch (tradeType)
            {
                case 0:
                {
                    [options addObject:@"出售"];
                    [options addObject:@"出租"];
                    [options addObject:@"租售"];
                }
                    break;
                case 1:
                {
                    [options addObject:@"出售"];
                    [options addObject:@"出租"];
                    [options addObject:@"租售"];
                }
                    break;
                case 2:
                {
                    [options addObject:@"出租"];
                }
                    break;
                case 3:
                {
                    [options addObject:@"出售"];
                }
                    break;
                case 4:
                {
                    
                }
                    break;
                default:
                    break;
            }
            RETableViewOptionsController *optionsController = [[RETableViewOptionsController alloc] initWithItem:item options:options multipleChoice:NO completionHandler:^(RETableViewItem *selectedItem)
                                                               {
                                                                   [weakSelf.navigationController popViewControllerAnimated:YES];
                                                                   [item reloadRowWithAnimation:UITableViewRowAnimationNone]; //
                                                                   
                                                        
                                                                   [self adjustByTradeType];
                                                               }];
            
            optionsController.delegate = weakSelf;
            optionsController.style = self.infoSection.style;
            if (weakSelf.tableView.backgroundView == nil)
            {
                optionsController.tableView.backgroundColor = weakSelf.tableView.backgroundColor;
                optionsController.tableView.backgroundView = nil;
            }
            
            [weakSelf.navigationController pushViewController:optionsController animated:YES];
        }
    }];

}




-(void)createInfoSectionItems
{
    NSString*title = @"";
    NSString*value = @"";
    __typeof (&*self) __weak weakSelf = self;
    
    //图片
    //[self createWatchImageBtn];
    
//    @property (strong, readwrite, nonatomic) RERadioItem * domain_name;
//    //String
//    //楼盘名称
    value = @"";
    if (self.housePtcl && self.housePtcl.domain_name)
    {
        value = self.housePtcl.domain_name;
    }
    self.domain_name = [[RERadioItem alloc] initWithTitle:@"楼盘名称:" value:value selectionHandler:^(RERadioItem *item) {

    }];
//    @property (strong, readwrite, nonatomic) RETextItem * urbanname;
//    //String
//    //区域
    value = @"";
    if (self.housePtcl && self.housePtcl.urbanname)
    {
        value = self.housePtcl.urbanname;
    }
    self.house_urban = [[RETextItem alloc] initWithTitle:@"区域:" value:value];
    
//    
//    @property (strong, readwrite, nonatomic) RETextItem * areaname;
//    //String
//    //片区
    value = @"";
    if (self.housePtcl && self.housePtcl.areaname)
    {
        value = self.housePtcl.areaname;
    }
    self.house_area = [[RETextItem alloc] initWithTitle:@"片区:" value:value];
    
//    
//    @property (strong, readwrite, nonatomic) RETextItem *domain_address;
//    //String
//    //地址
    value = @"";
    if (self.housePtcl && self.housePtcl.domain_address)
    {
        value = self.housePtcl.domain_address;
    }
    self.domain_address = [[ReMultiTextItem alloc] initWithTitle:@"地址:" value:value];
    
//    
//    @property (strong, readwrite, nonatomic) RENumberItem * structure_area;
//    //float
//    //面积
    value = @"";
    if (self.housePtcl)
    {
        if(self.housePtcl.structure_area)
        {
            value = [NSString stringWithFormat:@"%@m²",self.housePtcl.structure_area];
        }
        
    }
    self.structure_area = [[RENumberItem alloc] initWithTitle:@"面积:" value:value];

//    
//    @property (strong, readwrite, nonatomic) RETextItem * house_model_type;
//    //户型
//    //比如几室内几厅
    value = @"";
    if (self.housePtcl)
    {
        value = [NSString stringWithFormat:@"%@室%@厅%@厨%@卫%@阳台", self.housePtcl.room_num, self.housePtcl.hall_num, self.housePtcl.kitchen_num, self.housePtcl.toilet_num, self.housePtcl.balcony_num];
    }
    self.house_model_type = [[RETextItem alloc] initWithTitle:@"户型:" value:value];
//    
//    
//    @property (strong, readwrite, nonatomic) RENumberItem * hall_num;
//    //Int
//    //房屋类型的厅的数量:如2厅
    value = @"";
    if (self.housePtcl && self.housePtcl.hall_num)
    {
        value = self.housePtcl.hall_num;
    }
    self.hall_num = [[RENumberItem alloc] initWithTitle:@"室:" value:value];

//    
//    @property (strong, readwrite, nonatomic) RENumberItem * room_num;
//    //Int
//    //房
    value = @"";
    if (self.housePtcl && self.housePtcl.room_num)
    {
        value = self.housePtcl.room_num;
    }
    self.room_num = [[RENumberItem alloc] initWithTitle:@"房:" value:value];

//
//    @property (strong, readwrite, nonatomic) RENumberItem * kitchen_num;
//    //类型的
//    //的数量:如3室
//    //Int
//    //厨
    value = @"";
    if (self.housePtcl && self.housePtcl.kitchen_num)
    {
        value = self.housePtcl.kitchen_num;
    }
    self.kitchen_num = [[RENumberItem alloc] initWithTitle:@"厨房:" value:value];

//    
//    @property (strong, readwrite, nonatomic) RENumberItem * toilet_num;
//    //Int
//    //卫
    value = @"";
    if (self.housePtcl && self.housePtcl.toilet_num)
    {
        value = self.housePtcl.toilet_num;
    }
    self.toilet_num = [[RENumberItem alloc] initWithTitle:@"卫生间:" value:value];

//    
//    @property (strong, readwrite, nonatomic) RENumberItem * balcony_num;
//    //In
//    //
//    //阳台
    value = @"";
    if (self.housePtcl && self.housePtcl.balcony_num)
    {
        value = self.housePtcl.balcony_num;
    }
    self.balcony_num = [[RENumberItem alloc] initWithTitle:@"阳台:" value:value];

//    
//    @property (strong, readwrite, nonatomic) RETextItem * house_application;
//    //Int
//    //物业用途（用来区分是住宅还是车位等）
//    //不同的物业用途有不同的属性字段，详见其他说明
    value = @"";
    if (self.housePtcl)
    {
        for (DicItem *di in self.tene_application_dic_arr)
        {
            if ([di.dict_value isEqualToString:self.housePtcl.house_application])
            {
                value = di.dict_label;
                break;
            }
        }
    }
    self.house_application = [[RERadioItem alloc] initWithTitle:@"物业用途:" value:value selectionHandler:^(RERadioItem *item) {
        //todo
    }];
    
    //@property (strong, readwrite, nonatomic) RERadioItem * house_rank;
    // String
    // 如果是
    // 商铺，商住，厂房，仓库，地皮表示位置:值取字典表中的
    title = @"";
    value = @"";

    if (self.housePtcl)
    {
        if ([self.house_application.value isEqualToString:@"商铺"] ||
            [self.house_application.value isEqualToString:@"商住"] ||
            [self.house_application.value isEqualToString:@"厂房"] ||
            [self.house_application.value isEqualToString:@"仓库"] ||
            [self.house_application.value isEqualToString:@"地皮"]
            )
        {
            title = @"位置";
            
            for (DicItem *di in self.shop_rank_dic_arr)
            {
                if ([di.dict_value isEqualToString:self.housePtcl.house_rank])
                {
                    value = di.dict_label;
                    break;
                }
            }
        }
        else if ([self.house_application.value isEqualToString:@"车位"])
        {
            title = @"车位类型";
            for (DicItem *di in self.carport_rank_dic_arr)
            {
                if ([di.dict_value isEqualToString:self.housePtcl.house_rank])
                {
                    value = di.dict_label;
                    break;
                }
            }
        }
        else if ([self.house_application.value isEqualToString:@"写字楼"])
        {
            title = @"级别";
            for (DicItem *di in self.office_rank_dic_arr)
            {
                if ([di.dict_value isEqualToString:self.housePtcl.house_rank])
                {
                    value = di.dict_label;
                    break;
                }
            }
        }
    }
    self.house_rank = [[RERadioItem alloc] initWithTitle:title value:value selectionHandler:^(RERadioItem *item)
    
    //@property (strong, readwrite, nonatomic) RERadioItem * shop_rank;
    ////
    //// 车位表示车位类型：
    //

                      {
                          NSArray*arr = nil;
                          if ([self.house_application.value isEqualToString:@"商铺"] ||
                              [self.house_application.value isEqualToString:@"商住"] ||
                              [self.house_application.value isEqualToString:@"厂房"] ||
                              [self.house_application.value isEqualToString:@"仓库"] ||
                              [self.house_application.value isEqualToString:@"地皮"]
                              )
                          {
                             arr = self.shop_rank_dic_arr;
                          }
                          else if ([self.house_application.value isEqualToString:@"车位"])
                          {
                              arr = self.carport_rank_dic_arr;
                          }
                          else if ([self.house_application.value isEqualToString:@"写字楼"])
                          {
                              arr = self.office_rank_dic_arr;
                          }
                          
                          if (arr)
                          {
                              //[item deselectRowAnimated:YES];
                              NSMutableArray *options = [[NSMutableArray alloc] init];
                              for (NSInteger i = 0; i < arr.count; i++)
                              {
                                  DicItem *di = [arr objectAtIndex:i];
                                  [options addObject:di.dict_label];
                              }
                              RETableViewOptionsController *optionsController = [[RETableViewOptionsController alloc] initWithItem:item options:options multipleChoice:NO completionHandler:^(RETableViewItem *selectedItem)
                                                                                 {
                                                                                     [weakSelf.navigationController popViewControllerAnimated:YES];
                                                                                     [item reloadRowWithAnimation:UITableViewRowAnimationNone]; //
                                                                                 }];
                              
                              optionsController.delegate = weakSelf;
                              optionsController.style = self.infoSection.style;
                              if (weakSelf.tableView.backgroundView == nil)
                              {
                                  optionsController.tableView.backgroundColor = weakSelf.tableView.backgroundColor;
                                  optionsController.tableView.backgroundView = nil;
                              }
                              
                              [weakSelf.navigationController pushViewController:optionsController animated:YES];
                          }
                          
        //todo
    }];
    //@property (strong, readwrite, nonatomic) RERadioItem * carpot_rank;
    //
    //// 写字楼表示级别:
    //@property (strong, readwrite, nonatomic) RERadioItem * office_rank;
    
    
    //@property (strong, readwrite, nonatomic) RERadioItem * house_depth;
    // Float
    // 进深
    value = @"";
    if (self.housePtcl && self.housePtcl.house_depth)
    {
        value = self.housePtcl.house_depth;
    }
    self.house_depth = [[RENumberItem alloc] initWithTitle:@"进深:" value:value];
    self.house_depth.keyboardType = UIKeyboardTypeDecimalPad;
    
    //@property (strong, readwrite, nonatomic) RERadioItem * floor_height;
    // Float
    // 层高
    value = @"";
    if (self.housePtcl && self.housePtcl.floor_height)
    {
        value = self.housePtcl.floor_height;
    }
    self.floor_height = [[RENumberItem alloc] initWithTitle:@"层高:" value:value];
    self.floor_height.keyboardType = UIKeyboardTypeDecimalPad;
    
    //@property (strong, readwrite, nonatomic) RERadioItem * floor_num;
    // int
    // 层数(里面有几层)
    value = @"";
    if (self.housePtcl && self.housePtcl.floor_num)
    {
        value = self.housePtcl.floor_num;
    }
    self.floor_num = [[RENumberItem alloc] initWithTitle:@"层数:" value:value];
    self.floor_num.keyboardType = UIKeyboardTypeDecimalPad;
    
    //@property (strong, readwrite, nonatomic) RERadioItem * efficiency_rate;
    // float
    // 实用率(百分比)
    value = @"";
    if (self.housePtcl && self.housePtcl.efficiency_rate)
    {
        value = self.housePtcl.efficiency_rate;
    }
    self.floor_num = [[RENumberItem alloc] initWithTitle:@"层数:" value:value];
    self.efficiency_rate = [[RENumberItem alloc] initWithTitle:@"实用率:" value:value];
    self.efficiency_rate.keyboardType = UIKeyboardTypeDecimalPad;
//    
//    @property (strong, readwrite, nonatomic) RETextItem * house_tene_type;
//    //Int
//    //物业类型
    value = @"";
    if (self.housePtcl)
    {
        for (DicItem *di in self.tene_type_dic_arr)
        {
            if ([di.dict_value isEqualToString:self.housePtcl.house_tene_type])
            {
                value = di.dict_label;
                break;
            }
        }
    }
    self.house_tene_type = [[RERadioItem alloc] initWithTitle:@"物业类型:" value:value selectionHandler:^(RERadioItem *item) {
        //todo
    }];
//    
//    @property (strong, readwrite, nonatomic) RERadioItem * fitment_type;
//    //Int
//    //装修
    value = @"";
    if (self.housePtcl)
    {
        for (DicItem *di in self.fitment_type_dic_arr)
        {
            if ([di.dict_value isEqualToString:self.housePtcl.fitment_type])
            {
                value = di.dict_label;
                break;
            }
        }
    }
    self.fitment_type = [[RERadioItem alloc] initWithTitle:@"装修:" value:value selectionHandler:^(RERadioItem *item) {
        
        [item deselectRowAnimated:YES];
        NSMutableArray *options = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < self.fitment_type_dic_arr.count; i++)
        {
            DicItem *di = [self.fitment_type_dic_arr objectAtIndex:i];
            [options addObject:di.dict_label];
        }
        RETableViewOptionsController *optionsController = [[RETableViewOptionsController alloc] initWithItem:item options:options multipleChoice:NO completionHandler:^(RETableViewItem *selectedItem)
                                                           {
                                                               [weakSelf.navigationController popViewControllerAnimated:YES];
                                                               [item reloadRowWithAnimation:UITableViewRowAnimationNone]; //
                                                           }];

        optionsController.delegate = weakSelf;
        optionsController.style = self.infoSection.style;
        if (weakSelf.tableView.backgroundView == nil)
        {
            optionsController.tableView.backgroundColor = weakSelf.tableView.backgroundColor;
            optionsController.tableView.backgroundView = nil;
        }

        [weakSelf.navigationController pushViewController:optionsController animated:YES];
    }];

//
//    @property (strong, readwrite, nonatomic) RERadioItem * house_driect;
//    //Int
//    //朝向
    value = @"";
    if (self.housePtcl)
    {
        for (DicItem *di in self.house_driect_dic_arr)
        {
            if ([di.dict_value isEqualToString:self.housePtcl.house_driect])
            {
                value = di.dict_label;
                break;
            }
        }
    }
    self.house_driect = [[RERadioItem alloc] initWithTitle:@"朝向:" value:value selectionHandler:^(RERadioItem *item) {
        [item deselectRowAnimated:YES];
        NSMutableArray *options = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < self.house_driect_dic_arr.count; i++)
        {
            DicItem *di = [self.house_driect_dic_arr objectAtIndex:i];
            [options addObject:di.dict_label];
        }
        RETableViewOptionsController *optionsController = [[RETableViewOptionsController alloc] initWithItem:item options:options multipleChoice:NO completionHandler:^(RETableViewItem *selectedItem)
                                                           {
                                                               [weakSelf.navigationController popViewControllerAnimated:YES];
                                                               [item reloadRowWithAnimation:UITableViewRowAnimationNone]; //
                                                           }];
        
        optionsController.delegate = weakSelf;
        optionsController.style = self.infoSection.style;
        if (weakSelf.tableView.backgroundView == nil)
        {
            optionsController.tableView.backgroundColor = weakSelf.tableView.backgroundColor;
            optionsController.tableView.backgroundView = nil;
        }
        
        [weakSelf.navigationController pushViewController:optionsController animated:YES];
    }];

//    
//    @property (strong, readwrite, nonatomic) RETextItem * cons_elevator_brand;
//    //String
//    //电梯（如奥旳斯
    
    value = @"";
    if (self.housePtcl&& self.housePtcl.cons_elevator_brand)
    {
        for (DicItem *di in self.cons_elevator_brand_dic_arr)
        {
            if ([di.dict_value isEqualToString:self.housePtcl.cons_elevator_brand])
            {
                value = di.dict_label;
                break;
            }
        }
    }
    

    self.cons_elevator_brand = [[RETextItem alloc] initWithTitle:@"电梯:" value:value];

//    
//    @property (strong, readwrite, nonatomic) RETextItem * facility_heating;
//    //String
//    //暖气
    value = @"";
    if (self.housePtcl&& self.housePtcl.facility_heating)
    {
        for (DicItem *di in self.facility_heating_dic_arr)
        {
            if ([di.dict_value isEqualToString:self.housePtcl.facility_heating])
            {
                value = di.dict_label;
                break;
            }
        }
    }
    self.facility_heating = [[RETextItem alloc] initWithTitle:@"暖气:" value:value];

//    
//    @property (strong, readwrite, nonatomic) RETextItem * facility_gas;
//    //String
//    //燃气
    value = @"";
    if (self.housePtcl&& self.housePtcl.facility_gas)
    {
        for (DicItem *di in self.facility_gas_dic_arr)
        {
            if ([di.dict_value isEqualToString:self.housePtcl.facility_gas])
            {
                value = di.dict_label;
                break;
            }
        }
    }
    self.facility_gas = [[RETextItem alloc] initWithTitle:@"燃气:" value:value];

//    
//    @property (strong, readwrite, nonatomic) RERadioItem * build_year;
//    //Int
//    //建房年代
    value = @"";
    if (self.housePtcl)
    {
        value = self.housePtcl.build_year;
    }
    self.build_year = [[RERadioItem alloc] initWithTitle:@"建房年代:" value:value selectionHandler:^(RERadioItem *item) {
        [item deselectRowAnimated:YES];

        RETableViewOptionsController *optionsController = [[RETableViewOptionsController alloc] initWithItem:item options:self.build_year_arr multipleChoice:NO completionHandler:^(RETableViewItem *selectedItem)
                                                           {
                                                               [weakSelf.navigationController popViewControllerAnimated:YES];
                                                               [item reloadRowWithAnimation:UITableViewRowAnimationNone]; //
                                                           }];
        
        optionsController.delegate = weakSelf;
        optionsController.style = self.infoSection.style;
        if (weakSelf.tableView.backgroundView == nil)
        {
            optionsController.tableView.backgroundColor = weakSelf.tableView.backgroundColor;
            optionsController.tableView.backgroundView = nil;
        }
        
        [weakSelf.navigationController pushViewController:optionsController animated:YES];
    }];;

//    
//    @property (strong, readwrite, nonatomic) RERadioItem * property_term;
//    //Int
//    //产权年限
    value = @"";
    if (self.housePtcl&& self.housePtcl.property_term)
    {
        for (DicItem *di in self.build_property_dic_arr)
        {
            if ([di.dict_value isEqualToString:self.housePtcl.property_term])
            {
                value = di.dict_label;
                break;
            }
        }
    }
    self.property_term = [[RERadioItem alloc] initWithTitle:@"产权年限:" value:value selectionHandler:^(RERadioItem *item) {
        [item deselectRowAnimated:YES];
        NSMutableArray *options = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < self.build_property_dic_arr.count; i++)
        {
            DicItem *di = [self.build_property_dic_arr objectAtIndex:i];
            [options addObject:di.dict_label];
        }
        RETableViewOptionsController *optionsController = [[RETableViewOptionsController alloc] initWithItem:item options:options multipleChoice:NO completionHandler:^(RETableViewItem *selectedItem)
                                                           {
                                                               [weakSelf.navigationController popViewControllerAnimated:YES];
                                                               [item reloadRowWithAnimation:UITableViewRowAnimationNone]; //
                                                           }];
        
        optionsController.delegate = weakSelf;
        optionsController.style = self.infoSection.style;
        if (weakSelf.tableView.backgroundView == nil)
        {
            optionsController.tableView.backgroundColor = weakSelf.tableView.backgroundColor;
            optionsController.tableView.backgroundView = nil;
        }
        
        [weakSelf.navigationController pushViewController:optionsController animated:YES];
    }];

//
//    @property (strong, readwrite, nonatomic) RERadioItem * use_situation;
//    //Int
//    //现状
    
    value = @"";
    if (self.housePtcl)
    {
        for (DicItem *di in self.use_situation_dic_arr)
        {
            if ([di.dict_value isEqualToString:self.housePtcl.use_situation])
            {
                value = di.dict_label;
                break;
            }
        }
    }
    self.use_situation = [[RERadioItem alloc] initWithTitle:@"现状:" value:value selectionHandler:^(RERadioItem *item) {
        [item deselectRowAnimated:YES];
        NSMutableArray *options = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < self.use_situation_dic_arr.count; i++)
        {
            DicItem *di = [self.use_situation_dic_arr objectAtIndex:i];
            [options addObject:di.dict_label];
        }
        RETableViewOptionsController *optionsController = [[RETableViewOptionsController alloc] initWithItem:item options:options multipleChoice:NO completionHandler:^(RETableViewItem *selectedItem)
                                                           {
                                                               [weakSelf.navigationController popViewControllerAnimated:YES];
                                                               [item reloadRowWithAnimation:UITableViewRowAnimationNone]; //
                                                           }];
        
        optionsController.delegate = weakSelf;
        optionsController.style = self.infoSection.style;
        if (weakSelf.tableView.backgroundView == nil)
        {
            optionsController.tableView.backgroundColor = weakSelf.tableView.backgroundColor;
            optionsController.tableView.backgroundView = nil;
        }
        
        [weakSelf.navigationController pushViewController:optionsController animated:YES];
    }];

    //@property(nonatomic,strong)RERadioItem* buildname;
    //栋座（房源的）
    //Int
    value = @"";
    if (self.housePtcl)
    {
        value = self.housePtcl.building_name;
    }
    self.building_name = [[RERadioItem alloc] initWithTitle:@"栋座:" value:value selectionHandler:^(RERadioItem *item) {
        
    }];
    
//    
//    @property (strong, readwrite, nonatomic) RETextItem * house_and_build_floor;
//    //在第几层，共几层
    value = @"";
    if (self.housePtcl)
    {
        value = [NSString stringWithFormat:@"%@层 共%@层",self.housePtcl.house_floor,self.housePtcl.floor_count];
    }
    self.house_and_build_floor = [[RETextItem alloc] initWithTitle:@"所在楼层:" value:value];

//
//    @property (strong, readwrite, nonatomic) RENumberItem * house_floor;
//    //Int
//    //所在楼层
    //self.house_floor = [[RENumberItem alloc] initWithTitle:@"所在楼层:" value:self.housePtcl.house_floor];

//    
//    @property (strong, readwrite, nonatomic) RENumberItem * floor_count;
//    //Int
//    //总楼层
    value = @"";
    if (self.housePtcl && self.housePtcl.floor_count)
    {
        value = self.housePtcl.floor_count;
    }
    self.floor_count = [[RENumberItem alloc] initWithTitle:@"总楼层:" value:value];

//    
//    @property (strong, readwrite, nonatomic) RENumberItem * sale_listing;
//    //Float
//    //总价(出售 万)
    //todo 处理出租还是出售
    value = @"";
    if (self.housePtcl)
    {
        if (self.housePtcl.sale_listing)
        {
            CGFloat price = [self.housePtcl.sale_listing floatValue]/10000.0f;
            value = [NSString stringWithFormat:@"%.2f万元",price];
        }
    }
    self.sale_listing = [[RENumberItem alloc] initWithTitle:@"出售总价:" value:value  placeholder:@"万"];

//    
//    @property (strong, readwrite, nonatomic) RENumberItem * sale_single;
//    //Float
//    //单价(出售 元/平米)
    //todo 处理出租还是出售
    value = @"";
    if (self.housePtcl)
    {
        if (self.housePtcl.sale_single)
        {
            value = [NSString stringWithFormat:@"%@元",self.housePtcl.sale_single];
        }
    }
    self.sale_single = [[RENumberItem alloc] initWithTitle:@"出售单价:" value:value  placeholder:@"元/平米"];

//    
//    @property (strong, readwrite, nonatomic) RENumberItem * sale_bottom;
//    //Float
//    //底价（出售 万）
    //todo 处理出租还是出售
    value = @"";
    if (self.housePtcl)
    {
        if (self.housePtcl.sale_bottom)
        {
            CGFloat price = [self.housePtcl.sale_bottom floatValue]/10000.0f;
            value = [NSString stringWithFormat:@"%.2f万元",price];
        }
    }
    self.sale_bottom = [[RENumberItem alloc] initWithTitle:@"出售底价:" value:value  placeholder:@"万"];

//    
//    @property (strong, readwrite, nonatomic) RENumberItem * rent_listing;
//    //Float
//    //总价(出租 元/月)
    //todo 处理出租还是出售
    value = @"";
    if (self.housePtcl)
    {
        if (self.housePtcl.rent_listing)
        {
            value = [NSString stringWithFormat:@"%@元",self.housePtcl.rent_listing];
        }
        
    }
    self.rent_listing = [[RENumberItem alloc] initWithTitle:@"出租总价:" value:value  placeholder:@"元/月"];

//    
//    @property (strong, readwrite, nonatomic) RENumberItem * lease_value_single;
//    //Float
//    //单价(出租 元/月/平米)
    //todo 处理出租还是出售
    value = @"";
    if (self.housePtcl)
    {
        if (self.housePtcl.rent_single)
        {
            value = [NSString stringWithFormat:@"%@元/月/平米",self.housePtcl.rent_single];
        }
    }
    self.rent_single = [[RENumberItem alloc] initWithTitle:@"出租单价:" value:value placeholder:@"元/月/平米"];

//    
//    @property (strong, readwrite, nonatomic) RETextItem * client_remark;
//    //String
//    //备注
    value = @"";
    if (self.housePtcl && self.housePtcl.client_remark)
    {
        value = self.housePtcl.client_remark;
    }
    self.client_remark = [[RETextItem alloc] initWithTitle:@"备注:" value:value];
    
    
    

//    
//    @property (strong, readwrite, nonatomic) RETextItem * b_staff_describ;
//    //String
//    //房源描述
    value = @"";
    if (self.housePtcl && self.housePtcl.describ)
    {
        value = self.housePtcl.describ;
    }
    self.describ = [[RETextItem alloc] initWithTitle:@"房源描述:" value:value];
    
    
    //@property (strong, readwrite, nonatomic) RERadioItem * b_staff_describ_to_view_html;
    //String
    //房源描述,点击后进入html页面查看html格式的房源描述
    value = @"";
    if (self.housePtcl && self.housePtcl.describ)
    {
        value = self.housePtcl.describ;
    }
    self.b_staff_describ_to_view_html = [[RERadioItem alloc] initWithTitle:@"房源描述" value:@"点击查看" selectionHandler:^(RERadioItem *item) {
        houseDescribeViewController*vc = [[houseDescribeViewController alloc] init];
        vc.client_remark = value;
        [self.navigationController pushViewController:vc animated:YES];
    }];
    

//    
//    @property (strong, readwrite, nonatomic) RETextItem * owner_staff_name;
//    //String
//    //经纪人姓名
    value = @"";
    if (self.housePtcl && self.housePtcl.owner_staff_name)
    {
        value = self.housePtcl.owner_staff_name;
    }
    self.owner_staff_name = [[RETextItem alloc] initWithTitle:@"经纪人姓名:" value:value];

//    
//    @property (strong, readwrite, nonatomic) RETextItem * owner_staff_dept;
//    //String
//    //经纪人所属部门
    value = @"";
    if (self.housePtcl && self.housePtcl.owner_staff_dept)
    {
        value = self.housePtcl.owner_staff_dept;
    }
    self.owner_staff_dept = [[RETextItem alloc] initWithTitle:@"经纪人部门:" value:value];

//    
//    @property (strong, readwrite, nonatomic) RETextItem * owner_company_no;
//    //String
//    //经纪人所属公司编号
    value = @"";
    if (self.housePtcl && self.housePtcl.owner_company_no)
    {
        value = self.housePtcl.owner_company_no;
    }
    self.owner_company_no = [[RETextItem alloc] initWithTitle:@"经纪人公司编号:" value:value];

//    
//    @property (strong, readwrite, nonatomic) RETextItem * owner_compony_name;
//    //String
//    //经纪人所属公司名称
    value = @"";
    if (self.housePtcl && self.housePtcl.owner_company_name)
    {
        value = self.housePtcl.owner_company_name;
    }
    self.owner_company_name = [[RETextItem alloc] initWithTitle:@"经纪人公司:" value:value];

//    
//    @property (strong, readwrite, nonatomic) RETextItem * owner_mobile;
//    //String
//    //经纪人电话
    value = @"";
    if (self.housePtcl && self.housePtcl.owner_mobile)
    {
        value = self.housePtcl.owner_mobile;
    }
    self.owner_mobile = [[RETextItem alloc] initWithTitle:@"经纪人电话:" value:value];

//    
//    @property (strong, readwrite, nonatomic) RERadioItem * client_source;
//    //String
//    //信息来源
    
    
    
    
    value = @"";
    if (self.housePtcl)
    {
        for (DicItem *di in self.client_source_dic_arr)
        {
            if ([di.dict_value isEqualToString:self.housePtcl.client_source])
            {
                value = di.dict_label;
                break;
            }
        }
    }
    self.client_source = [[RERadioItem alloc] initWithTitle:@"信息来源:" value:value selectionHandler:^(RERadioItem *item) {
        [item deselectRowAnimated:YES];
        NSMutableArray *options = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < self.client_source_dic_arr.count; i++)
        {
            DicItem *di = [self.client_source_dic_arr objectAtIndex:i];
            [options addObject:di.dict_label];
        }
        RETableViewOptionsController *optionsController = [[RETableViewOptionsController alloc] initWithItem:item options:options multipleChoice:NO completionHandler:^(RETableViewItem *selectedItem)
                                                           {
                                                               [weakSelf.navigationController popViewControllerAnimated:YES];
                                                               [item reloadRowWithAnimation:UITableViewRowAnimationNone]; //
                                                           }];
        
        optionsController.delegate = weakSelf;
        optionsController.style = self.infoSection.style;
        if (weakSelf.tableView.backgroundView == nil)
        {
            optionsController.tableView.backgroundColor = weakSelf.tableView.backgroundColor;
            optionsController.tableView.backgroundView = nil;
        }
        
        [weakSelf.navigationController pushViewController:optionsController animated:YES];
    }];

    
    //@property (strong, readwrite, nonatomic) RERadioItem * look_permit;
    //String
    //看房:
    //预约
    //有钥匙
    //借钥匙
    //直接
    value = @"";
    if (self.housePtcl)
    {
        for (DicItem *di in self.look_permit_dic_arr)
        {
            if ([di.dict_value isEqualToString:self.housePtcl.look_permit])
            {
                value = di.dict_label;
                break;
            }
        }
    }
    self.look_permit = [[RERadioItem alloc] initWithTitle:@"看房:" value:value selectionHandler:^(RERadioItem *item) {
        [item deselectRowAnimated:YES];
        NSMutableArray *options = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < self.look_permit_dic_arr.count; i++)
        {
            DicItem *di = [self.look_permit_dic_arr objectAtIndex:i];
            [options addObject:di.dict_label];
        }
        RETableViewOptionsController *optionsController = [[RETableViewOptionsController alloc] initWithItem:item options:options multipleChoice:NO completionHandler:^(RETableViewItem *selectedItem)
                                                           {
                                                               [weakSelf.navigationController popViewControllerAnimated:YES];
                                                               [item reloadRowWithAnimation:UITableViewRowAnimationNone]; //
                                                           }];
        
        optionsController.delegate = weakSelf;
        optionsController.style = self.infoSection.style;
        if (weakSelf.tableView.backgroundView == nil)
        {
            optionsController.tableView.backgroundColor = weakSelf.tableView.backgroundColor;
            optionsController.tableView.backgroundView = nil;
        }
        
        [weakSelf.navigationController pushViewController:optionsController animated:YES];
    }];

    //@property (strong, readwrite, nonatomic) RERadioItem * sale_state;
    //
    //
    // String
    // 状态（出售）
    value = @"";
    
    if (self.housePtcl && self.housePtcl.sale_state)
    {
        value = self.housePtcl.sale_state; 
    }
    self.sale_state = [[RERadioItem alloc] initWithTitle:@"出售状态:" value:value selectionHandler:^(RERadioItem *item) {
        //todo
    }];
    
    
    //@property (strong, readwrite, nonatomic) RERadioItem * lease_state;
    //
    // String
    // 状态（出租）
    value = @"";
    if (self.housePtcl && self.housePtcl.rent_state)
    {
        value = self.housePtcl.rent_state;
    }
    self.lease_state = [[RERadioItem alloc] initWithTitle:@"出租状态:" value:value selectionHandler:^(RERadioItem *item) {
        //todo
    }];
    
    [self createLookSecretBtn];
}


-(void)createSecretSectionItems
{
    __typeof (&*self) __weak weakSelf = self;
    NSString*value = @"";
    
    
    //@property(nonatomic,strong)RETableViewItem* client_name;
    //业主（姓名）
    //String
    value = @"";
    if (self.houseSecretPtcl)
    {
        value = self.houseSecretPtcl.client_name;
    }
    self.client_name = [[RETextItem alloc] initWithTitle:@"业主姓名:" value:value];
    
    
    //@property(nonatomic,strong)RETableViewItem* obj_mobile;
    //手机号码（业主）
    //String
    value = @"";
    if (self.houseSecretPtcl)
    {
        value = self.houseSecretPtcl.obj_mobile;
    }
    self.obj_mobile = [[RENumberItem alloc] initWithTitle:@"手机号码:" value:value];
    
    //@property(nonatomic,strong)RETableViewItem* client_gender;
    //性别（业主）
    //String
    value = @"";
    if (self.houseSecretPtcl)
    {
        
        
        for (DicItem *di in self.sex_dic_arr)
        {
            if ([di.dict_value isEqualToString:self.houseSecretPtcl.client_gender])
            {
                value = di.dict_label;
                break;
            }
        }

    }
    self.client_gender = [[RERadioItem alloc] initWithTitle:@"性别:" value:value selectionHandler:^(RERadioItem *item) {
        [item deselectRowAnimated:YES];
        NSMutableArray *options = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < self.sex_dic_arr.count; i++)
        {
            DicItem *di = [self.sex_dic_arr objectAtIndex:i];
            [options addObject:di.dict_label];
        }
        RETableViewOptionsController *optionsController = [[RETableViewOptionsController alloc] initWithItem:item options:options multipleChoice:NO completionHandler:^(RETableViewItem *selectedItem)
                                                           {
                                                               [weakSelf.navigationController popViewControllerAnimated:YES];
                                                               [item reloadRowWithAnimation:UITableViewRowAnimationNone]; //
                                                           }];
        
        optionsController.delegate = weakSelf;
        optionsController.style = self.infoSection.style;
        if (weakSelf.tableView.backgroundView == nil)
        {
            optionsController.tableView.backgroundColor = weakSelf.tableView.backgroundColor;
            optionsController.tableView.backgroundView = nil;
        }
        
        [weakSelf.navigationController pushViewController:optionsController animated:YES];
    }];
    
    //@property(nonatomic,strong)RENumberItem* obj_fixtel;
    //固定电话（业主）
    //String
    value = @"";
    if (self.houseSecretPtcl)
    {
        value = self.houseSecretPtcl.obj_fixtel;
    }
    self.obj_fixtel = [[RENumberItem alloc] initWithTitle:@"固定电话:" value:value];
    
    //@property(nonatomic,strong)RETextItem* client_identity;
    //身份证号（业主）
    //String
    value = @"";
    if (self.houseSecretPtcl)
    {
        value = self.houseSecretPtcl.client_identity;
    }
    self.client_identity = [[RENumberItem alloc] initWithTitle:@"身份证号:" value:value];
    
    //@property(nonatomic,strong)RETextItem* obj_address;
    //联系地址（业主）
    //String
    value = @"";
    if (self.houseSecretPtcl)
    {
        value = self.houseSecretPtcl.obj_address;
    }
    self.obj_address = [[RETextItem alloc] initWithTitle:@"联系地址:" value:value];
    
    

    
    //@property(nonatomic,strong)RERadioItem* house_serect_unit;
    //单元（房源的）
    //Int
    value = @"";
    if (self.houseSecretPtcl)
    {
        value = self.houseSecretPtcl.unit_name;
    }
    self.house_unit = [[RERadioItem alloc] initWithTitle:@"单元:" value:value selectionHandler:^(RERadioItem *item) {
        //todo
    }];
    //@property(nonatomic,strong)RENumberItem* house_secrect_tablet;
    //门牌号（房
    //的）
    //Int
    value = @"";
    if (self.houseSecretPtcl)
    {
        value = self.houseSecretPtcl.house_tablet;
    }
    self.house_secrect_tablet = [[RENumberItem alloc] initWithTitle:@"门牌号:" value:value ];
    
    
    
    
    
}

-(void)createActionSectionItems
{
    //[self createDaiKanBtn];
    //[self createGenjinBtn];
    //[self createWeiTuoBtn];
    //[self createQianYueBtn];
    
    

}


- (void)createWatchImageBtn
{
    __typeof (&*self) __weak weakSelf = self;
    self.watchHouseImages = [RETableViewItem itemWithTitle:@"点击查看图片" accessoryType:UITableViewCellAccessoryNone selectionHandler:^(RETableViewItem *item)
                                   {
                                       if(self.houseImageCtrl == nil)
                                       {
                                           self.houseImageCtrl = [[houseImagesTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
                                           self.houseImageCtrl.housePtcl = self.housePtcl;
                                           self.houseImageCtrl.houseDtl = self.houseDtl;
                                       }
                                       
                                       
                                       [weakSelf.navigationController pushViewController:self.houseImageCtrl animated:YES];
                                   }];
    self.watchHouseImages.textAlignment = NSTextAlignmentCenter;
}
- (void)createLookSecretBtn
{
    self.lookSecretItem = [RETableViewItem itemWithTitle:@"查看保密信息" accessoryType:UITableViewCellAccessoryNone selectionHandler:^(RETableViewItem *item)
                        {
                            if (self.housePtcl &&
                                ([self.housePtcl.edit_permit isEqualToString:@"1"] ||
                                 [self.housePtcl.edit_permit isEqualToString:@"0"] ||
                                [self.housePtcl.secret_permit isEqualToString:@"1"]))
                            {
                                if ([self.manager sections].count == 2)
                                {
                                    [self reloadUIForSecret:NO];
                                }
                                else
                                {
                                    [self getSecretDataForEdit:NO];
                                }
                            }
                            else
                            {
                                PRESENTALERT(@"",@"对不起,您没有查看该房源的保密信息的权限",@"OK",nil,self);
                            }

                            
                        }];
    
    
    self.lookSecretItem.textAlignment = NSTextAlignmentCenter;
}

-(void)genJinAction
{
    
    [self genJinActionAction];
}

-(void)genJinActionAction
{
    FollowTableViewController *vc = [[FollowTableViewController alloc] initWithNibName:@"FollowTableViewController" bundle:[NSBundle mainBundle]];
    if ([self.housePtcl.edit_permit isEqualToString:@"1"] || [self.housePtcl.secret_permit isEqualToString:@"1"])
    {
        vc.hasAddPermit = YES;
    }
    else
    {
        vc.hasAddPermit = NO;
    }
    
    
    vc.sid = self.houseDtl.trade_no;
    vc.type = self.housePtcl.trade_type;
    vc.houseDtl = self.houseDtl;
    vc.housePtcl = self.housePtcl;
    vc.followType = K_FOLLOW_TYPE_HOUSE;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)createGenjinBtn
{
    __typeof (&*self) __weak weakSelf = self;
    self.addGenJinActions = [RETableViewItem itemWithTitle:@"跟进" accessoryType:UITableViewCellAccessoryNone selectionHandler:^(RETableViewItem *item)
                        {
                            [item deselectRowAnimated:YES];
                            
                            [weakSelf genJinAction];
                            
                        }];
    self.addGenJinActions.textAlignment = NSTextAlignmentCenter;
}

-(void)daiKanAction
{
    AppointTableViewController *vc = [[AppointTableViewController alloc] initWithNibName:@"AppointTableViewController" bundle:[NSBundle mainBundle]];
    vc.sid = self.houseDtl.trade_no;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)createDaiKanBtn
{
    __typeof (&*self) __weak weakSelf = self;
    self.addDaiKanActions = [RETableViewItem itemWithTitle:@"带看" accessoryType:UITableViewCellAccessoryNone selectionHandler:^(RETableViewItem *item)
                        {
                            [item deselectRowAnimated:YES];
                            [weakSelf daiKanAction];
                        }];
    self.addDaiKanActions.textAlignment = NSTextAlignmentCenter;
}

-(void)weiTuoAction
{
    ContractTableViewController *vc = [[ContractTableViewController alloc] initWithNibName:@"ContractTableViewController" bundle:[NSBundle mainBundle]];
    vc.sid = self.houseDtl.trade_no;
    vc.type = self.housePtcl.trade_type;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)createWeiTuoBtn
{
    __typeof (&*self) __weak weakSelf = self;
    self.addWeiTuoActions = [RETableViewItem itemWithTitle:@"委托" accessoryType:UITableViewCellAccessoryNone selectionHandler:^(RETableViewItem *item)
                        {
                            [item deselectRowAnimated:YES];
                            [weakSelf weiTuoAction];
                        }];
    self.addWeiTuoActions.textAlignment = NSTextAlignmentCenter;
}


-(void)qianYueAction
{
    if (![self.housePtcl.edit_permit isEqualToString:@"1"] && ![self.housePtcl.secret_permit isEqualToString:@"1"])
    {
        PRESENTALERT(@"添加失败", @"对不起您没有权限对该房源新增签约", @"OK", nil,self);
        return;
    }
    
    SignAddController *vc = [[SignAddController alloc] initWithStyle:UITableViewStyleGrouped];
    vc.sid = self.houseDtl.trade_no;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)createQianYueBtn
{
    __typeof (&*self) __weak weakSelf = self;
    self.addQianYueActions = [RETableViewItem itemWithTitle:@"签约" accessoryType:UITableViewCellAccessoryNone selectionHandler:^(RETableViewItem *item)
                        {
                            [item deselectRowAnimated:YES];
                            [weakSelf qianYueAction];
                        }];
    self.addQianYueActions.textAlignment = NSTextAlignmentCenter;
}

#pragma mark ---------------CreateSection&Items----------------
#pragma mark


#pragma mark ---------------getData----------------
#pragma mark
-(void)getData
{
    SHOWHUD_WINDOW;
    [HouseDataPuller pullHouseParticulars:self.houseDtl Success:^(HouseParticulars*ptcl,NSArray*roleList)
     {
         self.housePtcl = ptcl;
         self.roleListOfHouse = roleList;
         
         [contactDataManager getPsnByJobNo:self.housePtcl.owner_job_no Success:^(id responseObject) {
             if (responseObject)
             {
                 self.owner = responseObject;
             }
             [self reloadUI];
         } failure:^(NSError *error) {
             
         }];
         
         
         HIDEHUD_WINDOW;
     }failure:^(NSError* error)
     {
         
         HIDEHUD_WINDOW;
     }];
    
}

-(void)getSecretDataForEdit:(BOOL)edit
{
    if (self.houseSecretPtcl)
    {
        if (edit)
        {
            [self toEditCtrl];
        }
        else
        {
            [self reloadUIForSecret:YES];
        }
        
        return;
    }
    SHOWHUD_WINDOW;
    [HouseDataPuller pullHouseSecrectParticulars:self.houseDtl Success:^(houseSecretParticulars*ptcl)
     {
         self.houseSecretPtcl = ptcl;
         if (self.houseSecretPtcl)
         {
             if (edit)
             {
                 [self toEditCtrl];
             }
             else
             {
                 [self reloadUIForSecret:YES];
             }
             
             
         }
         HIDEHUD_WINDOW;
     }failure:^(NSError* error)
     {
         HIDEHUD_WINDOW;
     }];
}

-(void)reloadUIForSecret:(BOOL)lookSecret
{
    [self.manager removeAllSections];
    if (lookSecret == YES)
    {
        
        [self.manager addSection:self.infoSection];
        [self.manager addSection:self.secretSection];
        //[self.manager addSection:self.actionSection];
        [self prepareSecretSectionItems];
        [self enableOrDisableItems];
        self.lookSecretItem.title = @"隐藏保密信息";
    }
    else
    {
        [self.manager addSection:self.infoSection];
        self.lookSecretItem.title = @"查看保密信息";
        //[self.manager addSection:self.actionSection];
    }
    
    [self.tableView reloadData];
    
}
#pragma mark ---------------getData----------------
#pragma mark

#pragma mark ---------------elementMethods----------------
#pragma mark
-(BOOL)isString:(NSString*)str InStringArr:(NSArray*)arr
{
    if (str && [str length] > 0 && arr)
    {
        for (NSString*tmpStr in arr)
        {
            if ([tmpStr isKindOfClass:[NSString class]])
            {
                if ([tmpStr isEqualToString:str])
                {
                    return YES;
                }
            }
        }
    }
    return NO;
}

-(NSString*)nameOfInstance:(id)instance
{
    unsigned int numIvars = 0;
    NSString *key=nil;
    
    Ivar * ivars = class_copyIvarList([super superclass], &numIvars);
    for(int i = 0; i < numIvars; i++) {
        Ivar thisIvar = ivars[i];
        const char *type = ivar_getTypeEncoding(thisIvar);
        NSString *stringType =  [NSString stringWithCString:type encoding:NSUTF8StringEncoding];
        if (![stringType hasPrefix:@"@"]) {
            continue;
        }
        if ((object_getIvar(self, thisIvar) == instance)) {
            key = [NSString stringWithUTF8String:ivar_getName(thisIvar)];
            break;
        }
    }
    free(ivars);
    return key;
    
}

-(id)instanceOfName:(NSString*)name
{
    unsigned int numIvars = 0;
    id returnValue = nil;
    
    Ivar * ivars = class_copyIvarList([super superclass], &numIvars);
    for (const Ivar *p = ivars; p < ivars + numIvars; ++p)
    {
        Ivar const ivar = *p;
        
        NSString *key = [NSString stringWithUTF8String:ivar_getName(ivar)];
        if ([key hasPrefix:@"_"])
        {
            NSString*tmpKey = [key substringFromIndex:1];
            if ([tmpKey isEqualToString:name])
            {
                
                returnValue =  [self valueForKey:key];
                break;
            }
        }
        
        
        
        
    }
    free(ivars);
    return returnValue;
    
}

-(NSString*)convertToDicValueForItem:(NSString*)itemName FromValue:(NSString*)value
{
    NSString*dicValue = @"";
    
    NSArray*arr = nil;
    
    if(value && itemName)
    {
        if([itemName isEqualToString:@"house_driect"])
        {
            arr =  self.house_driect_dic_arr;
        }
        else if ([itemName isEqualToString:@"fitment_type"])
        {
            arr =  self.fitment_type_dic_arr;
        }
        else if ([itemName isEqualToString:@"use_situation"])
        {
            arr =  self.use_situation_dic_arr;
        }
        else if ([itemName isEqualToString:@"client_gender"])
        {
            arr =  self.sex_dic_arr;
        }
        else if ([itemName isEqualToString:@"look_permit"])
        {
            arr =  self.look_permit_dic_arr;
        }
        else if ([itemName isEqualToString:@"client_source"])
        {
            arr =  self.client_source_dic_arr;
        }
        else if ([itemName isEqualToString:@"property_term"])
        {
            arr =  self.build_property_dic_arr;
        }
    }
    
    
    
    if (arr)
    {
        for (DicItem*di in arr)
        {
            if ([value  isEqualToString:di.dict_label])
            {
                return di.dict_value;
            }
        }
    }
    return  dicValue;
}



-(void)editBtnClicked:(id)sender
{
    if (self.houseSecretPtcl)
    {
        [self toEditCtrl];
    }
    else
    {
        [self getSecretDataForEdit:YES];
    }
}

-(void)toEditCtrl
{
    HouseEditParticularsViewController*editCtrl = [[HouseEditParticularsViewController alloc] init];
    editCtrl.housePtcl = self.housePtcl;
    editCtrl.houseSecretPtcl = self.houseSecretPtcl;
    editCtrl.houseDtl = self.houseDtl;
    editCtrl.delegate = self;
    editCtrl.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:editCtrl animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setNeedRefresh
{
    self.refreshAfterEdit = YES;
}



- (void)initiateMenuOptions {
    self.menuTitles = @[
                        @"新增跟进",　
                        @"新增委托",
                        @"新增带看",
                        @"新增签约",
                        @"房源实勘",
                        @"添加钥匙"
                        ];
    
    self.menuIcons = @[
                       [UIImage imageNamed:@"房源详情_跟进"],
                       [UIImage imageNamed:@"房源详情_委托"],
                       [UIImage imageNamed:@"房源详情_带看"],
                       [UIImage imageNamed:@"房源详情_签约"],
                       [UIImage imageNamed:@"房源详情_实勘"],
                       [UIImage imageNamed:@"房源详情_钥匙"],
                       ];
}


- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    //should be called after rotation animation completed
    [self.contextMenuTableView reloadData];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    [self.contextMenuTableView updateAlongsideRotation];
}

- (void)viewWillTransitionToSize:(CGSize)size
       withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    
    [coordinator animateAlongsideTransition:nil completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        //should be called after rotation animation completed
        [self.contextMenuTableView reloadData];
    }];
    [self.contextMenuTableView updateAlongsideRotation];
    
}


-(YALContextMenuTableView*)contextMenuTableView
{
    if (!_contextMenuTableView)
    {
        _contextMenuTableView = [[YALContextMenuTableView alloc]initWithTableViewDelegateDataSource:self];
        _contextMenuTableView.animationDuration = 0.03;
        _contextMenuTableView.yalDelegate = self;
        
        
        UINib *cellNib = [UINib nibWithNibName:menuCellIdentifier bundle:nil];
        [_contextMenuTableView registerNib:cellNib forCellReuseIdentifier:menuCellIdentifier];
    }
    return _contextMenuTableView;
}


#pragma mark - YALContextMenuTableViewDelegate

- (void)contextMenuTableView:(YALContextMenuTableView *)contextMenuTableView didDismissWithIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"Menu dismissed with indexpath = %@", indexPath);
}

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (void)tableView:(YALContextMenuTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //NSIndexPath*path = [NSIndexPath indexPathForRow:0 inSection:0];
    //[tableView dismisWithIndexPath:path];
    if (tableView == _contextMenuTableView) {
        [self dismissContextMenuTableView];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _contextMenuTableView)
    {
        return 55;
    }
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.menuTitles.count;
}

- (UITableViewCell *)tableView:(YALContextMenuTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ContextMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:menuCellIdentifier forIndexPath:indexPath];
    
    if (cell) {
        NSInteger index = self.menuTitles.count - 1 - indexPath.row;
        cell.menuTitleLabel.text = [self.menuTitles objectAtIndex:index];
        cell.menuImageView.image = [self.menuIcons objectAtIndex:index];
        cell.tag = index;
        cell.delegate = self;
    }
    
    return cell;
}


-(void)didTapedOnImageView:(id)sender
{
    [self dismissContextMenuTableView];
    UIView*view = sender;
    switch (view.tag)
    {
        case 0:
        {
            [self genJinAction];
        }
            break;
        case 1:
        {
            [self weiTuoAction];
            
        }
            break;
        case 2:
        {
            [self daiKanAction];
        }
            break;
        case 3:
        {
            [self qianYueAction];
            
        }
            break;
        case 4:
        {
            if (self.survey == nil)
            {
                self.survey = [[HouseSurvey alloc] init];
            }
            
            [self.survey startSurveyWithHouse:self.houseDtl RoleList:self.roleListOfHouse InVc:self];
        }
        case 5:
        {
            
        }
            break;
            
        default:
            break;
    }
    
    
}


-(void)contextMenuTableViewDidDismissingOnBlank
{
    [self dismissContextMenuTableView];
}
@end
