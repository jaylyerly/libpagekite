//
//  NSImage+ColorMap.m
//  PageKite
//
//  Created by Jay Lyerly on 7/10/14.
//  Copyright (c) 2014 SonicBunny Software. All rights reserved.
//

#import "NSImage+ColorMap.h"
#import <Quartz/Quartz.h>

@implementation NSImage (ColorMap)

- (NSImage *)clampToColor:(NSColor *)theColor{
    
    CIColor *coreColor = [CIColor colorWithCGColor:theColor.CGColor];

    CIContext *context = [CIContext contextWithCGContext:[[NSGraphicsContext currentContext] graphicsPort]
                                                 options:nil];
    CIImage *image = [CIImage imageWithData:[self TIFFRepresentation]];
    
    CIFilter *filter = [CIFilter filterWithName:@"CIColorMonochrome"];
    [filter setValue:image forKey:kCIInputImageKey];
    [filter setValue:coreColor forKey:kCIInputColorKey];
    [filter setValue:@1.0 forKey:@"inputIntensity"];
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    
    CGRect extent = [result extent];
    CGImageRef cgImage = [context createCGImage:result fromRect:extent];
    NSImage *clampedImage = [[NSImage alloc] initWithCGImage:cgImage size:self.size];
    return clampedImage ?: self;    // return original image if something went horribly wrong (like no filter, etc)
}

-(NSImage *)whiten {
    return [self clampToColor:[NSColor whiteColor]];
}

- (NSImage *)blacken{
    return [self clampToColor:[NSColor blackColor]];
}

- (NSImage *)reden{
    return [self clampToColor:[NSColor redColor]];
}

@end
