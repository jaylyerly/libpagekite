//
//  PKDImageCaptureMgr.h
//  PageKiteDemo
//
//  Created by Jay Lyerly on 6/19/14.
//  Copyright (c) 2014 SonicBunny Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PKDImageCaptureMgr : NSObject

@property (nonatomic, readonly) UIImage *currentImage;

+ (instancetype) sharedManager;

- (void) startImageCapture;
- (void) stopImageCapture;

@end
