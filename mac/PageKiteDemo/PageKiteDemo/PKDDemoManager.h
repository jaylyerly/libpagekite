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
@property (nonatomic, readonly) BOOL               loggedIn;
@property (nonatomic, readonly) NSArray            *kiteStatusList;
@property (nonatomic, readonly) NSMutableArray     *kiteList;
@property (nonatomic, readonly) NSArray            *domainList;
@property (nonatomic, readonly) NSArray            *services;
@property (nonatomic, readonly) NSString           *addDomainName;
@property (nonatomic, readonly) NSString           *serviceName;
@property (nonatomic, readonly) NSString           *addKiteName;
@property (nonatomic, readonly) NSNumber           *remotePort;
@property (nonatomic, readonly) NSNumber           *localPort;
@property (nonatomic, readonly) NSString           *localHost;
@property (nonatomic, readonly) NSString           *addKiteDomain;

@property (nonatomic, readonly) BOOL               kitesAreFlying;

@property (nonatomic, strong) IBOutlet NSArrayController *domainListController;
@property (nonatomic, strong) IBOutlet NSArrayController *kiteListController;

- (IBAction)handleLogin:(id)sender;
- (IBAction)handleGetKites:(id)sender;
- (IBAction)handleGetDomains:(id)sender;
- (IBAction)handleClearLog:(id)sender;
- (IBAction)handleAddKiteName:(id)sender;
- (IBAction)handleRemoveKiteName:(id)sender;
- (IBAction)handleAddKite:(id)sender;
- (IBAction)handleRemoveKite:(id)sender;
- (IBAction)handleFlyKites:(id)sender;
- (IBAction)handleLandKites:(id)sender;

@end
