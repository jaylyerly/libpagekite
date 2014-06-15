//
//  PKKProtocols.h
//  PageKiteKit
//
//  Created by Jay Lyerly on 6/6/14.
//  Copyright (c) 2014 SonicBunny Software. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, PKKProtocol) {
    PKKProtocolHttp,
    PKKProtocolHttps,
    PKKProtocolSsh,
    PKKProtocolVnc,
    PKKProtocolFinger,
    PKKProtocolRaw,
};


@interface PKKProtocols : NSObject

+ (NSArray *)protocols;
+ (NSDictionary *)protocolNames;
+ (NSDictionary *)protocolServiceNames;
+ (NSDictionary *)protocolLocalPorts;
+ (NSDictionary *)protocolRemotePorts;

@property (nonatomic, readonly) NSArray *protocols;
@property (nonatomic, readonly) NSDictionary *protocolNames;
@property (nonatomic, readonly) NSDictionary *protocolRemotePorts;
@property (nonatomic, readonly) NSDictionary *protocolServiceName;
@property (nonatomic, readonly) NSDictionary *protocolLocalPort;

@end
