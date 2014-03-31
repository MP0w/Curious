//
//  MPViewController.h
//  curious
//
//  Created by Alex Manzella on 28/03/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPViewController.h"
#import "MPMethodsListViewController.h"

@interface MPInspectorViewController : MPViewController{
    
    NSCache *snapshotsCache;
}

@property (nonatomic,readwrite) NSArray *objects;

- (instancetype)initWithObjects:(NSArray *)objects;

@end
