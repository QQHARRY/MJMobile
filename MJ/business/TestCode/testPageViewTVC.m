//
//  testPageViewTVC.m
//  MJ
//
//  Created by harry on 15/7/15.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//

#import "testPageViewTVC.h"

@implementation testPageViewTVC


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString*identifier = @"testcell";
    UITableViewCell*cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    cell.textLabel.text = @"test";
    
    return cell;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

@end
