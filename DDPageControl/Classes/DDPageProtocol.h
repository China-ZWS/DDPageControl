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

- (BOOL)slideSegment:(UICollectionView *)segmentBar shouldSelectViewController:(UIViewController *)viewController;

- (void)slideSegment:(UICollectionView *)segmentBar didSelectedViewController:(UIViewController *)viewController index:(NSInteger)index;

@end

@protocol DDPageDataSource <NSObject>

@required

- (NSInteger)slideSegment:(UICollectionView *)segmentBar
   numberOfItemsInSection:(NSInteger)section;

- (UICollectionViewCell *)slideSegment:(UICollectionView *)segmentBar
                cellForItemAtIndexPath:(NSIndexPath *)indexPath;

@optional

- (NSInteger)numberOfSectionsInslideSegment:(UICollectionView *)segmentBar;

@end
