//
//  DDPageContentManager.m
//  Pods
//
//  Created by 周文松 on 2017/6/3.
//
//

#import "DDPageContentManager.h"


static NSString *const cellIdentifier = @"DDPageContentViewCell";

@interface DDPageContentManager () <UICollectionViewDelegate, UICollectionViewDataSource,DDPageContentViewPresenterDelegate>

@property (nonatomic, strong) DDPageContentView *contentView;
@property (nonatomic, strong) DDPagePresenter *presenter;
@property (nonatomic, assign) CGSize itemSize;

@end

@implementation DDPageContentManager

- (void)dealloc {
    NSLog(@"%@",self);
}


+ (instancetype)initWithPresenter:(DDPagePresenter *)presenter {
    return [[DDPageContentManager alloc] initWithPresenter:presenter];
}

- (instancetype)initWithPresenter:(DDPagePresenter *)presenter {
    if ((self = [super init])) {
        self.presenter = presenter;
        self.presenter.contentViewManager = self;
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

- (DDPageContentView *)contentView {
    return _contentView = ({
        DDPageContentView *bar = nil;
        if (_contentView) {
            bar = _contentView;
        } else {
            bar = [[DDPageContentView alloc] initWithFrame:CGRectMake(0, 0, 1, 1) collectionViewLayout:[self segmentBarLayout]];
            [bar registerClass:[DDPageContentViewCell class] forCellWithReuseIdentifier:cellIdentifier];
            bar.delegate = self;
            bar.dataSource = self;
        }
        bar;
    });
}

- (void)setContentViewWithitemSize:(CGSize)itemSize {
    self.itemSize = itemSize;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    if (CGSizeEqualToSize(_itemSize, CGSizeZero)) {
        return CGSizeZero;
    }
    return _itemSize;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _presenter.cellModels.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DDPageContentViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    DDPageModel *pageModel = _presenter.cellModels[indexPath.row];
    
    pageModel.viewController.view.frame = CGRectMake(0, 0, CGRectGetWidth(cell.frame), CGRectGetHeight(cell.frame));
    [cell.contentView addSubview:pageModel.viewController.view];

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(nonnull UICollectionViewCell *)cell forItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    DDPageModel *pageModel = _presenter.cellModels[indexPath.row];
    if ([_delegate respondsToSelector:@selector(contentView:didEndDisplayingViewController:scrollToIndex:)]) {
        [_delegate contentView:collectionView didEndDisplayingViewController:pageModel.viewController scrollToIndex:indexPath.row];
    }
}


- (void)contentViewToSelectIndex:(NSInteger)index animated:(BOOL)animated {
   [_contentView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:animated];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
   
    if ([_delegate respondsToSelector:@selector(contentViewDidScroll:)]) {
        [_delegate contentViewDidScroll:scrollView];
    }
}

#pragma 滚动完毕就会调用（如果不是人为拖拽scrollView导致滚动完毕，才会调用这个方法）

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView; {
  
    if (!scrollView.decelerating && !scrollView.dragging) {
        [self loadLodingForOnscreenRows];
    }
}

#pragma mark - 延迟加载关键
#pragma tableView  滑动手离开屏幕 (如果是人为拖拽scrollView导致滚动完毕，才会调用这个方法）非惯性停止滑动

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) { // 手指离开
        [self loadLodingForOnscreenRows];
    }
}

#pragma 滚动完毕就会调用（如果是人为拖拽scrollView导致滚动完毕，才会调用这个方法）惯性停止滑动

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self loadLodingForOnscreenRows];
}

- (void)loadLodingForOnscreenRows {
  
    
    CGFloat percent = _contentView.contentOffset.x / _contentView.contentSize.width;
    NSInteger index = round(percent * _presenter.cellModels.count);
    
    if (index >= 0 && index < _presenter.cellModels.count)
    {
        DDPageModel *pageModel = _presenter.cellModels[index];
    
        if ([_delegate respondsToSelector:@selector(contentView:didSelectedViewController:scrollToIndex:)]) {
            [_delegate contentView:_contentView didSelectedViewController:pageModel.viewController scrollToIndex:index];
        }
    }
}

- (void)reloadData {
    [_contentView reloadData];
    [_contentView layoutIfNeeded];
}



@end
