//
//  PKDDemoManager.h
//  PageKiteDemo
//
//  Created by Jay Lyerly on 5/29/14.
//  Copyright (c) 2014 SonicBunny Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PKDDemoManager : NSObject
@property (nonatomic, readonly) NSImage *statusImage;
@property (nonatomic, readonly) NSAttributedString *logText;
@property (nonatomic, readonly) BOOL            loggedIn;
@property (nonatomic, readonly) NSArray         *kiteList;
@property (nonatomic, readonly) NSArray         *domainList;

- (IBAction)handleLogin:(id)sender;
- (IBAction)handleGetKites:(id)sender;
- (IBAction)handleGetDomains:(id)sender;

@end
