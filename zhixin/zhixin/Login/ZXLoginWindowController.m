//
//  ZXLoginWindowController.m
//  zhixin
//
//  Created by linyi on 17/6/29.
//  Copyright © 2017年 oa. All rights reserved.
//

#import "ZXLoginWindowController.h"
#import "NSWindow+CloseFuc.h"
#import "ZXChatMainWindowController.h"
#import "ZXDragWindow.h"

@interface ZXLoginWindowController() 

@end

@implementation ZXLoginWindowController
- (void)awakeFromNib{
    [self.window center];
    [self.window addLeftCloseBtn];
    ((ZXDragWindow*)self.window).isResize = YES;
    
}
- (void)windowDidLoad {
    [super windowDidLoad];
    [_username setFocusRingType:NSFocusRingTypeNone];
    [_pwd setFocusRingType:NSFocusRingTypeNone];
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}
- (IBAction)onLogin:(NSButton *)sender {
    [self close];
    [[ZXChatMainWindowController shareInstace] showWindow:nil];
    [[ZXChatMainWindowController shareInstace].window makeKeyAndOrderFront:nil];
}

@end
