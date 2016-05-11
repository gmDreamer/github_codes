//
//  AppDelegate.m
//  Snip
//
//
// Created by linyi on 16/4/13.
// Copyright (c) 2016 linyi . All rights reserved.
//

#import "AppDelegate.h"
#import <Carbon/Carbon.h>
#import "SnipManager.h"
@interface AppDelegate ()
@property(nonatomic,strong) NSStatusItem *statusItem;
@property (strong) IBOutlet NSMenu *customMenu;
@property(weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate
OSStatus hotKeyHandler(EventHandlerCallRef nextHandler, EventRef anEvent, void *userData);
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
//    _statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
//    [_statusItem setHighlightMode:YES];
//    [_statusItem setImage:[NSImage imageNamed:@"apps.icns"]];
//    _statusItem.menu =_customMenu;
    EventHotKeyRef gMyHotKeyRef;
    EventHotKeyID gMyHotKeyID;
    EventTypeSpec eventType;
    eventType.eventClass = kEventClassKeyboard;
    eventType.eventKind = kEventHotKeyPressed;
    //快捷键的签名,实际类型为UInt32,所以用4个字符最好
    gMyHotKeyID.signature='hkid';
    // 快捷键的id，处理多个全局快捷键时最好的标识
    gMyHotKeyID.id=1;
    // 通过这个函数向系统注册快捷键
    RegisterEventHotKey(kVK_ANSI_A, cmdKey, gMyHotKeyID, GetApplicationEventTarget(), 0, &gMyHotKeyRef);
    
    InstallApplicationEventHandler(&hotKeyHandler, 1, &eventType, NULL, NULL);
    [self onStart:nil];
    
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}
OSStatus hotKeyHandler(EventHandlerCallRef nextHandler, EventRef anEvent, void *userData) {
    EventHotKeyID hotKeyRef;
    
    GetEventParameter(anEvent, kEventParamDirectObject, typeEventHotKeyID, NULL, sizeof(hotKeyRef), NULL, &hotKeyRef);
    
    unsigned int hotKeyId = hotKeyRef.id;
    
    switch (hotKeyId) {
        case 1:
            [[SnipManager sharedInstance] startCapture];
            break;
        case 2:
            // do other thing
            break;
        default:
            break;
    }
    
    return noErr;
}
- (IBAction)onStart:(id)sender {
    [[SnipManager sharedInstance] startCapture];
}
@end
