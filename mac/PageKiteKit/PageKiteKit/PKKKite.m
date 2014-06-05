//
//  PKKKite.m
//  PageKiteKit
//
//  Created by Jay Lyerly on 6/5/14.
//  Copyright (c) 2014 SonicBunny Software. All rights reserved.
//

#import "PKKKite.h"

@interface PKKKite ()
@property (nonatomic, copy)   NSString *name;
@property (nonatomic, copy)   NSString *secret;
@property (nonatomic, copy)   NSString *remoteIp;
@property (nonatomic, strong) NSNumber *remotePort;
@property (nonatomic, copy)   NSString *localIp;
@property (nonatomic, strong) NSNumber *localPort;

@end

@implementation PKKKite


- (instancetype) initWithName:(NSString *)name
                       secret:(NSString *)secret
                     remoteIp:(NSString *)remoteIp
                   remotePort:(NSNumber *)remotePort
                      localIp:(NSString *)localIp
                    localPort:(NSNumber *)localPort{
    self = [super init];
    if (self){
        _name = name;
        _secret = secret;
        _remoteIp = remoteIp;
        _remotePort = remotePort;
        _localIp = localIp;
        _localPort = localPort;
    }
    return self;
}



@end
