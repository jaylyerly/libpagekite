//
//  PKXAppManager.h
//  PageKite
//
//  Created by Jay Lyerly on 6/26/14.
//  Copyright (c) 2014 SonicBunny Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PKXAppManager : NSObject

@property (nonatomic, readonly)                                 NSStatusItem  *statusItem;
@property (nonatomic, weak)                         IBOutlet    NSMenu        *statusMenu;
@property (nonatomic, weak)                         IBOutlet    NSMenuItem    *flyKitesMenuItem;
@property (nonatomic, weak)                         IBOutlet    NSMenuItem    *statusMenuItem;
@property (nonatomic, readonly)                                 NSArray       *domains;
@property (nonatomic, assign, getter = areFlying)               BOOL          flying;

- (IBAction)quit:(id)sender;
- (IBAction)about:(id)sender;
- (IBAction)preferences:(id)sender;
- (IBAction)addKite:(id)sender;
- (IBAction)flyKites:(id)sender;

@end
