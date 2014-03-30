//
//  MPInspectorManager.m
//  curious
//
//  Created by Alex Manzella on 30/03/14.
//  Copyright (c) 2014 Alex Manzella. All rights reserved.
//

#import "MPInspectorManager.h"
#import "MPInspectorViewController.h"

@import AudioToolbox;


static MPInspectorManager* sharedManager=nil;


@implementation MPInspectorManager

void volumeListenerCallback (void *inClientData, AudioSessionPropertyID inID, UInt32 inDataSize, const void *inData){

    [[MPInspectorManager sharedManager] present];
}

+(MPInspectorManager *)sharedManager{
    
#if DEBUG
    
    if (nil != sharedManager) {
        return sharedManager;
    }
    
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        
        sharedManager = [[MPInspectorManager alloc] init];
  
#ifdef USE_VOLUME_CONTROL_TO_SHOW
#if USE_VOLUME_CONTROL_TO_SHOW
        
        AudioSessionInitialize(NULL, NULL, NULL, NULL);
        AudioSessionSetActive(YES);
        AudioSessionAddPropertyListener(kAudioSessionProperty_CurrentHardwareOutputVolume,volumeListenerCallback, (__bridge void *)(sharedManager));

#endif
#endif
        
    });
    
#endif
    return sharedManager;
}

+ (void)presentForApplication:(UIApplication *)application{
    [[MPInspectorManager sharedManager] presentForApplication:application];
}

+ (void)presentWithObjects:(NSArray *)objects{
    [[MPInspectorManager sharedManager] presentWithObjects:objects];

}

+ (void)present{
    [[MPInspectorManager sharedManager] present];
}

+ (void)dismiss{
    [[MPInspectorManager sharedManager] dismiss];
}

- (void)presentWithObjects:(NSArray *)objects{
    
    if (self.inspectorWindow) {
        return;
    }
    
    MPInspectorViewController *inspectorVC=[[MPInspectorViewController alloc] initWithObjects:objects];
    
    UINavigationController *nav=[[UINavigationController alloc] initWithRootViewController:inspectorVC];
    
    self.inspectorWindow=[[UIWindow alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    self.inspectorWindow.windowLevel = UIWindowLevelAlert;
    [self.inspectorWindow makeKeyAndVisible];
    
    [self.inspectorWindow setRootViewController:nav];
    
    [self.inspectorWindow makeKeyAndVisible];
    
    
    [UIView animateWithDuration:.25 animations:^{
        self.inspectorWindow.y=0;
    }];

}

- (void)presentForApplication:(UIApplication *)application{
    
    UIWindow *window=[[application delegate] window];
    
    [self presentWithObjects:@[window]];

}


- (void)present{
    
    [self presentForApplication:[UIApplication sharedApplication]];

}


- (void)dismiss{
    
    [UIView animateWithDuration:.25 animations:^{
        self.inspectorWindow.y=self.inspectorWindow.height;
    }completion:^(BOOL finished) {
        [self.inspectorWindow resignKeyWindow];
        [self.inspectorWindow removeFromSuperview];
        self.inspectorWindow.windowLevel=-1;
        self.inspectorWindow=nil;

    }];
}

#if DEBUG

// create the singleton so it register for volume events if enabled

__attribute__((constructor)) static void createSingleton() {
    [MPInspectorManager sharedManager];
}

#endif

@end
