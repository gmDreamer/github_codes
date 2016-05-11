//
//  SnipWindow.h
//  Snip
//
//
// Created by linyi on 16/4/13.
// Copyright (c) 2016 linyi . All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MouseEventProtocol.h"

@interface SnipWindow : NSPanel

@property(weak) id <MouseEventProtocol> mouseDelegate;
@end
