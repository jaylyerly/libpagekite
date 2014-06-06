//
//  PKKKite.m
//  PageKiteKit
//
//  Created by Jay Lyerly on 6/5/14.
//  Copyright (c) 2014 SonicBunny Software. All rights reserved.
//

#import "PKKKite.h"
#import "PKKLibPageKite.h"

//LibPageKite headers
#include "common.h"
#include "pkstate.h"
#include "pkerror.h"
#include "pkconn.h"
#include "pkproto.h"
#include "pkblocker.h"
#include "pkmanager.h"
#include "pklogging.h"
#include "version.h"
#include "pagekite_net.h"

@interface PKKKite ()
@property (nonatomic, copy)   NSString *name;
@property (nonatomic, copy)   NSString *secret;
@property (nonatomic, copy)   NSString *protocol;
@property (nonatomic, copy)   NSString *remoteIp;
@property (nonatomic, strong) NSNumber *remotePort;
@property (nonatomic, copy)   NSString *localIp;
@property (nonatomic, strong) NSNumber *localPort;

@property (nonatomic, assign) struct pk_manager *manager;
@property (nonatomic, assign) BOOL              isFlying;

@end

@implementation PKKKite


- (instancetype) initWithName:(NSString *)name
                       secret:(NSString *)secret
                     protocol:(NSString *)protocol
                     remoteIp:(NSString *)remoteIp
                   remotePort:(NSNumber *)remotePort
                      localIp:(NSString *)localIp
                    localPort:(NSNumber *)localPort{
    self = [super init];
    if (self){
        _name = name;
        _secret = secret;
        _protocol = protocol;
        _remoteIp = remoteIp;
        _remotePort = remotePort;
        _localIp = localIp;
        _localPort = localPort;
        _isFlying = NO;
        //[self getNewManager];
    }
    return self;
}

- (void) getNewManager {
    //        struct pk_manager* pkm_manager_init(struct ev_loop* loop,
    //                                            int buffer_size, char* buffer,
    //                                            int kites, int frontends, int conns,
    //                                            const char* dynamic_dns_url, SSL_CTX* ctx)

    PKKLibPageKite *libMgr = [PKKLibPageKite sharedLibManager];
    self.manager = pkm_manager_init(NULL, 0, NULL,
                                    1, /* Kites */
                                    PAGEKITE_NET_FE_MAX,
                                    25,     // max connections
                                    PAGEKITE_NET_DDNS,
                                    libMgr.ssl_ctx
                                    );
}

- (void) fly {
    if (self.isFlying){
        return;
    }
    
    [self getNewManager];
    
    NSString *errorHeader = [NSString stringWithFormat:@"Error in kite(%@)", self.name];
    const char *errorHeaderC = [errorHeader UTF8String];
    /*
     struct pk_pagekite* pkm_add_kite(struct pk_manager* pkm,
     const char* protocol,
     const char* public_domain, int public_port,
     const char* auth_secret,
     const char* local_domain, int local_port)
     */
    struct pk_pagekite *pagekite = pkm_add_kite(self.manager,
                                                [self.protocol UTF8String],
                                                [self.remoteIp UTF8String], [self.remotePort integerValue],
                                                [self.secret UTF8String],
                                                [self.localIp UTF8String], [self.localPort integerValue]);
    
    if (! pagekite) {
        return;
    }
    int fes_v4 = 0;

    fes_v4 = pkm_add_frontend(self.manager, PAGEKITE_NET_V4FRONTENDS, FE_STATUS_AUTO);
    if (fes_v4 == 0){
        pk_error = ERR_NO_FRONTENDS;
        pk_perror(errorHeaderC);
        return;
    }
    
    if (0 > pkm_run_in_thread(self.manager)) {
        pk_perror(errorHeaderC);
        return;
    }
    
    self.isFlying = YES;
}

- (void) land {
    if (! self.isFlying){
        return;
    }
    pkm_stop_thread(self.manager);
    self.manager = nil;
    self.isFlying = NO;
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
