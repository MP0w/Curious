//
//  NSObject+object_print.m
//  CuriosInspectorTestApp
//
//  Created by Alex Manzella on 31/03/14.
//  Copyright (c) 2014 Alex Manzella. All rights reserved.
//

#import "NSObject+object_print.h"

// Thanks to http://codethink.no-ip.org/wordpress/archives/236

// ...and based on https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html#//apple_ref/doc/uid/TP40008048-CH100-SW1

@implementation NSObject(object_print)

+ (NSString*) appendTo: (NSString*) base with: (NSString*) rest {
    return [NSString stringWithFormat:@"%@%@", base, rest];
}




+ (NSString*) codeToReadableType: (const char*) code {
    NSString* codeString = [NSString stringWithFormat:@"%s", code];
    NSString* result = @"";
    
    bool array = NO;
    NSString* arrayString;
    //note:  we parse our type from left to right, but build our result string from right to left
    for (NSInteger index = 0; index < [codeString length]; index++) {
        char nextChar = [codeString characterAtIndex:index];
        switch (nextChar) {
            case 'T':
                //a placeholder code, the actual type will be specified by the next character
                break;
            case ',':
                //used in conjunction with 'T', indicates the end of the data that we care about
                //we could further process the character(s) after the comma to work out things like 'nonatomic', 'retain', etc., but let's not
                index = [codeString length];
                break;
            case 'i':
                //int or id
                if (index + 1 < [codeString length] && [codeString characterAtIndex:index + 1] == 'd') {
                    //id
                    result = [self appendTo: (array ? @"id[" : @"id") with: result];
                    index++;
                }
                else {
                    //int
                    result = [self appendTo: (array ? @"int[" : @"int") with: result];
                }
                break;
            case 'I':
                //unsigned int
                result = [self appendTo: (array ? @"unsigned int[" : @"unsigned int") with: result];
                break;
            case 's':
                //short
                result = [self appendTo: (array ? @"short[" : @"short") with: result];
                break;
            case 'S':
                //unsigned short
                result = [self appendTo: (array ? @"unsigned short[" : @"unsigned short") with: result];
                break;
            case 'l':
                //long
                result = [self appendTo: (array ? @"long[" : @"long") with: result];
                break;
            case 'L':
                //unsigned long
                result = [self appendTo: (array ? @"unsigned long[" : @"unsigned long") with: result];
                break;
            case 'q':
                //long long
                result = [self appendTo: (array ? @"long long[" : @"long long") with: result];
                break;
            case 'Q':
                //unsigned long long
                result = [self appendTo: (array ? @"unsigned long long[" : @"unsigned long long") with: result];
                break;
            case 'f':
                //float
                result = [self appendTo: (array ? @"float[" : @"float") with: result];
                break;
            case 'd':
                //double
                result = [self appendTo: (array ? @"double[" : @"double") with: result];
                break;
            case 'B':
                //bool
                result = [self appendTo: (array ? @"bool[" : @"bool") with: result];
                break;
            case 'b':
                //char and BOOL; is stored as "bool", so need to ignore the next 3 chars
                result = [self appendTo: (array ? @"BOOL[" : @"BOOL") with: result];
                index += 3;
                break;
            case 'c':
                //char?
                result = [self appendTo: (array ? @"char[" : @"char") with: result];
                break;
            case 'C':
                //unsigned char
                result = [self appendTo: (array ? @"unsigned char[" : @"unsigned char") with: result];
                break;
            case 'v':
                //void
                result = [self appendTo: @"void" with: result];
                break;
            case ':':
                //selector
                result = [self appendTo: @"SEL" with: result];
                break;
            case '^':
                //pointer
                result = [self appendTo: @"*" with: result];
                break;
            case '@': {
                //object instance, may or may not include the type in quotes, like @"NSString"
                if (index + 1 < [codeString length] && [codeString characterAtIndex:index + 1] == '"') {
                    //we can get the exact type
                    int endIndex = index + 2;
                    NSString* theType = @"";
                    while ([codeString characterAtIndex:endIndex] != '"') {
                        theType = [NSString stringWithFormat:@"%@%c", theType, [codeString characterAtIndex:endIndex]];
                        endIndex++;
                    }
                    theType = [self appendTo: theType with: @"*"];
                    result = [self appendTo: theType with: result];
                    
                    index = endIndex + 1;
                }
                else {
                    //all we know is that it's an object of some kind
                    //result = [self appendTo: @"NSObject*" with: result];
                    
                    // MPOW : I prefer just id, more readable method in our cells
                    result = [self appendTo:@"id" with:result];
                }
                break;
            }
            case '{': {
                //struct, we don't fully process these; just echo them
                NSRange structrange = [codeString rangeOfString:@"="];
                if(structrange.location == NSNotFound)
                    result = [self appendTo: @"struct" with: result];
                else   result = [self appendTo: [codeString substringWithRange:NSMakeRange(1, structrange.location-1)] with: result];
                return result;
                break;
            }
            case '?':
                //IMP and function pointer
                result = [self appendTo: @"IMP" with: result];
                break;
            case '[':
                //array type
                array = YES;
                arrayString = @"";
                result = [self appendTo: @"]" with: result];
                break;
            case ']':
                //array type
                array = NO;
                break;
            case '0':
            case '1':
            case '2':
            case '3':
            case '4':
            case '5':
            case '6':
            case '7':
            case '8':
            case '9':
                //for a statically-sized array, indicates the number of elements
                if (array) {
                    arrayString = [NSString stringWithFormat:@"%@%c", arrayString, nextChar];
                }
                break;
            default:
                break;
        }
    }
    
    return result;
}

@end