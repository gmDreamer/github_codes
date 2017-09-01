//
//  ZXTopToolbar.m
//  zhixin
//
//  Created by linyi on 17/7/17.
//  Copyright © 2017年 oa. All rights reserved.
//

#import "ZXTopToolbar.h"

@implementation ZXTopToolbar

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    [[NSColor greenColor] set];
    [NSBezierPath fillRect:dirtyRect];
}

@end
