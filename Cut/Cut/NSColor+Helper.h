//
//  NSColor+Helper.h
//  Snip
//
// Created by linyi on 16/4/13.
// Copyright (c) 2016 linyi . All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSColor (Helper)
+ (NSColor *)colorFromInt:(int)colorValue;
+ (NSColor*)colorWithHex:(NSString *)hexValue alpha:(CGFloat)alphaValue;
@end
