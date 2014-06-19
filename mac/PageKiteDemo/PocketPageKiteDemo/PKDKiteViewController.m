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
#import "PKDWebServer.h"
#import "PKDLocationMgr.h"

#import "UIImage+Capture.h"

@interface PKDKiteViewController () <RMPickerViewControllerDelegate, PKDLocationMgrWatcher, MKMapViewDelegate>

@property (nonatomic, strong) RMPickerViewController *domainPicker;
@property (nonatomic, strong) PKKDomain              *selectedDomain;
@property (nonatomic, strong) PKDWebServer           *webServer;
@property (nonatomic, strong) UIImage                *mapImage;

@property (nonatomic, assign, getter = isFlying)          BOOL     flying;

@end

@implementation PKDKiteViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.selectedDomain = objc_dynamic_cast(PKKDomain, [[PKKManager sharedManager].domains lastObject]);
    self.domainButton.titleLabel.minimumScaleFactor = .5;
    [self updateDomainButton];
    
    [[PKDLocationMgr sharedManager] addWatcher:self];
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    
    self.flying = NO;
 }

- (void)setFlying:(BOOL)flying {
    _flying = flying;
    self.flyButton.enabled = ! flying;
    self.landButton.enabled = flying;
}

- (void)updateLocationLabel {
    CLLocationCoordinate2D coord = [[PKDLocationMgr sharedManager] currentLocation];
    NSString *locString = [NSString stringWithFormat:@"Latitude: %0.2f Longitude: %0.2f", coord.latitude, coord.longitude];
    self.locationLabel.text = locString;
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
    self.webServer = [[PKDWebServer alloc] init];
    self.webServer.kiteVC = self;
    [self.webServer enable];
}

- (void) stopWebServer {
    [self.webServer disable];
    self.webServer.kiteVC = nil;
    self.webServer = nil;
}

- (void) locationMgr:(PKDLocationMgr *)mgr location:(CLLocation *)location{
    
    MKCoordinateRegion region;
    region.center = location.coordinate;
    
    MKCoordinateSpan span;
    span.latitudeDelta  = 1; // Change these values to change the zoom
    span.longitudeDelta = 1;
    region.span = span;
    
    [self.mapView setRegion:region animated:YES];
    
    [self updateLocationLabel];
}

- (void) mapViewDidFinishLoadingMap:(MKMapView *)mapView {
    // lame hack to make sure that map has time to actually render
    [self performSelector:@selector(captureMap) withObject:nil afterDelay:1];
}

- (void) captureMap{
    UIImage *img = [UIImage imageWithView:self.mapView];
    self.mapImage = img;
}

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
        _tbi = [[UITabBarItem alloc] initWithTitle:@"Kites" image:[UIImage imageNamed:@"pagekite"] tag:1];
    });
    return _tbi;
}

@end
