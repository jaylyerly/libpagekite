//
//  PKXLogWindowController.h
//  PageKite
//
//  Created by Jay Lyerly on 7/10/14.
//  Copyright (c) 2014 SonicBunny Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface PKXLogWindowController : NSWindowController

@property (nonatomic, copy, readonly) NSAttributedString *attributedLog;

- (IBAction)copyToClipboard:(id)sender;
- (IBAction)clearLog:(id)sender;

@end
