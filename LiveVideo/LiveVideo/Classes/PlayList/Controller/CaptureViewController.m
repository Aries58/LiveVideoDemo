//
//  CaptureViewController.m
//  LiveVideo
//
//  Created by 王亮 on 2016/11/3.
//  Copyright © 2016年 wangliang. All rights reserved.
//

#import "CaptureViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface CaptureViewController ()<AVCaptureVideoDataOutputSampleBufferDelegate,AVCaptureAudioDataOutputSampleBufferDelegate>

@property (nonatomic,strong) AVCaptureSession *captureSession;
@property (nonatomic,strong) AVCaptureDeviceInput *currentVideoDeviceInput;
@property (nonatomic,weak) UIImageView *focusCursorImageView;
@property (nonatomic,weak) AVCaptureVideoPreviewLayer *previedLayer;
@property (nonatomic,weak) AVCaptureConnection *videoConnection;

@end

@implementation CaptureViewController

//加载聚焦视图

-(UIImageView *)focusCursorImageView
{
    if (_focusCursorImageView ==nil) {
        
        UIImageView *imageView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"focus"]];
        _focusCursorImageView=imageView;
        [self.view addSubview:_focusCursorImageView];
    }
    
    return _focusCursorImageView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"视频采集";
    self.view.backgroundColor=[UIColor blueColor];
    
    [self setupCaputureVideo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//捕捉音视频
-(void)setupCaputureVideo
{
    //捕捉会话
    AVCaptureSession *captureSession=[[AVCaptureSession alloc] init];
    self.captureSession=captureSession;
    
    /*
     typedef NS_ENUM(NSInteger, AVCaptureDevicePosition)
     {
        AVCaptureDevicePositionUnspecified         = 0,
        AVCaptureDevicePositionBack                = 1,
        AVCaptureDevicePositionFront               = 2
     }
     */
    //获取摄像头设备
    AVCaptureDevice *videoDevice=[self getVideoDevice:AVCaptureDevicePositionBack];
    
    //获取声音设备
    AVCaptureDevice *audioDevice=[AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
    
    //创建对应视频设备输入对象
    AVCaptureDeviceInput *videoInput=[AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:nil];
    self.currentVideoDeviceInput=videoInput;
    
    AVCaptureDeviceInput *audioInput=[AVCaptureDeviceInput deviceInputWithDevice:audioDevice error:nil];
    
    
    //添加到会话中
    if ([captureSession canAddInput:videoInput]) {
        
        [captureSession addInput:videoInput];
    }
    
    if ([captureSession canAddInput:audioInput]) {
        
        [captureSession addInput:audioInput];
    }
    
    //视频数据输出设备
    AVCaptureVideoDataOutput *videoOutput=[[AVCaptureVideoDataOutput alloc] init];
    
    //设置代理 捕获视频样品数据
    dispatch_queue_t videoQueue=dispatch_queue_create("Video Capture Queue", DISPATCH_QUEUE_SERIAL);
    [videoOutput setSampleBufferDelegate:self queue:videoQueue];
    
    if ([captureSession canAddOutput:videoOutput]) {
        
        [captureSession addOutput:videoOutput];
    }
    
    
    //音频数据输出设备
    AVCaptureAudioDataOutput *audioOutput=[[AVCaptureAudioDataOutput alloc] init];
    dispatch_queue_t audioQueue=dispatch_queue_create("Audio Capture Queue", DISPATCH_QUEUE_SERIAL);
    [audioOutput setSampleBufferDelegate:self queue:audioQueue];
    if ([captureSession canAddOutput:audioOutput]) {
        
        [captureSession addOutput:audioOutput];
    }
    
    //获取视频输入与输出连接用于分辨音视频数据
    self.videoConnection=[videoOutput connectionWithMediaType:AVMediaTypeVideo];
    
    //添加视频预览图层
    AVCaptureVideoPreviewLayer *previedLayer=[AVCaptureVideoPreviewLayer layerWithSession:captureSession];
    previedLayer.frame=[UIScreen mainScreen].bounds;
    [self.view.layer insertSublayer:previedLayer atIndex:0];
    self.previedLayer=previedLayer;
    
    //启动会话
    [captureSession startRunning];
}

//指定摄像头方向 获取摄像头
-(AVCaptureDevice *)getVideoDevice:(AVCaptureDevicePosition)positon
{
    NSArray *devices=[AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    
    //[AVCaptureDeviceDiscoverySession discoverySessionWithDeviceTypes:<#(NSArray<AVCaptureDeviceType> *)#> mediaType:AVMediaTypeVideo position:positon]
    
    for (AVCaptureDevice *device in devices) {
        
        if (device.position == positon) {
            
            return device;
        }
    }
    return  nil;
}

#pragma mark -- AVCaptureVideoDataOutputSampleBufferDelegate
//获取输入设备数据 音频或视频
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    
    if (_videoConnection == connection) {
        
        NSLog(@"视频数据---");
    }else{
        
        NSLog(@"音频数据---");
    }
    
}

#pragma mark -- AVCaptureAudioDataOutputSampleBufferDelegate

- (IBAction)switchCamera:(UIButton *)sender {
    
    NSLog(@"switchCamera---'");
    
    //获取当前设备方向
    AVCaptureDevicePosition curPosition=self.currentVideoDeviceInput.device.position;
    
    //获取需要改变的方向
    AVCaptureDevicePosition switchPosition = curPosition == AVCaptureDevicePositionFront ? AVCaptureDevicePositionBack : AVCaptureDevicePositionFront;
    
    AVCaptureDevice *switchDevice=[self getVideoDevice:switchPosition];
    
    //改变后的摄像头设备
    AVCaptureDeviceInput *switchDeviceInput=[AVCaptureDeviceInput deviceInputWithDevice:switchDevice error:nil];
    
    //移除之前摄像头设备
    [self.captureSession removeInput:self.currentVideoDeviceInput];
    
    //添加新的摄像头输入设备
    [self.captureSession addInput:switchDeviceInput];
    
    self.currentVideoDeviceInput=switchDeviceInput;
    
}

//点击屏幕出现聚焦视图
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //点击位置
    UITouch *touch=[touches anyObject];
    CGPoint point=[touch locationInView:self.view];
    
    //转换当前位置为摄像头点上的位置
    CGPoint cameraPoint=[self.previedLayer captureDevicePointOfInterestForPoint:point];
    
    [self setFocusCursorWithPoint:point];
    
    [self focusWithMode:AVCaptureFocusModeAutoFocus exposureMode:AVCaptureExposureModeAutoExpose atPoint:cameraPoint];
    
}

//设置聚焦点光标位置
-(void)setFocusCursorWithPoint:(CGPoint)point
{
    self.focusCursorImageView.center=point;
    self.focusCursorImageView.transform=CGAffineTransformMakeScale(1.5, 1.5);
    self.focusCursorImageView.alpha=1.0;
    
    [UIView animateWithDuration:1.0 animations:^{
        self.focusCursorImageView.transform=CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        
        self.focusCursorImageView.alpha=0;
    }];
    
}

//设置聚焦
-(void)focusWithMode:(AVCaptureFocusMode)focusMode exposureMode:(AVCaptureExposureMode)exposureMode atPoint:(CGPoint)point{
    
    AVCaptureDevice *captureDevice=self.currentVideoDeviceInput.device;
    
    //锁定配置
    [captureDevice lockForConfiguration:nil];
    
    //设置聚焦
    if ([captureDevice isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
        
        [captureDevice setFocusMode:AVCaptureFocusModeAutoFocus];
    }
    
    if ([captureDevice isFocusPointOfInterestSupported]) {
        
        [captureDevice setFocusPointOfInterest:point];
    }
   
    //设置曝光
    if ([captureDevice isExposureModeSupported:AVCaptureExposureModeAutoExpose]) {
        
        [captureDevice setExposureMode:AVCaptureExposureModeAutoExpose];
    }
    
    if ([captureDevice isExposurePointOfInterestSupported]) {
        
        [captureDevice setFocusPointOfInterest:point];
    }
    
    //解锁配置
    [captureDevice unlockForConfiguration];
    
}


@end
