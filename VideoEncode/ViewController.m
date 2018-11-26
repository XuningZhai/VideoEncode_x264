//
//  ViewController.m
//  VideoEncode
//
//  Created by aipu on 2018/5/17.
//  Copyright © 2018年 aipu. All rights reserved.
//

#import "ViewController.h"
#import "CaptureSession.h"
#import "X264Encoder.h"

@interface ViewController ()<CaptureSessionDelegate>
{
    X264Encoder *x264encoder;
    dispatch_queue_t encodeQueue;
    BOOL isRecording;
}
@property (nonatomic,strong) CaptureSession *captureSession;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    encodeQueue = dispatch_queue_create(DISPATCH_QUEUE_SERIAL, NULL);
    _captureSession = [[CaptureSession alloc] initWithCaptureSessionPreset:CaptureSessionPreset640x480];
    _captureSession.delegate = self;
    AVCaptureVideoPreviewLayer *preViewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession.session];
    preViewLayer.frame = CGRectMake(0.f, 0.f, self.view.bounds.size.width, self.view.bounds.size.height);
    preViewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    preViewLayer.backgroundColor = [UIColor blackColor].CGColor;
    [self.view.layer addSublayer:preViewLayer];
    [self.view bringSubviewToFront:self.btn];
}
    
- (IBAction)start:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self initX264Encoder];
        [_captureSession start];
        isRecording = YES;
    }
    else {
        isRecording = NO;
        [self teardown];
        [_captureSession stop];
    }
}

- (void)initX264Encoder
{
    dispatch_sync(encodeQueue, ^{
        self->x264encoder = [X264Encoder defaultX264Encoder];
    });
}

- (void)teardown
{
    dispatch_sync(encodeQueue, ^{
        [self->x264encoder teardown];
    });
}
    
- (void)videoWithSampleBuffer:(CMSampleBufferRef)sampleBuffer
{
    dispatch_sync(encodeQueue, ^{
        if (self->isRecording) {
            CVPixelBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
            CMTime ptsTime = CMSampleBufferGetOutputPresentationTimeStamp(sampleBuffer);
            CGFloat pts = CMTimeGetSeconds(ptsTime);
            [self->x264encoder encoding:pixelBuffer timestamp:pts];
        }
    });
}

@end
