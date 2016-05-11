//
//  DrawPathInfo.h
//  Snip
//
// Created by linyi on 16/4/13.
// Copyright (c) 2016 linyi . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SnipManager.h"

@interface DrawPathInfo : NSObject

@property NSPoint startPoint;
@property NSPoint endPoint;
@property DRAW_TYPE drawType;

- (instancetype)initWith:(NSPoint)startPoint andEndPoint:(NSPoint)endPoint andType:(DRAW_TYPE)drawType;

@end
