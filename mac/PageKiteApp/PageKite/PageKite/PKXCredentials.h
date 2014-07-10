//
//  PKXCredentials.h
//  PageKite
//
//  Created by Jay Lyerly on 7/10/14.
//  Copyright (c) 2014 SonicBunny Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PKXCredentials : NSObject
@property (nonatomic, strong)            NSString     *email;
@property (nonatomic, strong)            NSString     *password;

+ (instancetype) sharedManager;

@end
