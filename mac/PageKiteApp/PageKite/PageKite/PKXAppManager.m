//
//  PKXAppManager.m
//  PageKite
//
//  Created by Jay Lyerly on 6/26/14.
//  Copyright (c) 2014 SonicBunny Software. All rights reserved.
//

#import "PKXAppManager.h"
#import <PageKiteKit/PageKiteKit.h>
#import "PKXAddKiteController.h"
#import "PKXLogWindowController.h"
#import "PKXAlert.h"
#import "PKXLogger.h"
#import "PKXCredentials.h"
#import "PKXKiteMenu.h"

#import "PKXPrefsDomainsViewController.h"
#import "PKXPrefsLoginViewController.h"
#import "PKXPrefsGeneralViewController.h"
#import "MASPreferencesWindowController.h"

#import "NSString+Additions.h"
#import "NSImage+ColorMap.h"
#import "PKKManager+WebServer.h"
#import "PKKKite+WebServer.h"

const NSUInteger kPKXMenuItemKiteTag = 17;

@interface PKXAppManager ()

@property (nonatomic, strong)   NSStatusItem                    *statusItem;
@property (nonatomic, strong)   MASPreferencesWindowController  *prefsWindowController;
@property (nonatomic, strong)   PKXLogWindowController          *logController;
@property (nonatomic, strong)   PKXAddKiteController            *kiteController;

@property (nonatomic, assign)   BOOL                            areKitesRestoring;
@end

@implementation PKXAppManager

+ (instancetype) sharedManager {
    static dispatch_once_t onceToken;
    static PKXAppManager *_mgr = nil;
    dispatch_once(&onceToken, ^{
        _mgr = [[PKXAppManager _alloc] _init];
    });
    
    return _mgr;
}

+ (id) allocWithZone:(NSZone*)z { return [self sharedManager];       }
+ (id) alloc                    { return [self sharedManager];       }
- (id) init                     { return  self;                      }
+ (id)_alloc                    { return [super allocWithZone:NULL]; }
- (id)_init                     { return [super init];               }

- (void) awakeFromNib {
    self.areKitesRestoring = NO;
    [self buildStatusItem];
    [self buildPreferencesController];
    [self checkStartupCreds];
    [self restoreKites];
    [self rebuildKiteItems];
    [self configureMenuItemsForFlightStatus:NO];
    [[PKKManager sharedManager] addObserver:self
                                 forKeyPath:@"kites"
                                    options:0 context:nil];

    // Setup up the statusMenuItem attributes
    [self.statusMenuItem setTarget:self];
    [self.statusMenuItem setAction:@selector(statusAction:)];
    [self.statusMenuItem setOnStateImage: [NSImage imageNamed:NSImageNameStatusAvailable  ]];
    [self.statusMenuItem setOffStateImage:[NSImage imageNamed:NSImageNameStatusUnavailable]];

}

- (void) dealloc {
    [[PKKManager sharedManager] removeObserver:self
                                    forKeyPath:@"kites"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"kites"]){
        [self persistKites];
        [self rebuildKiteItems];
    }
}

