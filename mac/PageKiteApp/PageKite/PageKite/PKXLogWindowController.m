//
//  PKXLogWindowController.m
//  PageKite
//
//  Created by Jay Lyerly on 7/10/14.
//  Copyright (c) 2014 SonicBunny Software. All rights reserved.
//

#import "PKXLogWindowController.h"
#import <PageKiteKit/PageKiteKit.h>
#import "PKXLogger.h"

@interface PKXLogWindowController ()
@property (nonatomic, copy) NSAttributedString *attributedLog;
@end

@implementation PKXLogWindowController

- (instancetype)initWithWindowNibName:(NSString *)windowNibName {
    self = [super initWithWindowNibName:windowNibName];
    if (self){
        [self updateLog];
        [[PKXLogger sharedManager] addObserver:self
                                     forKeyPath:@"attributedLog"
                                        options:0
                                        context:nil];
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"attributedLog"]){
        [self updateLog];
    }
}

- (void)updateLog {
    self.attributedLog = [PKXLogger sharedManager].attributedLog;
}

-(IBAction)copyToClipboard:(id)sender {
    NSPasteboard *pb = [NSPasteboard generalPasteboard];
    [pb clearContents];
    [pb writeObjects:@[self.attributedLog]];
//    [pasteBoard declareTypes:@[NSStringPboardType] owner:nil];
//    [pasteBoard setString:string forType:NSStringPboardType]
}

-(IBAction)clearLog:(id)sender {
    [[PKXLogger sharedManager] clearLog];
}



@end
