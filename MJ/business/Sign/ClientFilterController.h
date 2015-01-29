//
//  ClientFilterController.h
//  RETableViewManagerExample
//
//  Created by Roman Efimov on 2/28/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RETableViewManager.h"
#import "RETableViewOptionsController.h"
#import "CustomerViewController.h"
#import "ContactListTableViewController.h"

@protocol ClientSelection <NSObject>

@required

-(void)returnClientSelection:(NSDictionary *)client;

@end

@interface ClientFilterController : UITableViewController
    <RETableViewManagerDelegate, contacSelection, ClientSelection>

@property (nonatomic, weak) id<ClientSelection> delegate;

-(void)returnSelection:(NSArray*)curSelection;
-(void)returnClientSelection:(NSDictionary *)client;

@end
