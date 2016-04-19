//
//  ViewController.m
//  MovieDemo
//
//  Created by linyi on 16/4/10.
//  Copyright (c) 2016 infoview. All rights reserved.
//


#import "ViewController.h"
#import "VPlayerManager.h"
#import "UIImage+Orientation.h"
#import <AssetsLibrary/ALAssetsLibrary.h>
typedef void(^PropertyChangeBlock)(AVCaptureDevice *captureDevice);
@interface ViewController ()<AVCaptureFileOutputRecordingDelegate,VPlayerManagerDelegate> //视频文件输出代理
@property (nonatomic, strong) AVCaptureSession *captureSession;//负责输入输出设备直接数据传递
@property (nonatomic, strong) AVCaptureDeviceInput *captureDeviceInput;//负责从AvcaptureDevice 获取输入数据
@property (nonatomic, strong) AVCaptureMovieFileOutput *captureMovieFileOutput; //照片输出流
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;//相机拍摄预览图
@property (nonatomic, assign) UIBackgroundTaskIdentifier  backgroundTaskIdentifier;//后台自任务标示
@property (nonatomic, strong) UIView *viewContainer;
@property (nonatomic, strong) UIImageView *focusCursor;// 聚焦光标
@property (nonatomic, strong) UIView * showView;
@end

@implementation ViewController
{
    NSMutableArray * images;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _viewContainer = [[UIView alloc] initWithFrame:CGRectMake(0,50,320,240)];
    _viewContainer.backgroundColor = [UIColor grayColor];
    _focusCursor = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"camera_focus_red@2x.png"]];
    _focusCursor.frame = CGRectMake(30,30,75,75);

    _showView = [[UIView alloc] initWithFrame:CGRectMake(50,300,200,240)];
    _showView.backgroundColor = [UIColor greenColor];
    [self.viewContainer addSubview:_focusCursor];
    [self.view addSubview:_viewContainer];
    [self.view addSubview:_showView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _captureSession = [AVCaptureSession new];
    if([_captureSession canSetSessionPreset:AVCaptureSessionPreset352x288]){
        _captureSession.sessionPreset = AVCaptureSessionPreset352x288;//设置设备分辨率
    }
    //获取输入设备
    AVCaptureDevice *captureDevice = [self getCameraDeviceWithPosition:AVCaptureDevicePositionBack];

    //添加一个音频输入设备
    AVCaptureDevice *audioCaptureDevice=[[AVCaptureDevice devicesWithMediaType:AVMediaTypeAudio] firstObject];
    NSError *error = nil;
    //初始化输入对象,用于获得输入数据
    _captureDeviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:captureDevice error:&error];
    if(error){
        NSLog(@"取得设备对象时出错,错误原因:%@",error.localizedDescription);
        return;
    }
    //初始化音频设备
    AVCaptureDeviceInput *audioCaptureDeviceInput=[[AVCaptureDeviceInput alloc]initWithDevice:audioCaptureDevice error:&error];
    if (error) {
        NSLog(@"取得设备输入对象时出错，错误原因：%@",error.localizedDescription);
        return;
    }
    //初始化设备输出对象,用于获得输出数据
    _captureMovieFileOutput = [AVCaptureMovieFileOutput new];
    //将设备添加到会话中
    if([_captureSession canAddInput:_captureDeviceInput]){
       [_captureSession addInput:_captureDeviceInput];
       [_captureSession addInput:audioCaptureDeviceInput];
       AVCaptureConnection *captureConnection = [_captureMovieFileOutput connectionWithMediaType:AVMediaTypeAudio];
       if([captureConnection isVideoStabilizationSupported]){
           captureConnection.preferredVideoStabilizationMode = AVCaptureVideoStabilizationModeAuto;
       }
    }
    //设备输出添加到会话中
    if([_captureSession canAddOutput:_captureMovieFileOutput]){
        [_captureSession addOutput:_captureMovieFileOutput];
    }
    //创建视频预览层,用于实时展示摄像头状态
    _captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession];
    CALayer *layer = self.viewContainer.layer;
    layer.masksToBounds = YES;
    _captureVideoPreviewLayer.frame =layer.bounds;
    _captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;//填充模式
    [layer insertSublayer:_captureVideoPreviewLayer below:self.focusCursor.layer];
    [self addNotificationToCapTureDevice:captureDevice];
    [self addGenstureRecognizer];
    [self.captureSession startRunning];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.captureSession stopRunning];
}

