//
//  PKDWebServer.m
//  PageKiteDemo
//
//  Created by Jay Lyerly on 6/16/14.
//  Copyright (c) 2014 SonicBunny Software. All rights reserved.
//

#import "PKDWebServer.h"
#import "GCDWebServerDataResponse.h"
#import <PageKiteKit/PageKiteKit.h>
#import "PKDLocationMgr.h"

@implementation PKDWebServer

- (instancetype) init {
    self = [super init];
    if (self){
        [self addHandlers];
    }
    return self;
}

- (void) addHandlers {
    [self addDefaultHandlerForMethod:@"GET"
                        requestClass:[GCDWebServerRequest class]
                        processBlock:^GCDWebServerResponse *(GCDWebServerRequest* request) {
                  
                            CLLocationCoordinate2D location = [[PKDLocationMgr sharedManager] currentLocation];
                            
                            NSMutableString *html = [NSMutableString stringWithString:@""];
                            [html appendString:@"<html><body>"];
                            [html appendString:@"<p>Hello World from iPhone</p>"];
                            [html appendFormat:@"<p>Device: %@</p>", [[UIDevice currentDevice] name]];
                            [html appendFormat:@"<p>Location: %f, %f</p>", location.latitude, location.longitude];
                            [html appendString:@"</body></html>"];
                            return [GCDWebServerDataResponse responseWithHTML:html];
                  
                        }];

}

- (void) enable {
    BOOL status = [self startWithPort:8123 bonjourName:nil];
    if (! status) {
        [[PKKManager sharedManager] addLogMessage:@"Failed to start webserver on port:8123"];
    }
}

- (void) disable {
    [self stop];
}
@end
