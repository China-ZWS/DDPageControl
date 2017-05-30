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

// model
#import "DDPageModel.h"

#define SEGMENT_BAR_HEIGHT 44.f
#define INDICATOR_HEIGHT 3.f

/** 按钮之间的间距 */
static CGFloat const DDPageTitleMargin = 20;


@interface DDPageControl () <UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) DDPageBar *pageBar;                //!< bar
@property (nonatomic, strong) DDPageContentView *contentView;    //!< 滑动内容
@property (nonatomic) NSInteger selectedIndex;                   //!< 选中的下标
@property (nonatomic, strong) UIView *indicatorLayer;
@property (nonatomic, assign) NSInteger startOffsetX;            //!< 记录刚开始时的偏移量

@property (nonatomic, strong) NSMutableArray *pageModels;

@end

@implementation DDPageControl

- (void)configWithData {
    _selectedIndex = NSNotFound;
    _scrollLineColor = [UIColor redColor];
    _titleColor = [UIColor blackColor];
    _titleFont = DDPageFont(15);
    _selectedTitleColor = [UIColor redColor];
    _pageModels = NSMutableArray.array;
    _defaultSelected = 0;
}

- (instancetype)init {
    if ((self = [super init])) {
        [self configWithData];
    }
    return self;
}

+ (instancetype)controllers:(NSArray *)controllers {
    DDPageControl *control = [[self alloc] init];
    control.controllers = controllers;
    return control;
}

- (instancetype)initWithControllers:(NSArray *)controllers
{
    if ((self = [super init])) {
        [self configWithData];
        self.controllers = controllers;
    }
    return self;
}

- (CGFloat)getSizeWithText:(NSString *)text font:(UIFont *)font;
{
    
    if (text.length) {
        NSDictionary * attributes = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
        NSAttributedString *attributedText =[[NSAttributedString alloc]initWithString:text attributes:attributes];
        CGRect rect = [attributedText boundingRectWithSize:CGSizeZero
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                   context:nil];
        return rect.size.width;
    }
    return 0;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // 内部组件
    [self setUpViews];
    
    [self reloadData];
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

- (void)reloadData {
    if (!_controllers.count) return;
    
    // 如果 _pageModels 有值清空
    if (_pageModels && _pageModels.count) [_pageModels removeAllObjects];
    
    __block CGFloat totalTextSizeWidth = 0;
    __block CGFloat maxTextSizeWidth = 0;
    // 计算所有按钮的文字宽度
    [_controllers enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIViewController *vc = (UIViewController *)obj;
        CGFloat tempWidth = [self getSizeWithText:vc.title font:_titleFont] + DDPageTitleMargin;
        DDPageModel *model = DDPageModel.new;
        model.viewController = obj;
        model.originalItemX = totalTextSizeWidth;
        model.originalItemWidth = tempWidth;
        totalTextSizeWidth += tempWidth;
        model.targetItemX = totalTextSizeWidth;
        [_pageModels addObject:model];
        
        if (_defaultSelected == idx) {
            model.currentColor = _selectedTitleColor;
        } else {
            model.currentColor = _titleColor;
        }
        
        if (maxTextSizeWidth < tempWidth) {
            maxTextSizeWidth = tempWidth;
        }
    }];
    
    if (maxTextSizeWidth <= self.view.frame.size.width / _pageModels.count) {
        maxTextSizeWidth = self.view.frame.size.width / _pageModels.count;
    }
    
    if (totalTextSizeWidth <= self.view.frame.size.width) {
        totalTextSizeWidth = 0;
        for (DDPageModel *model in _pageModels) {
            model.originalItemX = totalTextSizeWidth;
            model.originalItemWidth = maxTextSizeWidth;
            totalTextSizeWidth += maxTextSizeWidth;
            model.targetItemX = totalTextSizeWidth;
        }
    }
    
    CGRect rect = _indicatorLayer.frame;
    DDPageModel *model = _pageModels.firstObject;
    rect.size.width = model.originalItemWidth - 20;
    rect.origin.x = 10;
    _indicatorLayer.frame = rect;
    _indicatorLayer.backgroundColor = _scrollLineColor;
    [_pageBar reloadData];
    [self reset];

}


#pragma mark - 初始化segmentBarLayout

- (UICollectionViewFlowLayout *)segmentBarLayout
{
    UICollectionViewFlowLayout *segmentBarLayout = [[UICollectionViewFlowLayout alloc] init];
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
            content = [[DDPageContentView alloc] initWithFrame:CGRectMake(0,CGRectGetHeight(_pageBar.frame), CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - CGRectGetHeight(_pageBar.frame))];
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
    CGSize conentSize = CGSizeMake(CGRectGetWidth(self.view.frame) * _pageModels.count, 0);
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
            CGRect frame = CGRectMake(0, CGRectGetHeight(_pageBar.frame) - INDICATOR_HEIGHT, 0, INDICATOR_HEIGHT);
            layer = UIView.new;
            layer.frame = frame;
        }
        layer;
    });
}

