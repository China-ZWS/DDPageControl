//
//  DDPageProtocol.h
//  DDKit
//
//  Created by Song on 16/9/26.
//  Copyright © 2016年 https://github.com/China-ZWS. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DDPageDelegate <NSObject>

@optional

- (NSMutableDictionary *)slideSegment:(UIViewController *)segmentBar willSelectedForOperationWithViewController:(UIViewController *)viewController index:(NSInteger)index;

- (void)slideSegment:(UIViewController *)segmentBar didSelectedViewController:(UIViewController *)viewController index:(NSInteger)index;

- (void)slideSegment:(UIViewController *)segmentBar didEndDisplayingViewController:(UIViewController *)viewController scrollToIndex:(NSInteger)scrollToIndex;

@end
