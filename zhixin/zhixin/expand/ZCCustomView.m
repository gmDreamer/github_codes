//
//  ZCCustomView.m
//  zhixin
//
//  Created by linyi on 17/7/8.
//  Copyright © 2017年 oa. All rights reserved.
//
 
#import "ZCCustomView.h"

@implementation ZCCustomView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    NSRect frame = [self frame];
    [[NSColor redColor] set];
    
    [NSBezierPath fillRect:frame];
}

@end
