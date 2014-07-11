//
//  PKXLogger.h
//  PageKite
//
//  Created by Jay Lyerly on 7/11/14.
//  Copyright (c) 2014 SonicBunny Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PKXLogger : NSObject
@property (nonatomic, copy, readonly) NSAttributedString *attributedLog;

+ (instancetype) sharedManager;

- (void) clearLog;
- (void) logMessage:(NSString *)aString;

@end
