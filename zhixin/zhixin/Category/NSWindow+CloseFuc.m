//
//  NSWindow+CloseFuc.m
//  zhixin
//
//  Created by linyi on 17/7/8.
//  Copyright © 2017年 oa. All rights reserved.
//

#import "NSWindow+CloseFuc.h"

@implementation NSWindow (CloseFuc)
-(void)addLeftCloseBtn{
    [self setStyleMask:NSBorderlessWindowMask];
    NSButton *close = [NSWindow standardWindowButton:NSWindowCloseButton forStyleMask:self.styleMask];
    CGFloat y = self.contentView.bounds.size.height - close.bounds.size.height-10;
    [close setFrame:NSMakeRect(10, y, close.bounds.size.width, close.bounds.size.height)];
    [self.contentView addSubview:close positioned:NSWindowAbove relativeTo:nil];
}

-(void)addTreeWindowFun{
    [self setStyleMask:NSBorderlessWindowMask];
    NSButton *close = [NSWindow standardWindowButton:NSWindowCloseButton forStyleMask:self.styleMask];
    CGFloat y = self.contentView.bounds.size.height-(54-close.bounds.size.height)/2-close.bounds.size.height;
    [close setFrame:NSMakeRect(10, y, close.bounds.size.width, close.bounds.size.height)];
    [self.contentView addSubview:close positioned:NSWindowAbove relativeTo:nil];

    NSButton *min = [NSWindow standardWindowButton:NSWindowMiniaturizeButton forStyleMask:self.styleMask];
    int offx = NSMaxX(close.frame)+6;
    [min setFrame:NSMakeRect(offx, y, min.bounds.size.width, min.bounds.size.height)];
    [self.contentView addSubview:min positioned:NSWindowAbove relativeTo:nil];
    
    offx = NSMaxX(min.frame)+6;
    NSButton *zoom = [NSWindow standardWindowButton:NSWindowZoomButton  forStyleMask:self.styleMask];
    [zoom setFrame:NSMakeRect(offx, y, zoom.bounds.size.width, zoom.bounds.size.height)];
    [self.contentView addSubview:zoom positioned:NSWindowAbove relativeTo:nil];
}
@end
