//
//  PKXPrefsViewController.m
//  PageKite
//
//  Created by Jay Lyerly on 7/10/14.
//  Copyright (c) 2014 SonicBunny Software. All rights reserved.
//

#import "PKXPrefsViewController.h"

@interface PKXPrefsViewController ()

@end

@implementation PKXPrefsViewController

- (id)init
{
    return [super initWithNibName:[self className] bundle:nil];
}

- (NSString *)identifier{
    return [self className];
}

- (NSImage *)toolbarItemImage {
    return nil;
}

- (NSString *)toolbarItemLabel {
    return @"No Label";
}

@end
