//
//  AppDelegate.m
//  zhixin
//
//  Created by linyi on 17/6/26.
//  Copyright © 2017年 oa. All rights reserved.
//

#import "AppDelegate.h"
#import "ZXLoginWindowController.h"

@interface AppDelegate ()
@property (nonatomic,strong) ZXLoginWindowController *loginWC;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    _loginWC = [[ZXLoginWindowController alloc] initWithWindowNibName:@"ZXLoginWindowController"];
    [_loginWC showWindow:nil];
    [_loginWC.window makeKeyAndOrderFront:nil];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


@end
