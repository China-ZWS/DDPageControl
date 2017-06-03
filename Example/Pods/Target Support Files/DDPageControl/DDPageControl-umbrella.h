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

#import "DDPageBar.h"
#import "DDPageContentView.h"
#import "DDPageControl.h"
#import "DDPageDefine.h"
#import "DDPageModel.h"
#import "DDPageProtocol.h"
#import "DDPageBarManager.h"
#import "DDPageBarPresenter.h"
#import "DDPageContentManager.h"
#import "DDPageContentPresenter.h"

FOUNDATION_EXPORT double DDPageControlVersionNumber;
FOUNDATION_EXPORT const unsigned char DDPageControlVersionString[];

