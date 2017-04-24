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
- (void)slideSegment:(UICollectionView *)segmentBar didSelectedViewController:(UIViewController *)viewController index:(NSInteger)index;

- (BOOL)slideSegment:(UICollectionView *)segmentBar shouldSelectViewController:(UIViewController *)viewController;
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
