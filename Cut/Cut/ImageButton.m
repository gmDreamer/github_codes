//
//  ImageButton.m
//  Snip
//
//
// Created by linyi on 16/4/13.
// Copyright (c) 2016 linyi . All rights reserved.
//

#import "ImageButton.h"

@implementation ImageButton

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];

    // Drawing code here.
}

- (void)mouseDown:(NSEvent *)theEvent
{
    [NSApp sendAction:self.action
                   to:self.target
                 from:self];
}

@end
