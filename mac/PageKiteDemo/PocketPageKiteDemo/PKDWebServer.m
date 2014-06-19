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
#import "PKDKiteViewController.h"

@implementation PKDWebServer

- (instancetype) init {
    self = [super init];
    if (self){
        [self addHandlers];
    }
    return self;
}

- (void) addHandlers {
    __weak PKDWebServer *weakSelf = self;
    
    [self addDefaultHandlerForMethod:@"GET"
                        requestClass:[GCDWebServerRequest class]
                        processBlock:^GCDWebServerResponse *(GCDWebServerRequest* request) {
                  
                            NSString *path = request.path;
                            
                            if ([path isEqualToString:@"/mapview.png"]){
                                NSData *data = UIImagePNGRepresentation(weakSelf.kiteVC.mapImage);
                                return [GCDWebServerDataResponse responseWithData:data
                                                                      contentType:@"image/png"];

                            }
                            
                            CLLocationCoordinate2D location = [[PKDLocationMgr sharedManager] currentLocation];
                            CLLocationDegrees llat = location.latitude;
                            CLLocationDegrees llong = location.longitude;
                            
                            NSMutableString *html = [NSMutableString stringWithString:@""];
                            [html appendString:@"<html><body>"];
                            [html appendString:@"<p>Hello World from iPhone</p>"];
                            [html appendFormat:@"<p>Device: %@</p>", [[UIDevice currentDevice] name]];
                            [html appendFormat:@"<p>Location: %f, %f</p>", llat, llong];
                            [html appendFormat:@"<p><img src=\"mapview.png\"></p>"];
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
