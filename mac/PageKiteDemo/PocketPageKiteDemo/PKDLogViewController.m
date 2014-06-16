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
                                   

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (UITabBarItem *)tabBarItem {
    static dispatch_once_t onceToken;
    static UITabBarItem *_tbi = nil;
    dispatch_once(&onceToken, ^{
        _tbi = [[UITabBarItem alloc] initWithTitle:@"Service Log" image:nil tag:2];
    });
    return _tbi;
}

@end
