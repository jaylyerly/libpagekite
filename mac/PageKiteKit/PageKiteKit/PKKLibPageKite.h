//
//  PKKLibPageKite.h
//  PageKiteKit
//
//  Created by Jay Lyerly on 6/5/14.
//  Copyright (c) 2014 SonicBunny Software. All rights reserved.
//

#import <Foundation/Foundation.h>

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

@class PKKKite;

@interface PKKLibPageKite : NSObject
@property (nonatomic, readonly)                            NSString *log;
@property (nonatomic, readonly, getter = isManagerRunning) BOOL     managerRunning;

+ (instancetype) sharedLibManager;

- (void) startManager;
- (void) stopManager;

@end
