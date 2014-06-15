//
//  PKKKite.h
//  PageKiteKit
//
//  Created by Jay Lyerly on 6/5/14.
//  Copyright (c) 2014 SonicBunny Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PKKKite : NSObject

@property (nonatomic, readonly, copy) NSString *name;
@property (nonatomic, readonly, copy) NSString *protocol;
@property (nonatomic, readonly, copy) NSString *remoteIp;
@property (nonatomic, readonly)       NSNumber *remotePort;
@property (nonatomic, readonly, copy) NSString *localIp;
@property (nonatomic, readonly)       NSNumber *localPort;

@end
