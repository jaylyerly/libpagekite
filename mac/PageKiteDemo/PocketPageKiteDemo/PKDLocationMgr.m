//
//  PKDLocationMgr.m
//  PageKiteDemo
//
//  Created by Jay Lyerly on 6/16/14.
//  Copyright (c) 2014 SonicBunny Software. All rights reserved.
//

#import "PKDLocationMgr.h"

@interface PKDLocationMgr ()

@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation PKDLocationMgr

+ (instancetype) sharedManager {
    static dispatch_once_t onceToken;
    static PKDLocationMgr *_mgr = nil;
    dispatch_once(&onceToken, ^{
        _mgr = [[PKDLocationMgr alloc] init];
    });
    return _mgr;
}

- (instancetype) init {
    self = [super init];
    if (self){
        _locationManager = [[CLLocationManager alloc] init];
    }
    return self;
}

- (CLLocationCoordinate2D) currentLocation{
    return self.locationManager.location.coordinate;
}

- (void) beginLocating {
    [self.locationManager startUpdatingLocation];
}
@end
