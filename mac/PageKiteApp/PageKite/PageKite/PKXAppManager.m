//
//  PKXAppManager.m
//  PageKite
//
//  Created by Jay Lyerly on 6/26/14.
//  Copyright (c) 2014 SonicBunny Software. All rights reserved.
//

#import "PKXAppManager.h"
#import "FXKeychain.h"

NSString *kPKXKeychainPassword = @"pkxKeychainPassword";
NSString *kPKXUserDefaultsEmail = @"pkxUserDefaultsEmail";

@interface PKXAppManager ()

@property (nonatomic, strong)          NSStatusItem *statusItem;

@end

@implementation PKXAppManager

- (void) awakeFromNib {
    self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    [self.statusItem setMenu:self.statusMenu];
    [self.statusItem setTitle:@"Status"];
    [self.statusItem setHighlightMode:YES];
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

@end
