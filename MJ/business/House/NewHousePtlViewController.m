//
//  ViewController.m
//  MJ
//
//  Created by harry on 15/6/11.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//

#import "NewHousePtlViewController.h"
#import "ImagePlayerView.h"
#import "houseDoubleFieldCell.h"
#import "UIImageView+AFNetworking.h"
#import "MessageReadManager.h"
#import "UIViewController+ContactsFunction.h"

#define ITEMBARHEIGHT 44
#define NAVGATIONBAR_H 64


@interface NewHousePtlViewController ()<ImagePlayerViewDelegate,UITableViewDataSource,UITableViewDelegate>


@property(strong,nonatomic)ImagePlayerView*houseImagePlayer;
@property(strong,nonatomic)UITableView*tableView;
@property(strong,nonatomic)UIToolbar*toolBar;
@property(strong,nonatomic)MessageReadManager*messageReadManager;

@end

@implementation NewHousePtlViewController

@synthesize houseDtl;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self houseImagePlayer];
    [self tableView];
    [self toolBar];
    [self editButtonByRights];
    if (houseDtl)
    {
        
    }
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
        [_houseImagePlayer initWithCount:15 delegate:self];
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

-(UITableView*)tableView
{
    if (_tableView == nil)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - ITEMBARHEIGHT - NAVGATIONBAR_H) style:UITableViewStylePlain];
        [_tableView setShowsVerticalScrollIndicator:NO];
        [_tableView setShowsHorizontalScrollIndicator:NO];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[houseDoubleFieldCell class] forCellReuseIdentifier:@"houseDoubleFieldCell"];
        [self.view addSubview:_tableView];
    }
    
    return _tableView;
}

-(UIToolbar*)toolBar
{
    if (_toolBar == nil)
    {
        _toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-ITEMBARHEIGHT-NAVGATIONBAR_H, self.view.frame.size.width, ITEMBARHEIGHT)];
        
        //_toolBar.backgroundColor = [UIColor redColor];
        
        NSMutableArray *items = [[NSMutableArray alloc] init];
        
        UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        UIBarButtonItem* genJinBtn =  [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@""] style:UIBarButtonItemStylePlain target:self action:@selector(onBtnClicked:)];
        genJinBtn.tag = 10001;
        UIBarButtonItem* weiTuoBtn =  [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@""] style:UIBarButtonItemStylePlain target:self action:@selector(onBtnClicked:)];
        weiTuoBtn.tag = genJinBtn.tag+1;
        UIBarButtonItem* qianYueBtn =  [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@""] style:UIBarButtonItemStylePlain target:self action:@selector(onBtnClicked:)];
        qianYueBtn.tag = weiTuoBtn.tag+1;
        [items addObjectsFromArray:[NSArray arrayWithObjects:flexSpace,genJinBtn,flexSpace,weiTuoBtn,flexSpace,qianYueBtn,flexSpace,nil]];
        [_toolBar setItems:items];
        [self.view addSubview:_toolBar];
    }
    
    return _toolBar;
}

//-(void)onBtnClicked:(UIBarButtonItem*)sender
//{
//    switch (sender.tag)
//    {
//        case 10001:
//        {
//           
//        }
//            break;
//        case 10002:
//        {
//            
//        }
//            break;
//        case 10003:
//        {
//            
//        }
//            break;
//            
//        default:
//            break;
//    }
//}


-(void)editButtonByRights
{

}

#pragma mark - ImagePlayerViewDelegate
- (void)imagePlayerView:(ImagePlayerView *)imagePlayerView loadImageForImageView:(UIImageView *)imageView index:(NSInteger)index
{
    [imageView setImageWithURL:[NSURL URLWithString:@"http://sudasuta.com/wp-content/uploads/2013/10/10143181686_375e063f2c_z.jpg"]];
    
}

- (void)imagePlayerView:(ImagePlayerView *)imagePlayerView didTapAtIndex:(NSInteger)index
{
    NSMutableArray*arr = [[NSMutableArray alloc] initWithCapacity:15];
    for (int i =0; i < 15; i++)
    {
        MWPhoto*photo = [[MWPhoto alloc] initWithURL:[NSURL URLWithString:@"http://sudasuta.com/wp-content/uploads/2013/10/10143181686_375e063f2c_z.jpg"]];
        photo.caption = @"户型图";
        [arr addObject:photo];
    }
    
    [self.messageReadManager showBrowserWithImages:arr];
}



#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* identifier = @"houseDoubleFieldCell";
    houseDoubleFieldCell*cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
    {
        cell = [[houseDoubleFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    switch (indexPath.row)
    {
        case 0:
        {
            [cell setT1:@"11房源的详情:" V1:@"房源详情好房子" T2:@"美丽的房源:" V2:@"好房子"];
        }
            break;
        case 1:
        {
            [cell setT1:@"房源的详情:" V1:@"房源详情好房子" T2:nil V2:nil];
        }
            break;
        case 2:
        {
            [cell setT1:@"" V1:@"房源详情好房子" T2:@"美丽的好房源:" V2:@"好房子"];
        }
             break;
        case 3:
        {
            [cell setT1:@"房" V1:@"房源详情好房子" T2:@"美" V2:@"好房子"];
        }
             break;
        case 4:
        {
            [cell setT1:@"房源好房子" V1:@"房源详情好房子" T2:@"" V2:@"好房子"];
        }
             break;
        case 5:
        {
            [cell setT1:@"" V1:@"" T2:@"" V2:@""];
        }
            break;
            
        default:
        {
            [cell setT1:@"房源好房子" V1:@"房源详情好房子" T2:@"" V2:@"好房子"];
        }
            break;
    }
    
    
    
    
    return cell;
}

#pragma mark - UITableViewDelegate


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/














@end
