//
//  PKXAlert.h
//  PageKite
//
//  Created by Jay Lyerly on 7/10/14.
//  Copyright (c) 2014 SonicBunny Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface PKXAlert : NSAlert

+ (void)showAlertMesg:(NSString *)msg info:(NSString *)info;

@end
