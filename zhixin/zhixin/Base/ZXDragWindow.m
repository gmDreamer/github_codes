//
//  ZXDragWindow.m
//  zhixin
//
//  Created by linyi on 17/7/14.
//  Copyright © 2017年 oa. All rights reserved.
//

#import "ZXDragWindow.h"

@implementation ZXDragWindow
-(BOOL)canBecomeKeyWindow{
    return YES;
}
-(BOOL)canBecomeMainWindow{
    return YES;
}
-(NSRect)measureAreaRect{
    const CGFloat resizeBoxSize = 20.0;
    NSRect resizeRect = NSMakeRect(self.frame.size.width-20, 0, resizeBoxSize,resizeBoxSize);
    return resizeRect;
}
-(void)mouseDown:(NSEvent *)event{
    NSPoint pointInView = [event locationInWindow];
    BOOL resize = NSPointInRect(pointInView, [self measureAreaRect]);
    NSRect  mouseLocation = [self convertRectToScreen:NSMakeRect(pointInView.x, pointInView.y, self.frame.size.width, self.frame.size.height)];
    NSRect  frame = self.frame;
    while (YES) {
        //捕获鼠标拖动或鼠标按键弹起事件
        NSEvent *newEvent = [self nextEventMatchingMask:(NSLeftMouseDraggedMask|NSLeftMouseUpMask)];
        if([newEvent type] == NSLeftMouseUp){
            break;
        }
        NSPoint  newPointInView = [newEvent locationInWindow];
        NSRect newMouseLocation = [self convertRectToScreen:NSMakeRect(newPointInView.x, newPointInView.y, self.frame.size.width, self.frame.size.height)];
        NSPoint delta = NSMakePoint(newMouseLocation.origin.x-mouseLocation.origin.x
                                    ,newMouseLocation.origin.y-mouseLocation.origin.y);
        NSRect newFrame = frame;
        if(!_isResize || !resize){
            newFrame.origin.x += delta.x;
            newFrame.origin.y += delta.y;
        }else{
            NSSize maxSize = [self maxSize];
            NSSize minSize = [self minSize];
            
            newFrame.size.width   +=delta.x;
            newFrame.size.height  -=delta.y;
            
            //有些窗口有最大，最小窗口大小限制
            newFrame.size.width = MIN(MAX(newFrame.size.width, minSize.width),maxSize.width);
            newFrame.size.height = MIN(MAX(newFrame.size.width,minSize.height),maxSize.height);
            newFrame.origin.y -= newFrame.size.height - frame.size.height;
        }
        [self setFrame:newFrame display:YES animate:NO];
    }
}
@end
