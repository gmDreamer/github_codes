//
//  ZXChatingViewController.m
//  zhixin
//
//  Created by linyi on 17/7/17.
//  Copyright © 2017年 oa. All rights reserved.
//

#import "ZXChatingViewController.h"
#import "BottomTooolViewController.h"
@interface ZXChatingViewController ()<NSSplitViewDelegate>
{
    BottomTooolViewController *toolbar;
}
@end

@implementation ZXChatingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBottomBar];
}
- (void)addBottomBar{
    toolbar = [BottomTooolViewController new];
    [toolbar.view setFrame:NSMakeRect(0, 0, _bottomToolView.bounds.size.width, _bottomToolView.bounds.size.height)];
    [_bottomToolView addSubview:toolbar.view];
}
- (CGFloat)splitView:(NSSplitView *)splitView constrainMinCoordinate:(CGFloat)proposedMinimumPosition ofSubviewAt:(NSInteger)dividerIndex {
    if (dividerIndex == 0)
    {
        return 416;
    }
    else
    {
        return 570;
    }
}

- (CGFloat)splitView:(NSSplitView *)splitView constrainMaxCoordinate:(CGFloat)proposedMaximumPosition ofSubviewAt:(NSInteger)dividerIndex {
    if (dividerIndex == 0)
    {
        return 486;
    }
    else
    {
        return 1000;
    }
}
@end
