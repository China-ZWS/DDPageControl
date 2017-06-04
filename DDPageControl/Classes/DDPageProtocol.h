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

- (NSMutableDictionary *)slideSegment:(UICollectionView *)segmentBar willSelectedForOperationWithViewController:(UIViewController *)viewController index:(NSInteger)index;

- (void)slideSegment:(UICollectionView *)segmentBar didSelectedViewController:(UIViewController *)viewController index:(NSInteger)index;


@end
