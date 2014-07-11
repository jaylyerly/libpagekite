//
//  PKKManager+WebServer.m
//  PageKiteDemo
//
//  Created by Jay Lyerly on 6/13/14.
//  Copyright (c) 2014 SonicBunny Software. All rights reserved.
//

#import "PKKManager+WebServer.h"
#import "PKKKite+WebServer.h"

@implementation PKKManager (WebServer)

- (void) flyKitesWithWebServers{
    for (PKKKite *kite in self.kites){
        [kite startWebServer];
    }
    [self flyKites];
}

- (void) landKitesWithWebServers{
    [self landKites];
    for (PKKKite *kite in self.kites){
        [kite stopWebServer];
    }
}

@end
