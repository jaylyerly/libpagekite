//
//  PKKKite.m
//  PageKiteKit
//
//  Created by Jay Lyerly on 6/5/14.
//  Copyright (c) 2014 SonicBunny Software. All rights reserved.
//

#import "PKKKite.h"
#import "PKKLibPageKite.h"


@interface PKKKite ()
@property (nonatomic, copy)   NSString *name;
@property (nonatomic, copy)   NSString *protocol;
@property (nonatomic, copy)   NSString *remoteIp;
@property (nonatomic, strong) NSNumber *remotePort;
@property (nonatomic, copy)   NSString *localIp;
@property (nonatomic, strong) NSNumber *localPort;

@end

@implementation PKKKite


- (instancetype) initWithName:(NSString *)name
                     protocol:(NSString *)protocol
                     remoteIp:(NSString *)remoteIp
                   remotePort:(NSNumber *)remotePort
                      localIp:(NSString *)localIp
                    localPort:(NSNumber *)localPort{
    self = [super init];
    if (self){
        _name = name;
        _protocol = protocol;
        _remoteIp = remoteIp;
        _remotePort = remotePort;
        _localIp = localIp;
        _localPort = localPort;
    }
    return self;
}


- (NSString *)description{
    return [NSString stringWithFormat:@"<PKKKite %p> Name: %@, Protocol: %@, RemoteIP: %@, RemotePort: %@, LocalIP: %@, LocalPort: %@",
            self,
            self.name,
            self.protocol,
            self.remoteIp,
            self.remotePort,
            self.localIp,
            self.localPort
        ];

}

@end
