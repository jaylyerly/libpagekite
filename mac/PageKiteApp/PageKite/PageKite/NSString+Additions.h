//
//  NSString+Additions.h
//  PageKite
//
//  Created by Jay Lyerly on 6/27/14.
//  Copyright (c) 2014 SonicBunny Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Additions)

/**
 *  isNotEmpty
 *
 *  @return Return YES if the string has not space characters
 */
- (BOOL) isNotEmpty;

/**
 *  isEmpty
 *
 *  @return Returns YES if the string is zero length or only contains spaces
 */
- (BOOL) isEmpty;

@end
