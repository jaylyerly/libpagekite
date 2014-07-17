//
//  PKXPrefsLoginViewController.m
//  PageKite
//
//  Created by Jay Lyerly on 7/10/14.
//  Copyright (c) 2014 SonicBunny Software. All rights reserved.
//

#import "PKXPrefsLoginViewController.h"
#import "PKXAlert.h"
#import "PKXCredentials.h"
#import <PageKiteKit/PageKiteKit.h>

@interface PKXPrefsLoginViewController ()

@property (nonatomic, strong) NSImage  *statusImage;
@property (nonatomic, copy)   NSString *statusText;

@end

@implementation PKXPrefsLoginViewController

- (void) awakeFromNib{
    [self updateStatus];
    [[PKKManager sharedManager] addObserver:self
                                 forKeyPath:@"isConnected"
                                    options:0
                                    context:nil];
        
}

- (void) dealloc {
    [[PKKManager sharedManager] removeObserver:self
                                    forKeyPath:@"isConnected"];
}
    
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"isConnected"]){
        [self updateStatus];
    }
}

- (NSString *)identifier{
    return @"PrefsLogin";
}

- (NSImage *)toolbarItemImage {
    return [NSImage imageNamed:NSImageNameUserAccounts];
}

- (NSString *)toolbarItemLabel {
    return @"Account";
}

- (IBAction)verifyCreds:(id)sender {
    [[PKKManager sharedManager] loginWithUser:[PKXCredentials sharedManager].email
                                     password:[PKXCredentials sharedManager].password
                              completionBlock:^(BOOL success){
                                  if (success) {
                                      NSLog(@"Log in successful!");
                                  }else {
                                      [PKXAlert showAlertMesg:@"Login failed." info:@"Unable to log in to the PageKite service."];
                                  }
                              }];
    
}

- (void) updateStatus {
    if ([PKKManager sharedManager].isConnected){
        self.statusImage = [NSImage imageNamed:NSImageNameStatusAvailable];
        self.statusText = @"Agent connected.";
    }else{
        self.statusImage = [NSImage imageNamed:NSImageNameStatusUnavailable];
        self.statusText = @"Agent not connected.";
    }
}

@end