- (void) persistKites {
    if (self.areKitesRestoring) { return; }     // don't persist kites that are being restored.
    NSMutableArray *kiteList = [@[] mutableCopy];
    for (PKKKite *kite in [PKKManager sharedManager].kites) {
        NSLog(@"persisting kite named: %@", kite.name);
        NSMutableDictionary *kiteInfo = [@{
                                   @"name"       : kite.name                    ?: @"",
                                   @"protocol"   : kite.protocol                ?: @"",
                                   @"remoteIp"   : kite.remoteIp                ?: @"",
                                   @"remotePort" : kite.remotePort              ?: @0,
                                   @"localIp"    : kite.localIp                 ?: @"",
                                   @"localPort"  : kite.localPort               ?: @0,
                                   } mutableCopy];
        if (kite.webDocumentDirectory) {
            kiteInfo[@"webRoot"] = kite.webDocumentDirectory;
        }
        [kiteList addObject:kiteInfo];
    }
    
    NSData *kiteData = [NSKeyedArchiver archivedDataWithRootObject:kiteList];
    
    [[NSUserDefaults standardUserDefaults] setObject:kiteData forKey:@"kites"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void) restoreKites {
    self.areKitesRestoring = YES;
    NSData *kiteData = [[NSUserDefaults standardUserDefaults] objectForKey:@"kites"];
    NSArray *kiteList = [NSKeyedUnarchiver unarchiveObjectWithData:kiteData];
    [[PKKManager sharedManager] destroyAllKites];       // Nuke it from orbit, only way to be sure.

    for (NSDictionary *kiteInfo in kiteList){
        NSLog(@"Add kite -> name: %@, protocol: %@, remote IP: %@, remote port: %@, local IP: %@, local port: %@",
              kiteInfo[@"name"],
              kiteInfo[@"protocol"],
              kiteInfo[@"remoteIp"],
              kiteInfo[@"remotePort"],
              kiteInfo[@"localIp"],
              kiteInfo[@"localPort"]
              );

        PKKKite *kite = [[PKKManager sharedManager] addKiteWithName:kiteInfo[@"name"]
                                                           protocol:kiteInfo[@"protocol"]
                                                           remoteIp:kiteInfo[@"remoteIp"]
                                                         remotePort:kiteInfo[@"remotePort"]
                                                            localIp:kiteInfo[@"localIp"]
                                                          localPort:kiteInfo[@"localPort"]
                         ];
        kite.webDocumentDirectory = kiteInfo[@"webRoot"];
    }
    self.areKitesRestoring = NO;
}

- (void)buildStatusItem {
    self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    [self.statusItem setMenu:self.statusMenu];
    NSImage *statusIcon = [[NSImage imageNamed:@"StatusIcon"] blacken];  // 18 px for non-retina, 34 for retina
    [self.statusItem setImage:statusIcon];
    [self.statusItem setHighlightMode:YES];
}

- (void)buildPreferencesController {
    NSArray *prefsControllers = @[
                                  [PKXPrefsLoginViewController new],
                                  [PKXPrefsDomainsViewController new],
                                  [PKXPrefsGeneralViewController new],
                                  ];
    self.prefsWindowController =[[MASPreferencesWindowController alloc] initWithViewControllers:prefsControllers
                                                                                          title:@"PageKite Preferences"];
}

- (void)checkStartupCreds {
    BOOL showDlg = NO;
    
    if (! [[PKXCredentials sharedManager].email isNotEmpty]) {
        showDlg = YES;
    }
    if (! [[PKXCredentials sharedManager].password isNotEmpty]) {
        showDlg = YES;
    }
    
    if (showDlg){
        [self promptUserToLogin];
    }else{
        // have username and password, so try to log in
        __weak PKXAppManager *weakSelf = self;
        [[PKKManager sharedManager] loginWithUser:[PKXCredentials sharedManager].email
                                         password:[PKXCredentials sharedManager].password
                                  completionBlock:^(BOOL success){
                                      if (success) {
                                          BOOL flyOnLaunch = [[NSUserDefaults standardUserDefaults] boolForKey:@"flyOnLaunch"];
                                          if (flyOnLaunch && !(self.areFlying)){
                                              [self flyKites:self];
                                          }                                          
                                      } else {      // login failed!
                                          [weakSelf promptUserToLogin];
                                      }
                                  }];
    }
}

- (void) promptUserToLogin {
    [self preferences:self];
    [self.prefsWindowController selectControllerAtIndex:0]; // switch to login tab
    [PKXAlert showAlertMesg:@"Time to log in to PageKite!"
                       info:@"Please enter your email and password to connect to your PageKite account."];
}

- (void)rebuildKiteItems {
    for (NSMenuItem *item in self.statusMenu.itemArray){
        if (item.tag == kPKXMenuItemKiteTag){
            [self.statusMenu removeItem:item];
        }
    }
    
    NSInteger insertionPoint = 4;           // FIXME: hardcoded magic number
    
    for (PKKKite *kite in [[PKKManager sharedManager].kites reverseObjectEnumerator]){
        NSMenuItem *item = [[NSMenuItem alloc] init];
        item.title = kite.name;
        item.tag = kPKXMenuItemKiteTag;
        item.indentationLevel = 1;
        [self.statusMenu insertItem:item atIndex:insertionPoint];
        PKXKiteMenu *kiteMenu = [[PKXKiteMenu alloc] initWithKite:kite];
        [item setSubmenu:kiteMenu];
    }
    
    if ([[PKKManager sharedManager].kites count] == 0){
        NSMenuItem *item = [[NSMenuItem alloc] init];
        item.title = @"No Kites";
        item.tag = kPKXMenuItemKiteTag;
        item.indentationLevel = 1;
        [self.statusMenu insertItem:item atIndex:insertionPoint];
    }
}

#pragma mark - Actions

- (IBAction)quit:(id)sender {
    [[NSApplication sharedApplication] terminate:sender];
}

- (IBAction)about:(id)sender{
    [self activate];
    [[NSApplication sharedApplication] orderFrontStandardAboutPanel:sender];
}

- (IBAction)preferences:(id)sender{
    [self activate];
    [self.prefsWindowController showWindow:self];
}

- (void) activate {
    [[NSApplication sharedApplication] activateIgnoringOtherApps:YES];
}

- (IBAction)addKite:(id)sender {
    [self activate];
    [self.kiteController showWindow:self];
}

- (IBAction)showLog:(id)sender {
    [self activate];
    [self.logController showWindow:nil];
}

- (IBAction)flyKites:(id)sender{
    self.flying = ! self.areFlying;
}

- (IBAction)help:(id)sender {
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"https://pagekite.net/wiki/Howto/Mac/MacClient/"]];
}

