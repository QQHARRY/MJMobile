//
//  houseSurveyTableViewController.h
//  MJ
//
//  Created by harry on 15/6/30.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//

#import "houseImagesTableViewController.h"
#import "HouseDetail.h"

@protocol HouseAddSurveryDelegate <NSObject>

-(void)hasSelectZt:(NSArray*)ztArr Snt:(NSArray*)sntArr Hxt:(NSArray*)hxtArr Zpt:(NSArray*)zptArr Remark:(NSString*)remark ForHouse:(HouseDetail*)house;

@end



@interface houseSurveyTableViewController : houseImagesTableViewController


@property(nonatomic,weak)id<HouseAddSurveryDelegate>delegate;
@property(nonatomic,strong)NSString*parentPictureID;


@end
