//
//  ZXTextField.m
//  zhixin
//
//  Created by linyi on 17/7/18.
//  Copyright © 2017年 oa. All rights reserved.
//

#import "ZXTextField.h"

@implementation ZXTextField

- (void)drawRect:(NSRect)dirtyRect {
    NSRect rect = self.bounds;
    NSBezierPath *bezierPath = [NSBezierPath bezierPathWithRoundedRect:rect
                                                               xRadius:NSHeight(rect)/2
                                                               yRadius:NSHeight(rect)/2];
    [[NSColor orangeColor] set];
    [bezierPath fill];
    [super drawRect:dirtyRect];

}

@end
