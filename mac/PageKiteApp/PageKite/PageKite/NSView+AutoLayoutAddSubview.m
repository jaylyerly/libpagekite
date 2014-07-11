//
//  NSView+AutoLayoutAddSubview.m
//  PageKite
//
//  Created by Jay Lyerly on 7/11/14.
//  Copyright (c) 2014 SonicBunny Software. All rights reserved.
//

#import "NSView+AutoLayoutAddSubview.h"

@implementation NSView (AutoLayoutAddSubview)

- (void) autoLayoutAddSubview:(NSView *)subview {
    NSView *superview = self;
    
    [subview removeFromSuperview];      // Just in case
    [superview addSubview:subview];
    [subview setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    NSLayoutConstraint *centerY =[NSLayoutConstraint
                                  constraintWithItem:subview
                                  attribute:NSLayoutAttributeCenterY
                                  relatedBy:NSLayoutRelationEqual
                                  toItem:superview
                                  attribute:NSLayoutAttributeCenterY
                                  multiplier:1.0
                                  constant:0];
    
    NSLayoutConstraint *centerX =[NSLayoutConstraint
                                  constraintWithItem:subview
                                  attribute:NSLayoutAttributeCenterX
                                  relatedBy:NSLayoutRelationEqual
                                  toItem:superview
                                  attribute:NSLayoutAttributeCenterX
                                  multiplier:1.0
                                  constant:0];
    
    NSLayoutConstraint *width =[NSLayoutConstraint
                                constraintWithItem:subview
                                attribute:NSLayoutAttributeHeight
                                relatedBy:NSLayoutRelationEqual
                                toItem:superview
                                attribute:NSLayoutAttributeHeight
                                multiplier:1.0
                                constant:0];
    
    NSLayoutConstraint *height =[NSLayoutConstraint
                                 constraintWithItem:subview
                                 attribute:NSLayoutAttributeWidth
                                 relatedBy:NSLayoutRelationEqual
                                 toItem:superview
                                 attribute:NSLayoutAttributeWidth
                                 multiplier:1.0
                                 constant:0];
    
    [superview addConstraint:centerY];
    [superview addConstraint:centerX];
    [superview addConstraint:width];
    [superview addConstraint:height];
}


@end
