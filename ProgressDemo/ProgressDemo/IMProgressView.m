//
// Created by linyi on 16/4/13.
// Copyright (c) 2016 infoview. All rights reserved.
//

#import "IMProgressView.h"

#define Radius (self.bounds.size.width - self.progressWidth)/2
@implementation IMProgressView

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self){
        _trackLayer = [CAShapeLayer new];
        [self.layer addSublayer:_trackLayer];
        _trackLayer.fillColor = nil;
        _trackLayer.frame = self.bounds;

        _progressLayer = [CAShapeLayer new];
        [self.layer addSublayer:_progressLayer];
        _progressLayer.fillColor = nil;
        _progressLayer.lineCap = kCALineCapRound;
        _progressLayer.frame = self.bounds;

        self.progressWidth = 5;
    }
    return self;
}
-(void) setTrack{
    _trackPath = [UIBezierPath bezierPathWithArcCenter:self.center radius:Radius startAngle:0 endAngle:M_PI*2 clockwise:YES];
    _trackLayer.path = _trackPath.CGPath;
}
-(void)setProgressWidth:(float)progressWidth {
    _progressWidth = progressWidth;
    _trackLayer.lineWidth = _progressWidth;
    _progressLayer.lineWidth = _progressWidth;
    [self setTrack];
    [self setProgress];
}
-(void)setProgress {
    _progressPath = [UIBezierPath bezierPathWithArcCenter:self.center radius:Radius startAngle:-M_PI_2 endAngle:(M_PI*2)*_progress-M_PI_2 clockwise:YES];
    _progressLayer.path = _progressPath.CGPath;
}
-(void)setProgress:(float)progress {
    _progress = progress;
    [self setProgress];
}
-(void)setProgressColor:(UIColor *)progressColor {
    _progressLayer.strokeColor = progressColor.CGColor;
}
-(void)setTrackColor:(UIColor *)trackColor {
    _trackLayer.strokeColor = trackColor.CGColor;
}
-(void)setProgress:(float)progress animation:(BOOL)animation {

}
@end