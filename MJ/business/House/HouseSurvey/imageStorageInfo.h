//
//  imageStorageInfo.h
//  MJ
//
//  Created by harry on 15/6/24.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//

#import "dic2Object.h"

@interface imageStorageInfo : dic2Object

@property(strong,nonatomic)NSString*fileName;
@property(strong,nonatomic)NSString*filePath;
@property(strong,nonatomic)NSString*thumbPath;
@property(strong,nonatomic)NSString*status;
@property(strong,nonatomic)NSString*topic;
@property(strong,nonatomic)NSString*storageNo;
@end
