//
//  UIImage+Capture.m
//  PageKiteDemo
//
//  Created by Jay Lyerly on 6/17/14.
//  Copyright (c) 2014 SonicBunny Software. All rights reserved.
//

#import "UIImage+Capture.h"

@implementation UIImage (Capture)

+ (UIImage *) imageWithView:(UIView *)view {
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}

@end
