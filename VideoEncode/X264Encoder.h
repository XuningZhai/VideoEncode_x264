//
//  X264Encoder.h
//  VideoEncode
//
//  Created by aipu on 2018/11/26.
//  Copyright © 2018 aipu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface X264Encoder : NSObject
@property (assign, nonatomic) CGSize videoSize;
@property (assign, nonatomic) CGFloat frameRate;
@property (assign, nonatomic) CGFloat maxKeyframeInterval;
@property (assign, nonatomic) CGFloat bitrate;
@property (strong, nonatomic) NSString *profileLevel;
+ (instancetype)defaultX264Encoder;
- (instancetype)initX264Encoder:(CGSize)videoSize
                                 frameRate:(NSUInteger)frameRate
                       maxKeyframeInterval:(CGFloat)maxKeyframeInterval
                                   bitrate:(NSUInteger)bitrate
                              profileLevel:(NSString *)profileLevel;
- (void)encoding:(CVPixelBufferRef)pixelBuffer timestamp:(CGFloat)timestamp;
- (void)teardown;
@end

NS_ASSUME_NONNULL_END
