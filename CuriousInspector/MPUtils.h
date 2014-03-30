//
//  MPUtils.h
//  curious
//
//  Created by Alex Manzella on 30/03/14.
//  Copyright (c) 2014 Alex Manzella. All rights reserved.
//

#ifndef curious_MPUtils_h
#define curious_MPUtils_h

#import "UIView+Frame.h"




#define MPDEBUG

#ifdef MPDEBUG

#define	MPLog(x,...)                                  NSLog(@"%s - %@", __FUNCTION__, [NSString stringWithFormat:(x), ##__VA_ARGS__])
#define MPLogHighlited(x,...)   NSLog(@"\033[bg210,0,0;\033[fg255,255,255;%s - %@ \033[;", __FUNCTION__, [NSString stringWithFormat:(x), ##__VA_ARGS__])
#define	MFLogSimple(x)                                      NSLog(@"%s %d: %@", __FUNCTION__, __LINE__,x);

#else

#define	MPLog(x,...)
#define MPLogHighlited(x,...)
#define	MFLogSimple(x)

#endif






#endif
