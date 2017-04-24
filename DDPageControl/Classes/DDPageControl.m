//
//  DDPageControl.m
//  DDKit
//
//  Created by Song on 16/9/26.
//  Copyright © 2016年 https://github.com/China-ZWS. All rights reserved.
//

#import "DDPageControl.h"

#import "DDPageDefine.h"

// bar
#import "DDPageBar.h"

// content
#import "DDPageContentView.h"

#define SEGMENT_BAR_HEIGHT 44.f
#define INDICATOR_HEIGHT 3.f


@interface DDPageControl () <UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) DDPageBar *pageBar;                //!< bar
@property (nonatomic, strong) DDPageContentView *contentView;    //!< 滑动内容
@property (nonatomic) NSInteger selectedIndex;                   //!< 选中的下标
@property (nonatomic, strong) UIView *indicatorLayer;

@end

@implementation DDPageControl

- (instancetype)initWithControllers:(NSArray *)controllers
{
    if ((self = [super init])) {
        _controllers = controllers;
        _selectedIndex = NSNotFound;
        _scrollLineColor = [UIColor redColor];
        _titleColor = [UIColor blackColor];
        _titleFont = DDPageFont(15);
        _selectedTitleColor = [UIColor redColor];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // 内部组件
    [self setUpViews];

    [self reset];
}



- (void)setUpViews
{
    /* bar */
    [self.view addSubview:self.pageBar];
//    /* 滑动类容快 */
    [self.view addSubview:self.contentView];
//    /* 注册item */
    [_pageBar registerClass:[DDPageBarItem class] forCellWithReuseIdentifier:@"title"];
//    /* 线条 */
    [_pageBar addSubview:self.indicatorLayer];

}

#pragma mark - 初始化segmentBarLayout

- (UICollectionViewFlowLayout *)segmentBarLayout
{
    UICollectionViewFlowLayout *segmentBarLayout = [[UICollectionViewFlowLayout alloc] init];
    segmentBarLayout.itemSize = CGSizeMake(self.view.frame.size.width / _controllers.count, SEGMENT_BAR_HEIGHT);
    segmentBarLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    segmentBarLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    segmentBarLayout.minimumLineSpacing = 0;
    segmentBarLayout.minimumInteritemSpacing = 0;
    return segmentBarLayout;
}

- (DDPageBar *)pageBar
{
    return _pageBar = ({
        DDPageBar *bar = nil;
        if (_pageBar) {
            bar = _pageBar;
        } else {
            bar = [[DDPageBar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 44) collectionViewLayout:[self segmentBarLayout]];
            bar.delegate = self;
            bar.dataSource = self;
        }
        bar;
    });
}

- (DDPageContentView *)contentView
{
    return _contentView = ({
        DDPageContentView *content = nil;
        if (_contentView) {
            content = _contentView;
        } else {
            content = [[DDPageContentView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(_pageBar.frame), CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - CGRectGetHeight(_pageBar.frame))];
            content.backgroundColor = self.view.backgroundColor;

            [content setShowsHorizontalScrollIndicator:NO];
            content.autoresizingMask = UIViewAutoresizingFlexibleHeight;
            [content setShowsVerticalScrollIndicator:NO];
            [content setPagingEnabled:YES];
            [content setBounces:NO];
            [content setDelegate:self];
        }
        content;
    });
}

- (void)reset
{
    CGSize conentSize = CGSizeMake(CGRectGetWidth(self.view.frame) * _controllers.count, 0);
    [_contentView setContentSize:conentSize];

    if (_defaultSelected == 0) {
        self.selectedIndex = 0;
    }
    [self scrollToViewWithIndex:_defaultSelected animated:NO];
}

#pragma mark - 初始化线条

- (UIView *)indicatorLayer
{
    return _indicatorLayer = ({

        UIView *layer = nil;
        if (_indicatorLayer) {
            layer = _indicatorLayer;
        } else {
            CGRect frame = CGRectMake(5, CGRectGetHeight(_pageBar.frame) - INDICATOR_HEIGHT, CGRectGetWidth(self.view.frame) / _controllers.count - 10, INDICATOR_HEIGHT);
            layer = UIView.new;
            layer.frame = frame;
            layer.backgroundColor = _scrollLineColor;
        }
        layer;
    });
}

#pragma mark - delegate or dataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if ([_dataSource respondsToSelector:@selector(slideSegment:numberOfItemsInSection:)]) {
        return [_dataSource slideSegment:collectionView numberOfItemsInSection:section];
    }
    return _controllers.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{

    if ([_dataSource respondsToSelector:@selector(slideSegment:cellForItemAtIndexPath:)]) {
        return [_dataSource slideSegment:collectionView cellForItemAtIndexPath:indexPath];
    }
    DDPageBarItem *barItem = [collectionView dequeueReusableCellWithReuseIdentifier:@"title" forIndexPath:indexPath];

    barItem.titleLabel.highlightedTextColor = _selectedTitleColor;
    barItem.titleLabel.textColor = _titleColor;
    barItem.titleLabel.font = _titleFont;

    UIViewController *vc = _controllers[indexPath.row];
    barItem.titleLabel.text = vc.title;
    if (_selectedIndex == indexPath.row) {
        barItem.titleLabel.highlighted = YES;
    }

    return barItem;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.row < 0 || indexPath.row >= _controllers.count) {
        return NO;
    }

    BOOL flag = YES;
    UIViewController *vc = _controllers[indexPath.row];
    if ([_delegate respondsToSelector:@selector(slideSegment:shouldSelectViewController:)]) {
        flag = [_delegate slideSegment:collectionView shouldSelectViewController:vc];
    }
    return flag;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < 0 || indexPath.row >= _controllers.count) {
        return;
    }
    [self scrollToViewWithIndex:indexPath.row animated:YES];
}

