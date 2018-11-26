//
//  VideoCaptureSession.h
//  VideoEncode
//
//  Created by aipu on 2018/5/17.
//  Copyright © 2018年 aipu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

typedef NS_ENUM (NSUInteger,CaptureSessionPreset)
{
    CaptureSessionPreset640x480,
    CaptureSessionPresetiFrame960x540,
    CaptureSessionPreset1280x720,
};

@protocol CaptureSessionDelegate <NSObject>
- (void)videoWithSampleBuffer:(CMSampleBufferRef)sampleBuffer;
@end

@interface CaptureSession : NSObject
@property (nonatomic ,strong) id<CaptureSessionDelegate>delegate;
@property (nonatomic ,strong) AVCaptureSession *session;
- (instancetype)initWithCaptureSessionPreset:(CaptureSessionPreset)preset;
- (void)start;
- (void)stop;
@end
