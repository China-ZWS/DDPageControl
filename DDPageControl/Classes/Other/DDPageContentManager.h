//
//  DDPageContentManager.h
//  Pods
//
//  Created by 周文松 on 2017/6/3.
//
//

#import <Foundation/Foundation.h>

#import "DDPageContentView.h"

#import "DDPagePresenter.h"

@protocol DDPageContentManagerDelegate <NSObject>

- (void)contentViewDidScroll:(UIScrollView *)scrollView;

- (void)contentView:(UICollectionView *)contentView didSelectedViewController:(UIViewController *)viewController scrollToIndex:(NSInteger)scrollToIndex;

- (void)contentView:(UICollectionView *)contentView didEndDisplayingViewController:(UIViewController *)viewController scrollToIndex:(NSInteger)scrollToIndex;


@end

@interface DDPageContentManager : NSObject

@property (nonatomic, readonly) DDPageContentView *contentView;               
@property (nonatomic, assign) id<DDPageContentManagerDelegate> delegate;
@property (nonatomic, assign) UIViewController *presenterController;

+ (instancetype)initWithPresenter:(DDPagePresenter *)presenter;

- (void)setContentViewWithitemSize:(CGSize)itemSize;

- (void)contentViewToSelectIndex:(NSInteger)index animated:(BOOL)animated;

@end
