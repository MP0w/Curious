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

@interface MPInspectorViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    
    UITableView *tableView;
    NSDictionary *defaultAttributes;
    NSDictionary *normalAttributes;
    NSDictionary *hierarchyAttributes;
}

@property (nonatomic,readwrite) NSArray *objects;

- (instancetype)initWithObjects:(NSArray *)objects;

@end
