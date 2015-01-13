//
//  HouseEditParticularsViewController.m
//  MJ
//
//  Created by harry on 15/1/12.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//

#import "HouseEditParticularsViewController.h"
#import <objc/runtime.h>

@interface HouseEditParticularsViewController ()

@end

@implementation HouseEditParticularsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.housePtcl)
    {
        //[self prepareInfoSectionItems];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getData
{
    [self reloadUI];
}

-(void)reloadUI
{

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(sumitBtnClicked:)];

    [self prepareSections];
    [self prepareItems];
    [self.tableView reloadData];
}

-(void)createSections
{
    CGFloat sectH = 1;
    self.infoSection = [RETableViewSection sectionWithHeaderTitle:@""];
    self.infoSection.headerHeight = sectH;
}

-(void)prepareSections
{
    [self.manager removeAllSections];
    [self.manager addSection:self.infoSection];
    
}

-(void)prepareItems
{
    [self prepareInfoSectionItems];
    
}
-(void)prepareInfoSectionItems
{
    [super createInfoSectionItems];
    [super createSecretSectionItems];
    [self.infoSection removeAllItems];
    
    NSArray*arr = [super getEditAbleFields];

    for (NSString* name in arr)
    {
        id item = [self instanceOfName:name];
        if (item != nil && [item isKindOfClass:[RETableViewItem class]])
        {
            NSLog(@"add item =%@",name);
            [self.infoSection addItem:item];
        }
    }
    
    self.build_structure_area.value = self.housePtcl.build_structure_area;

    [self adjustByTeneApplication];
}

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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
