//
//  PKXAppDelegate.m
//  PageKite
//
//  Created by Jay Lyerly on 6/26/14.
//  Copyright (c) 2014 SonicBunny Software. All rights reserved.
//

#import "PKXAppDelegate.h"
#import "PKXLogger.h"

@implementation PKXAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [[PKXLogger sharedManager] logMessage:@"PageKite app startup"];
}

@end
