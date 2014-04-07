//
//  MPViewController.h
//  CuriosInspectorTestApp
//
//  Created by Alex Manzella on 30/03/14.
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

typedef enum : NSUInteger {
    MPClassMethod,
    MPInstanceMethod,
} MPMethodType;

@interface MPViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    
    UITableView *tableView;
    
}

@end
