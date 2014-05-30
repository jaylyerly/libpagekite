//
//  PKDBooleanStringTransformer.m
//  PageKiteDemo
//
//  Created by Jay Lyerly on 5/30/14.
//  Copyright (c) 2014 SonicBunny Software. All rights reserved.
//

#import "PKDBooleanStringTransformer.h"

@implementation PKDBooleanStringTransformer

+ (Class)transformedValueClass {
    return [NSString class];
}

+ (BOOL)allowsReverseTransformation {
    return NO;
}

- (id)transformedValue:(id)value {
    if ([value boolValue])
    {
        return @"Yes";
    }
    return @"No";
}

@end
