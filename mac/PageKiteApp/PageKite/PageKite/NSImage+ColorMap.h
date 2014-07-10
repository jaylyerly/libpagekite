//
//  NSImage+ColorMap.h
//  PageKite
//
//  Created by Jay Lyerly on 7/10/14.
//  Copyright (c) 2014 SonicBunny Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSImage (ColorMap)

- (NSImage *)clampToColor:(NSColor *)theColor;  // clamp image to arbitrary color
- (NSImage *)whiten;                            // clamp to [NSColor whiteColor]
- (NSImage *)blacken;                           // clamp to [NSColor blackColor]
- (NSImage *)reden;                             // clamp to [NSColor redColor]

@end
