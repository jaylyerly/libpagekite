//
//  NSString+Additions.m
//  PageKite
//
//  Created by Jay Lyerly on 6/27/14.
//  Copyright (c) 2014 SonicBunny Software. All rights reserved.
//

#import "NSString+Additions.h"

@implementation NSString (Additions)

- (BOOL) isNotEmpty {
    NSString *testString = [self stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if ( [testString isEqualToString:@""] ) {
        return NO;
    }
    return YES;
}
@end
