//
//  houseImagesTableViewController.m
//  MJ
//
//  Created by harry on 15/1/10.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//

#import "houseImagesTableViewController.h"
#import "Macro.h"
#import "UIImageView+AFNetworking.h"

@interface houseImagesTableViewController ()
@property (strong, readwrite, nonatomic) RETableViewManager *manager;
@property (strong, readwrite, nonatomic) RETableViewSection *xqtSection;
@property (strong, readwrite, nonatomic) RETableViewSection *hxtSection;
@property (strong, readwrite, nonatomic) RETableViewSection *sntSection;
@end

@implementation houseImagesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.manager = [[RETableViewManager alloc] initWithTableView:self.tableView delegate:self];
    [self createxqtSection];
    [self createhxtSection];
    [self createsntSection];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)createxqtSection
{
    self.xqtSection = [RETableViewSection sectionWithHeaderTitle:@"小区图"];
    [self.manager addSection:self.xqtSection];
    

    
    if (self.housePtcl)
    {
        if (self.housePtcl.xqt)
        {
            NSArray*arr = [self.housePtcl.xqt componentsSeparatedByString:@";"];
            for (NSString*imgName in arr)
            {
                RETableViewItem*item = [[RETableViewItem alloc] init];
                item.cellHeight = 200;
                [self.xqtSection addItem:item];
                
                NSString *imgStr = [SERVER_ADD stringByAppendingString:imgName];
                UIImageView* imageV = [[UIImageView alloc] init];
                [imageV getImageWithURL:[NSURL URLWithString:imgStr] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                    item.image = image;
                    
                    
                } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                    
                    
                }];
            }
        }
        
    }
}

-(void)createhxtSection
{
    self.hxtSection = [RETableViewSection sectionWithHeaderTitle:@"户型图"];
    
    
    [self.manager addSection:self.hxtSection];
}


-(void)createsntSection
{
    self.sntSection = [RETableViewSection sectionWithHeaderTitle:@"室内图"];
    
    
    [self.manager addSection:self.sntSection];
}


@end
