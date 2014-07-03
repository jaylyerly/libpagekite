//
//  PKKCompilerMacros.h
//  PageKiteKit
//
//  Created by Jay Lyerly on 7/3/14.
//  Copyright (c) 2014 SonicBunny Software. All rights reserved.
//

#ifndef PageKiteKit_PKKCompilerMacros_h
#define PageKiteKit_PKKCompilerMacros_h

#define objc_dynamic_cast(TYPE, object) \
({ \
TYPE *dyn_cast_object = (TYPE*)(object); \
[dyn_cast_object isKindOfClass:[TYPE class]] ? dyn_cast_object : nil; \
})


#endif
