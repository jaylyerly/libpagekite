//
//  PKDLocationMgr.m
//  PageKiteDemo
//
//  Created by Jay Lyerly on 6/16/14.
//  Copyright (c) 2014 SonicBunny Software. All rights reserved.
//

#import "PKDLocationMgr.h"
#import <PageKiteKit/PageKiteKit.h>

@interface PKDLocationMgr ()<CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSMutableSet      *watcherSet;
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
        _locationManager.delegate = self;
        _watcherSet = [[NSMutableSet alloc] init];
    }
    return self;
}

- (void) beginLocating {
    [self.locationManager startUpdatingLocation];
}

- (CLLocationCoordinate2D) currentLocation{
    return self.locationManager.location.coordinate;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *location = objc_dynamic_cast(CLLocation, [locations firstObject]);
    for (id<PKDLocationMgrWatcher> watcher in self.watcherSet){
        [watcher locationMgr:self location:location];
    }
}

- (void)addWatcher:(id<PKDLocationMgrWatcher>)watcher {
    [self.watcherSet addObject:watcher];
    
    // if a watcher is added after a location is detected, let the watcher know
    // it might be a while before an update
    CLLocation *location = self.locationManager.location;
    if (location){
        [watcher locationMgr:self location:location];
    }
}

@end
