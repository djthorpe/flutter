#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "EventHandler.h"
#import "RNNetServiceSerializer.h"
#import "ZeroconfPlugin.h"

FOUNDATION_EXPORT double zeroconfVersionNumber;
FOUNDATION_EXPORT const unsigned char zeroconfVersionString[];

