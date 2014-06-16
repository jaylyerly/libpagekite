//
//  PKKManager.h
//  PageKiteKit
//
//  Created by Jay Lyerly on 5/29/14.
//

#import <Foundation/Foundation.h>

typedef void (^PKKManagerCompletionBlock)(BOOL success);

@class PKKKite;
@class PKKManager;

@protocol PKKManagerLogWatcher <NSObject>
- (void) pageKiteManager:(PKKManager*)manager newLogMessage:(NSString *)message;
@end

@interface PKKManager : NSObject

@property (nonatomic, readonly)       NSArray *kites;
@property (nonatomic, readonly)       NSArray *domains;
@property (nonatomic, readonly, copy) NSString *lastError;
@property (nonatomic, readonly, copy) NSString *log;

@property (nonatomic, readonly) BOOL kitesAreFlying;

+ (instancetype) sharedManager;

- (void)loginWithUser:(NSString *)user password:(NSString *)password completionBlock:(PKKManagerCompletionBlock)block;
- (void)retrieveKitesStatusWithCompletionBlock:(PKKManagerCompletionBlock)block;
- (void)retrieveDomainsWithCompletionBlock:(PKKManagerCompletionBlock)block;
- (void)addDomainName:(NSString*)name completionBlock:(PKKManagerCompletionBlock)block;
//- (void)getAccountInfoWithCompletionBlock:(PKKManagerCompletionBlock)block;

- (PKKKite *) addKiteWithName:(NSString *)name
                     protocol:(NSString *)protocol
                     remoteIp:(NSString *)remoteIp
                   remotePort:(NSNumber *)remotePort
                      localIp:(NSString *)localIp
                    localPort:(NSNumber *)localPort;

- (void)flyKites;
- (void)landKites;

- (void)destroyAllKites;

- (void)addLogMessage:(NSString *)message;
- (void)addLogWacher:(id<PKKManagerLogWatcher>)watcher;

@end
