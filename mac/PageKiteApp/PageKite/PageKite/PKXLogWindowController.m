//
//  PKXLogWindowController.m
//  PageKite
//
//  Created by Jay Lyerly on 7/10/14.
//  Copyright (c) 2014 SonicBunny Software. All rights reserved.
//

#import "PKXLogWindowController.h"
#import <PageKiteKit/PageKiteKit.h>

@interface PKXLogWindowController () <PKKManagerLogWatcher>
@property (nonatomic, copy) NSMutableString *logString;
@end

@implementation PKXLogWindowController

- (instancetype)initWithWindowNibName:(NSString *)windowNibName {
    self = [super initWithWindowNibName:windowNibName];
    if (self){
        _logString = [@"" mutableCopy];
        [[PKKManager sharedManager] addLogWacher:self];
    }
    return self;
}

- (NSAttributedString *)attributedLog {
    return [[NSAttributedString alloc] initWithString:self.logString];
}

-(IBAction)copyToClipboard:(id)sender {
    
}

-(IBAction)clearLog:(id)sender {
    [self willChangeValueForKey:@"attributedLog"];
    self.logString = [@"" mutableCopy];
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
    
    [self willChangeValueForKey:@"logText"];
    [self.logString appendString:newString];
    [self didChangeValueForKey:@"logText"];
}


@end
