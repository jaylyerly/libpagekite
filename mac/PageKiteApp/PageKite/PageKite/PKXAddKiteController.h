//
//  PKXAddKiteController.h
//  PageKite
//
//  Created by Jay Lyerly on 6/27/14.
//  Copyright (c) 2014 SonicBunny Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface PKXAddKiteController : NSWindowController

@property (nonatomic, assign)           NSUInteger      modeIndex;

@property (nonatomic, weak) IBOutlet    NSView          *webserverConfigView;
@property (nonatomic, weak) IBOutlet    NSView          *portConfigView;
@property (nonatomic, weak) IBOutlet    NSView          *modeBoxView;
@property (nonatomic, weak) IBOutlet    NSTabView       *tabView;

@property (nonatomic, weak) IBOutlet    NSPopUpButton   *modePopup;
@property (nonatomic, weak) IBOutlet    NSPopUpButton   *domainPopup;
@property (nonatomic, weak) IBOutlet    NSPopUpButton   *portPopup;
@property (nonatomic, weak) IBOutlet    NSPopUpButton   *localPortPopup;
@property (nonatomic, weak) IBOutlet    NSPopUpButton   *protocolPopup;

@property (nonatomic, copy)             NSString        *kiteName;
@property (nonatomic, copy)             NSString        *kiteHostName;
@property (nonatomic, copy)             NSString        *remotePortName;
@property (nonatomic, copy)             NSString        *remotePortNumber;
@property (nonatomic, copy)             NSString        *protocolName;
@property (nonatomic, copy)             NSString        *localPortName;
@property (nonatomic, copy)             NSString        *localPortNumber;
@property (nonatomic, copy)             NSString        *webRootDir;

- (IBAction)chooseWebRootDir:(id)sender;
- (IBAction)createKite:(id)sender;

@end
