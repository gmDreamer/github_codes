//
//  DrawPathInfo.m
//  Snip
//
// Created by linyi on 16/4/13.
// Copyright (c) 2016 linyi . All rights reserved.
//

#import "DrawPathInfo.h"

@implementation DrawPathInfo

- (instancetype)initWith:(NSPoint)startPoint andEndPoint:(NSPoint)endPoint andType:(DRAW_TYPE)drawType
{
    if (self = [super init]) {
        _startPoint = startPoint;
        _endPoint = endPoint;
        _drawType = drawType;
    }
    return self;
}
@end
