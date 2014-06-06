//
//  PKKManager.h
//  PageKiteKit
//
//  Created by Jay Lyerly on 5/29/14.
//

#import <Foundation/Foundation.h>

typedef void (^PKKManagerCompletionBlock)(BOOL success);

@class PKKKite;

typedef NS_ENUM(NSUInteger, PKKProtocol) {
    PKKProtocolHttp,
    PKKProtocolHttps,
    PKKProtocolSsh,
    PKKProtocolRaw,
};

@interface PKKManager : NSObject

@property (nonatomic, readonly) NSArray *kites;
@property (nonatomic, readonly) NSArray *domains;
@property (nonatomic, readonly) NSString *lastError;

@property (nonatomic, readonly) NSString *log;

@property (nonatomic, readonly) NSArray *protocols;
@property (nonatomic, readonly) NSDictionary *protocolNames;
@property (nonatomic, readonly) NSDictionary *protocolPorts;

+ (instancetype) sharedManager;

- (void)loginWithUser:(NSString *)user password:(NSString *)password completionBlock:(PKKManagerCompletionBlock)block;
- (void)retrieveKitesWithCompletionBlock:(PKKManagerCompletionBlock)block;
- (void)retrieveDomainsWithCompletionBlock:(PKKManagerCompletionBlock)block;
- (void)addDomainName:(NSString*)name completionBlock:(PKKManagerCompletionBlock)block;
- (void)getAccountInfoWithCompletionBlock:(PKKManagerCompletionBlock)block;

- (PKKKite *) addKiteWithName:(NSString *)name
                     protocol:(NSString *)protocol
                     remoteIp:(NSString *)remoteIp
                   remotePort:(NSNumber *)remotePort
                      localIp:(NSString *)localIp
                    localPort:(NSNumber *)localPort;


@end
