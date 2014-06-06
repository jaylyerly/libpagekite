//
//  PKDDemoManager.h
//  PageKiteDemo
//
//  Created by Jay Lyerly on 5/29/14.
//  Copyright (c) 2014 SonicBunny Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PKDDemoManager : NSObject
@property (nonatomic, readonly) NSImage            *statusImage;
@property (nonatomic, readonly) NSAttributedString *logText;
@property (nonatomic, readonly) NSAttributedString *libraryLogText;
@property (nonatomic, readonly) BOOL               loggedIn;
@property (nonatomic, readonly) NSArray            *kiteStatusList;
@property (nonatomic, readonly) NSMutableArray     *kiteList;
@property (nonatomic, readonly) NSArray            *domainList;
@property (nonatomic, readonly) NSDictionary       *services;
@property (nonatomic, readonly) NSString           *addDomainName;
@property (nonatomic, readonly) NSString           *portName;
@property (nonatomic, readonly) NSString           *addKiteName;
@property (nonatomic, readonly) NSNumber           *remotePort;
@property (nonatomic, readonly) NSNumber           *localPort;
@property (nonatomic, readonly) NSString           *addKiteDomain;

@property (nonatomic, strong) IBOutlet NSArrayController *domainListController;
@property (nonatomic, strong) IBOutlet NSArrayController *kiteListController;

- (IBAction)handleLogin:(id)sender;
- (IBAction)handleGetKites:(id)sender;
- (IBAction)handleGetDomains:(id)sender;
- (IBAction)handleClearLog:(id)sender;
- (IBAction)handleAddKiteName:(id)sender;
- (IBAction)handleAddKite:(id)sender;
- (IBAction)handleFlyKite:(id)sender;

@end
