//
//  DDPageBarManager.m
//  Pods
//
//  Created by 周文松 on 2017/6/3.
//
//

#import "DDPageBarManager.h"

#define SEGMENT_BAR_HEIGHT 44.f
#define INDICATOR_HEIGHT 3.f

@interface DDPageBarManager () <UICollectionViewDelegate, UICollectionViewDataSource,DDPageBarPresenterDelegate>

@property (nonatomic, strong) DDPageBar *pageBar;                //!< bar
@property (nonatomic, strong) DDPagePresenter *presenter;
@property (nonatomic) NSInteger selectedIndex;                   //!< 选中的下标
@property (nonatomic, assign) NSInteger startOffsetX;            //!< 记录刚开始时的偏移量
@property (nonatomic, strong) UIView *indicatorLayer;

@end

@implementation DDPageBarManager

- (void)dealloc {
    NSLog(@"%@",self);
}

+ (instancetype)initWithPresenter:(DDPagePresenter *)presenter {
    return [[DDPageBarManager alloc] initWithPresenter:presenter];
}

- (instancetype)initWithPresenter:(DDPagePresenter *)presenter {
    if ((self = [super init])) {
        self.presenter = presenter;
        self.presenter.pageBarManager = self;
        _selectedIndex = NSNotFound;
    }
    return self;
}

#pragma mark - 初始化segmentBarLayout

- (UICollectionViewFlowLayout *)segmentBarLayout {
    UICollectionViewFlowLayout *segmentBarLayout = [[UICollectionViewFlowLayout alloc] init];
    segmentBarLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    segmentBarLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    segmentBarLayout.minimumLineSpacing = 0;
    segmentBarLayout.minimumInteritemSpacing = 0;
    return segmentBarLayout;
}

- (DDPageBar *)pageBar {
    return _pageBar = ({
        DDPageBar *bar = nil;
        if (_pageBar) {
            bar = _pageBar;
        } else {
            bar = [[DDPageBar alloc] initWithFrame:CGRectMake(0, 0, 1, 1) collectionViewLayout:[self segmentBarLayout]];
            [bar registerClass:[DDPageBarItem class] forCellWithReuseIdentifier:@"title"];
            bar.delegate = self;
            bar.dataSource = self;
        }
        bar;
    });
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
    if (_presenter.cellModels.count > 0) {
        DDPageModel *model = _presenter.cellModels[indexPath.row];
        return CGSizeMake(model.originalItemWidth, SEGMENT_BAR_HEIGHT);
    }
    return CGSizeZero;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _presenter.cellModels.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    DDPageModel *model = _presenter.cellModels[indexPath.row];
    DDPageBarItem *barItem = [collectionView dequeueReusableCellWithReuseIdentifier:@"title" forIndexPath:indexPath];
    barItem.titleLabel.textColor = model.currentColor;
    barItem.titleLabel.font = _titleFont;
    barItem.titleLabel.text = model.viewController.title;
    
    return barItem;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < 0 || indexPath.row >= _presenter.cellModels.count) {
        return;
    }
    NSLog(@"manager_row = %zd",indexPath.row);

    if (_selectedIndex == indexPath.row) return;
    
    DDPageModel *pageModel = _presenter.cellModels[indexPath.row];
    UIViewController *toSelectController = pageModel.viewController;
    if ([_delegate respondsToSelector:@selector(pageBar:didSelectedViewController:scrollToIndex:)]) {
        [_delegate pageBar:_pageBar didSelectedViewController:toSelectController scrollToIndex:indexPath.row];
    }
}

- (void)refreshIndicatorLayerFromContentView:(UIScrollView *)scrollView {
    
    CGFloat currentOffsetX = scrollView.contentOffset.x;
    CGFloat scrollViewW = scrollView.bounds.size.width;
    CGFloat progress = 0;
    NSInteger currentModelIndex = 0;
    DDPageModel *model = nil;
    
    if (currentOffsetX > _startOffsetX) { // 左滑
        currentModelIndex = scrollView.contentOffset.x / scrollView.bounds.size.width;
        model = _presenter.cellModels[currentModelIndex];
        if (currentModelIndex + 1 < _presenter.cellModels.count) {
            DDPageModel *targetModel = _presenter.cellModels[currentModelIndex + 1];
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
        if (_presenter.cellModels.count <= currentModelIndex) {
            currentModelIndex = _presenter.cellModels.count - 1;
        }
        
        model = _presenter.cellModels[currentModelIndex];
        if (currentModelIndex - 1 >= 0) {
            DDPageModel *targetModel = _presenter.cellModels[currentModelIndex - 1];
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

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _startOffsetX = scrollView.contentOffset.x;
}

- (void)refreshIndexFromContentView:(UIScrollView *)scrollView {

    CGFloat percent = scrollView.contentOffset.x / scrollView.contentSize.width;
    NSInteger index = round(percent * _presenter.cellModels.count);
    if (index >= 0 && index < _presenter.cellModels.count)
    {
        [self setSelectedIndex:index];
    }
}

- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    if (_selectedIndex == selectedIndex) return;
    
    [_pageBar scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:selectedIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    
    DDPageModel *targetModel = _presenter.cellModels[selectedIndex];
    targetModel.currentColor = _selectedTitleColor;
   
    if (_selectedIndex >=0 && _selectedIndex < _presenter.cellModels.count) {
        DDPageModel *originalModel = _presenter.cellModels[_selectedIndex];
        originalModel.currentColor = _titleColor;
    }
    
    [_pageBar reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:selectedIndex inSection:0],[NSIndexPath indexPathForRow:_selectedIndex inSection:0]]];

    
//    [UIView setAnimationsEnabled:NO];
//    [_pageBar performBatchUpdates:^{
//
//    } completion:^(BOOL finished) {
//        [UIView setAnimationsEnabled:YES];
//    }];
    
    _selectedIndex = selectedIndex;
}

- (void)reloadData {
    [_pageBar reloadData];
}


@end
