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
#import <MobileCoreServices/UTCoreTypes.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "HouseDataPuller.h"

@interface houseImagesTableViewController ()
@property (strong, readwrite, nonatomic) RETableViewManager *manager;
@property (strong, readwrite, nonatomic) RETableViewSection *xqtSection;
@property (strong, readwrite, nonatomic) RETableViewSection *hxtSection;
@property (strong, readwrite, nonatomic) RETableViewSection *sntSection;

@property (strong, readwrite, nonatomic) RETableViewSection *curSection;
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
                //item.cellHeight = 200;
                [self.xqtSection addItem:item];
                
                NSString *imgStr = [SERVER_ADD stringByAppendingString:imgName];
                UIImageView* imageV = [[UIImageView alloc] init];
                [imageV getImageWithURL:[NSURL URLWithString:imgStr] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image)
                 {
                    item.image = image;
                    
                    item.cellHeight = image.size.height * (self.view.frame.size.width-30)/image.size.width;
                    
                } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                    
                    
                }];
            }
        }
        
    }
    
    [self createAddImageButton:self.xqtSection];
}

-(void)createhxtSection
{
    self.hxtSection = [RETableViewSection sectionWithHeaderTitle:@"户型图"];
    [self.manager addSection:self.hxtSection];
    if (self.housePtcl)
    {
        if (self.housePtcl.hxt)
        {
            NSArray*arr = [self.housePtcl.hxt componentsSeparatedByString:@";"];
            for (NSString*imgName in arr)
            {
                RETableViewItem*item = [[RETableViewItem alloc] init];
                //item.cellHeight = 200;
                [self.hxtSection addItem:item];
                
                NSString *imgStr = [SERVER_ADD stringByAppendingString:imgName];
                UIImageView* imageV = [[UIImageView alloc] init];
                [imageV getImageWithURL:[NSURL URLWithString:imgStr] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image)
                 {
                     item.image = image;
                     
                     item.cellHeight = image.size.height * (self.view.frame.size.width-30)/image.size.width;
                     
                 } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                     
                     
                 }];
            }
        }
        
    }
    
    [self createAddImageButton:self.hxtSection];
}


-(void)createsntSection
{
    self.sntSection = [RETableViewSection sectionWithHeaderTitle:@"室内图"];
    [self.manager addSection:self.sntSection];
    if (self.housePtcl)
    {
        if (self.housePtcl.snt)
        {
            NSArray*arr = [self.housePtcl.snt componentsSeparatedByString:@";"];
            for (NSString*imgName in arr)
            {
                RETableViewItem*item = [[RETableViewItem alloc] init];
                //item.cellHeight = 200;
                [self.sntSection addItem:item];
                
                NSString *imgStr = [SERVER_ADD stringByAppendingString:imgName];
                UIImageView* imageV = [[UIImageView alloc] init];
                [imageV getImageWithURL:[NSURL URLWithString:imgStr] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image)
                 {
                     item.image = image;
                     
                     item.cellHeight = image.size.height * (self.view.frame.size.width-30)/image.size.width;
                     
                     
                 } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                     
                     
                 }];
            }
        }
        
    }
    
    [self createAddImageButton:self.sntSection];
}


- (IBAction)addPhoto
{
    
    UIActionSheet *sheet;
    
    
    NSString* take = @"照相";
    NSString* choose = @"从相册选择";
    NSString* cancel = @"取消";
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        
        sheet  = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:nil destructiveButtonTitle:cancel otherButtonTitles:take,choose, nil];
        
    }
    
    else {
        
        sheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:nil destructiveButtonTitle:cancel otherButtonTitles:choose, nil];
        
    }
    
    sheet.tag = 1;
    
    [sheet showInView:self.view];
}

- (void)createAddImageButton:(RETableViewSection*)section
{
    if (section != nil)
    {
        //__typeof (&*self) __weak weakSelf = self;
        RETableViewItem*addBtn = [RETableViewItem itemWithTitle:@"添加图片" accessoryType:UITableViewCellAccessoryNone selectionHandler:^(RETableViewItem *item)
                                  {
                                      self.curSection = section;
                                      [self addPhoto];
                                  }];
        addBtn.textAlignment = NSTextAlignmentCenter;
        [section addItem:addBtn];
    }
    
    
}


-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(self.curSection)
    {
        NSString*str = [self.curSection headerTitle];
    }
    if (actionSheet.tag == 1)
    {
        
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
}


#pragma mark - image picker delegte
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if (image && [type isEqualToString:(NSString *)kUTTypeImage])
    {
        
        //updae image to server
        NSString*strImageFor = @"xqt";
        if (self.curSection != self.xqtSection)
        {
            if (self.curSection == self.hxtSection)
            {
                strImageFor = @"hxt";
            }
            else if (self.curSection == self.sntSection)
            {
                strImageFor = @"snt";
            }
        }
        
        
        [HouseDataPuller pushImage:image ToHouse:self.houseDtl HouseParticulars:self.housePtcl ImageType:strImageFor Success:^(id responseObject) {
            
        } failure:^(NSError *error) {
            
        }];
        
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
