//
//  ZXChatMainWindowController.m
//  zhixin
//
//  Created by linyi on 17/7/8.
//  Copyright © 2017年 oa. All rights reserved.
//

#import "ZXChatMainWindowController.h"
#import "ZCCustomView.h"
#import "ZXSplitView.h"
#import "ZXSearchField.h"
#import "NSLeftSessionViewController.h"
#import "ZXChatingViewController.h"
#import "NSWindow+CloseFuc.h"
@interface ZXChatMainWindowController() <NSSplitViewDelegate>
{
    NSLeftSessionViewController *leftbar;
    ZXChatingViewController     *chatView;
}
@end

@implementation ZXChatMainWindowController
+(instancetype)shareInstace{
    static ZXChatMainWindowController *mainWindow;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mainWindow  = [[ZXChatMainWindowController alloc] init];
    });
    return mainWindow;
}
-(instancetype)init{
    if((self = [super initWithWindowNibName:self.className])){
        [self.window center];
        [self.window addTreeWindowFun];
        
    }
    return self;
}
- (void)windowDidLoad {
    [super windowDidLoad];
    [self addLeft];
    [_searchField setFocusRingType:NSFocusRingTypeNone];
    [self.window makeFirstResponder:nil];
}
- (void)addTop{

}
- (void)addLeft{
    leftbar = [NSLeftSessionViewController new];
    [leftbar.view setFrame:NSMakeRect(0, 0, _leftView.bounds.size.width, _leftView.bounds.size.height)];
    [_leftView addSubview:leftbar.view];
 
    chatView = [ZXChatingViewController new];
    [chatView.view setFrame:NSMakeRect(0, 0, _rightView.bounds.size.width, _rightView.bounds.size.height)];
    [_rightView addSubview:chatView.view];
}
- (CGFloat)splitView:(NSSplitView *)splitView constrainMinCoordinate:(CGFloat)proposedMinimumPosition ofSubviewAt:(NSInteger)dividerIndex {
    if (dividerIndex == 0)
    {
        return 200;
    }
    else
    {
        return 570;
    }
}

- (CGFloat)splitView:(NSSplitView *)splitView constrainMaxCoordinate:(CGFloat)proposedMaximumPosition ofSubviewAt:(NSInteger)dividerIndex {
    if (dividerIndex == 0)
    {
        return 300;
    }
    else
    {
        return 1000;
    }
}


- (BOOL)splitView:(NSSplitView *)splitView shouldAdjustSizeOfSubview:(NSView *)view
{
//    if ([view isEqual:_chattingBackgroudView])
//    {
//        return YES;
//    }
//    else
//    {
//        return NO;
//    }
    return YES;
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{
    return 20;
}
- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row{
    return 20;
}
- (void)tableView:(NSTableView *)tableView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    NSString *t_name = [tableColumn identifier];
    if([t_name isEqualToString:@"name"]){
        NSTextFieldCell *name = cell;
        [name  setTitle:@"123456" ];
    }
}
@end
