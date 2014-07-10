//
//  PKXPrefsDomainsViewController.m
//  PageKite
//
//  Created by Jay Lyerly on 7/10/14.
//  Copyright (c) 2014 SonicBunny Software. All rights reserved.
//

#import "PKXPrefsDomainsViewController.h"
#import <PageKiteKit/PageKiteKit.h>
#import "PKXAlert.h"

@interface PKXPrefsDomainsViewController ()
@property (nonatomic, copy)            NSString     *addDomainName;
@end

@implementation PKXPrefsDomainsViewController

- (NSString *)identifier{
    return @"PrefsDomains";
}

- (NSImage *)toolbarItemImage {
    return [NSImage imageNamed:NSImageNameNetwork];
}

- (NSString *)toolbarItemLabel {
    return @"Domains";
}

- (void) awakeFromNib {
    self.domains = [PKKManager sharedManager].domains;
    [self updateDomains];
    [[PKKManager sharedManager] addObserver:self
                                 forKeyPath:@"domains"
                                    options:0
                                    context:nil];

}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"domains"]){
        self.domains = [PKKManager sharedManager].domains;
    }
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
    __weak PKXPrefsDomainsViewController *weakSelf = self;
    NSLog(@"Remove domain: %@", domain);
    [[PKKManager sharedManager] removeDomainName:domain.name completionBlock:^(BOOL success){
        if (success){
            [weakSelf updateDomains];
        } else {
            NSString *msg = [NSString stringWithFormat:@"Failed to remove domain: %@.", domain.name];
            NSString *info = [NSString stringWithFormat:@"Server reported an error: %@", [PKKManager sharedManager].lastError ?: @"Unknown"];
            [PKXAlert showAlertMesg:msg info:info];
        }
    }];
}

- (IBAction)addDomainName:(id)sender{
    __weak PKXPrefsDomainsViewController *weakSelf = self;
    [[PKKManager sharedManager] addDomainName:self.addDomainName completionBlock:^(BOOL success){
        if (success){
            [weakSelf updateDomains];
            [weakSelf.addDomainWindow orderOut:self];
        } else {
            NSString *msg = [NSString stringWithFormat:@"Failed to add new domain name: %@.", weakSelf.addDomainName];
            NSString *info = [NSString stringWithFormat:@"Server reported an error: %@", [PKKManager sharedManager].lastError ?: @"Unknown"];
            [PKXAlert showAlertMesg:msg info:info];
        }
    }];
}

- (void) updateDomains {
    [[PKKManager sharedManager] retrieveDomainsWithCompletionBlock:nil];
}


@end
