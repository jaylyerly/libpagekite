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
#import "PKXLogWindowController.h"
#import "PKXAlert.h"
#import "PKXCredentials.h"

#import "PKXPrefsDomainsViewController.h"
#import "PKXPrefsLoginViewController.h"
#import "PKXPrefsGeneralViewController.h"
#import "MASPreferencesWindowController.h"

#import "NSString+Additions.h"
#import "NSImage+ColorMap.h"

@interface PKXAppManager ()

@property (nonatomic, strong)   NSStatusItem                    *statusItem;
@property (nonatomic, strong)   MASPreferencesWindowController  *prefsWindowController;
@property (nonatomic, strong)   PKXLogWindowController          *logController;
@property (nonatomic, strong)   PKXAddKiteController            *kiteController;
@end

@implementation PKXAppManager

- (void) awakeFromNib {
    [self buildStatusItem];
    [self buildPreferencesController];
    [self checkStartupCreds];
}

- (void)buildStatusItem {
    self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    [self.statusItem setMenu:self.statusMenu];
    NSImage *statusIcon = [[NSImage imageNamed:@"StatusIcon"] blacken];  // 18 px for non-retina, 34 for retina
    [self.statusItem setImage:statusIcon];
    [self.statusItem setHighlightMode:YES];
}

- (void)buildPreferencesController {
    NSArray *prefsControllers = @[
                                  [PKXPrefsLoginViewController new],
                                  [PKXPrefsDomainsViewController new],
                                  [PKXPrefsGeneralViewController new],
                                  ];
    self.prefsWindowController =[[MASPreferencesWindowController alloc] initWithViewControllers:prefsControllers
                                                                                          title:@"Preferences"];
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
        // have username and password, so try to log in
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

- (IBAction)addKite:(id)sender {
    [self activate];
    [self.kiteController showWindow:self];
}

- (IBAction)showLog:(id)sender {
    [self activate];
    [self.logController showWindow:nil];
}

- (PKXLogWindowController *)logController{
    if (! _logController){
        _logController = [[PKXLogWindowController alloc] initWithWindowNibName:@"PKXLogWindowController"];
    }
    return _logController;
}

- (PKXAddKiteController *)kiteController{
    if (! _kiteController){
        _kiteController = [[PKXAddKiteController alloc] initWithWindowNibName:@"PKXAddKiteController"];
    }
    return _kiteController;
}

@end
