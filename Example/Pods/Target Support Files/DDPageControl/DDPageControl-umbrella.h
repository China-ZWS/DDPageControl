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

#import "DDPageDefine.h"
#import "DDPageProtocol.h"
#import "DDPageModel.h"
#import "DDPageBarManager.h"
#import "DDPageContentManager.h"
#import "DDPagePresenter.h"
#import "DDPageBar.h"
#import "DDPageContentView.h"
#import "DDPageControl.h"

FOUNDATION_EXPORT double DDPageControlVersionNumber;
FOUNDATION_EXPORT const unsigned char DDPageControlVersionString[];

