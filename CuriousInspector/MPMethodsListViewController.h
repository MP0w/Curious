//
//  MPMethodsListViewController.h
//  CuriosInspectorTestApp
//
//  Created by Alex Manzella on 31/03/14.
//  Copyright (c) 2014 Alex Manzella. All rights reserved.
//

#import "MPViewController.h"
#import <objc/runtime.h>
#import "NSObject+object_print.h"

@interface MPMethodsListViewController : MPViewController<UISearchBarDelegate,UISearchDisplayDelegate>{
    
    NSMutableArray *methodsNames;
    
    NSArray *filteredArray;
    
    NSDictionary * detailAttributes;
    NSDictionary *normalAttributes;
    NSDictionary *returnTypeAttributes;
    
    UISearchDisplayController *searchDisplayController;
    
}

- (instancetype)initWithObjects:(NSObject *)object;


@end
