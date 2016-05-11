//
//  DrawPathView.h
//  Snip
//
// Created by linyi on 16/4/13.
// Copyright (c) 2016 linyi . All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "DrawPathInfo.h"

@interface DrawPathView : NSView
@property NSMutableArray *rectArray;
@property DrawPathInfo *currentInfo;

- (void)drawFinishCommentInRect:(NSRect)imageRect;
@end
