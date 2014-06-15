//
//  PKKKite+WebServer.m
//  PageKiteDemo
//
//  Created by Jay Lyerly on 6/13/14.
//  Copyright (c) 2014 SonicBunny Software. All rights reserved.
//

#import "PKKKite+WebServer.h"
#import <objc/runtime.h>
#import "GCDWebServer.h"

@interface PKKKite (WebServerInternal)
@property (nonatomic, strong) GCDWebServer *webServer;
@end

@implementation PKKKite (WebServer)

#pragma mark - webDocumentDirectory accessors
- (void)setWebDocumentDirectory:(NSString *)webDocumentDirectory {
	objc_setAssociatedObject(self, @selector(webDocumentDirectory), webDocumentDirectory, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)webDocumentDirectory {
	return objc_getAssociatedObject(self, @selector(webDocumentDirectory));
}

#pragma mark - webServer accessors
- (void)setWebServer:(GCDWebServer *)webServer{
	objc_setAssociatedObject(self, @selector(webServer), webServer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (GCDWebServer *)webServer {
	return objc_getAssociatedObject(self, @selector(webServer));
}


- (void)startWebServer {
    if (self.webDocumentDirectory){
        self.webServer = [[GCDWebServer alloc] init];
        [self.webServer addGETHandlerForBasePath:@"/"
                                   directoryPath:self.webDocumentDirectory
                                   indexFilename:@"index.html"
                                        cacheAge:3600
                              allowRangeRequests:YES];
        [self.webServer addHandlerWithMatchBlock:^GCDWebServerRequest *(NSString* requestMethod, NSURL* requestURL, NSDictionary* requestHeaders, NSString* urlPath, NSDictionary* urlQuery) {
            
            // DO LOGGING
            
            return nil;
        } processBlock:^GCDWebServerResponse *(GCDWebServerRequest* request){ return nil; }];
        
        BOOL status = [self.webServer startWithPort:[self.localPort integerValue] bonjourName:@""];
        if (! status) {
            [[PKKManager sharedManager] addLogMessage:[NSString stringWithFormat:@"Failed to start webserver on port:%@ with root directory: %@", self.localPort, self.webDocumentDirectory]];
        }
    }
}

- (void) stopWebServer {
    [self.webServer stop];
    self.webServer = nil;
}

@end
