//
//  PKXLogger.h
//  PageKite
//
//  Created by Jay Lyerly on 7/11/14.
//  Copyright (c) 2014 SonicBunny Software. All rights reserved.
//

#import <Foundation/Foundation.h>

// NSLog replacement
#define PKXLog(fmt, ...) [[PKXLogger sharedManager] log:(@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__];

@interface PKXLogger : NSObject
@property (nonatomic, copy, readonly) NSAttributedString *attributedLog;

+ (instancetype) sharedManager;

- (void) clearLog;
- (void) logMessage:(NSString *)aString;

- (void) log:(NSString *)formatString, ...;

@end
