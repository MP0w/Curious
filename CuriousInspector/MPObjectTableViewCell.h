//
//  MPObjectTableViewCell.h
//  CuriosInspectorTestApp
//
//  Created by Alex Manzella on 30/03/14.
//  Copyright (c) 2014 Alex Manzella. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPTableViewCell.h"

@interface MPObjectTableViewCell : MPTableViewCell{
    
    UIImageView *snapshotView;
}

@property (nonatomic,readwrite) UIImage *snapshot;

@end
