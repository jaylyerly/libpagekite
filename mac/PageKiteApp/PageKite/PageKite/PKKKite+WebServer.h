//
//  PKKKite+WebServer.h
//  PageKiteDemo
//
//  Created by Jay Lyerly on 6/13/14.
//  Copyright (c) 2014 SonicBunny Software. All rights reserved.
//

#import <PageKiteKit/PageKiteKit.h>

@interface PKKKite (WebServer)

@property (nonatomic, copy) NSString  *webDocumentDirectory;

- (void) startWebServer;
- (void) stopWebServer;

@end
