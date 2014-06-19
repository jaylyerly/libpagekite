//
//  PKDWebServer.h
//  PageKiteDemo
//
//  Created by Jay Lyerly on 6/16/14.
//  Copyright (c) 2014 SonicBunny Software. All rights reserved.
//

#import "GCDWebServer.h"

@class PKDKiteViewController;

@interface PKDWebServer : GCDWebServer

@property (nonatomic, weak)   PKDKiteViewController *kiteVC;

- (void) enable;
- (void) disable;

@end
