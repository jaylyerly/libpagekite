//
//  PKKManager.m
//  PageKiteKit
//
//  Created by Jay Lyerly on 5/29/14.
//  Copyright (c) 2014 SonicBunny Software. All rights reserved.
//

#import "PKKManager.h"
#import "PKKXmlRpcClient.h"
#import "PKKKiteStatus.h"
#import "PKKDomain.h"
#import "PKKKite.h"
#import "PKKLibPageKite.h"

#import <xmlrpc/XMLRPC.h>


@interface PKKKite ()
- (instancetype) initWithName:(NSString *)name
                     protocol:(NSString *)protocol
                     remoteIp:(NSString *)remoteIp
                   remotePort:(NSNumber *)remotePort
                      localIp:(NSString *)localIp
                    localPort:(NSNumber *)localPort;

@end

@interface PKKManager ()
@property (nonatomic, strong) PKKXmlRpcClient *xmlClient;
@property (nonatomic, copy)   NSString        *credential;
@property (nonatomic, copy)   NSString        *accountId;
@property (nonatomic, copy)   NSString        *sharedSecret;
@property (nonatomic, strong) NSMutableArray  *mutableKites;
@property (nonatomic, strong) NSMutableArray  *logWatchers;
@property (nonatomic, strong) NSArray         *domains;
@property (nonatomic, copy)   NSString        *lastError;
@property (nonatomic, copy)   NSMutableString *logString;

@property (nonatomic, assign) BOOL kitesAreFlying;

@end

@implementation PKKManager

+ (instancetype) sharedManager {
    static dispatch_once_t onceToken;
    static PKKManager *_mgr = nil;
    dispatch_once(&onceToken, ^{
        _mgr = [[PKKManager alloc] init];
    });
    
    return _mgr;
}

- (instancetype) init {
    self = [super init];
    if (self){
        _xmlClient = [[PKKXmlRpcClient alloc] init];
        [[PKKLibPageKite sharedLibManager] addObserver:self
                                            forKeyPath:@"log"
                                               options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                                               context:nil];
        [[PKKLibPageKite sharedLibManager] addObserver:self
                                            forKeyPath:@"managerRunning"
                                               options:0
                                               context:nil];
        _mutableKites = [@[] mutableCopy];
        _logString = [@"" mutableCopy];
        _logWatchers = [@[] mutableCopy];
    }
    return self;
}


- (void)retrieveKitesStatusWithCompletionBlock:(PKKManagerCompletionBlock)block {
    if (self.credential && self.accountId){
        [self.xmlClient callMethod:@"get_kite_stats"
                    withParameters:@[self.accountId, self.credential]
                   completionBlock:^(XMLRPCResponse *resp, NSError *err){
                       
                       NSDictionary *kiteDicts = objc_dynamic_cast(NSDictionary, [self payloadForResponse:resp error:err]);
                       if (kiteDicts){
                           NSMutableArray *tmpArray = [@[] mutableCopy];
                           [kiteDicts enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop){
                               NSString *name = objc_dynamic_cast(NSString, key);
                               NSString *bytes = objc_dynamic_cast(NSString, obj);
                               PKKKiteStatus *kite = [[PKKKiteStatus alloc] initWithName:name bytes:bytes];
                               [tmpArray addObject:kite];
                           }];
                           //self.kites = [NSArray arrayWithArray:tmpArray];
                           // FIXME -- update status for individual kites with contents of tmpArray
                           if (block) { block(YES); }
                           return;
                       }
                       if (block) { block(NO); }
                   }];
    } else {
        if (block) { block(NO); }
    }
}

- (void)retrieveDomainsWithCompletionBlock:(PKKManagerCompletionBlock)block{
    if (self.credential && self.accountId){
        [self.xmlClient callMethod:@"get_available_domains"
                    withParameters:@[self.accountId, self.credential]
                   completionBlock:^(XMLRPCResponse *resp, NSError *err){
                       
                       NSDictionary *domDicts = objc_dynamic_cast(NSDictionary, [self payloadForResponse:resp error:err]);
                       if (domDicts){
                           NSMutableArray *tmpArray = [@[] mutableCopy];
                           [domDicts enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop){
                               NSString *name = objc_dynamic_cast(NSString, key);
                               NSArray *services = objc_dynamic_cast(NSArray, obj);
                               PKKDomain *domain = [[PKKDomain alloc] initWithName:name services:services];
                               [tmpArray addObject:domain];
                           }];
                           self.domains = [NSArray arrayWithArray:tmpArray];
                           if (block) { block(YES); }
                           return;
                       }
                       if (block) { block(NO); }
                   }];
    } else {
        if (block) { block(NO); }
    }
}


- (void)loginWithUser:(NSString *)user password:(NSString *)password completionBlock:(PKKManagerCompletionBlock)block{
    
    [self.xmlClient callMethod:@"login"
                withParameters:@[user, password, @""]
               completionBlock:^(XMLRPCResponse *resp, NSError *err){
                   
                   NSArray *data = objc_dynamic_cast(NSArray, [self payloadForResponse:resp error:err]);
                   if (data && [data count] > 1){
                       self.accountId = data[0];
                       self.credential = data[1];
                       NSLog(@"Found credential: %@", self.credential);
                       NSLog(@"Found accountId: %@", self.accountId);
                       [self getAccountInfoWithCompletionBlock:^(BOOL success){        // make sure to get the shared secret
                           if (block) { block(success); }
                        }];
                       return;
                   }
                   if (block) { block(NO); }                   
               }];
}

