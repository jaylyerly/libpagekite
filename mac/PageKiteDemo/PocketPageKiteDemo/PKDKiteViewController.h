//
//  PKDKiteViewController.h
//  PageKiteDemo
//
//  Created by Jay Lyerly on 6/15/14.
//  Copyright (c) 2014 SonicBunny Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface PKDKiteViewController : UIViewController

@property (nonatomic, strong)                      IBOutlet UIButton  *domainButton;
@property (nonatomic, strong)                      IBOutlet UIButton  *flyButton;
@property (nonatomic, strong)                      IBOutlet UIButton  *landButton;
@property (nonatomic, strong)                      IBOutlet UILabel   *locationLabel;
@property (nonatomic, strong)                      IBOutlet MKMapView *mapView;
@property (nonatomic, readonly, getter = isFlying)          BOOL      flying;
@property (nonatomic, readonly)                             UIImage   *mapImage;

- (IBAction)handleDomainPicker:(id)sender;
- (IBAction)handleFly:(id)sender;
- (IBAction)handleLand:(id)sender;

@end
