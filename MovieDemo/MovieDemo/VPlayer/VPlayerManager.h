//
// Created by linyi on 16/4/11.
// Copyright (c) 2016 infoview. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@protocol VPlayerManagerDelegate
-(void) mMoveDecoder:(id) object  onNewVideoFrameReady:(CMSampleBufferRef)videoBuffer;
-(void) mMoveDecoderOnDecoderFinished:(id)vplayer;

@end
@interface VPlayerManager : NSObject
@property (nonatomic, strong) id<VPlayerManagerDelegate> delegate;
-(void) passMovie;
+(CGImageRef) imageFromSampleBufferRef:(CMSampleBufferRef) sampleBufferRef;
+(void)converVideoDimissionWithFilePath:(NSString *)videoPath andOutputPath:(NSString *)outputPath cutType:(int)type withCompletion:(void (^)(void))completion;
@end