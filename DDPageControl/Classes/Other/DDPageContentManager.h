//
//  DDPageContentManager.h
//  Pods
//
//  Created by 周文松 on 2017/6/3.
//
//

#import <Foundation/Foundation.h>

#import "DDPageContentView.h"

#import "DDPageContentPresenter.h"

@protocol DDPageContentManagerDelegate <NSObject>

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;

@end

@interface DDPageContentManager : NSObject

@property (nonatomic, readonly) DDPageContentView *contentView;               
@property (nonatomic, readonly) DDPageContentPresenter *presenter;
@property (nonatomic, assign) id<DDPageContentManagerDelegate> delegate;


+ (instancetype)initWithPresenter:(DDPageContentPresenter *)presenter;

- (void)setContentViewWithitemSize:(CGSize)itemSize;

- (void)scrollToViewWithIndex:(NSInteger)index animated:(BOOL)animated;

@end
