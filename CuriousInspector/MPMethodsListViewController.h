//
//  MPMethodsListViewController.h
//  CuriosInspectorTestApp
//
//  Created by Alex Manzella on 31/03/14.
//  Copyright (c) 2014 Alex Manzella. All rights reserved.
//

#import "MPViewController.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "NSObject+object_print.h"
#import "MPMessageSenderViewController.h"
#import "UIAlertView+blocks.h"




@interface MPMethodsListViewController : MPViewController<UISearchBarDelegate,UISearchDisplayDelegate>{
    
    NSMutableArray *methodsNames;
    
    NSArray *filteredArray;
    
    NSDictionary * detailAttributes;
    NSDictionary *normalAttributes;
    NSDictionary *returnTypeAttributes;
    
    UISearchDisplayController *searchDisplayController;
    
    
}

@property (nonatomic,assign)     id object;


- (instancetype)initWithObjects:(NSObject *)object;


@end
