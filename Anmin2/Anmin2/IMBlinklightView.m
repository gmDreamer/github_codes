//
// Created by linyi on 16/4/17.
// Copyright (c) 2016 linyi . All rights reserved.
//

#import "IMBlinklightView.h"


@implementation IMBlinklightView
-(instancetype)initWithFrame:(CGRect)frame {
    if(self =[super initWithFrame:frame]){
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}
-(void)startAnimation {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fromValue = [NSNumber numberWithFloat:1.0f];
    animation.toValue  = [NSNumber numberWithFloat:0.0f];
    animation.autoreverses = YES;
    animation.duration = 1/60;
    animation.repeatCount = MAXFLOAT;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    [self.layer addAnimation:animation forKey:@"opacity"];
}
-(void)drawRect:(CGRect)rect {
    CGContextRef cgContext= UIGraphicsGetCurrentContext();
    CGContextAddEllipseInRect(cgContext,self.bounds);
    [[UIColor redColor] set];
    CGContextFillPath(cgContext);
}
@end