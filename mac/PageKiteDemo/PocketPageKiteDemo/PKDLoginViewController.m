//
//  PKDLoginViewController.m
//  PageKiteDemo
//
//  Created by Jay Lyerly on 6/15/14.
//  Copyright (c) 2014 SonicBunny Software. All rights reserved.
//

#import "PKDLoginViewController.h"
#import <PageKiteKit/PageKiteKit.h>
#import "PKDDomainTableViewController.h"

NSString * const kPKDDefaultsKeyUsername = @"username";
NSString * const kPKDDefaultsKeyPassword = @"password";

@interface PKDLoginViewController () <UITextFieldDelegate>

@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *password;

@property (nonatomic, strong) PKDDomainTableViewController *domainTableVC;

@end

@implementation PKDLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.usernameField.text = self.username;
    self.passwordField.text = self.password;
    self.usernameField.delegate = self;
    self.passwordField.delegate = self;
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)username{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kPKDDefaultsKeyUsername];
}

- (void)setUsername:(NSString *)username {
    [[NSUserDefaults standardUserDefaults] setObject:username forKey:kPKDDefaultsKeyUsername];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)password{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kPKDDefaultsKeyPassword];
}

- (void)setPassword:(NSString *)password {
    [[NSUserDefaults standardUserDefaults] setObject:password forKey:kPKDDefaultsKeyPassword];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

// Closed the keyboard after 'Done'
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)handleUsername:(id)sender{
    self.username = self.usernameField.text;
}

- (IBAction)handlePassword:(id)sender{
    self.password = self.passwordField.text;
}

- (IBAction)handleLogin:(id)sender{
    
    __weak PKKManager *manager = [PKKManager sharedManager];
    
    [manager addLogMessage:[NSString stringWithFormat:@"Attempting login for %@/%@", self.username, self.password]];
    
    [manager loginWithUser:self.username password:self.password completionBlock:^(BOOL success){
        if (success) {
            [manager addLogMessage:@"Login success"];
            
            [manager retrieveDomainsWithCompletionBlock:^(BOOL success){
                if (success){
                    [self.domainTableVC.tableView reloadData];
                }else{
                    NSLog(@"Failed to get domains!");
                }
            }];
        } else {
            [manager addLogMessage:@"Login fail"];
        }
    }];

}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    self.domainTableVC = objc_dynamic_cast(PKDDomainTableViewController, segue.destinationViewController);
}

- (UITabBarItem *)tabBarItem {
    static dispatch_once_t onceToken;
    static UITabBarItem *_tbi = nil;
    dispatch_once(&onceToken, ^{
        _tbi = [[UITabBarItem alloc] initWithTitle:@"Login" image:[UIImage imageNamed:@"first"] tag:0];
    });
    return _tbi;
}


@end