#pragma mark - Custom Getters

- (PKXLogWindowController *)logController{
    if (! _logController){
        _logController = [[PKXLogWindowController alloc] initWithWindowNibName:@"PKXLogWindowController"];
    }
    return _logController;
}

- (PKXAddKiteController *)kiteController{
    if (! _kiteController){
        _kiteController = [[PKXAddKiteController alloc] initWithWindowNibName:@"PKXAddKiteController"];
    }
    return _kiteController;
}

- (void) setFlying:(BOOL)flying {
    _flying = flying;
    NSInteger kiteCount = [[[PKKManager sharedManager] kites] count];
    if (flying && kiteCount < 1){
        PKXLog(@"Can't fly without any kites.  Skipping launch.")
        _flying = NO;
    }
    [self configureMenuItemsForFlightStatus:_flying];
}

- (IBAction)statusAction:(id)sender{
    [self flyKites:sender];
}

- (void) configureMenuItemsForFlightStatus:(BOOL)status {
    PKKManager *mgr = [PKKManager sharedManager];
    if (status) {
        [self.flyKitesMenuItem setTitle:@"Land Kites"];
        [self.statusMenuItem setTitle:@"Status: Flying"];
        [self.statusMenuItem setState:NSOnState];
        [mgr flyKitesWithWebServers];
    } else {
        [self.flyKitesMenuItem setTitle:@"Fly Kites"];
        [self.statusMenuItem setTitle:@"Status: Landed"];
        [self.statusMenuItem setState:NSOffState];
        [mgr landKitesWithWebServers];
    }
}

- (void) promptToRestart {
    NSAlert *alert = [[NSAlert alloc] init];
    
    alert.messageText = @"Relaunch Kites";
    
    NSMutableString *info = [@"This change won't take affect until you stop your kites and restart.  " mutableCopy];
    [info appendString:@"Do you want to relaunch all your kites now?  "];
    alert.informativeText = info;
    
    [alert addButtonWithTitle:@"Relaunch Kites Now"];
    [alert addButtonWithTitle:@"Manually Relanch Later"];
    
    NSInteger status = [alert runModal];
    if (status == NSAlertFirstButtonReturn){
        self.flying = NO;
        self.flying = YES;
    }
}

@end
