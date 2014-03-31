//
//  MPMethodsListViewController.h
//  CuriosInspectorTestApp
//
//  Created by Alex Manzella on 31/03/14.
//  Copyright (c) 2014 Alex Manzella. All rights reserved.
//

#import "MPViewController.h"
#import <objc/runtime.h>

@interface MPMethodsListViewController : MPViewController<UISearchBarDelegate>{
    
    NSMutableArray *methodsNames;
    Method *methodsList;
    
    NSDictionary * detailAttributes;
    NSDictionary *normalAttributes;
    NSDictionary *returnTypeAttributes;
    
}

- (instancetype)initWithObjects:(NSObject *)object;


@end
