//
//  PKXLogger.m
//  PageKite
//
//  Created by Jay Lyerly on 7/11/14.
//  Copyright (c) 2014 SonicBunny Software. All rights reserved.
//

#import "PKXLogger.h"
#import <PageKiteKit/PageKiteKit.h>

@interface PKXLogger () <PKKManagerLogWatcher>

@property (nonatomic, copy) NSMutableString *logString;

@end

@implementation PKXLogger

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static PKXLogger *_mgr = nil;
    dispatch_once(&onceToken, ^{
        _mgr = [[PKXLogger alloc] init];
    });
    
    return _mgr;
}

- (instancetype)init {
    self = [super init];
    if (self){
        _logString = [NSMutableString string];
        [[PKKManager sharedManager] addLogWacher:self];
    }
    return self;
}

- (void) clearLog {
    [self willChangeValueForKey:@"attributedLog"];
    [self.logString deleteCharactersInRange:NSMakeRange(0, [self.logString length])];
    [self didChangeValueForKey:@"attributedLog"];
}

- (void) pageKiteManager:(PKKManager *)manager newLogMessage:(NSString *)message{
    [self logMessage:message];
}

- (void) logMessage:(NSString *)aString {
    NSString *newString = aString;
    
    NSString *lastChar = [aString substringFromIndex:([aString length]-1)];
    if (! [lastChar isEqualToString:@"\n"]){
        newString = [NSString stringWithFormat:@"%@\n", aString];
    }
    
    [self willChangeValueForKey:@"attributedLog"];
    [self.logString appendString:newString];
    [self didChangeValueForKey:@"attributedLog"];
}

- (NSAttributedString *)attributedLog {
    return [[NSAttributedString alloc] initWithString:self.logString];
}

- (void)log:(NSString *)formatString, ...
{
    va_list args;
    va_start(args, formatString);
    NSString *msg = [[NSString alloc] initWithFormat:formatString arguments:args];
    va_end(args);
    [self logMessage:msg];
}

@end
