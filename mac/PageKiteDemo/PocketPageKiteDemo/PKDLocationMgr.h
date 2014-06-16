//
//  PKDLocationMgr.h
//  PageKiteDemo
//
//  Created by Jay Lyerly on 6/16/14.
//  Copyright (c) 2014 SonicBunny Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface PKDLocationMgr : NSObject

+ (instancetype) sharedManager;

- (void) beginLocating;
- (CLLocationCoordinate2D) currentLocation;

@end
