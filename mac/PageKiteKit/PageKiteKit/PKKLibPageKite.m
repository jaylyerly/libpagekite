//
//  PKKLibPageKite.m
//  PageKiteKit
//
//  Created by Jay Lyerly on 6/5/14.
//  Copyright (c) 2014 SonicBunny Software. All rights reserved.
//

#import "PKKLibPageKite.h"

// LibPageKite Includes
#import "pkstate.h"
#import "pklogging.h"
#import "common.h"

@interface PKKLibPageKite ()

@property (nonatomic, assign) BOOL       isInitialized;
@property (nonatomic, assign) SSL_CTX    *ssl_ctx;
@property (nonatomic, strong) NSString   *log;
@property (nonatomic, assign) size_t     logCount;

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
        [self initializeLibrary];
    }
    return self;
}

- (void)initializeLibrary{
    if (! self.isInitialized){
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

@end
