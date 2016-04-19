//
// Created by linyi on 16/4/11.
// Copyright (c) 2016 infoview. All rights reserved.
//

#import "VPlayerManager.h"
#import <CoreMedia/CoreMedia.h>
@implementation VPlayerManager

-(void) passMovie{
    NSURL *fileUrl = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingString:@"myMovie.mp4"]];
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:fileUrl options:nil];
    NSError *error;
    AVAssetReader *reader = [[AVAssetReader alloc] initWithAsset:asset error:&error];
    if(error){
        NSLog(@"获取文件出错:%@",error.localizedDescription);
    }
    NSArray *videoTracks = [asset tracksWithMediaType:AVMediaTypeVideo];
    AVAssetTrack *videoTrack = [videoTracks objectAtIndex:0];
    int m_pixelFormatType;
    //视频播放时
    m_pixelFormatType = kCVPixelFormatType_32BGRA;
    // 视频压缩
    //m_pixelFormatType = kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange;
    NSMutableDictionary *options =@{}.mutableCopy;
    [options setObject:@(m_pixelFormatType) forKey:(id)kCVPixelBufferPixelFormatTypeKey];
    AVAssetReaderTrackOutput *videoReaderOutput = [[AVAssetReaderTrackOutput alloc] initWithTrack:videoTrack outputSettings:options];
    [reader addOutput:videoReaderOutput];
    [reader startReading];

    while ([reader status] == AVAssetReaderStatusReading && videoTrack.nominalFrameRate>0){
        CMSampleBufferRef videoBuffer = [videoReaderOutput copyNextSampleBuffer];
        [self.delegate mMoveDecoder:self onNewVideoFrameReady:videoBuffer];
        [NSThread sleepForTimeInterval:0.001];
    }
    //告诉上层视频解码结束
    [self.delegate mMoveDecoderOnDecoderFinished:self];
}
+(CGImageRef) imageFromSampleBufferRef:(CMSampleBufferRef) sampleBufferRef{
    // 为媒体数据设置一个CMSampleBufferRef
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBufferRef);
    if(imageBuffer == NULL) return NULL;
    // 锁定 pixel buffer 的基地址
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
    // 得到 pixel buffer 的基地址
    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
    // 得到 pixel buffer 的行字节数
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    // 得到 pixel buffer 的宽和高
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    
    // 创建一个依赖于设备的 RGB 颜色空间
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    // 用抽样缓存的数据创建一个位图格式的图形上下文（graphic context）对象
    CGContextRef context = CGBitmapContextCreate(baseAddress, width, height, 8, bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    //根据这个位图 context 中的像素创建一个 Quartz image 对象
    CGImageRef quartzImage = CGBitmapContextCreateImage(context);
    // 解锁 pixel buffer
    CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
    
    // 释放 context 和颜色空间
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    // 用 Quzetz image 创建一个 UIImage 对象
    // UIImage *image = [UIImage imageWithCGImage:quartzImage];
    
    // 释放 Quartz image 对象
    //    CGImageRelease(quartzImage);
    
    return quartzImage;
}
+(void)converVideoDimissionWithFilePath:(NSString *)videoPath
                          andOutputPath:(NSString *)outputPath
                                cutType:(int)type
                         withCompletion:(void (^)(void))completion{
    //获取原视频
    AVAsset *asset = [AVAsset assetWithURL:[NSURL fileURLWithPath:videoPath]];
    
    //创建视频轨道信息
    AVAssetTrack *clipVideoTrack = [[asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    
    //创建视频分辨率等一些设置
    AVMutableVideoComposition* videoComposition = [AVMutableVideoComposition videoComposition];
    videoComposition.frameDuration = CMTimeMake(1, 30);
    //设置渲染的宽高分辨率,均为视频的自然高度
    videoComposition.renderSize = CGSizeMake(clipVideoTrack.naturalSize.height, clipVideoTrack.naturalSize.height);
    
    //创建视频的构造信息
    AVMutableVideoCompositionInstruction *instruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    instruction.timeRange = CMTimeRangeMake(kCMTimeZero, CMTimeMakeWithSeconds(60, 30));
    
    AVMutableVideoCompositionLayerInstruction* transformer = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:clipVideoTrack];
    
    CGAffineTransform t1;
    switch (type) {
        case 0:{
            //将裁剪后保留的区域设置为视频顶部
            t1 = CGAffineTransformMakeTranslation(clipVideoTrack.naturalSize.height, 0 );
        }
            break;
        case 1:{
            //将裁剪后保留的区域设置为视频中间部分
            t1 = CGAffineTransformMakeTranslation(clipVideoTrack.naturalSize.height, -(clipVideoTrack.naturalSize.width - clipVideoTrack.naturalSize.height) /2 );
        }
            break;
        case 2:{
            //将裁剪后保留的区域设置为视频下面部分
            t1 = CGAffineTransformMakeTranslation(clipVideoTrack.naturalSize.height, (clipVideoTrack.naturalSize.width - clipVideoTrack.naturalSize.height) /2);
        }
            break;
        default:{
            //将裁剪后保留的区域设置为视频中间部分
            t1 = CGAffineTransformMakeTranslation(clipVideoTrack.naturalSize.height, -(clipVideoTrack.naturalSize.width - clipVideoTrack.naturalSize.height) /2 );
        }
            break;
    }
    
    //保证视频为垂直正确的方向
    CGAffineTransform t2 = CGAffineTransformRotate(t1, M_PI_2);
    
    CGAffineTransform finalTransform = t2;
    [transformer setTransform:finalTransform atTime:kCMTimeZero];
    
    //先添加tranform层的构造信息，再添加分辨率信息
    instruction.layerInstructions = [NSArray arrayWithObject:transformer];
    videoComposition.instructions = [NSArray arrayWithObject: instruction];
    
    //移除掉之前所存在的视频信息
    [[NSFileManager defaultManager]  removeItemAtURL:[NSURL fileURLWithPath:outputPath] error:nil];
    
    //开始进行导出视频
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:asset presetName:AVAssetExportPresetLowQuality] ;
    exporter.videoComposition = videoComposition;
    exporter.outputURL = [NSURL fileURLWithPath:outputPath];
    exporter.outputFileType = AVFileTypeQuickTimeMovie;
    
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            //导出完成后执行回调
            if(completion)
                completion();
        });
    }];
}
@end