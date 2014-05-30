//
//  PKKKite.h
//  PageKiteKit
//
//  Created by Jay Lyerly on 5/29/14.
//  Copyright (c) 2014 SonicBunny Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PKKKite : NSObject
@property (nonatomic, readonly, copy) NSString *name;
@property (nonatomic, readonly, copy) NSString *bytes;

- (instancetype)initWithName:(NSString *)name bytes:(NSString *)bytes;
@end
