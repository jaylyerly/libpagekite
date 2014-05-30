//
//  PKKDomain.h
//  PageKiteKit
//
//  Created by Jay Lyerly on 5/30/14.
//  Copyright (c) 2014 SonicBunny Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PKKDomain : NSObject
@property (nonatomic, readonly, copy) NSString *name;
@property (nonatomic, readonly)     BOOL serviceBasic;
@property (nonatomic, readonly)     BOOL serviceSSL;
- (instancetype)initWithName:(NSString *)name services:(NSArray *)services;


@end
