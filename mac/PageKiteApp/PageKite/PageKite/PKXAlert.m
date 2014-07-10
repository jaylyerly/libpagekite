//
//  PKXAlert.m
//  PageKite
//
//  Created by Jay Lyerly on 7/10/14.
//  Copyright (c) 2014 SonicBunny Software. All rights reserved.
//

#import "PKXAlert.h"

@implementation PKXAlert

+ (void)showAlertMesg:(NSString *)msg info:(NSString *)info {
    PKXAlert *alert = [[PKXAlert alloc] initWithMessage:msg info:info];
    [alert runModal];
}

- (instancetype)initWithMessage:(NSString *)msg info:(NSString *)info {
    self = [super init];
    if (self) {
        self.messageText = msg;
        self.informativeText = info;
    }
    return self;
}

@end
