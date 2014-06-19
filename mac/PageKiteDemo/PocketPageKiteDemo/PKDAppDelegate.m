//
//  PKDAppDelegate.m
//  PocketPageKiteDemo
//
//  Created by Jay Lyerly on 6/15/14.
//  Copyright (c) 2014 SonicBunny Software. All rights reserved.
//

#import "PKDAppDelegate.h"
#import "PKDLocationMgr.h"

@implementation PKDAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[PKDLocationMgr sharedManager] beginLocating]; // initialize location
    return YES;
}
							
@end
