//
// Created by linyi on 16/4/13.
// Copyright (c) 2016 infoview. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>


@interface IMProgressView : UIView
{
    CAShapeLayer *_trackLayer;
    UIBezierPath *_trackPath;
    CAShapeLayer *_progressLayer;
    UIBezierPath *_progressPath;
}
@property (nonatomic, strong)UIColor *trackColor;
@property (nonatomic, strong)UIColor *progressColor;
@property (nonatomic) float progress; //0~1
@property (nonatomic) float progressWidth;

-(void) setProgress:(float)progress animation:(BOOL) animation;
@end