//
//  DDPageControl.m
//  DDKit
//
//  Created by Song on 16/9/26.
//  Copyright © 2016年 https://github.com/China-ZWS. All rights reserved.
//

#import "DDPageControl.h"

#import "DDPageDefine.h"

// manager
#import "DDPageBarManager.h"
#import "DDPageContentManager.h"



@interface DDPageControl () <DDPageBarManagerDelegate,DDPageContentManagerDelegate>

@property (nonatomic, strong) DDPageBarManager *barManager;
@property (nonatomic, strong) DDPageContentManager *contentManager;

@end

@implementation DDPageControl

- (void)configWithData {
    _scrollLineColor = [UIColor redColor];
    _titleColor = [UIColor blackColor];
    _titleFont = DDPageFont(15);
    _selectedTitleColor = [UIColor redColor];
    _defaultSelected = 0;
    _scrollEnabled = YES;
    _barFrame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44);
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configuration];
    [self addUI];
    [self reloadData];
}

- (void)configuration {
    DDPageBarPresenter *barPresenter = DDPageBarPresenter.new;
    barPresenter.controllers = _controllers;
    barPresenter.titleFont = _titleFont;
    _barManager = [DDPageBarManager initWithPresenter:barPresenter];
    _barManager.selectedTitleColor = _selectedTitleColor;
    _barManager.titleFont = _titleFont;
    _barManager.titleColor = _titleColor;
    _barManager.delegate = self;
    
    _contentManager = [DDPageContentManager initWithPresenter:DDPageContentPresenter.new];
    _contentManager.delegate = self;
}

- (void)addUI {
    
    _barManager.pageBar.frame = _barFrame;
    [self.view addSubview:_barManager.pageBar];
    [_barManager.pageBar addSubview:_barManager.indicatorLayer];
    [self.view addSubview:_contentManager.contentView];
    
    _contentManager.contentView.scrollEnabled = _scrollEnabled;
    _contentManager.contentView.frame = CGRectMake(0, CGRectGetHeight(_barFrame), self.view.frame.size.width, self.view.frame.size.height - CGRectGetHeight(_barFrame));
    [_contentManager setContentViewWithitemSize:_contentManager.contentView.frame.size];
}

- (void)reloadData {
    if (!_controllers.count) return;
    
    [_barManager.presenter  fetchDatasWithViewWidth:self.view.frame.size.width completionHandler:^{
        CGRect rect = _barManager.indicatorLayer.frame;
        DDPageModel *model = _barManager.presenter.cellModels.firstObject;
        rect.size.width = model.originalItemWidth - 20;
        rect.origin.x = 10;
        _barManager.indicatorLayer.frame = rect;
        _barManager.indicatorLayer.backgroundColor = _scrollLineColor;
    }];
    [_contentManager.presenter fetchControllersWithControllers:_controllers completionHandler:^{
    }];
    [self reset];
}

- (void)reset {
    NSLog(@"%zd",_defaultSelected);
    [self scrollToViewWithIndex:_defaultSelected animated:NO];
}

- (void)scrollToViewWithIndex:(NSInteger)index animated:(BOOL)animated {
    [_contentManager scrollToViewWithIndex:index animated:animated];
}

#pragma mark - DDPageBarManagerDelegate

- (void)slideSegment:(UICollectionView *)segmentBar didSelectedViewController:(UIViewController *)viewController indexPath:(NSIndexPath *)indexPath {
    [self scrollToViewWithIndex:indexPath.row animated:YES];
}

- (BOOL)slideSegment:(UICollectionView *)segmentBar shouldSelectViewController:(UIViewController *)viewController {
    BOOL flag = YES;
    if ([_delegate respondsToSelector:@selector(slideSegment:shouldSelectViewController:)]) {
        flag =   [_delegate slideSegment:segmentBar shouldSelectViewController:viewController];
    }
    return flag;
}

#pragma mark - DDPageContentManagerDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [_barManager scrollViewDidScroll:scrollView];
}


@end
