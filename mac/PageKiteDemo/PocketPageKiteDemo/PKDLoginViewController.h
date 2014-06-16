//
//  PKDLoginViewController.h
//  PageKiteDemo
//
//  Created by Jay Lyerly on 6/15/14.
//  Copyright (c) 2014 SonicBunny Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PKDLoginViewController : UIViewController

@property (nonatomic, weak) IBOutlet UITextField *usernameField;
@property (nonatomic, weak) IBOutlet UITextField *passwordField;

- (IBAction)handleUsername:(id)sender;
- (IBAction)handlePassword:(id)sender;
- (IBAction)handleLogin:(id)sender;

@end
