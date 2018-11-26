//
//  VideoCaptureSession.m
//  VideoEncode
//
//  Created by aipu on 2018/5/17.
//  Copyright © 2018年 aipu. All rights reserved.
//

#import "CaptureSession.h"

@interface CaptureSession()<AVCaptureVideoDataOutputSampleBufferDelegate,AVCaptureAudioDataOutputSampleBufferDelegate>
@property (nonatomic,strong) AVCaptureDevice *videoDevice;
@property (nonatomic,strong) AVCaptureDeviceInput *videoInput;
@property (nonatomic,strong) AVCaptureVideoDataOutput *videoOutput;
@property (nonatomic,assign) CaptureSessionPreset definePreset;
@property (nonatomic,strong) NSString *realPreset;
@end


@implementation CaptureSession

- (instancetype)initWithCaptureSessionPreset:(CaptureSessionPreset)preset
{
    if ([super init]) {
        [self initAVCaptureSession];
        _definePreset = preset;
    }
    return self;
}

- (void)initAVCaptureSession
{
    _session = [[AVCaptureSession alloc] init];
    if (![self.session canSetSessionPreset:self.realPreset]) {
        if (![self.session canSetSessionPreset:AVCaptureSessionPresetiFrame960x540]) {
            if (![self.session canSetSessionPreset:AVCaptureSessionPreset640x480]) {
            }
        }
    }
    [_session beginConfiguration];
    AVCaptureDeviceDiscoverySession *deviceDiscoverySession = [AVCaptureDeviceDiscoverySession  discoverySessionWithDeviceTypes:@[AVCaptureDeviceTypeBuiltInWideAngleCamera] mediaType:AVMediaTypeVideo position:AVCaptureDevicePositionBack];
    NSArray *devices  = deviceDiscoverySession.devices;
    for (AVCaptureDevice *device in devices) {
        if (device.position == AVCaptureDevicePositionBack) {
            self.videoDevice = device;
        }
    }
    NSError *error;
    self.videoInput = [[AVCaptureDeviceInput alloc] initWithDevice:self.videoDevice error:&error];
    if (error) {
        NSLog(@"摄像头错误");
        return;
    }
    if ([self.session canAddInput:self.videoInput]) {
        [self.session addInput:self.videoInput];
    }
    self.videoOutput = [[AVCaptureVideoDataOutput alloc] init];
    self.videoOutput.alwaysDiscardsLateVideoFrames = NO;
    [self.videoOutput setVideoSettings:@{
                                         (__bridge NSString *)kCVPixelBufferPixelFormatTypeKey:@(kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange)
                                         }];
    dispatch_queue_t captureQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    [self.videoOutput setSampleBufferDelegate:self queue:captureQueue];
    if ([self.session canAddOutput:self.videoOutput]) {
        [self.session addOutput:self.videoOutput];
    }
    AVCaptureConnection *connection = [self.videoOutput connectionWithMediaType:AVMediaTypeVideo];
    connection.videoOrientation = AVCaptureVideoOrientationPortrait;
    if ([connection isVideoStabilizationSupported]) {
        connection.preferredVideoStabilizationMode = AVCaptureVideoStabilizationModeAuto;
    }
    connection.videoScaleAndCropFactor = connection.videoMaxScaleAndCropFactor;
    [self.session commitConfiguration];
}

- (NSString *)realPreset
{
    switch (_definePreset) {
        case CaptureSessionPreset640x480:
            _realPreset = AVCaptureSessionPreset640x480;
            break;
        case CaptureSessionPresetiFrame960x540:
            _realPreset = AVCaptureSessionPresetiFrame960x540;
            break;
        case CaptureSessionPreset1280x720:
            _realPreset = AVCaptureSessionPreset1280x720;
            break;
        default:
            _realPreset = AVCaptureSessionPreset640x480;
            break;
    }
    return _realPreset;
}

- (void)start
{
    [self.session startRunning];
}

- (void)stop
{
    [self.session stopRunning];
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(videoWithSampleBuffer:)]) {
        [self.delegate videoWithSampleBuffer:sampleBuffer];
    }
}

@end
