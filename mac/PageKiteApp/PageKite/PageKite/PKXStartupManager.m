//
//  PKXStartupManager.m
//  PageKite
//
//  Created by Jay Lyerly on 7/3/14.
//  Copyright (c) 2014 SonicBunny Software. All rights reserved.
//

#import "PKXStartupManager.h"

@implementation PKXStartupManager

+ (instancetype) sharedManager {
    static dispatch_once_t onceToken;
    static PKXStartupManager *_mgr = nil;
    dispatch_once(&onceToken, ^{
        _mgr = [[PKXStartupManager _alloc] _init];
    });
    
    return _mgr;
}

+ (id) allocWithZone:(NSZone*)z { return [self sharedManager];       }
+ (id) alloc                    { return [self sharedManager];       }
- (id) init                     { return  self;                      }
+ (id)_alloc                    { return [super allocWithZone:NULL]; }
- (id)_init                     { return [super init];               }


- (BOOL) willLaunchAtStartup {
    return [self inLoginItems];
}

- (void) setWillLaunchAtStartup:(BOOL)newWillLaunchAtStartup {
    if (self.willLaunchAtStartup == newWillLaunchAtStartup){
        return;     // no change in state, so bail early
    }
    if (newWillLaunchAtStartup){
        [self addLoginItem];
    }else{
        [self deleteLoginItem];
    }
}

- (LSSharedFileListRef) loginItems {
    return LSSharedFileListCreate(NULL, kLSSharedFileListSessionLoginItems, NULL);
}

- (CFURLRef)myURL {
    NSString * appPath = [[NSBundle mainBundle] bundlePath];
    
	// This will retrieve the path for the application
	// For example, /Applications/test.app
	return  (__bridge CFURLRef)[NSURL fileURLWithPath:appPath];
}

- (BOOL) inLoginItems {
    return ([self myLoginItem] != nil);
}

- (LSSharedFileListItemRef) myLoginItem {
    CFURLRef appUrl = [self myURL];
    CFURLRef itemUrl = nil;
    
    LSSharedFileListItemRef itemRef = nil;
    
    
    NSArray *loginItems = (__bridge NSArray *)LSSharedFileListCopySnapshot([self loginItems], nil);
	for (int currentIndex = 0; currentIndex < [loginItems count]; currentIndex++) {
		// Get the current LoginItem and resolve its URL.
		LSSharedFileListItemRef currentItemRef = (__bridge LSSharedFileListItemRef)[loginItems objectAtIndex:currentIndex];
        if (LSSharedFileListItemResolve(currentItemRef, 0, (CFURLRef *) &itemUrl, NULL) == noErr) {
			// Compare the URLs for the current LoginItem and the app.
			if ([(__bridge NSURL *)itemUrl isEqual:(__bridge NSURL *)appUrl]) {
				// Save the LoginItem reference.
				itemRef = currentItemRef;
			}
		}
        
    }
    return itemRef;
}

- (void)deleteLoginItem{
    LSSharedFileListItemRef itemRef = [self myLoginItem];
    if (itemRef){
        LSSharedFileListItemRemove([self loginItems],itemRef);
    }
}

- (void)addLoginItem{
    LSSharedFileListInsertItemURL([self loginItems],
                                  kLSSharedFileListItemLast,
                                  NULL,
                                  NULL,
                                  [self myURL],
                                  NULL,
                                  NULL);
}
@end
