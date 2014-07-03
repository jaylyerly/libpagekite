//
//  PKDImageCaptureMgr.m
//  PageKiteDemo
//
//  Created by Jay Lyerly on 6/19/14.
//  Copyright (c) 2014 SonicBunny Software. All rights reserved.
//

#import "PKDImageCaptureMgr.h"
#import <AVFoundation/AVFoundation.h>

#import "UIImage+Rotating.h"

// Image Capture code borrowed from
// http://stackoverflow.com/questions/20202310/how-can-i-capture-an-image-from-ios-camera-without-user-interaction

@interface PKDImageCaptureMgr () <AVCaptureVideoDataOutputSampleBufferDelegate>
@property (nonatomic, strong) UIImage *currentImage;
@property (nonatomic, strong) NSTimer *captureTimer;
@end

@implementation PKDImageCaptureMgr

+ (instancetype) sharedManager {
    static dispatch_once_t onceToken;
    static PKDImageCaptureMgr *_mgr = nil;
    dispatch_once(&onceToken, ^{
        _mgr = [[PKDImageCaptureMgr alloc] init];
    });
    return _mgr;
}

- (instancetype) init {
    self = [super init];
    if (self){
    }
    return self;
}

- (void) startImageCapture {
    self.captureTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                         target:self
                                                       selector:@selector(captureImage)
                                                       userInfo:nil
                                                        repeats:YES];
}

- (void) stopImageCapture {
    [self.captureTimer invalidate];
}

- (void)captureImage
{
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    session.sessionPreset = AVCaptureSessionPresetHigh;
    
    AVCaptureDevice *device = [self frontCamera];
    
    NSError *error = nil;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    if (!input) {
        // Handle the error appropriately.
        if (! self.currentImage) {
            self.currentImage = [UIImage imageNamed:@"NoCamera"];
        }
        return;
    }
    [session addInput:input];
    
    AVCaptureVideoDataOutput *output = [[AVCaptureVideoDataOutput alloc] init];
    [session addOutput:output];
    output.videoSettings = @{ (NSString *)kCVPixelBufferPixelFormatTypeKey : @(kCVPixelFormatType_32BGRA) };
    
    [output setSampleBufferDelegate:self queue:dispatch_queue_create(NULL, NULL)];
    
    [session startRunning];
    
    [session stopRunning];
}

- (AVCaptureDevice *)frontCamera {
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        if ([device position] == AVCaptureDevicePositionFront) {
            return device;
        }
    }
    return nil;
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput
didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
       fromConnection:(AVCaptureConnection *)connection {
    
    CGImageRef cgImage = [self imageFromSampleBuffer:sampleBuffer];
    self.currentImage = [UIImage imageWithCGImage:cgImage];

    // Fix the image orientation
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    float degrees;
    if (orientation == UIDeviceOrientationPortrait) {
        degrees = -90;
    } else if (orientation == UIDeviceOrientationPortraitUpsideDown) {
        degrees = 90;
    } else if (orientation == UIDeviceOrientationLandscapeRight) {
        degrees = 0;
    } else {
        degrees = 180;
    }

    self.currentImage = [self.currentImage rotateInDegrees:degrees];
    CGImageRelease( cgImage );
}

- (CGImageRef) imageFromSampleBuffer:(CMSampleBufferRef) sampleBuffer
{
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    CVPixelBufferLockBaseAddress(imageBuffer,0);
    uint8_t *baseAddress = (uint8_t *)CVPixelBufferGetBaseAddressOfPlane(imageBuffer, 0);
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef newContext = CGBitmapContextCreate(baseAddress, width, height, 8, bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    CGImageRef newImage = CGBitmapContextCreateImage(newContext);
    CGContextRelease(newContext);
    
    CGColorSpaceRelease(colorSpace);
    CVPixelBufferUnlockBaseAddress(imageBuffer,0);
    

    
    return newImage;
}
@end
