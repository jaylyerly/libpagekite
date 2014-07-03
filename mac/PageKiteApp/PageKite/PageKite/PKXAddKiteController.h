//
//  PKXAddKiteController.h
//  PageKite
//
//  Created by Jay Lyerly on 6/27/14.
//  Copyright (c) 2014 SonicBunny Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface PKXAddKiteController : NSWindowController

@property (nonatomic, assign) NSUInteger tabIndex;
@property (nonatomic, copy, readonly) NSString *webRootDir;

- (IBAction)chooseWebRootDir:(id)sender;
- (IBAction)createKite:(id)sender;

@end
