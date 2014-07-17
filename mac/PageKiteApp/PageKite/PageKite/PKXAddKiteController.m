//
//  PKXAddKiteController.m
//  PageKite
//
//  Created by Jay Lyerly on 6/27/14.
//  Copyright (c) 2014 SonicBunny Software. All rights reserved.
//

#import "PKXAddKiteController.h"
#import <PageKiteKit/PageKiteKit.h>
#import "PKXLogger.h"

#import "NSView+AutoLayoutAddSubview.h"

@interface PKXAddKiteController ()
@property (nonatomic, readonly) NSArray         *modeConfig;
@property (nonatomic, readonly) NSArray         *portConfig;
@end

@implementation PKXAddKiteController

//- (void)showWindow:(id)sender{
//    [self.window center];
//    [super showWindow:sender];
//}

- (instancetype)init {
    self = [super init];
    if (self){
    }
    return self;
}

- (void)dealloc{
    [[PKKManager sharedManager] removeObserver:self
                                    forKeyPath:@"domains"];
}

- (void) windowDidLoad{
    
    [[PKKManager sharedManager] addObserver:self
                                 forKeyPath:@"domains"
                                    options:0
                                    context:nil];
    [[PKKManager sharedManager] retrieveDomainsWithCompletionBlock:nil];
    [self setupDomainPopup];
    //[self.modeBoxView autoLayoutAddSubview:self.webserverConfigView];
    [self setupModePopup];
    [self setupOtherPopups];
    
    
    
    self.tabView.tabViewType = NSNoTabsBezelBorder;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"domains"]){
        [self setupDomainPopup];
    }
}

#pragma mark - Config info

- (NSArray *)modeConfig{
    return @[
             @{ @"title" : @"Connect to Local Server", @"view":self.portConfigView      },
             @{ @"title" : @"Built-In Web Server",     @"view":self.webserverConfigView },
             ];
}

- (NSArray *)portConfig {
    return @[
             @{ @"name" : @"HTTP",      @"port":@"80"  },
             @{ @"name" : @"HTTPS",     @"port":@"443" },
             @{ @"name" : @"SSH",       @"port":@"22"  },
             @{ @"name" : @"Custom",    @"port":@""    },
             ];
}

#pragma mark - Setup

- (void) setupModePopup {
    for (NSTabViewItem *item in self.tabView.tabViewItems){
        [self.tabView removeTabViewItem:item];
    }
    [self.modePopup removeAllItems];

    for (NSInteger i=0; i < [self.modeConfig count] ; i++) {
        NSString *title = self.modeConfig[i][@"title"];
        [self.modePopup addItemWithTitle:title];
        self.modePopup.lastItem.tag = i;
        
        NSView *view = self.modeConfig[i][@"view"];
        NSTabViewItem *item = [[NSTabViewItem alloc] init];
        item.view = view;
        item.label = title;
        [self.tabView addTabViewItem:item];
    }
    [self.tabView setNeedsDisplay:YES];
}

- (void) setupDomainPopup {
    NSMutableArray *domainNames = [@[] mutableCopy];
    for (PKKDomain *domain in [PKKManager sharedManager].domains){
        [domainNames addObject:domain.name];
    }
    self.kiteHostName = [domainNames firstObject];  // Bindings doesn't handle initial value
    
    [self setupPopup:self.domainPopup withTitles:domainNames];
}

- (void) setupOtherPopups {
    NSMutableArray *portNames = [@[] mutableCopy];
    for (NSDictionary *pDict in self.portConfig){
        [portNames addObject:pDict[@"name"]];
    }

    [self setupPopup:self.portPopup withTitles:portNames];
    [self setupPopup:self.localPortPopup withTitles:portNames];
    
    // prime the port number fields
    self.remotePortNumber = [self portNumberForName:[portNames firstObject]];
    self.localPortNumber  = [self portNumberForName:[portNames firstObject]];
    
    [self setupPopup:self.protocolPopup withTitles:[[PKKProtocols protocolNames] allValues]];
    self.protocolName = [[[PKKProtocols protocolNames] allValues] firstObject];  // Bindings doesn't handle initial value
}

- (void) setupPopup:(NSPopUpButton *)popup withTitles:(NSArray *)titles {
    [popup removeAllItems];
    
    for (NSInteger i=0; i < [titles count] ; i++) {
        NSString *title = titles[i];
        [popup addItemWithTitle:title];
        popup.lastItem.tag = i;
    }
}

#pragma mark - Actions

- (IBAction)chooseWebRootDir:(id)sender {
    __weak PKXAddKiteController *weakSelf = self;
    NSLog(@"Choose Web Dir");
    NSOpenPanel *open = [NSOpenPanel openPanel];
    [open setCanChooseDirectories:YES];
    [open setCanChooseFiles:NO];
    [open setAllowsMultipleSelection:NO];
    [open beginWithCompletionHandler:^(NSInteger result){
        if (result == NSFileHandlingPanelOKButton){
            weakSelf.webRootDir = open.directoryURL.path;
        }
    }];
}

- (IBAction)createKite:(id)sender {
    PKXLog(@"Create Kite with name: %@", self.kiteName);
    PKXLog(@"\t protocol: %@", self.protocolName);
    PKXLog(@"\t remoteIp: %@", self.kiteHostName);
    PKXLog(@"\t remotePort: %@", self.remotePortNumber);
    PKXLog(@"\t localIp: %@", @"127.0.0.1");
    PKXLog(@"\t localPort: %@", self.localPortNumber);
    PKKKite *kite = [[PKKManager sharedManager]addKiteWithName:self.kiteName
                                                      protocol:self.protocolName
                                                      remoteIp:self.kiteHostName
                                                    remotePort:@([self.remotePortNumber intValue])
                                                       localIp:@"127.0.0.1"
                                                     localPort:@([self.localPortNumber intValue])
                                                                  ];
    [self.window orderOut:self];
}

#pragma mark - Getters and Setters

- (void)setRemotePortName:(NSString *)remotePortName {
    _remotePortName = remotePortName;
    self.remotePortNumber = [self portNumberForName:remotePortName];
}

- (void)setLocalPortName:(NSString *)localPortName {
    _localPortName = localPortName;
    self.localPortNumber = [self portNumberForName:localPortName];
}

- (NSString *) portNumberForName:(NSString *)portName {
    for (NSDictionary *pDict in self.portConfig){
        if ([portName isEqualToString:pDict[@"name"]]){
            return pDict[@"port"];
        }
    }
    return @"";   // if no matching name found, return empty string
}

@end
