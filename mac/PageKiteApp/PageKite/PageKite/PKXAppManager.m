//
//  PKXAppManager.m
//  PageKite
//
//  Created by Jay Lyerly on 6/26/14.
//  Copyright (c) 2014 SonicBunny Software. All rights reserved.
//

#import "PKXAppManager.h"
#import <PageKiteKit/PageKiteKit.h>
#import "PKXAddKiteController.h"
#import "PKXAlert.h"
#import "PKXCredentials.h"

#import "PKXPrefsDomainsViewController.h"
#import "PKXPrefsLoginViewController.h"
#import "PKXPrefsGeneralViewController.h"
#import "MASPreferencesWindowController.h"

#import "NSString+Additions.h"
#import "NSImage+ColorMap.h"

@interface PKXAppManager ()

@property (nonatomic, strong)          NSStatusItem *statusItem;
@property (nonatomic, strong)          NSArray      *domains;
@property (nonatomic, copy)            NSString     *addDomainName;

@property (nonatomic, strong)          MASPreferencesWindowController            *prefsWindowController;

@end

@implementation PKXAppManager

- (void) awakeFromNib {
    self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    [self.statusItem setMenu:self.statusMenu];
    NSImage *statusIcon = [[NSImage imageNamed:@"StatusIcon"] blacken];  // 18 px for non-retina, 34 for retina
    [self.statusItem setImage:statusIcon];
    [self.statusItem setHighlightMode:YES];
 
    NSArray *prefsControllers = @[
                                  [PKXPrefsLoginViewController new],
                                  [PKXPrefsDomainsViewController new],
                                  [PKXPrefsGeneralViewController new],
                                  ];
    self.prefsWindowController =[[MASPreferencesWindowController alloc] initWithViewControllers:prefsControllers
                                                                                          title:@"Preferences"];
    [self checkStartupCreds];
}

- (void)checkStartupCreds {
    BOOL showDlg = NO;
    
    if (! [[PKXCredentials sharedManager].email isNotEmpty]) {
        showDlg = YES;
    }
    if (! [[PKXCredentials sharedManager].password isNotEmpty]) {
        showDlg = YES;
    }
    
    if (showDlg){
        [self promptUserToLogin];
    }else{
        // have username and password, so try to login
        __weak PKXAppManager *weakSelf = self;
        [[PKKManager sharedManager] loginWithUser:[PKXCredentials sharedManager].email
                                         password:[PKXCredentials sharedManager].password
                                  completionBlock:^(BOOL success){
                                      if (! success) {  // login failed!
                                          [weakSelf promptUserToLogin];
                                      }
                                  }];
    }
}

- (void) promptUserToLogin {
    [self preferences:self];
    [self.prefsWindowController selectControllerAtIndex:0]; // switch to login tab
    [PKXAlert showAlertMesg:@"Time to log in to PageKite!"
                       info:@"Please enter your email and password to connect to your PageKite account."];
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
    [self.prefsWindowController showWindow:self];
}

- (void) activate {
    [[NSApplication sharedApplication] activateIgnoringOtherApps:YES];
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
    [[PKKManager sharedManager] loginWithUser:[PKXCredentials sharedManager].email
                                     password:[PKXCredentials sharedManager].password
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
    [[PKKManager sharedManager] loginWithUser:[PKXCredentials sharedManager].email
                                     password:[PKXCredentials sharedManager].password
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
