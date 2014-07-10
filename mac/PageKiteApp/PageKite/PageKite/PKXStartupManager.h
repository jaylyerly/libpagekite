//
//  PKXStartupManager.h
//  PageKite
//
//  Created by Jay Lyerly on 7/3/14.
//  Copyright (c) 2014 SonicBunny Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PKXStartupManager : NSObject

@property (nonatomic, assign) BOOL willLaunchAtStartup;

+ (instancetype) sharedManager;


@end
