//
//  MPMessageSenderViewController.h
//  CuriosInspectorTestApp
//
//  Created by Alex Manzella on 06/04/14.
//  Copyright (c) 2014 Alex Manzella. All rights reserved.
//

#import "MPViewController.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "NSObject+object_print.h"

#import "UIAlertView+blocks.h"

@interface MPMessageSenderViewController : MPViewController{
    
    NSArray *argumentsType;
    NSInteger numberOfArguments;
    NSArray *methodComponents;
    
    NSMutableDictionary *parameters;
    
}

@property (nonatomic,assign) MPMethodType methodType;
@property (nonatomic) Method method;
@property (nonatomic) Class objClass;

- (instancetype)initWithClass:(Class)objClass method:(Method)method methodType:(MPMethodType)methodType;

@end
