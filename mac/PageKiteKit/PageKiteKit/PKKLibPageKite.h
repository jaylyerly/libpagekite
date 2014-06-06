//
//  PKKLibPageKite.h
//  PageKiteKit
//
//  Created by Jay Lyerly on 6/5/14.
//  Copyright (c) 2014 SonicBunny Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "common.h"

@interface PKKLibPageKite : NSObject
@property (nonatomic, readonly, assign) SSL_CTX* ssl_ctx;
@property (nonatomic, readonly)  NSString *log;

+ (instancetype) sharedLibManager;

@end
