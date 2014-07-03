//
//  PKXAppManager.h
//  PageKite
//
//  Created by Jay Lyerly on 6/26/14.
//  Copyright (c) 2014 SonicBunny Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PKXAppManager : NSObject

@property (nonatomic, readonly)          NSStatusItem        *statusItem;
@property (nonatomic, weak)     IBOutlet NSMenu              *statusMenu;
@property (nonatomic, weak)     IBOutlet NSWindow            *prefsWindow;
@property (nonatomic, weak)     IBOutlet NSWindow            *addDomainWindow;
@property (nonatomic, weak)     IBOutlet NSWindowController  *addKiteWindowController;
@property (nonatomic, weak)     IBOutlet NSArrayController   *domainController;

@property (nonatomic, copy, readonly)            NSString     *addDomainName;
@property (nonatomic, copy, readonly)            NSString     *email;
@property (nonatomic, copy, readonly)            NSString     *password;
@property (nonatomic, readonly)            NSArray      *domains;

- (IBAction)quit:(id)sender;
- (IBAction)about:(id)sender;
- (IBAction)preferences:(id)sender;
- (IBAction)verifyCreds:(id)sender;
- (IBAction)addDomain:(id)sender;
- (IBAction)removeDomain:(id)sender;

- (IBAction)addKite:(id)sender;


- (IBAction)addDomainName:(id)sender;

@end
