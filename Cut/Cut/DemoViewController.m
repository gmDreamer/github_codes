//
//  DemoViewController.m
//  Snip
//
// Created by linyi on 16/4/13.
// Copyright (c) 2016 linyi . All rights reserved.
//

#import "DemoViewController.h"
#import "SnipManager.h"

@interface DemoViewController ()
@property(weak) IBOutlet NSImageView *backImageView;
@end

@implementation DemoViewController
- (void) viewDidLoad{
    [super viewDidLoad];


    
//    NSEvent * (^monitorHandler)(NSEvent *);
//    monitorHandler = ^NSEvent * (NSEvent * theEvent){
//
//        NSLog(@"adfd%d",theEvent.keyCode);
//        if([theEvent modifierFlags] ==NSCommandKeyMask){
//            NSLog(@"command");
//        }
//        
//        return theEvent;
//    }; 
//    [NSEvent addLocalMonitorForEventsMatchingMask:NSFlagsChangedMask handler:^(NSEvent *event){
//        NSUInteger flags = [event modifierFlags] & NSDeviceIndependentModifierFlagsMask;
//        if (flags == NSCommandKeyMask) {
//            NSLog(@"aad");
//        }
//        return event;
//    }];
}
- (void)awakeFromNib {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onEndCapture:) name:kNotifyCaptureEnd object:nil];
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)onEndCapture:(NSNotification *)notification {
    if (notification.userInfo[@"image"]) {
        self.backImageView.image = notification.userInfo[@"image"];
        return;
    }
//    NSPasteboard *pasteboard = [NSPasteboard generalPasteboard];
//    NSArray *classArray = [NSArray arrayWithObject:[NSImage class]];
//    NSDictionary *options = [NSDictionary dictionary];
//    BOOL ok = [pasteboard canReadObjectForClasses:classArray options:options];
//    if(ok) {
//        NSArray *objectsToPaste = [pasteboard readObjectsForClasses:classArray options:options];
//        NSImage *image = [objectsToPaste objectAtIndex:0];
//        self.backImageView.image = image;
//        //[self.view.window setBackgroundColor:[NSColor colorWithPatternImage:image]];
//    } else {
//        NSLog(@"Error: Clipboard doesn't seem to contain an image.");
//    }
}

- (IBAction)onStart:(id)sender {
    [[SnipManager sharedInstance] startCapture];
}

@end
