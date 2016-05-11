//
//  SnipWindowController.h
//  Snip
//
// Created by linyi on 16/4/13.
// Copyright (c) 2016 linyi . All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>
#import "MouseEventProtocol.h"

@interface SnipWindowController : NSWindowController <NSWindowDelegate, MouseEventProtocol>

- (void)startCaptureWithScreen:(NSScreen *)screen;
@end