- (void)scrollToViewWithIndex:(NSInteger)index animated:(BOOL)animated;
{
    CGRect rect = _contentView.bounds;
    rect.origin.x = rect.size.width * index;
    [_contentView setContentOffset:CGPointMake(rect.origin.x, rect.origin.y) animated:animated];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{

    if (scrollView == _contentView) {
        // set indicator frame
        CGRect frame = _indicatorLayer.frame;
        CGFloat percent = scrollView.contentOffset.x / scrollView.contentSize.width;
        frame.origin.x = scrollView.frame.size.width * percent + 5;
        _indicatorLayer.frame = frame;
        NSInteger index = round(percent * _controllers.count);
        if (index >= 0 && index < _controllers.count)
        {
            [self setSelectedIndex:index];
        }
    }
}

- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    if (_selectedIndex == selectedIndex) return;

    DDPageBarItem *newItem = (DDPageBarItem *)[_pageBar cellForItemAtIndexPath:[NSIndexPath indexPathForRow:selectedIndex inSection:0]];
    newItem.titleLabel.highlighted = YES;

    DDPageBarItem *oldItem = (DDPageBarItem *)[_pageBar cellForItemAtIndexPath:[NSIndexPath indexPathForRow:_selectedIndex inSection:0]];
    oldItem.titleLabel.highlighted = NO;

    NSParameterAssert(selectedIndex >= 0 && selectedIndex < _controllers.count);

    UIViewController *toSelectController = [_controllers objectAtIndex:selectedIndex];
    if ([_delegate respondsToSelector:@selector(slideSegment:didSelectedViewController:index:)]) {
        [_delegate slideSegment:_pageBar didSelectedViewController:toSelectController index:selectedIndex];
    }


    //    toSelectController.title
    // Add selected view controller as child view controller
    if (!toSelectController.parentViewController) {
        [self addChildViewController:toSelectController];
        CGRect rect = _contentView.bounds;
        rect.origin.x = rect.size.width * selectedIndex;
        toSelectController.view.frame = rect;
        [_contentView addSubview:toSelectController.view];
        [toSelectController didMoveToParentViewController:self];
    }
    [self.view endEditing:YES];
    _selectedIndex = selectedIndex;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

@end
