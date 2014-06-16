//
//  PKDKiteViewController.m
//  PageKiteDemo
//
//  Created by Jay Lyerly on 6/15/14.
//  Copyright (c) 2014 SonicBunny Software. All rights reserved.
//

#import "PKDKiteViewController.h"
#import "RMPickerViewController.h"
#import <PageKiteKit/PageKiteKit.h>
#import "GCDWebServer.h"
#import "GCDWebServerDataResponse.h"

@interface PKDKiteViewController () <RMPickerViewControllerDelegate>

@property (nonatomic, strong) RMPickerViewController *domainPicker;
@property (nonatomic, strong) PKKDomain              *selectedDomain;
@property (nonatomic, strong) GCDWebServer           *webServer;

@property (nonatomic, assign, getter = isFlying)          BOOL     flying;

@end

@implementation PKDKiteViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.selectedDomain = objc_dynamic_cast(PKKDomain, [[PKKManager sharedManager].domains lastObject]);
    self.domainButton.titleLabel.minimumScaleFactor = .5;
    [self updateDomainButton];
    
    self.flying = NO;
 }

- (void)setFlying:(BOOL)flying {
    _flying = flying;
    self.flyButton.enabled = ! flying;
    self.landButton.enabled = flying;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)handleFly:(id)sender{
    PKKManager *manager = [PKKManager sharedManager];
    [manager destroyAllKites];
    [self startWebServer];
    [manager addKiteWithName:@"iOS Kite"
                    protocol:[PKKProtocols protocolServiceNames][@(PKKProtocolHttp)]
                    remoteIp:self.selectedDomain.name
                  remotePort:@80
                     localIp:@"127.0.0.1"
                   localPort:@8123];
    [manager flyKites];
    self.flying = YES;
}

- (IBAction)handleLand:(id)sender{
    [[PKKManager sharedManager] landKites];
    [self stopWebServer];
    self.flying = NO;
}

- (void) startWebServer {
    self.webServer = [[GCDWebServer alloc] init];
    
    [self.webServer addDefaultHandlerForMethod:@"GET"
                                  requestClass:[GCDWebServerRequest class]
                                  processBlock:^GCDWebServerResponse *(GCDWebServerRequest* request) {
                                 
                        return [GCDWebServerDataResponse responseWithHTML:@"<html><body><p>Hello World from iPhone</p></body></html>"];
                                 
                                  }];
    
    BOOL status = [self.webServer startWithPort:8123 bonjourName:nil];
    if (! status) {
        [[PKKManager sharedManager] addLogMessage:@"Failed to start webserver on port:8123"];
    }

}

- (void) stopWebServer {
    [self.webServer stop];
    self.webServer = nil;
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


#pragma mark - Domain Picker

- (void)updateDomainButton {
    [self.domainButton setTitle:self.selectedDomain.name forState:UIControlStateNormal];
    [self.domainButton setTitle:self.selectedDomain.name forState:UIControlStateSelected];
    [self.domainButton setTitle:self.selectedDomain.name forState:UIControlStateHighlighted];
}

- (IBAction)handleDomainPicker:(id)sender {
    self.domainPicker = [[RMPickerViewController alloc] init];
    self.domainPicker.delegate = self;
    [self.domainPicker show];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [[PKKManager sharedManager].domains count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    PKKDomain *domain = [PKKManager sharedManager].domains[row];
    return domain.name;
}

#pragma mark - RMPickerViewController Delegates
- (void)pickerViewController:(RMPickerViewController *)vc didSelectRows:(NSArray  *)selectedRows {
    NSUInteger selection = [[selectedRows firstObject] integerValue];
    self.selectedDomain = objc_dynamic_cast(PKKDomain, [[PKKManager sharedManager].domains objectAtIndex:selection]);
    [self updateDomainButton];
}

- (void)pickerViewControllerDidCancel:(RMPickerViewController *)vc {
    //Do something else
}

- (UITabBarItem *)tabBarItem {
    static dispatch_once_t onceToken;
    static UITabBarItem *_tbi = nil;
    dispatch_once(&onceToken, ^{
        _tbi = [[UITabBarItem alloc] initWithTitle:@"Kites" image:nil tag:1];
    });
    return _tbi;
}

@end
