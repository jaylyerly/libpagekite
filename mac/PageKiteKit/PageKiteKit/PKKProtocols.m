//
//  PKKProtocols.m
//  PageKiteKit
//
//  Created by Jay Lyerly on 6/6/14.
//  Copyright (c) 2014 SonicBunny Software. All rights reserved.
//

#import "PKKProtocols.h"

@implementation PKKProtocols

+ (NSDictionary *)protocolMap {
    return @{
             @(PKKProtocolHttp)  : @{ @"display": @"HTTP",   @"remotePort": @0,    @"localPort": @80,   @"serviceName": @"http" },
             @(PKKProtocolHttps) : @{ @"display": @"HTTPS",  @"remotePort": @0,    @"localPort": @443,  @"serviceName": @"http" },
             @(PKKProtocolSsh)   : @{ @"display": @"SSH",    @"remotePort": @22,   @"localPort": @22,   @"serviceName": @"raw" },
             @(PKKProtocolVnc)   : @{ @"display": @"VNC",    @"remotePort": @5900, @"localPort": @5900, @"serviceName": @"raw" },
             @(PKKProtocolFinger): @{ @"display": @"Finger", @"remotePort": @79,   @"localPort": @79,   @"serviceName": @"finger" },
             @(PKKProtocolRaw)   : @{ @"display": @"Raw",    @"remotePort": @-1,   @"localPort": @-1,   @"serviceName": @"raw" },
             };
}

+ (NSArray *)protocols {
    return @[
             @(PKKProtocolHttp),
             @(PKKProtocolHttps),
             @(PKKProtocolSsh),
             @(PKKProtocolRaw),
             @(PKKProtocolFinger),
             @(PKKProtocolVnc),
             ];
}

+ (NSDictionary *)protocolMapForKey:(NSString *)key{
    NSDictionary *map = self.protocolMap;
    NSMutableDictionary *tmp = [@{} mutableCopy];
    for (NSNumber *pId in [self.protocolMap allKeys]){
        tmp[pId] = map[pId][key];
    }
    return [NSDictionary dictionaryWithDictionary:tmp];
    
}

+ (NSDictionary *)protocolNames {
    static NSDictionary *pNames = nil;
    if (! pNames){
        pNames = [self protocolMapForKey:@"display"];
    }
    return pNames;
}


+ (NSDictionary *)protocolRemotePorts {
    static NSDictionary *pPorts = nil;
    if (! pPorts){
        pPorts = [self protocolMapForKey:@"remotePort"];
    }
    return pPorts;
}

+ (NSDictionary *)protocolLocalPorts {
    static NSDictionary *lPorts = nil;
    if (! lPorts){
        lPorts = [self protocolMapForKey:@"localPort"];
    }
    return lPorts;
}

+ (NSDictionary *)protocolServiceNames {
    static NSDictionary *pServiceName = nil;
    if (! pServiceName){
        pServiceName = [self protocolMapForKey:@"serviceName"];
    }
    return pServiceName;
}

@end
