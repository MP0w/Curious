//
//  NSObject+object_print.h
//  CuriosInspectorTestApp
//
//  Created by Alex Manzella on 31/03/14.
//  Copyright (c) 2014 Alex Manzella. All rights reserved.
//

#import <Foundation/Foundation.h>


// Thanks to http://codethink.no-ip.org/wordpress/archives/236

@interface NSObject (object_print)

+ (NSString*) appendTo: (NSString*) base with: (NSString*) rest ;
+ (NSString*) codeToReadableType: (const char*) code;

@end