//添加通知
-(void) addNotificationToCapTureDevice:(AVCaptureDevice *) captureDevice{
    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
        captureDevice.subjectAreaChangeMonitoringEnabled =YES;
    }];
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    //捕获区域发生改变
    [notificationCenter addObserver:self selector:@selector(areaChange:) name:AVCaptureDeviceSubjectAreaDidChangeNotification object:captureDevice];
}
//添加手势
-(void)addGenstureRecognizer{
 UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapScreen:)];
    [self.viewContainer addGestureRecognizer:tapGestureRecognizer];
}
-(void)tapScreen:(UITapGestureRecognizer *) tapGesture{
    CGPoint point = [tapGesture locationInView:self.viewContainer];
    //将UI坐标转换为摄像头坐标
    CGPoint cameraPoint = [self.captureVideoPreviewLayer captureDevicePointOfInterestForPoint: point];
    [self setFocusCursorWithPoint:point];
    [self focusWithMode:AVCaptureFocusModeAutoFocus exposureMode:AVCaptureExposureModeAutoExpose aPoint:cameraPoint];
}
/**
 *设置聚焦光标位置
 */
-(void)setFocusCursorWithPoint:(CGPoint)point{
    self.focusCursor.center = point;
    self.focusCursor.transform = CGAffineTransformMakeScale(1.5,1.5);
    self.focusCursor.alpha = 1.0;
    [UIView animateWithDuration:0.1 animations:^{
        self.focusCursor.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        self.focusCursor.alpha =0;
    }];
}
/**
 * 设置聚焦点
 */
-(void)focusWithMode:(AVCaptureFocusMode)focusMode exposureMode:(AVCaptureExposureMode)exposureMode aPoint:(CGPoint) point{
    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
        if([captureDevice isFocusModeSupported:focusMode]){
            [captureDevice setFocusMode:AVCaptureFocusModeAutoFocus];
        }
        if([captureDevice isFocusPointOfInterestSupported]){
            [captureDevice setFocusPointOfInterest:point];
        }
        if([captureDevice isExposureModeSupported:exposureMode]){
            [captureDevice setExposureMode:AVCaptureExposureModeAutoExpose];
        }
        if([captureDevice isExposurePointOfInterestSupported]){
            [captureDevice setExposurePointOfInterest:point];
        }
    }];
}
//根据位置获取前后摄像头
-(AVCaptureDevice *) getCameraDeviceWithPosition:(AVCaptureDevicePosition) postion{
    NSArray *cameras= [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *camera in cameras) {
        if ([camera position]==postion) {
            return camera;
        }
    }
    return nil;
}
-(void)areaChange:(NSNotification *)notification{
    NSLog(@"捕获区域改变...");
}

