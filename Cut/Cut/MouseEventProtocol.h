//
//  MouseEventProtocol.h
//  Snip
//
// Created by linyi on 16/4/13.
// Copyright (c) 2016 linyi . All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MouseEventProtocol <NSObject>

- (void)mouseDown:(NSEvent *)theEvent;

- (void)mouseUp:(NSEvent *)theEvent;

- (void)mouseDragged:(NSEvent *)theEvent;

- (void)mouseMoved:(NSEvent *)theEvent;
@end
