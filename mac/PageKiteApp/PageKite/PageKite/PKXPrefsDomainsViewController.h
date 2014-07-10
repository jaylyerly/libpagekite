//
//  PKXPrefsDomainsViewController.h
//  PageKite
//
//  Created by Jay Lyerly on 7/10/14.
//  Copyright (c) 2014 SonicBunny Software. All rights reserved.
//

#import "PKXPrefsViewController.h"

@interface PKXPrefsDomainsViewController : PKXPrefsViewController

@property (nonatomic, weak)     IBOutlet NSWindow           *addDomainWindow;
@property (nonatomic, weak)     IBOutlet NSArrayController  *domainController;
@property (nonatomic, strong)            NSArray            *domains;
@property (nonatomic, copy, readonly)            NSString     *addDomainName;

@end
