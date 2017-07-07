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

#import "DDPagePresenter.h"

@protocol DDPageBarManagerDelegate <NSObject>

@optional

- (void)pageBar:(UICollectionView *)pageBar didSelectedViewController:(UIViewController *)viewController scrollToIndex:(NSInteger)scrollToIndex;

@end


@interface DDPageBarManager : NSObject

@property (nonatomic, readonly) DDPageBar *pageBar;                //!< bar
@property (nonatomic, readonly) UIView *indicatorLayer;

@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, strong) UIColor *selectedTitleColor;

@property (nonatomic, assign) id<DDPageBarManagerDelegate> delegate;

+ (instancetype)initWithPresenter:(DDPagePresenter *)presenter;

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;

- (void)refreshIndicatorLayerFromContentView:(UIScrollView *)scrollView;
- (void)refreshIndexFromContentView:(UIScrollView *)scrollView;

@end
