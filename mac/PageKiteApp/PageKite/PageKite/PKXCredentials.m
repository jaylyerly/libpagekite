//
//  PKXCredentials.m
//  PageKite
//
//  Created by Jay Lyerly on 7/10/14.
//  Copyright (c) 2014 SonicBunny Software. All rights reserved.
//

#import "PKXCredentials.h"
#import "FXKeychain.h"

NSString *kPKXKeychainPassword = @"PageKitePassword";
NSString *kPKXUserDefaultsEmail = @"PageKiteEmail";

@implementation PKXCredentials

+(instancetype) sharedManager {
    static dispatch_once_t onceToken;
    static PKXCredentials *_mgr = nil;
    dispatch_once(&onceToken, ^{
        _mgr = [[PKXCredentials _alloc] _init];
    });
    
    return _mgr;
}

// Make Interface Builder instances be the singleton
+ (id) allocWithZone:(NSZone*)z { return [self sharedManager];       }
+ (id) alloc                    { return [self sharedManager];       }
- (id) init                     { return  self;                      }
+ (id)_alloc                    { return [super allocWithZone:NULL]; }
- (id)_init                     { return [super init];               }


- (NSString *)password {
    return [FXKeychain defaultKeychain][kPKXKeychainPassword];
}

- (void) setPassword:(NSString *)password {
    [FXKeychain defaultKeychain][kPKXKeychainPassword] = password;
}

- (NSString *)email {
    return [[NSUserDefaults standardUserDefaults] stringForKey:kPKXUserDefaultsEmail];
}

- (void)setEmail:(NSString *)email {
    [[NSUserDefaults standardUserDefaults] setObject:email forKey:kPKXUserDefaultsEmail];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


@end
