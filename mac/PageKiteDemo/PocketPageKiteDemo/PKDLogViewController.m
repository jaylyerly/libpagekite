//
//  PKDLogViewController.m
//  PageKiteDemo
//
//  Created by Jay Lyerly on 6/15/14.
//  Copyright (c) 2014 SonicBunny Software. All rights reserved.
//

#import "PKDLogViewController.h"
#import <PageKiteKit/PageKiteKit.h>

@interface PKDLogViewController ()

@end

@implementation PKDLogViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadLog];
    [[PKKManager sharedManager] addObserver:self
                                 forKeyPath:@"log"
                                    options:0
                                    context:nil];
}

- (void) loadLog {
    self.logView.text = [PKKManager sharedManager].log;
}
                                   
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    [self loadLog];
}
                                   
- (UITabBarItem *)tabBarItem {
    static dispatch_once_t onceToken;
    static UITabBarItem *_tbi = nil;
    dispatch_once(&onceToken, ^{
        _tbi = [[UITabBarItem alloc] initWithTitle:@"Service Log" image:[UIImage imageNamed:@"second"] tag:2];
    });
    return _tbi;
}

@end
