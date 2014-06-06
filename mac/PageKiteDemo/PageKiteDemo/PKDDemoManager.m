//
//  PKDDemoManager.m
//  PageKiteDemo
//
//  Created by Jay Lyerly on 5/29/14.
//  Copyright (c) 2014 SonicBunny Software. All rights reserved.
//

#import "PKDDemoManager.h"
#import <PageKiteKit/PageKiteKit.h>

@interface PKDDemoManager ()

@property (nonatomic, strong) NSMutableString    *logString;
@property (nonatomic, assign) BOOL               loggedIn;
@property (nonatomic, strong) NSImage            *statusImage;
@property (nonatomic, strong) NSArray            *kiteStatusList;
@property (nonatomic, strong) NSMutableArray     *kiteList;
@property (nonatomic, strong) NSArray            *domainList;
@property (nonatomic, strong) NSDictionary       *services;
@property (nonatomic, strong) NSString           *addKiteName;
@property (nonatomic, strong) NSString           *addDomainName;
@property (nonatomic, strong) NSString           *portName;
@property (nonatomic, strong) NSAttributedString *libraryLogText;

@end

@implementation PKDDemoManager

- (instancetype) init {
    self = [super init];
    if (self){
        _logString = [@"Demo Manager Initialized...\n" mutableCopy];
        _loggedIn = NO;
        _statusImage = [NSImage imageNamed:@"NSStatusUnavailable"];
        [self prepareServicesDictionary];
        _portName = [[self.services allKeys] lastObject];
        _addKiteName = @"MyNewKite";
        _kiteList = [@[] mutableCopy];
        [[PKKManager sharedManager] addObserver:self
                                     forKeyPath:@"log"
                                        options:0
                                        context:nil];

    }
    return self;
}

- (void)prepareServicesDictionary {
    
    NSMutableDictionary *tmpDict = [@{} mutableCopy];
    
    PKKManager *mgr = [PKKManager sharedManager];
    
    for (NSNumber *protocol in mgr.protocols){
        tmpDict[mgr.protocolNames[protocol]] = mgr.protocolPorts[protocol];
    }
    
    self.services = [NSDictionary dictionaryWithDictionary:tmpDict];
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    // The library log changed, so get a copy to expose it to the world.
    self.libraryLogText = [[NSAttributedString alloc] initWithString:[PKKManager sharedManager].log];
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
    [manager retrieveKitesWithCompletionBlock:^(BOOL success){
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
    [self willChangeValueForKey:@"logText"];
    [self.logString appendFormat:@"%@\n",aString];
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
    [manager addDomainName:self.addKiteName completionBlock:^(BOOL success){
        if (success){
            [self handleGetKites:self];
        }else{
            [self log:[NSString stringWithFormat:@"failed to make new kite: %@", manager.lastError]];
        }
    }];
}


- (IBAction)handleAddKite:(id)sender{
    
//    PKKDomain *remoteDomain = objc_dynamic_cast(PKKDomain, [[self.domainListController selectedObjects] firstObject]);
    NSLog(@"Add kite -> name: %@, protocol: %@, remote IP: %@, remote port: %@, local IP: %@, local port: %@",
          self.addKiteName,
          self.portName,
          self.addKiteDomain,
          self.remotePort,
          @"127.0.0.1",
          self.localPort
          );
    
    PKKKite *kite = [[PKKManager sharedManager]addKiteWithName:self.addKiteName
                                                      protocol:self.portName
                                                      remoteIp:self.addKiteDomain
                                                    remotePort:self.remotePort
                                                       localIp:@"127.0.0.1"
                                                     localPort:self.localPort];
    [self willChangeValueForKey:@"kiteList"];
    [self.kiteList addObject:kite];
    [self didChangeValueForKey:@"kiteList"];
    NSLog(@"Created kite: %@", kite);
}

- (IBAction)handleFlyKite:(id)sender {
    PKKKite *kite = objc_dynamic_cast(PKKKite, [[self.kiteListController selectedObjects] lastObject]);
    NSLog(@"Toggle kite flying status on kite: %@", kite);
    
    if (kite.isFlying){
        [kite land];
    } else {
        [kite fly];
    }
}
@end
