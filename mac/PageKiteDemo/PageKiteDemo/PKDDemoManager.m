//
//  PKDDemoManager.m
//  PageKiteDemo
//
//  Created by Jay Lyerly on 5/29/14.
//  Copyright (c) 2014 SonicBunny Software. All rights reserved.
//

#import "PKDDemoManager.h"
#import <PageKiteKit/PageKiteKit.h>
#import "PKKKite+WebServer.h"
#import "PKKManager+WebServer.h"

@interface PKDDemoManager () <PKKManagerLogWatcher>

@property (nonatomic, strong) NSMutableString    *logString;
@property (nonatomic, assign) BOOL               loggedIn;
@property (nonatomic, strong) NSImage            *statusImage;
@property (nonatomic, strong) NSArray            *kiteStatusList;
@property (nonatomic, strong) NSMutableArray     *kiteList;
@property (nonatomic, strong) NSArray            *domainList;
@property (nonatomic, strong) NSArray            *services;
@property (nonatomic, strong) NSString           *addKiteName;
@property (nonatomic, strong) NSString           *addDomainName;
@property (nonatomic, strong) NSString           *serviceName;
@property (nonatomic, strong) NSString           *addKiteDomain;
@property (nonatomic, assign) BOOL               kitesAreFlying;
@property (nonatomic, strong) NSString           *localHost;

@end

@implementation PKDDemoManager

- (instancetype) init {
    self = [super init];
    if (self){
        _logString = [@"Demo Manager Initialized...\n" mutableCopy];
        _loggedIn = NO;
        _statusImage = [NSImage imageNamed:@"NSStatusUnavailable"];
        _services = [[PKKProtocols protocolNames] allValues];
        _serviceName = [PKKProtocols protocolNames][@(PKKProtocolHttp)];
        _addKiteName = @"MyNewKite";
        _kiteList = [@[] mutableCopy];
        _localHost = @"127.0.0.1";
        [[PKKManager sharedManager] addLogWacher:self];
        [[PKKManager sharedManager] addObserver:self
                                     forKeyPath:@"kitesAreFlying"
                                        options:0
                                        context:nil];
        

    }
    return self;
}

- (void) pageKiteManager:(PKKManager *)manager newLogMessage:(NSString *)message{
    [self log:message];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"kitesAreFlying"]){
        self.kitesAreFlying = [[PKKManager sharedManager] kitesAreFlying];
    }
}


- (IBAction)handleLogin:(id)sender {
    __weak PKDDemoManager* weakSelf = self;
    
    NSLog(@"Handle Login");
    NSString *username = [[NSUserDefaults standardUserDefaults] stringForKey:@"username"];
    NSString *password = [[NSUserDefaults standardUserDefaults] stringForKey:@"password"];
    NSLog(@"username: %@", username);
    NSLog(@"password: %@", password);
    [self log:[NSString stringWithFormat:@"Attempting login for %@/%@", username, password]];
    
    [[PKKManager sharedManager] loginWithUser:username password:password completionBlock:^(BOOL success){
        weakSelf.loggedIn = success;
        if (success) {
            [self log:@"Login success"];
        } else {
            [self log:@"Login fail"];
        }
    }];
}

- (IBAction)handleGetKites:(id)sender {
    PKKManager *manager = [PKKManager sharedManager];
    [manager retrieveKitesStatusWithCompletionBlock:^(BOOL success){
        if (success){
            for (PKKKiteStatus *kite in manager.kites){
                NSLog(@"Found kite: %@",kite);
                [self log:[NSString stringWithFormat:@"Found kite: %@", kite]];
            }
            self.kiteStatusList = manager.kites;
            
            PKKKiteStatus *kite = [self.kiteStatusList lastObject];
            self.addDomainName = [NSString stringWithFormat:@"foo.%@", kite.name];
        }else{
            NSLog(@"Failed to get kites!");
        }
    }];
}

