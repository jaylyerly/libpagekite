//
//  PKXAppManager.h
//  PageKite
//
//  Created by Jay Lyerly on 6/26/14.
//  Copyright (c) 2014 SonicBunny Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PKXAppManager : NSObject

@property (nonatomic, readonly)          NSStatusItem *statusItem;
@property (nonatomic, weak)     IBOutlet NSMenu       *statusMenu;
@property (nonatomic, weak)     IBOutlet NSWindow     *prefsWindow;

@property (nonatomic, strong)   IBOutlet NSString     *email;
@property (nonatomic, strong)   IBOutlet NSString     *password;

- (IBAction)quit:(id)sender;
- (IBAction)about:(id)sender;
- (IBAction)preferences:(id)sender;


@end
