//
//  PKXAppManager.m
//  PageKite
//
//  Created by Jay Lyerly on 6/26/14.
//  Copyright (c) 2014 SonicBunny Software. All rights reserved.
//

#import "PKXAppManager.h"
#import "FXKeychain.h"
#import <PageKiteKit/PageKiteKit.h>
#import "PKXAddKiteController.h"

#import "NSString+Additions.h"

NSString *kPKXKeychainPassword = @"PageKitePassword";
NSString *kPKXUserDefaultsEmail = @"PageKiteEmail";

@interface PKXAppManager ()

@property (nonatomic, strong)          NSStatusItem *statusItem;
@property (nonatomic, copy)            NSString     *email;
@property (nonatomic, copy)            NSString     *password;
@property (nonatomic, strong)          NSArray      *domains;
@property (nonatomic, copy)            NSString     *addDomainName;
@end

@implementation PKXAppManager

- (void) awakeFromNib {
    self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    [self.statusItem setMenu:self.statusMenu];
    [self.statusItem setTitle:@"Status"];
    [self.statusItem setHighlightMode:YES];
    
    [self checkStartupCreds];
}

- (void)checkStartupCreds {
    BOOL showDlg = NO;
    
    if (! [self.email isNotEmpty]) {
        showDlg = YES;
    }
    if (! [self.password isNotEmpty]) {
        showDlg = YES;
    }
    
    if (showDlg){
        [self preferences:self];
        [self showAlertMesg:@"Time to log in to PageKite!"
                       info:@"Please enter your email and password to connect to your PageKite account."];
    } else {
        [self updateDomains];
    }
}

- (void)showAlertMesg:(NSString *)msg info:(NSString *)info {
    NSAlert *alert = [[NSAlert alloc] init];
    alert.messageText = msg;
    alert.informativeText = info;
    [alert runModal];
}

#pragma mark - Accessor Methods for Keychain / NSUserDefaults

- (NSString *)password {
  return [FXKeychain defaultKeychain][kPKXKeychainPassword];
}

- (void) setPassword:(NSString *)password {
    [FXKeychain defaultKeychain][kPKXKeychainPassword] = password;
}

- (NSString *)email {
    return [[NSUserDefaults standardUserDefaults] stringForKey:kPKXUserDefaultsEmail];
}

- (void)setEmail:(NSString *)email {
    [[NSUserDefaults standardUserDefaults] setObject:email forKey:kPKXUserDefaultsEmail];
    [[NSUserDefaults standardUserDefaults] synchronize];    
}

#pragma mark - Actions

- (IBAction)quit:(id)sender {
    [[NSApplication sharedApplication] terminate:sender];
}

- (IBAction)about:(id)sender{
    [self activate];
    [[NSApplication sharedApplication] orderFrontStandardAboutPanel:sender];
}

- (IBAction)preferences:(id)sender{
    [self activate];
    [self.prefsWindow makeKeyAndOrderFront:sender];
}

- (void) activate {
    [[NSApplication sharedApplication] activateIgnoringOtherApps:YES];
}

#pragma mark - Domain operations

- (IBAction)addDomain:(id)sender {
    NSLog(@"Add domain");
    NSPoint mouseLoc = [NSEvent mouseLocation];
    [self.addDomainWindow setFrameOrigin:mouseLoc];
    [self.addDomainWindow makeKeyAndOrderFront:self];
}

- (IBAction)removeDomain:(id)sender {
    __weak PKKDomain *domain = [[self.domainController selectedObjects] firstObject];
    NSLog(@"Remove domain: %@", domain);
    [[PKKManager sharedManager] removeDomainName:domain.name completionBlock:^(BOOL success){
        if (success){
            [self updateDomains];
        } else {
            NSString *msg = [NSString stringWithFormat:@"Failed to remove domain: %@.", domain.name];
            NSString *info = [NSString stringWithFormat:@"Server reported an error: %@", [PKKManager sharedManager].lastError ?: @"Unknown"];
            [self showAlertMesg:msg info:info];
        }
    }];
}

- (IBAction)addDomainName:(id)sender{
    __weak PKXAppManager *weakSelf = self;
    [[PKKManager sharedManager] addDomainName:self.addDomainName completionBlock:^(BOOL success){
        if (success){
            [self updateDomains];
            [self.addDomainWindow orderOut:self];
        } else {
            NSString *msg = [NSString stringWithFormat:@"Failed to add new domain name: %@.", weakSelf.addDomainName];
            NSString *info = [NSString stringWithFormat:@"Server reported an error: %@", [PKKManager sharedManager].lastError ?: @"Unknown"];
            [self showAlertMesg:msg info:info];
        }
    }];
}

#pragma mark - Kite Operations

- (IBAction)addKite:(id)sender {
    NSLog(@"Add kite");
    [self activate];
    PKXAddKiteController *kiteCon = [[PKXAddKiteController alloc] initWithWindowNibName:@"AddKite"];
    [kiteCon showWindow:self];
}

#pragma mark - PageKite Manager interactions

- (IBAction)verifyCreds:(id)sender {
    [[PKKManager sharedManager] loginWithUser:self.email
                                     password:self.password
                              completionBlock:^(BOOL success){
                                  if (success) {
                                      NSLog(@"Log in successful!");
                                      [self updateDomains];
                                  }else {
                                      NSLog(@"Log in FAILED!");
                                  }
                              }];
}

- (void) updateDomains {
    [[PKKManager sharedManager] loginWithUser:self.email
                                     password:self.password
                              completionBlock:^(BOOL success){
                                  if (success) {
                                      NSLog(@"Log in successful!");
                                      [[PKKManager sharedManager] retrieveDomainsWithCompletionBlock:^(BOOL success){
                                          if (success){
                                              self.domains = [PKKManager sharedManager].domains;
                                          }
                                      }];
                                  }else {
                                      NSLog(@"Log in FAILED!");
                                  }
                              }];

}

@end
