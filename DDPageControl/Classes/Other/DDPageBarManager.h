//
//  DDPageBarManager.h
//  Pods
//
//  Created by 周文松 on 2017/6/3.
//
//

#import <Foundation/Foundation.h>

// bar
#import "DDPageBar.h"

#import "DDPageBarPresenter.h"

@protocol DDPageBarManagerDelegate <NSObject>

@optional

- (void)slideSegment:(UICollectionView *)segmentBar didSelectedViewController:(UIViewController *)viewController indexPath:(NSIndexPath *)indexPath;

- (BOOL)slideSegment:(UICollectionView *)segmentBar shouldSelectViewController:(UIViewController *)viewController;

@end

@protocol DDPageBarManagerDataSource <NSObject>

@required

- (NSInteger)slideSegment:(UICollectionView *)segmentBar
   numberOfItemsInSection:(NSInteger)section;

- (UICollectionViewCell *)slideSegment:(UICollectionView *)segmentBar
                cellForItemAtIndexPath:(NSIndexPath *)indexPath;

@optional

- (NSInteger)numberOfSectionsInslideSegment:(UICollectionView *)segmentBar;

@end

@interface DDPageBarManager : NSObject

@property (nonatomic, readonly) DDPageBar *pageBar;                //!< bar
@property (nonatomic, readonly) UIView *indicatorLayer;
@property (nonatomic, readonly) DDPageBarPresenter *presenter;

@property (nonatomic, strong) UIFont *titleFont;
@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, strong) UIColor *selectedTitleColor;

@property (nonatomic, assign) id<DDPageBarManagerDelegate> delegate;
@property (nonatomic, assign) id<DDPageBarManagerDataSource> dataSource;

+ (instancetype)initWithPresenter:(DDPageBarPresenter *)presenter;

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;

@end
