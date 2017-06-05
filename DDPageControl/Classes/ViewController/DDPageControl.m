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
@property (nonatomic, strong) DDPagePresenter *presenter;
@property (nonatomic, strong) NSMutableDictionary *operations;

- (void)dd_configuration;
- (void)dd_addUI;
- (void)dd_fetchData;
- (void)dd_reset;

@end


@implementation DDPageControl

- (void)dealloc {
    NSLog(@"222 %@",self);
}

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
    [self dd_configuration];
    [self dd_addUI];
    [self dd_fetchData];
    [self dd_reset];

}

- (void)dd_configuration {
    
    _operations = NSMutableDictionary.dictionary;

    _presenter = DDPagePresenter.new;
    _presenter.titleFont = _titleFont;
 
    _barManager = [DDPageBarManager initWithPresenter:_presenter];
    _barManager.selectedTitleColor = _selectedTitleColor;
    _barManager.titleFont = _titleFont;
    _barManager.titleColor = _titleColor;
    _barManager.delegate = self;
    
    _contentManager = [DDPageContentManager initWithPresenter:_presenter];
    _contentManager.delegate = self;
}

- (void)dd_addUI {
    
    _barManager.pageBar.frame = _barFrame;
    [self.view addSubview:_barManager.pageBar];
    [_barManager.pageBar addSubview:_barManager.indicatorLayer];
    [self.view addSubview:_contentManager.contentView];
    
    _contentManager.contentView.scrollEnabled = _scrollEnabled;
    _contentManager.contentView.frame = CGRectMake(0, CGRectGetHeight(_barFrame), self.view.frame.size.width, self.view.frame.size.height - CGRectGetHeight(_barFrame));
    [_contentManager setContentViewWithitemSize:_contentManager.contentView.frame.size];
}

- (void)dd_fetchData {
  
    if (!_controllers.count) return;
    
    [_presenter  fetchDatasWithViewWidth:self.view.frame.size.width controllers:_controllers completionHandler:^{
        CGRect rect = _barManager.indicatorLayer.frame;
        DDPageModel *model = _presenter.cellModels[_defaultSelected];
        rect.size.width = model.originalItemWidth - 20;
        rect.origin.x = model.originalItemX + 10;
        _barManager.indicatorLayer.frame = rect;
        _barManager.indicatorLayer.backgroundColor = _scrollLineColor;
    }];
}

- (void)dd_reset {
    
    if (!_controllers.count) return;
    if (_defaultSelected >= _controllers.count) {
        // 越界处理
        _defaultSelected = _controllers.count - 1;
    }
    
    
    if ([_delegate respondsToSelector:@selector(pageBar:didSelectedViewController:scrollToIndex:)]) {
        [_delegate slideSegment:self didSelectedViewController:_controllers[_defaultSelected] index:_defaultSelected];
    }

    // 初始化Size
    CGSize conentSize = CGSizeMake(CGRectGetWidth(self.view.frame) * _controllers.count, 0);
    [_contentManager.contentView setContentSize:conentSize];
    
    //  代码控制是不会启动懒加载的
    [_contentManager contentViewToSelectIndex:_defaultSelected animated:NO];
}

- (void)reloadData {
    [self dd_fetchData];
    [self dd_reset];
}

#pragma mark - DDPageBarManagerDelegate
#pragma mark  点击pageBar 触发

- (void)pageBar:(DDPageBar *)pageBar didSelectedViewController:(UIViewController *)viewController scrollToIndex:(NSInteger)scrollToIndex {
    
    if ([_delegate respondsToSelector:@selector(pageBar:didSelectedViewController:scrollToIndex:)]) {
        [_delegate slideSegment:self didSelectedViewController:viewController index:scrollToIndex];
    }
    _defaultSelected = scrollToIndex;
    [_contentManager contentViewToSelectIndex:scrollToIndex animated:YES];
}

#pragma mark - DDPageContentManagerDelegate
#pragma mark 点击pageBarItem或者直接滑动contentView 都会触发

- (void)contentViewDidScroll:(UIScrollView *)scrollView {
    [_barManager refreshPageBarFromContentView:scrollView];
}

#pragma mark contentView 懒加载触发

- (void)contentView:(DDPageContentView *)contentView didSelectedViewController:(UIViewController *)viewController scrollToIndex:(NSInteger)scrollToIndex {
    
    if ([_delegate respondsToSelector:@selector(contentView:didSelectedViewController:scrollToIndex:)]) {
        [_delegate slideSegment:self didSelectedViewController:viewController index:scrollToIndex];
    }
}

@end