#pragma mark - 私有方法
-(void)changeDeviceProperty:(PropertyChangeBlock)propertyChange{
   AVCaptureDevice *captureDevice = [self.captureDeviceInput device];
   NSError *error;
    //注意改变设备属性前一定要首先调用lockForConfiguration,调用使unlockForConfiguration 解锁
   if([captureDevice lockForConfiguration:&error]){
       propertyChange(captureDevice);
       [captureDevice unlockForConfiguration];
    }else{
       NSLog(@"设置设备属性过程发生错误，错误信息：%@",error.localizedDescription);

   }


}
- (IBAction)onClick:(id)sender {
    //根据设备输出获得连接
    AVCaptureConnection *captureConnection = [self.captureMovieFileOutput connectionWithMediaType:AVMediaTypeAudio];
    //根据连接取得设备输出的数据
   if(![self.captureMovieFileOutput isRecording]){
       //如果支持多任务则开始多任务
       if([[UIDevice currentDevice] isMultitaskingSupported]){
           self.backgroundTaskIdentifier = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
       }
       //预览图层和视频方向保持一致
       captureConnection.videoOrientation = [self.captureVideoPreviewLayer connection].videoOrientation;
       NSString *outputFilePath = [NSTemporaryDirectory() stringByAppendingString:@"myMovie.mp4"];
       NSLog(@"sava path is:%@",outputFilePath);
       NSURL *fileUrl = [NSURL fileURLWithPath:outputFilePath];
       NSLog(@"fileurl:%@",fileUrl);
       [self.captureMovieFileOutput startRecordingToOutputFileURL:fileUrl recordingDelegate:self];
   }else{
       [self.captureMovieFileOutput stopRecording];//停止录制
   }

}
#pragma mark - 视频输出代理
-(void)captureOutput:(AVCaptureFileOutput *)captureOutput didStartRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray *)connections {
    NSLog(@"开始录制...");
}
-(void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error {
    NSLog(@"视频录制完成..");
    UIBackgroundTaskIdentifier  lastBackgroundTaskIdIdentifier = self.backgroundTaskIdentifier;
    self.backgroundTaskIdentifier = UIBackgroundTaskInvalid;
    ALAssetsLibrary *assetsLibrary = [ALAssetsLibrary new];
    [assetsLibrary writeVideoAtPathToSavedPhotosAlbum:outputFileURL completionBlock:^(NSURL *assetURL, NSError *error) {
        [[UIApplication sharedApplication] endBackgroundTask:lastBackgroundTaskIdIdentifier];
    }];
    NSLog(@"成功保持到相册");
}
- (IBAction)onStop:(id)sender {
    [self.captureMovieFileOutput stopRecording];//停止录制
}
- (IBAction)showMovie:(id)sender {
    VPlayerManager *playManager = [VPlayerManager new];
    playManager.delegate =self;
    [playManager passMovie];
}
-(void)mMoveDecoder:(id)object onNewVideoFrameReady:(CMSampleBufferRef)videoBuffer {
  CGImageRef cgImage = [VPlayerManager imageFromSampleBufferRef:videoBuffer];
   if(!(__bridge id )(cgImage))  {NSLog(@"什么都没有");return;}
   if(!images) images =@[].mutableCopy;
//    UIImage *img = [UIImage imageWithCGImage:cgImage];
//    img = [img fixOrientation ];
   [images addObject:(__bridge id)cgImage];
    CGImageRelease(cgImage);
}
-(void)mMoveDecoderOnDecoderFinished:(id)vplayer {
    NSLog(@"视频解挡完成");
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingString:@"myMovie.mp4"]] options:nil];
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
    animation.duration = asset.duration.value/asset.duration.timescale;
    animation.values = images;
    animation.repeatDuration = MAXFLOAT;
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    CALayer *layer = [CALayer layer];
    maskLayer.frame = self.showView.bounds;
    maskLayer.fillColor = [UIColor redColor].CGColor;
    maskLayer.contentsCenter = CGRectMake(0.25, 0.75, 0.1, 0.1);
    maskLayer.contents =(id)[UIImage imageNamed:@"textBubbleclick@2x.png"].CGImage;

    CGAffineTransform transform = CGAffineTransformIdentity;
    layer.affineTransform = CGAffineTransformRotate(transform, (M_PI / 180.0 * 90.0));
    CALayer *newLayer = [CALayer layer];
    [newLayer addSublayer:layer];
    newLayer.mask =maskLayer;
    layer.frame =self.showView.bounds;
   // layer.contents = images[0];
    [self.showView.layer addSublayer:newLayer];
    [layer addAnimation:animation  forKey:nil];
    [images enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if(obj){
            obj = nil;
        }
    }];
}
- (IBAction)onYaSuo:(id)sender {
    NSString *path = [NSTemporaryDirectory() stringByAppendingString:@"myMovie.mov"];
    NSString *path1 = [NSTemporaryDirectory() stringByAppendingString:@"myMovie2.mp4"];
    [VPlayerManager converVideoDimissionWithFilePath:path andOutputPath:path1 cutType:1 withCompletion:^{
        NSLog(@"转换成功");
    }];
}
@end