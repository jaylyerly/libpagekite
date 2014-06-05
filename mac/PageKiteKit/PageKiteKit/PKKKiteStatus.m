//
//  PKKKite.m
//  PageKiteKit
//
//  Created by Jay Lyerly on 5/29/14.
//  Copyright (c) 2014 SonicBunny Software. All rights reserved.
//

#import "PKKKiteStatus.h"

@interface PKKKiteStatus ()
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *bytes;
@end

@implementation PKKKiteStatus

- (instancetype)initWithName:(NSString *)name bytes:(NSString *)bytes {
    self = [super init];
    if (self){
        _name = name;
        _bytes = bytes;
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<PKKKite %p> %@:%@", self, self.name, self.bytes];
}

@end
