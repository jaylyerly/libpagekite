//
//  PKXAddKiteController.m
//  PageKite
//
//  Created by Jay Lyerly on 6/27/14.
//  Copyright (c) 2014 SonicBunny Software. All rights reserved.
//

#import "PKXAddKiteController.h"

@interface PKXAddKiteController ()
@property (nonatomic, copy) NSString *webRootDir;

@end

@implementation PKXAddKiteController

- (NSString *)windowNibName {
    return @"AddKite";
}

- (void)showWindow:(id)sender{
    [self.window center];
    [super showWindow:sender];
}

- (IBAction)chooseWebRootDir:(id)sender {
    __weak PKXAddKiteController *weakSelf = self;
    NSLog(@"Choose Web Dir");
    NSOpenPanel *open = [NSOpenPanel openPanel];
    [open setCanChooseDirectories:YES];
    [open setCanChooseFiles:NO];
    [open setAllowsMultipleSelection:NO];
    [open beginWithCompletionHandler:^(NSInteger result){
        if (result == NSFileHandlingPanelOKButton){
            weakSelf.webRootDir = open.directoryURL.path;
        }
    }];
}

- (IBAction)createKite:(id)sender {
    NSLog(@"Create Kite");
}

@end
