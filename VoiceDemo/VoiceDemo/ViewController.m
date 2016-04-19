//
//  ViewController.m
//  VoiceDemo
//
//  Created by linyi on 16/4/9.
//  Copyright (c) 2016 infoview. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()
@end

@implementation ViewController
{
    NSMutableArray *imageArr;
    UIWebView *movieShow;
    NSTimer *timer;
    BOOL  isVideo;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    isVideo = YES;
    UIButton * button1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button1 setFrame:CGRectMake(100, 0, 150, 50)];
    [button1 setTitle:@"start recording" forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(testCompressionSession) forControlEvents:UIControlEventTouchUpInside];

    UIButton * button2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button2 setFrame:CGRectMake(200, 0, 150, 50)];
    [button2 setTitle:@"show Video" forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(movieShow:) forControlEvents:UIControlEventTouchUpInside];
    UIButton * button3 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button3 setFrame:CGRectMake(300, 0, 150, 50)];
    [button3 setTitle:@"stop recording" forState:UIControlStateNormal];
    [button3 addTarget:self action:@selector(stop) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:button1];
    [self.view addSubview:button2];
    [self.view addSubview:button3];
}
-(void)movieShow:(id)sender{
    movieShow = [[UIWebView alloc] initWithFrame:CGRectMake(0,50,320,240)];
    [movieShow setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:movieShow];
    NSArray *paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *moviePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4",@"test"]];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[moviePath stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]];
    [movieShow loadRequest:request];
}
-(void) stop{
    if([timer isValid] == YES){
        [timer invalidate];
        timer = nil;
        isVideo =NO;
        return;
    }
}
-(void) getImageDataTimer:(NSTimer *)timer{
    UIGraphicsBeginImageContext(self.view.bounds.size);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    [imageArr addObject:image];
    UIGraphicsEndImageContext();
}
-(void) addImageData{
    timer = [[NSTimer alloc] initWithFireDate:[NSDate new] interval:0.09 target:self selector:@selector(getImageDataTimer:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    [[NSRunLoop currentRunLoop] run];

}
-(CVPixelBufferRef) pixelBufferFromCGImage:(CGImageRef) image size:(CGSize) size{
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], kCVPixelBufferCGImageCompatibilityKey,
                             [NSNumber numberWithBool:YES], kCVPixelBufferCGBitmapContextCompatibilityKey, nil];
    CVPixelBufferRef pxbuffer = NULL;
    CVReturn status = CVPixelBufferCreate(kCFAllocatorDefault, size.width, size.height, kCVPixelFormatType_32ARGB, CFBridgingRetain(options), &pxbuffer);
    
    NSParameterAssert(status == kCVReturnSuccess && pxbuffer != NULL);
    
    CVPixelBufferLockBaseAddress(pxbuffer, 0);
    void *pxdata = CVPixelBufferGetBaseAddress(pxbuffer);
    NSParameterAssert(pxdata != NULL);
    
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(pxdata, size.width, size.height, 8, 4*size.width, rgbColorSpace, kCGImageAlphaPremultipliedFirst);
    NSParameterAssert(context);
    
    CGContextDrawImage(context, CGRectMake(0, 0, CGImageGetWidth(image), CGImageGetHeight(image)), image);
    
    CGColorSpaceRelease(rgbColorSpace);
    CGContextRelease(context);
    
    CVPixelBufferUnlockBaseAddress(pxbuffer, 0);
    
    return pxbuffer;}
-(void)testCompressionSession{
    if([imageArr count] == 0 && isVideo ==YES){
        imageArr = [NSMutableArray array];
        NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(addImageData) object:nil];
        NSOperationQueue *queue = [NSOperationQueue new];
        [queue addOperation:operation];
        [NSThread sleepForTimeInterval:0.1];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
        NSString *moviePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4",@"test"]];
        CGSize size = CGSizeMake(320,240);
        NSError *error = nil;
        unlink([moviePath UTF8String]);
        AVAssetWriter *videoWriter = [[AVAssetWriter alloc] initWithURL:[NSURL fileURLWithPath:moviePath] fileType:AVFileTypeQuickTimeMovie error:&error];
        NSParameterAssert(videoWriter);
        if(error){
            NSLog(@"error:%@",[error localizedDescription]);
        }
        NSDictionary *videoSettiongs = [NSDictionary dictionaryWithObjectsAndKeys:AVVideoCodecH264,AVVideoCodecKey,[NSNumber numberWithInt:size.width],AVVideoWidthKey,[NSNumber numberWithInt:size.height],AVVideoHeightKey,nil];
        AVAssetWriterInput *writerInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeVideo outputSettings:videoSettiongs];
        NSDictionary *sourcePixeBufferAttributesDictionnary = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:kCVPixelFormatType_32ABGR],kCVPixelBufferPixelFormatTypeKey,nil];
        AVAssetWriterInputPixelBufferAdaptor *adaptor = [AVAssetWriterInputPixelBufferAdaptor assetWriterInputPixelBufferAdaptorWithAssetWriterInput:writerInput sourcePixelBufferAttributes:sourcePixeBufferAttributesDictionnary];
        NSParameterAssert(writerInput);
        NSParameterAssert([videoWriter canAddInput:writerInput]);
        if([videoWriter canAddInput:writerInput]){
            NSLog(@"ok");
        }else{
            NSLog(@"...");
        }
        [videoWriter addInput:writerInput];
        [videoWriter startWriting];
        [videoWriter startSessionAtSourceTime:kCMTimeZero];
        dispatch_queue_t dispatch_queue_t1 = dispatch_queue_create("mediaInputQueue",NULL);
        int __block  frame = 0;
        [writerInput requestMediaDataWhenReadyOnQueue:dispatch_queue_t1 usingBlock:^{
            NSLog(@"wrierInput is->>>>>>>>>%i",[writerInput isReadyForMoreMediaData]);
            while([writerInput isReadyForMoreMediaData]){
                NSLog(@"imageArr->%lu,isVideo -->%i",(unsigned long)[imageArr count],isVideo);
                if([imageArr count] == 0 && isVideo == NO){
                    isVideo =YES;
                    [writerInput markAsFinished];
                    [videoWriter finishWritingWithCompletionHandler:^{

                    }];
                    break;
                }
                if([imageArr count] == 0 && isVideo ==YES){

                }else{
                    CVPixelBufferRef  buffer =NULL;
                    buffer = [self pixelBufferFromCGImage:[[imageArr objectAtIndex:0] CGImage] size:size];
                    if(++frame){
                        [imageArr removeObjectAtIndex:0];
                    }
                    if(buffer){
                        if(![adaptor appendPixelBuffer:buffer withPresentationTime:CMTimeMake(frame,120)]){
                           NSLog(@"fail");
                        }else{
                            NSLog(@"doing");
                            CFRelease(buffer);
                        }
                    }
                }
            }
        }];
    }
}
@end