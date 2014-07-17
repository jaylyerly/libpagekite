//
//  PKXKiteMenu.m
//  PageKite
//
//  Created by Jay Lyerly on 7/17/14.
//  Copyright (c) 2014 SonicBunny Software. All rights reserved.
//

#import "PKXKiteMenu.h"
#import <PageKiteKit/PageKiteKit.h>

@interface PKXKiteMenu ()

@property (nonatomic, strong) PKKKite *kite;

@end

@implementation PKXKiteMenu

- (instancetype) initWithKite:(PKKKite *)kite {
    self = [super init];
    if (self){
        _kite = kite;
        NSMenuItem *detailItem = [[NSMenuItem alloc] init];
        detailItem.title = @"Details";
        detailItem.target = self;
        detailItem.action = @selector(showDetails:);
        [self addItem:detailItem];
        NSMenuItem *deleteItem = [[NSMenuItem alloc] init];
        deleteItem.title = @"Remove";
        deleteItem.target = self;
        deleteItem.action = @selector(removeKite:);
        [self addItem:deleteItem];
    
    }
    return self;
}

- (IBAction)showDetails:(id)sender {
    
}

- (IBAction)removeKite:(id)sender {
    
}

@end
