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

@property (nonatomic, strong) NSMutableString *logString;
@property (nonatomic, assign) BOOL            loggedIn;
@property (nonatomic, strong) NSImage         *statusImage;
@property (nonatomic, strong) NSArray         *kiteList;
@property (nonatomic, strong) NSArray         *domainList;
@end

@implementation PKDDemoManager

- (instancetype) init {
    self = [super init];
    if (self){
        _logString = [@"Demo Manager Initialized...\n" mutableCopy];
        _loggedIn = NO;
        _statusImage = [NSImage imageNamed:@"NSStatusUnavailable"];
    }
    return self;
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
            for (PKKKite *kite in manager.kites){
                NSLog(@"Found kite: %@",kite);
                [self log:[NSString stringWithFormat:@"Found kite: %@", kite]];
            }
            self.kiteList = manager.kites;
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

- (NSAttributedString *)logText {
    return [[NSAttributedString alloc] initWithString:self.logString];
}
@end
