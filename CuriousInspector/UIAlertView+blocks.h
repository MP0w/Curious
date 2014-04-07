//
//  UIAlertView+blocks.h
//  CuriosInspectorTestApp
//
//  Created by Alex Manzella on 06/04/14.
//  Copyright (c) 2014 Alex Manzella. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface UIAlertView (blocks)<UIAlertViewDelegate>


- (id)initWithTitle:(NSString *)title message:(NSString *)message complentionBlock:(void (^)(NSInteger clickedButton)) complentionBlock cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... ;

@end
