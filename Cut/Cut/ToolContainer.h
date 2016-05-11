//
//  ToolContainer.h
//  Snip
//
// Created by linyi on 16/4/13.
// Copyright (c) 2016 linyi . All rights reserved.
//

#import <Cocoa/Cocoa.h>

typedef NS_ENUM(NSInteger, ActionType)
{
    ActionCancel,
    ActionOK,
    ActionShapeRect,
    ActionShapeEllipse,
    ActionShapeArrow
};

@interface ToolContainer : NSView
@property(nonatomic, copy) void (^toolClick)(long index);
@end
