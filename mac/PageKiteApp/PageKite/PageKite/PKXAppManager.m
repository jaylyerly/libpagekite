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

#import "NSString+Additions.h"

NSString *kPKXKeychainPassword = @"PageKitePassword";
NSString *kPKXUserDefaultsEmail = @"PageKiteEmail";

@interface PKXAppManager ()

@property (nonatomic, strong)          NSStatusItem *statusItem;
@property (nonatomic, strong)          NSString     *email;
@property (nonatomic, strong)          NSString     *password;
@property (nonatomic, strong)          NSArray      *domains;
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

- (IBAction)addDomain:(id)sender {
    NSLog(@"Add domain");
}

- (IBAction)removeDomain:(id)sender {
    PKKDomain *domain = [[self.domainController selectedObjects] firstObject];
    NSLog(@"Remove domain: %@", domain);
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
