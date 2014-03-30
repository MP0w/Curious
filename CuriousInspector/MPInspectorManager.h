//
//  MPInspectorManager.h
//  curious
//
//  Created by Alex Manzella on 30/03/14.
//  Copyright (c) 2014 Alex Manzella. All rights reserved.
//

#import <Foundation/Foundation.h>

#define USE_VOLUME_CONTROL_TO_SHOW 1



@interface MPInspectorManager : NSObject{
    
}

@property (nonatomic,strong) UIWindow *inspectorWindow;


+ (MPInspectorManager *)sharedManager;

+ (void)presentForApplication:(UIApplication *)application;// to use somewhere outside the sandbox ?!?
+ (void)presentWithObjects:(NSArray *)objects;
+ (void)present; // assume the current Application
+ (void)dismiss;

- (void)presentForApplication:(UIApplication *)application;// to use somewhere outside the sandbox ?!? 
- (void)presentWithObjects:(NSArray *)objects;
- (void)present; // assume the current Application
- (void)dismiss;

@end
