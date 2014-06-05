//
//  PKKLibPageKite.m
//  PageKiteKit
//
//  Created by Jay Lyerly on 6/5/14.
//  Copyright (c) 2014 SonicBunny Software. All rights reserved.
//

#import "PKKLibPageKite.h"

// LibPageKite Includes
#import "common.h"

@interface PKKLibPageKite ()

@property (nonatomic, assign) BOOL isInitialized;
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
    }
    return self;
}

- (void)initializeLibrary{
    if (! self.isInitialized){
        pks_global_init(PK_LOG_NORMAL);
        PKS_SSL_INIT(ssl_ctx);

        self.isInitialized = YES;
    }
}

@end
