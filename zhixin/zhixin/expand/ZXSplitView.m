//
//  ZXSplitView.m
//  zhixin
//
//  Created by linyi on 17/7/11.
//  Copyright © 2017年 oa. All rights reserved.
//

#import "ZXSplitView.h"

@implementation ZXSplitView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    NSRect frame = [self frame];
    [[NSColor greenColor] set];
    [NSBezierPath fillRect:frame];
}

@end