- (IBAction)handleGetDomains:(id)sender {
    PKKManager *manager = [PKKManager sharedManager];
    [manager retrieveDomainsWithCompletionBlock:^(BOOL success){
        if (success){
            for (PKKDomain *domain in manager.domains){
                NSLog(@"Found domain: %@",domain);
                [self log:[NSString stringWithFormat:@"Found domain: %@", domain]];
            }
            self.domainList = manager.domains;
            PKKDomain *domain = [self.domainList lastObject];
            self.addKiteDomain = domain.name; // prime the list selection
        }else{
            NSLog(@"Failed to get domains!");
        }
    }];
}

- (void)setLoggedIn:(BOOL)loggedIn{
    _loggedIn = loggedIn;
    if (loggedIn){
        self.statusImage = [NSImage imageNamed:@"NSStatusAvailable"];
    }else{
        self.statusImage = [NSImage imageNamed:@"NSStatusUnavailable"];
    }
        
}

- (void) log:(NSString *)aString {
    NSString *newString = aString;
    
    NSString *lastChar = [aString substringFromIndex:([aString length]-1)];
    if (! [lastChar isEqualToString:@"\n"]){
        newString = [NSString stringWithFormat:@"%@\n", aString];
    }

    [self willChangeValueForKey:@"logText"];
    [self.logString appendString:newString];
    [self didChangeValueForKey:@"logText"];
}

- (IBAction)handleClearLog:(id)sender{
    [self willChangeValueForKey:@"logText"];
    self.logString = [@"" mutableCopy];
    [self didChangeValueForKey:@"logText"];
};

- (NSAttributedString *)logText {
    return [[NSAttributedString alloc] initWithString:self.logString];
}

- (IBAction)handleAddKiteName:(id)sender{
    __weak PKKManager *manager = [PKKManager sharedManager];
    [manager addDomainName:self.addDomainName completionBlock:^(BOOL success){
        if (success){
            [self handleGetDomains:self];
        }else{
            [self log:[NSString stringWithFormat:@"failed to make new kite: %@", manager.lastError]];
        }
    }];
}

- (IBAction)handleRemoveKiteName:(id)sender{
    __weak PKKManager *manager = [PKKManager sharedManager];
    PKKDomain *domain = [[self.domainListController selectedObjects] firstObject];
    NSLog(@"Removing domain: %@", domain);
    [manager removeDomainName:domain.name completionBlock:^(BOOL success){
        if (success){
            [self handleGetDomains:self];
        }else{
            [self log:[NSString stringWithFormat:@"failed to delete kite: %@", manager.lastError]];
        }
    }];
}

- (IBAction)handleAddKite:(id)sender{
    
//    PKKDomain *remoteDomain = objc_dynamic_cast(PKKDomain, [[self.domainListController selectedObjects] firstObject]);
    
    // FIXME -- this is a little gross
    NSNumber *protocolId = [[[PKKProtocols protocolNames] allKeysForObject:self.serviceName] lastObject];
    NSString *protocol = [PKKProtocols protocolServiceNames][protocolId];
    
    NSLog(@"Add kite -> name: %@, protocol: %@, remote IP: %@, remote port: %@, local IP: %@, local port: %@",
          self.addKiteName,
          protocol,
          self.addKiteDomain,
          self.remotePort,
          self.localHost,
          self.localPort
          );
    
    PKKKite *kite = [[PKKManager sharedManager]addKiteWithName:self.addKiteName
                                                      protocol:protocol
                                                      remoteIp:self.addKiteDomain
                                                    remotePort:self.remotePort
                                                       localIp:self.localHost
                                                     localPort:self.localPort];
    if ([self.localPort integerValue]==8080){
        kite.webDocumentDirectory = @"/Users/jayl/Sites/images";
    }
    [self willChangeValueForKey:@"kiteList"];
    [self.kiteList addObject:kite];
    [self didChangeValueForKey:@"kiteList"];
    NSLog(@"Created kite: %@", kite);
}

- (IBAction)handleRemoveKite:(id)sender{
    [self.kiteListController removeObjectsAtArrangedObjectIndexes:[self.kiteListController selectionIndexes]];
}


- (IBAction)handleFlyKites:(id)sender {
    [[PKKManager sharedManager] flyKitesWithWebServers];
}

- (IBAction)handleLandKites:(id)sender{
    [[PKKManager sharedManager] landKitesWithWebServers];
}

@end
