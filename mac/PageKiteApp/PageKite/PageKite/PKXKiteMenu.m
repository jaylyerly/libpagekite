//
//  PKXKiteMenu.m
//  PageKite
//
//  Created by Jay Lyerly on 7/17/14.
//  Copyright (c) 2014 SonicBunny Software. All rights reserved.
//

#import "PKXKiteMenu.h"
#import <PageKiteKit/PageKiteKit.h>
#import "PKKKite+WebServer.h"

@interface PKXKiteMenu ()

@property (nonatomic, strong) PKKKite *kite;

@end

@implementation PKXKiteMenu

- (instancetype) initWithKite:(PKKKite *)kite {
    self = [super init];
    if (self){
        _kite = kite;
        
        [self addDetailItemNamed:kite.name];
        
        NSString *remote = [NSString stringWithFormat:@"Public URL: %@://%@:%@", self.kite.protocol, kite.remoteIp, kite.remotePort];
        [self addDetailItemNamed:remote selector:@selector(openRemoteUrl:)];

        if (kite.webDocumentDirectory) {
            NSString *rootDir = [NSString stringWithFormat:@"Built-In Web Server: %@", kite.webDocumentDirectory];
            [self addDetailItemNamed:rootDir selector:@selector(openWebRoot:)];
        } else {
            NSString *local = [NSString stringWithFormat:@"Connects to local port: %@", kite.localPort];
            [self addDetailItemNamed:local];
        }
        
        [self addItem:[NSMenuItem separatorItem]];
        [self addDetailItemNamed:@"Remove" selector:@selector(removeKite:)];
    }
    return self;
}
- (void)addDetailItemNamed:(NSString *)name{
    [self addDetailItemNamed:name selector:nil];
}

- (void)addDetailItemNamed:(NSString *)name selector:(SEL)aSelector{
    NSMenuItem *detailItem = [[NSMenuItem alloc] init];
    detailItem.title = name;
    detailItem.target = self;
    detailItem.action = aSelector ?: @selector(noOp:);
    [self addItem:detailItem];
}

- (IBAction)noOp:(id)sender {
    
}

- (IBAction)openRemoteUrl:(id)sender {
    NSString *urlString = [NSString stringWithFormat:@"%@://%@:%@", self.kite.protocol, self.kite.remoteIp, self.kite.remotePort];
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:urlString]];
}

- (IBAction)openWebRoot:(id)sender {
    if (self.kite.webDocumentDirectory){
        NSString *urlString = [NSString stringWithFormat:@"file://%@", self.kite.webDocumentDirectory];
        [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:urlString]];
    }
}

- (IBAction)removeKite:(id)sender {
    [[PKKManager sharedManager] removeKite:self.kite];
}

@end
