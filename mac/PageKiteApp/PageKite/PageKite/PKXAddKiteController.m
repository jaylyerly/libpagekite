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
#import "PKXAppManager.h"
#import "PKXAlert.h"

#import "PKKKite+WebServer.h"
#import "NSView+AutoLayoutAddSubview.h"

#include <time.h>
#include <stdlib.h>

// FIXME -- this should be smarter and make sure the port is not in use.
int randomPort(int minPort, int maxPort){
    srand((unsigned int)time(NULL));
    int range = maxPort - minPort;
    int r = rand() % range;
    return r + minPort;
}


@interface PKXAddKiteController () <NSTextFieldDelegate>
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

    [self resetFields];
    
    self.tabView.tabViewType = NSNoTabsBezelBorder;
    self.localPortTextField.delegate = self;
    self.remotePortTextField.delegate = self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"domains"]){
        [self setupDomainPopup];
    }
}

- (void) showWindow:(id)sender {
    [super showWindow:sender];
    [self resetFields];
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

- (void) resetFields {
    [self setupDomainPopup];
    [self setupModePopup];
    [self setupOtherPopups];
    self.kiteName = @"";
}

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
    
    if (self.modeIndex == 0) {      // local server
        self.webRootDir = nil;
    } else {                        // modeIndex == 1, built in web server
        self.localPortNumber = [NSString stringWithFormat:@"%d", randomPort(45000, 46000)];
    }
    
    NSNumber *protocolId = @(-1);
    // FIXME -- reverse mapping the display name to service name should be easier
    for (NSNumber *tmpProtocolId in [PKKProtocols protocols]){
        NSString *displayName = [PKKProtocols protocolNames][tmpProtocolId];
        if ([displayName isEqualToString:self.protocolName]){
            protocolId = tmpProtocolId;
        }
    }
    
    NSString *serviceName = [PKKProtocols protocolServiceNames][protocolId] ?: @"http";
    
    PKXLog(@"Create Kite with name: %@", self.kiteName);
    PKXLog(@"\t protocol: %@", serviceName);
    PKXLog(@"\t remoteIp: %@", self.kiteHostName);
    PKXLog(@"\t remotePort: %@", self.remotePortNumber);
    PKXLog(@"\t localIp: %@", @"127.0.0.1");
    PKXLog(@"\t localPort: %@", self.localPortNumber);
    
    NSNumber *remotePort = @([self.remotePortNumber intValue]);
    NSNumber *localPort = @([self.localPortNumber intValue]);
    
    if ([self preflightKiteRemoteIp:self.kiteHostName remotePort:remotePort]){  // check for conflicts
        PKKKite *kite = [[PKKManager sharedManager]addKiteWithName:self.kiteName
                                                          protocol:serviceName
                                                          remoteIp:self.kiteHostName
                                                        remotePort:remotePort
                                                           localIp:@"127.0.0.1"
                                                         localPort:localPort
                                                                      ];
        kite.webDocumentDirectory = self.webRootDir;
        [self.window orderOut:self];
        [[PKXAppManager sharedManager] promptToRestart];
    }
}

- (BOOL) preflightKiteRemoteIp:(NSString *)remoteIp remotePort:(NSNumber *)port {
    for (PKKKite *kite in [[PKKManager sharedManager] kites]){
        if ([remoteIp isEqualToString:kite.remoteIp] && [port isEqualToNumber:kite.remotePort]){
            NSString *msg = @"This hostname and remote port combination is already in use.  Please choose another hostname/port or delete the other kite first.";
            [PKXAlert showAlertMesg:@"Address Conflict" info:msg];
            return NO;
        }
    }
    return YES;
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


#pragma mark - NSTextField Delegates
- (BOOL)control:(NSControl *)control textShouldBeginEditing:(NSText *)fieldEditor {
    if ([control isEqualTo:self.localPortTextField]){
        [self.localPortPopup selectItemWithTitle:@"Custom"];
    }
    if ([control isEqualTo:self.remotePortTextField]){
        [self.portPopup selectItemWithTitle:@"Custom"];
    }
    return YES;
}

@end
