//
//  PKKDomain.m
//  PageKiteKit
//
//  Created by Jay Lyerly on 5/30/14.
//  Copyright (c) 2014 SonicBunny Software. All rights reserved.
//

#import "PKKDomain.h"

@interface PKKDomain ()
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign)     BOOL serviceBasic;
@property (nonatomic, assign)     BOOL serviceSSL;
@end

@implementation PKKDomain

- (instancetype)initWithName:(NSString *)name services:(NSArray *)services {
    self = [super init];
    if (self){
        _name = name;
        _serviceBasic = [services containsObject:@"pk"];
        _serviceSSL = [services containsObject:@"ssl"];
    }
    return self;
}

- (NSString *)description {
    NSString *basic = self.serviceBasic ? @"basic service:YES" : @"basic service:NO";
    NSString *ssl = self.serviceSSL ? @"SSL service:YES" : @"SSL service:NO";
    return [NSString stringWithFormat:@"<PKKDomain %p> %@: %@ %@", self, self.name, basic, ssl];
}

@end
