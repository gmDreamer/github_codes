//
//  ZXChatMainWindowController.h
//  zhixin
//
//  Created by linyi on 17/7/8.
//  Copyright © 2017年 oa. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class ZCCustomView;
@class ZXSplitView;
@class ZXTopToolbar;
@class ZXSearchField;
@interface ZXChatMainWindowController:NSWindowController
@property (weak) IBOutlet ZXSplitView  *splitView;
@property (weak) IBOutlet NSView *leftView;
@property (weak) IBOutlet NSView *rightView;
@property (weak) IBOutlet NSTableView *tableView;
@property (weak) IBOutlet ZXTopToolbar *topToolbar;
@property (weak) IBOutlet ZXSearchField *searchField;

+(instancetype)shareInstace;
@end
