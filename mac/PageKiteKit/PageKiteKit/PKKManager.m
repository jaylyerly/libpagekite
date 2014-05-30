//
//  PKKManager.m
//  PageKiteKit
//
//  Created by Jay Lyerly on 5/29/14.
//  Copyright (c) 2014 SonicBunny Software. All rights reserved.
//

#import "PKKManager.h"
#import "PKKXmlRpcClient.h"
#import "PKKKite.h"
#import "PKKDomain.h"
#import <xmlrpc/XMLRPC.h>

@interface PKKManager ()
@property (nonatomic, strong) PKKXmlRpcClient *xmlClient;
@property (nonatomic, copy) NSString *credential;
@property (nonatomic, copy) NSString *accountId;
@property (nonatomic, strong) NSArray *kites;
@property (nonatomic, strong) NSArray *domains;
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
    }
    return self;
}

- (void)retrieveKitesWithCompletionBlock:(PKKManagerCompletionBlock)block {
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
                               PKKKite *kite = [[PKKKite alloc] initWithName:name bytes:bytes];
                               [tmpArray addObject:kite];
                           }];
                           self.kites = [NSArray arrayWithArray:tmpArray];
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
                       if (block) { block(YES); }
                       return;
                   }
                   if (block) { block(NO); }                   
               }];
}

#pragma mark - API helper funcs

- (BOOL) isResponseOk:(XMLRPCResponse *)resp error:(NSError *)err{
    if (err) {
        NSLog(@"Error with login: %@", err);
        return NO;
    }
    NSArray *respArray = [resp object];
    if ([respArray count] > 0){
        NSString *status = respArray[0];
        if ([status isEqualToString:@"ok"]){
            return YES;
        }
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