#pragma mark - delegate or dataSource

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    if (_pageModels.count > 0) {
        DDPageModel *model = _pageModels[indexPath.row];
        return CGSizeMake(model.originalItemWidth, SEGMENT_BAR_HEIGHT);
    }
    return CGSizeZero;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if ([_dataSource respondsToSelector:@selector(slideSegment:numberOfItemsInSection:)]) {
        return [_dataSource slideSegment:collectionView numberOfItemsInSection:section];
    }
    return _pageModels.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{

    if ([_dataSource respondsToSelector:@selector(slideSegment:cellForItemAtIndexPath:)]) {
        return [_dataSource slideSegment:collectionView cellForItemAtIndexPath:indexPath];
    }
    DDPageModel *model = _pageModels[indexPath.row];

    DDPageBarItem *barItem = [collectionView dequeueReusableCellWithReuseIdentifier:@"title" forIndexPath:indexPath];

    barItem.titleLabel.textColor = model.currentColor;
    barItem.titleLabel.font = _titleFont;

    barItem.titleLabel.text = model.viewController.title;
    if (_selectedIndex == indexPath.row) {
        barItem.titleLabel.highlighted = YES;
    }

    return barItem;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.row < 0 || indexPath.row >= _pageModels.count) {
        return NO;
    }

    BOOL flag = YES;
    UIViewController *vc = _pageModels[indexPath.row];
    if ([_delegate respondsToSelector:@selector(slideSegment:shouldSelectViewController:)]) {
        flag = [_delegate slideSegment:collectionView shouldSelectViewController:vc];
    }
    return flag;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < 0 || indexPath.row >= _pageModels.count) {
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
        
        CGFloat percent = scrollView.contentOffset.x / scrollView.contentSize.width;
        NSInteger index = round(percent * _pageModels.count);
        if (index >= 0 && index < _pageModels.count)
        {
            [self setSelectedIndex:index];
        }
        
        CGFloat currentOffsetX = scrollView.contentOffset.x;
        CGFloat scrollViewW = scrollView.bounds.size.width;
        CGFloat progress = 0;
        NSInteger currentModelIndex = 0;
        DDPageModel *model = nil;
        
        if (currentOffsetX > self.startOffsetX) { // 左滑
            currentModelIndex = scrollView.contentOffset.x / scrollView.bounds.size.width;
            model = _pageModels[currentModelIndex];
            if (currentModelIndex + 1 < _pageModels.count) {
                DDPageModel *targetModel = _pageModels[currentModelIndex + 1];
                model.targetItemWidth = targetModel.originalItemWidth;
            }
            
            progress = currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW);
            CGFloat offsetX = model.originalItemWidth * progress;
            CGFloat distance = progress * (model.targetItemWidth - model.originalItemWidth);
            
            
            CGRect frame = _indicatorLayer.frame;
            frame.origin.x =  model.originalItemX + offsetX + 10;
            frame.size.width = model.originalItemWidth + distance - 20;
            _indicatorLayer.frame = frame;
            
        } else {
            currentModelIndex = scrollView.contentOffset.x / scrollView.bounds.size.width + 1;
            model = _pageModels[currentModelIndex];
            if (currentModelIndex - 1 >= 0) {
                DDPageModel *targetModel = _pageModels[currentModelIndex - 1];
                model.targetItemWidth = targetModel.originalItemWidth;
            }
            progress = 1 - (currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW));
            CGFloat offsetX = model.targetItemWidth * progress;
            CGFloat distance = progress * (model.targetItemWidth - model.originalItemWidth);
           
            CGRect frame = _indicatorLayer.frame;
            frame.origin.x =  model.originalItemX - offsetX + 10;
            frame.size.width = model.originalItemWidth + distance - 20;
            _indicatorLayer.frame = frame;
            
        }
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _startOffsetX = scrollView.contentOffset.x;
}

- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    if (_selectedIndex == selectedIndex) return;

    [_pageBar scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:selectedIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    
    DDPageModel *targetModel = _pageModels[selectedIndex];
    targetModel.currentColor = _selectedTitleColor;
    if (_selectedIndex >=0 && _selectedIndex < _pageModels.count) {
        DDPageModel *originalModel = _pageModels[_selectedIndex];
        originalModel.currentColor = _titleColor;
    }
    
    [_pageBar reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:selectedIndex inSection:0],[NSIndexPath indexPathForRow:_selectedIndex inSection:0]]];

    
    NSParameterAssert(selectedIndex >= 0 && selectedIndex < _pageModels.count);

    DDPageModel *model = [_pageModels objectAtIndex:selectedIndex];
    UIViewController *toSelectController = model.viewController;

    if (!model.viewController.parentViewController) {
        [self addChildViewController:toSelectController];
        CGRect rect = _contentView.bounds;
        rect.origin.x = rect.size.width * selectedIndex;
        toSelectController.view.frame = rect;
        [_contentView addSubview:toSelectController.view];
        [toSelectController didMoveToParentViewController:self];
    }
    [self.view endEditing:YES];
    _selectedIndex = selectedIndex;
    if ([_delegate respondsToSelector:@selector(slideSegment:didSelectedViewController:index:)]) {
        [_delegate slideSegment:_pageBar didSelectedViewController:toSelectController index:selectedIndex];
    }

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

@end
