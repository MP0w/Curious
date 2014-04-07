//
//  UIAlertView+blocks.m
//  CuriosInspectorTestApp
//
//  Created by Alex Manzella on 06/04/14.
//  Copyright (c) 2014 Alex Manzella. All rights reserved.
//

#import "UIAlertView+blocks.h"

void (^complention)(NSInteger clickedButton);


@implementation UIAlertView (blocks)



- (id)initWithTitle:(NSString *)title message:(NSString *)message complentionBlock:(void (^)(NSInteger clickedButton)) complentionBlock cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... {
    
    if (self=[self initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles, nil]) {
        
        
        complention=complentionBlock;
        
    }
    
    return self;
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    complention(buttonIndex);
    
}

@end
