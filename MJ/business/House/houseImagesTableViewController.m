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
#import "UtilFun.h"
#import "person.h"
#import "postFileUtils.h"



#define SECTION_HEIGHT 22

@interface houseImagesTableViewController ()


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
    //[self createZptSection];
}

-(void)viewDidAppear:(BOOL)animated
{
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

-(void)viewDidDisappear:(BOOL)animated
{
     self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)createxqtSection
{
    self.xqtSection = [RETableViewSection sectionWithHeaderTitle:@"主图"];
    self.xqtSection.headerHeight = SECTION_HEIGHT;
    [self.manager addSection:self.xqtSection];
    

    
    if (self.housePtcl && self.watchMode == EDITMODE)
    {
        if (self.housePtcl.xqt && self.housePtcl.xqt.length > 0)
        {
            //NSLog(@"小区图=%@",self.housePtcl.xqt);
            NSArray*arr = [self.housePtcl.xqt componentsSeparatedByString:@", "];
            for (NSString*imgName in arr)
            {
                
                
                NSString *imgStr = imgName;
                //NSLog(@"%@",imgStr);
                UIImageView* imageV = [[UIImageView alloc] init];
                [imageV getImageWithURL:[NSURL URLWithString:imgStr] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image)
                 {
                     RETableViewItem*item = [[RETableViewItem alloc] init];
                     CGFloat scale =  (self.view.frame.size.width-30)/image.size.width;
                     UIImage*covertedImg = [UtilFun scaleImage:image toScale:scale];
                     item.cellHeight = image.size.height * scale;
                     item.image = covertedImg;
                     [self.xqtSection addItem:item];
                     [self.tableView reloadData];
                     
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
    self.hxtSection.headerHeight = SECTION_HEIGHT;
    [self.manager addSection:self.hxtSection];
    if (self.housePtcl && self.watchMode == EDITMODE)
    {
        if (self.housePtcl.hxt && self.housePtcl.hxt.length == 0)
        {
            NSLog(@"户型图=%@",self.housePtcl.hxt);
            NSArray*arr = [self.housePtcl.hxt componentsSeparatedByString:@", "];
            for (NSString*imgName in arr)
            {
                NSString *imgStr = imgName;
                NSLog(@"%@",imgStr);
                UIImageView* imageV = [[UIImageView alloc] init];
                [imageV getImageWithURL:[NSURL URLWithString:imgStr] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image)
                 {
                     RETableViewItem*item = [[RETableViewItem alloc] init];
                     CGFloat scale =  (self.view.frame.size.width-30)/image.size.width;
                     UIImage*covertedImg = [UtilFun scaleImage:image toScale:scale];
                     item.cellHeight = image.size.height * scale;
                     item.image = covertedImg;
                     [self.hxtSection addItem:item];
                     [self.tableView reloadData];
                     
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
    self.sntSection.headerHeight = SECTION_HEIGHT;
    [self.manager addSection:self.sntSection];
    if (self.housePtcl && self.watchMode == EDITMODE)
    {
        if (self.housePtcl.snt && self.housePtcl.snt.length == 0)
        {
            NSLog(@"室内图=%@",self.housePtcl.snt);
            NSArray*arr = [self.housePtcl.snt componentsSeparatedByString:@", "];
            for (NSString*imgName in arr)
            {
                
                
                NSString *imgStr = imgName;
                NSLog(@"%@",imgStr);
                UIImageView* imageV = [[UIImageView alloc] init];

                [imageV getImageWithURL:[NSURL URLWithString:imgStr] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image)
                 {
                     RETableViewItem*item = [[RETableViewItem alloc] init];
                     CGFloat scale =  (self.view.frame.size.width-30)/image.size.width;
                     UIImage*covertedImg = [UtilFun scaleImage:image toScale:scale];
                     item.cellHeight = image.size.height * scale;
                     item.image = covertedImg;
                     [self.sntSection addItem:item];
                     [self.tableView reloadData];
                     
                 } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                     
                     
                 }];
            }
        }
        
    }
    
    [self createAddImageButton:self.sntSection];
}
-(void)createZptSection
{
    self.zptSection = [RETableViewSection sectionWithHeaderTitle:@"自拍图"];
    self.zptSection.headerHeight = 22;
    [self.manager addSection:self.zptSection];
    
    
    
    if (self.housePtcl && self.watchMode == EDITMODE)
    {
        if (self.housePtcl.zpt && self.housePtcl.zpt.length > 0)
        {
            NSArray*arr = [self.housePtcl.zpt componentsSeparatedByString:@", "];
            for (NSString*imgName in arr)
            {
                
                
                NSString *imgStr = imgName;
                NSLog(@"%@",imgStr);
                UIImageView* imageV = [[UIImageView alloc] init];
                [imageV getImageWithURL:[NSURL URLWithString:imgStr] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image)
                 {
                     RETableViewItem*item = [[RETableViewItem alloc] init];
                     CGFloat scale =  (self.view.frame.size.width-30)/image.size.width;
                     UIImage*covertedImg = [UtilFun scaleImage:image toScale:scale];
                     item.cellHeight = image.size.height * scale;
                     item.image = covertedImg;
                     [self.zptSection addItem:item];
                     [self.tableView reloadData];
                     
                 } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                     
                     
                 }];
            }
        }
        
    }
    
    [self createAddImageButton:self.zptSection];
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
    if (section != nil && (self.watchMode == EDITMODE || self.watchMode == ADDMODE))
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
        //NSString*str = [self.curSection headerTitle];
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
        
        imagePickerController.allowsEditing = NO;
        
        imagePickerController.sourceType = sourceType;
        imagePickerController.navigationBar.barTintColor = self.navigationController.navigationBar.barTintColor;
        imagePickerController.navigationBar.tintColor = self.navigationController.navigationBar.tintColor;
        imagePickerController.navigationBar.titleTextAttributes = self.navigationController.navigationBar.titleTextAttributes;
        [self presentViewController:imagePickerController animated:YES completion:^{}];
        
    }
}


- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([navigationController isKindOfClass:[UIImagePickerController class]])
    {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    }
}

#pragma mark - image picker delegte

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    _lastestMimeType = [info objectForKeyedSubscript:UIImagePickerControllerMediaType];
    
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    }
    
    [CLClippingTool setupWithDataSource:self];
    CLImageEditor *editor = [[CLImageEditor alloc] initWithImage:image SingleEditting:YES SingleEdittingClass:[CLClippingTool class]];
    editor.delegate = self;
    //[picker presentViewController:editor animated:YES completion:nil];
    [self.navigationController pushViewController:editor animated:YES];
    
    
    
    
    

}


-(CliplingRatio*)CLClippingRatio;
{
    return [CliplingRatio RatioWithWidthSide:4 andHeightSide:3];
}

-(void)imageEditor:(CLImageEditor *)editor didFinishEdittingWithImage:(UIImage *)image
{

    NSData*data = UIImageJPEGRepresentation(image, 0.5);
    NSString *type = _lastestMimeType;
    if (image && [type isEqualToString:(NSString *)kUTTypeImage])
    {
        if (self.watchMode == EDITMODE)
        {
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
                else if (self.curSection == self.zptSection)
                {
                    strImageFor = @"zpt";
                }
            }
            
            NSDictionary *parameters = @{@"job_no":[person me].job_no,
                                         @"acc_password":[person me].password,
                                         @"DeviceID":[UtilFun getUDID],
                                         @"obj_type":@"房源",
                                         @"obj_no":self.housePtcl.buildings_picture,
                                         @"imageType":strImageFor,
                                         };
            SHOWHUD_WINDOW;
            [postFileUtils postFileWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", SERVER_URL, ADD_IMAGE] ] data:data Parameter:parameters ServerParamName:@"imagedata" FileName:strImageFor MimeType:type Success:^(id responseObj){
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
                    
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.tableView reloadData];
                        HIDEHUD_WINDOW;
                        
                    });
                    
                }
            } failure:^(NSError *error) {
                {
                    __block NSString*err = [error description
                                            ];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        PRESENTALERT(@"编辑失败",err, nil,nil, nil);
                        HIDEHUD_WINDOW;
                        
                    });
                }
            }];
            
        }
        else if (self.watchMode == ADDMODE)
        {
            RETableViewItem*item = [[RETableViewItem alloc] init];
            CGFloat scale =  (self.view.frame.size.width-30)/image.size.width;
            
            UIImage*covertedImg = [UtilFun scaleImage:image toScale:scale];
            item.cellHeight = image.size.height * scale;
            item.image = covertedImg;
            //item.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
            //item.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cancel"]];
            item.editingStyle = UITableViewCellEditingStyleDelete;
            
            item.deletionHandler = ^(RETableViewItem* item)
            {
                RETableViewSection*section =  item.section;
                if (section == self.hxtSection)
                {
                    if (self.hxtArr !=nil)
                    {
                        for (NSDictionary*dic in self.hxtArr)
                        {
                            id key = [[dic allKeys] objectAtIndex:0];
                            if ([key isEqualToString:[NSString stringWithFormat:@"%@",item]])
                            {
                                [self.hxtArr removeObject:dic];
                                break;
                            }
                        }
                    }
                    //[self.hxtSection removeItem:item];
                }
                else if (section == self.sntSection)
                {
                    if (self.sntArr !=nil)
                    {
                        for (NSDictionary*dic in self.sntArr)
                        {
                            id key = [[dic allKeys] objectAtIndex:0];
                            if ([key isEqualToString:[NSString stringWithFormat:@"%@",item]])
                            {
                                [self.sntArr removeObject:dic];
                                break;
                            }
                        }
                    }
                    
                    //[self.sntSection removeItem:item];
                }
                else if (section == self.xqtSection)
                {
                    if (self.xqtArr !=nil)
                    {
                        [self.xqtArr removeAllObjects];
                    }
                    
                    //[self.xqtSection removeItem:item];
                    
                }
                else if (self.curSection == self.zptSection)
                {
                    if (self.zqtArr !=nil)
                    {
                        for (NSDictionary*dic in self.zqtArr)
                        {
                            id key = [[dic allKeys] objectAtIndex:0];
                            if ([key isEqualToString:[NSString stringWithFormat:@"%@",item]])
                            {
                                [self.zqtArr removeObject:dic];
                                break;
                            }
                        }
                    }
                }
                [self.tableView reloadData];
                
                
            };
            
            if (self.curSection == self.hxtSection)
            {
                if (self.hxtArr ==nil)
                {
                    self.hxtArr = [[NSMutableArray alloc] init];
                }
                
                NSString*key = [NSString stringWithFormat:@"%@",item];
                [self.hxtArr addObject:[NSDictionary dictionaryWithObject:image forKey:key]];
                
                [self.hxtSection removeLastItem];
                [self.hxtSection addItem:item];
                [self createAddImageButton:self.hxtSection];
            }
            else if (self.curSection == self.sntSection)
            {
                if (self.sntArr ==nil)
                {
                    self.sntArr = [[NSMutableArray alloc] init];
                }
                
                NSString*key = [NSString stringWithFormat:@"%@",item];
                [self.sntArr addObject:[NSDictionary dictionaryWithObject:image forKey:key]];
                
                [self.sntSection removeLastItem];
                [self.sntSection addItem:item];
                [self createAddImageButton:self.sntSection];
            }
            else if (self.curSection == self.zptSection)
            {
                if (self.zqtArr ==nil)
                {
                    self.zqtArr = [[NSMutableArray alloc] init];
                }
                
                NSString*key = [NSString stringWithFormat:@"%@",item];
                [self.zqtArr addObject:[NSDictionary dictionaryWithObject:image forKey:key]];
                
                [self.zptSection removeLastItem];
                [self.zptSection addItem:item];
                [self createAddImageButton:self.zptSection];
            }
            else
            {
                if (self.xqtArr ==nil)
                {
                    self.xqtArr = [[NSMutableArray alloc] init];
                }
                
                [self.xqtArr removeAllObjects];
                
                NSString*key = [NSString stringWithFormat:@"%@",item];
                [self.xqtArr addObject:[NSDictionary dictionaryWithObject:image forKey:key]];
                
                [self.xqtSection removeAllItems];
                [self.xqtSection addItem:item];
                [self createAddImageButton:self.xqtSection];
                
            }
            [self.tableView reloadData];
        }
    }
}

-(void)imageEditorDidCancel:(CLImageEditor *)editor
{
    
}


-(BOOL)navigationShouldPopOnBackButton
{
    if (self.watchMode == ADDMODE)
    {
        PRESENTALERTWITHHANDER_WITHDEFAULTCANCEL(@"确定退出?", @"退出将放弃已经保存的内容", @"确定", ^()
                                                 {
                                                     [self.navigationController  popViewControllerAnimated:YES];
                                                     
                                                 },@"取消",nil, self);
        return NO;
    }
    return YES;
}








@end
