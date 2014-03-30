//
//  MPViewController.h
//  curious
//
//  Created by Alex Manzella on 28/03/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPUtils.h"
#import "MPInspectorManager.h"
#import "MPObjectTableViewCell.h"
#import "MPRelatedObjectTableViewCell.h"

static NSString *objectCellID=@"objectCellID";
static NSString *relatedObjectCellID=@"relatedObjectCellID";
static NSString *methodCellID=@"methodCellID";

@interface MPInspectorViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    
    UITableView *tableView;
    NSCache *snapshotsCache;
}

@property (nonatomic,readwrite) NSArray *objects;

- (instancetype)initWithObjects:(NSArray *)objects;

@end
