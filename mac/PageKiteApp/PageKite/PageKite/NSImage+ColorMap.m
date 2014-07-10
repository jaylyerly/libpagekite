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

/**
 *  Take an image and clamp all colors to the given color, except the alpha channel.
 *  For an icon with transparency, it makes all the visible colors the same, leaving all
 *  the transparent areas unaffected.
 *
 *  @return New UIImage with the whitened image
 */
- (NSImage *)clampToColor:(NSColor *)theColor{
    
    CGSize size = self.size;
    
    NSColorSpaceModel cSpace = theColor.colorSpace.colorSpaceModel;

    // For unknown color space, don't clamp anything.
    CIVector *colorMin = [[CIVector alloc] initWithX:0.0f
                                                   Y:0.0f
                                                   Z:0.0f
                                                   W:0.0f];
    CIVector *colorMax = [[CIVector alloc] initWithX:1.0f
                                                   Y:1.0f
                                                   Z:1.0f
                                                   W:1.0f];
    
    // extract the color correctly, depending on colorspace
    switch (cSpace) {
        case NSGrayColorSpaceModel:
            colorMin = [[CIVector alloc] initWithX:theColor.whiteComponent
                                                 Y:theColor.whiteComponent
                                                 Z:theColor.whiteComponent
                                                 W:0.0f];
            colorMax = [[CIVector alloc] initWithX:theColor.whiteComponent
                                                 Y:theColor.whiteComponent
                                                 Z:theColor.whiteComponent
                                                 W:1.0f];
            break;
        case NSRGBColorSpaceModel:
            colorMin = [[CIVector alloc] initWithX:theColor.redComponent
                                                 Y:theColor.greenComponent
                                                 Z:theColor.blueComponent
                                                 W:0.0f];
            colorMax = [[CIVector alloc] initWithX:theColor.redComponent
                                                 Y:theColor.greenComponent
                                                 Z:theColor.blueComponent
                                                 W:1.0f];
            break;

        default:
            break;
    }
    
    CIContext *context = [CIContext contextWithCGContext:[[NSGraphicsContext currentContext] graphicsPort]
                                                 options:nil];
    CIImage *image = [CIImage imageWithData:[self TIFFRepresentation]];
    CIFilter *filter = [CIFilter filterWithName:@"CIColorClamp"];
    [filter setValue:image forKey:kCIInputImageKey];
    [filter setValue:colorMin forKey:@"inputMinComponents"];
    [filter setValue:colorMax forKey:@"inputMaxComponents"];
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    CGRect extent = [result extent];
    CGImageRef cgImage = [context createCGImage:result fromRect:extent];
    return [[NSImage alloc] initWithCGImage:cgImage size:size];
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
