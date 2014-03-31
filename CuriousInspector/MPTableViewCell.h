//
//  MPTableViewCell.h
//  CuriosInspectorTestApp
//
//  Created by Alex Manzella on 30/03/14.
//  Copyright (c) 2014 Alex Manzella. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPUtils.h"

@interface MPTableViewCell : UITableViewCell

@property (nonatomic,readwrite) NSString *cellText,*objectClass;

@end
