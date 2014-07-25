//
//  PKKLibPageKite.m
//  PageKiteKit
//
//  Created by Jay Lyerly on 6/5/14.
//  Copyright (c) 2014 SonicBunny Software. All rights reserved.
//

#import "PKKLibPageKite.h"
#import "PKKKite.h"
#import "PKKManager.h"

@interface PKKManager ()
@property (nonatomic, readonly) NSString *sharedSecret;
@end


@interface PKKLibPageKite ()

@property (nonatomic, assign) BOOL                                isInitialized;
@property (nonatomic, assign) SSL_CTX                             *ssl_ctx;
@property (nonatomic, strong) NSString                            *log;
@property (nonatomic, assign) size_t                              logCount;
@property (nonatomic, assign) struct pk_manager                   *manager;
@property (nonatomic, assign, getter = isManagerRunning) BOOL     managerRunning;

@end

@implementation PKKLibPageKite

+ (instancetype) sharedLibManager {
    static dispatch_once_t onceToken;
    static PKKLibPageKite *_lib = nil;
    dispatch_once(&onceToken, ^{
        _lib = [[PKKLibPageKite alloc] init];
    });
    
    return _lib;
}

- (instancetype)init{
    self = [super init];
    if (self){
        _isInitialized = NO;
        _managerRunning = NO;
        [self initializeLibrary];
    }
    return self;
}

- (void)initializeLibrary{
    if (! self.isInitialized){
        //pks_global_init(PK_LOG_ALL);
        pks_global_init(PK_LOG_NORMAL);
        PKS_SSL_INIT(self.ssl_ctx);
        [NSTimer scheduledTimerWithTimeInterval:.3
                                         target:self
                                       selector:@selector(logWatcher:)
                                       userInfo:nil
                                        repeats:YES];

        self.isInitialized = YES;
    }
}

- (void)logWatcher:(NSTimer *)timer {
    char logCopy[PKS_LOG_DATA_MAX];
    
    pks_copylog(logCopy);
    size_t logSize = strnlen(logCopy, PKS_LOG_DATA_MAX);
    
    if ( !self.log || logSize != self.logCount){
        self.logCount = logSize;
        self.log = [NSString stringWithCString:logCopy encoding:NSUTF8StringEncoding];
    }
    
}

- (void) startManager{
    if (self.isManagerRunning){
        return;
    }
    
    self.manager = pkm_manager_init(NULL, 0, NULL,
                                    1, /* Kites */
                                    PAGEKITE_NET_FE_MAX,
                                    25,     // max connections
                                    PAGEKITE_NET_DDNS,
                                    self.ssl_ctx
                                    );

    
    /*
     struct pk_pagekite* pkm_add_kite(struct pk_manager* pkm,
     const char* protocol,
     const char* public_domain, int public_port,
     const char* auth_secret,
     const char* local_domain, int local_port)
     */
    NSString *errorHeader = [NSString stringWithFormat:@"Error in PKKLibPageKite starting manager"];
    const char *errorHeaderC = [errorHeader UTF8String];
    
    for (PKKKite *kite in [[PKKManager sharedManager] kites]){
        struct pk_pagekite *pagekite = pkm_add_kite(self.manager,
                                                    [kite.protocol UTF8String],
                                                    [kite.remoteIp UTF8String], [kite.remotePort integerValue],
                                                    [[PKKManager sharedManager].sharedSecret UTF8String],
                                                    [kite.localIp UTF8String], [kite.localPort integerValue]);
        
        if (! pagekite) {
            return;
        }
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
    
    self.managerRunning = YES;

}

- (void) stopManager{
    if (! self.isManagerRunning){
        return;
    }
    pkm_stop_thread(self.manager);
    free(self.manager);
    self.manager = nil;
    self.managerRunning = NO;
}


- (void) flyKite:(PKKKite *)kite{
}


- (void) landKite:(PKKKite *)kite{

}


@end
