//
//  ZXSearchFieldCell.m
//  zhixin
//
//  Created by linyi on 17/7/18.
//  Copyright © 2017年 oa. All rights reserved.
//

#import "ZXSearchFieldCell.h"

@implementation ZXSearchFieldCell
-(instancetype)init{
    if(self = [super init]){
        [self initStyle];
    }
    return self;
}
-(instancetype) initWithCoder:(NSCoder *)coder{
    if(self = [super initWithCoder:coder]){
        [self initStyle];
    }
    return self;
}
-(void)initStyle{
    [self setFocusRingType:NSFocusRingTypeNone];
    NSButtonCell *searchIconCell= [self searchButtonCell];
    NSImage *searchImage = [NSImage imageNamed:@"search_tokenfield_magnifier"];
    [searchImage setSize:NSMakeSize(12, 12)];
    [searchIconCell setImage:searchImage];
   // [searchIconCell setAlternateImage:searchImage];
//
    NSButtonCell *cancelIconCell = [self cancelButtonCell];
    NSImage *cancelImage = [NSImage imageNamed:@"search_tokenfield_delete"];
    [cancelImage setSize:NSMakeSize(12, 12)];
    [cancelIconCell setImage:cancelImage];
//    [cancelIconCell setAlternateImage:cancelImage];

    
    
}
-(void)drawInteriorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView{
    NSRect rect = controlView.bounds;
    NSBezierPath *bezierPath = [NSBezierPath bezierPathWithRoundedRect: rect xRadius:NSHeight(rect)/2 yRadius:NSHeight(rect)/2];
    [[NSColor whiteColor] set];
    [bezierPath fill];
    [super drawInteriorWithFrame:cellFrame inView:controlView];
}
-(NSText*)setUpFieldEditorAttributes:(NSText *)textObj{
    NSText *text = [super setUpFieldEditorAttributes:textObj];
    [(NSTextView*)text setInsertionPointColor:[NSColor grayColor]];
    return text;
}
@end
