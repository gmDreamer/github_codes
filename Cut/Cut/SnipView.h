//
//  SnipView.h
//  Snip
//
// Created by linyi on 16/4/13.
// Copyright (c) 2016 linyi . All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "DrawPathInfo.h"
#import "ToolContainer.h"
#import "DrawPathView.h"

@interface SnipView : NSView
@property NSImage *image;
@property NSRect drawingRect;
@property DrawPathView *pathView;

@property(nonatomic, strong) NSTrackingArea *trackingArea;
//@property NSMutableArray *rectArray;
//@property DrawPathInfo *currentInfo;
@property ToolContainer *toolContainer;

- (void)setupTrackingArea:(NSRect)rect;

- (void)setupTool;

- (void)setupDrawPath;

- (void)showToolkit;

- (void)hideToolkit;

- (void)showTip;

- (void)hideTip;

@end