- (void)addDomainName:(NSString*)name completionBlock:(PKKManagerCompletionBlock)block{
    [self.xmlClient callMethod:@"add_kite"
                withParameters:@[self.accountId, self.credential, name, @NO]
               completionBlock:^(XMLRPCResponse *resp, NSError *err){
                   
                   NSString *data = objc_dynamic_cast(NSString, [self payloadForResponse:resp error:err]);
                   if (data){
                       NSLog(@"Added kite with response: %@", data);
                       if (block) { block(YES); }
                       return;
                   }
                   if (block) { block(NO); }
               }];
    
}

- (void)getAccountInfoWithCompletionBlock:(PKKManagerCompletionBlock)block{
    NSString *version = [NSString stringWithFormat:@"%@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]];

    [self.xmlClient callMethod:@"get_account_info"
                withParameters:@[self.accountId, self.credential, version]
               completionBlock:^(XMLRPCResponse *resp, NSError *err){
                   
                   NSDictionary *data = objc_dynamic_cast(NSDictionary, [self payloadForResponse:resp error:err]);
                   if (data){
                       self.sharedSecret = data[@"data"][@"_ss"];
                       NSLog(@"Account info: %@", data);
                       if (block) { block(YES); }
                       return;
                   }
                   if (block) { block(NO); }
               }];
    
}

- (PKKKite *) addKiteWithName:(NSString *)name
                     protocol:(NSString *)protocol
                     remoteIp:(NSString *)remoteIp
                   remotePort:(NSNumber *)remotePort
                      localIp:(NSString *)localIp
                    localPort:(NSNumber *)localPort{
    
    PKKKite *kite = [[PKKKite alloc] initWithName:name
                                            protocol:protocol
                                            remoteIp:remoteIp
                                          remotePort:remotePort
                                             localIp:localIp
                                           localPort:localPort];
    [self willChangeValueForKey:@"kites"];
    [self.mutableKites addObject:kite];
    [self didChangeValueForKey:@"kites"];
    return kite;
}


- (NSArray *)kites {
    return [NSArray arrayWithArray:self.mutableKites];
}

- (void)addLogMessage:(NSString *)message {
    NSString *realMessage = message;

    NSString *lastChar = [message substringFromIndex:([message length]-1)];
    if (! [lastChar isEqualToString:@"\n"]){
        realMessage = [NSString stringWithFormat:@"%@\n", message];
    }
    
    for (id<PKKManagerLogWatcher> watcher in self.logWatchers){
        [watcher pageKiteManager:self newLogMessage:realMessage];
    }

    [self willChangeValueForKey:@"log"];
    [self.logString appendString:realMessage];
    [self didChangeValueForKey:@"log"];
}

- (NSString *)log{
    return [NSString stringWithString:self.logString];
}

- (void)addLogWacher:(id<PKKManagerLogWatcher>)watcher{
    if (watcher){
        [self.logWatchers addObject:watcher];
    }
}

- (void)removeLogWatcher:(id<PKKManagerLogWatcher>)watcher{
    if (watcher){
        [self.logWatchers removeObject:watcher];
    }
}



#pragma mark - PKKLibPageKite interface

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"log"]){
        // The library log changed, so get a copy to expose it to the world.
        NSString *new = change[@"new"];
        NSString *old = change[@"old"];
        NSString *delta = [new stringByReplacingOccurrencesOfString:old withString:@""];
        if ([delta length] > 0) {  //avoid initialization issue, nil -> @""
            [self addLogMessage:[NSString stringWithFormat:@"<libpagekite> %@", delta]];
        }
    }
    if ([keyPath isEqualToString:@"managerRunning"]){
        self.kitesAreFlying = [[PKKLibPageKite sharedLibManager] isManagerRunning];
    }
}

- (void) flyKites {
    [[PKKLibPageKite sharedLibManager] startManager];
}

- (void) landKites{
    [[PKKLibPageKite sharedLibManager] stopManager];
}

- (BOOL) kitesAreFlying{
    return [[PKKLibPageKite sharedLibManager] isManagerRunning];
}

#pragma mark - API helper funcs

- (BOOL) isResponseOk:(XMLRPCResponse *)resp error:(NSError *)err{
    if (err) {
        NSLog(@"Error with login: %@", err);
        return NO;
    }
    NSArray *respArray = objc_dynamic_cast(NSArray, [resp object]);
    if (respArray && [respArray count] > 0){
        NSString *status = objc_dynamic_cast(NSString,respArray[0]);
        if (status && [status isEqualToString:@"ok"]){
            return YES;
        }
    }
    NSDictionary *respDict = objc_dynamic_cast(NSDictionary, [resp object]);
    if (respDict){
        self.lastError = objc_dynamic_cast(NSString, respDict[@"faultString"]);
    }
    
    NSLog(@"status code not ok!");
    return NO;
}

- (id) payloadForResponse:(XMLRPCResponse *)resp error:(NSError *)err {
    if ([self isResponseOk:resp error:err]){
        NSArray *respArray = [resp object];
        if ([respArray count] > 1){
            return respArray[1];
        }
    }
    return nil;
}


@end
