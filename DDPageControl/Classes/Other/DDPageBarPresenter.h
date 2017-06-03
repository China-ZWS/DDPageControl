//
//  DDPageBarPresenter.h
//  Pods
//
//  Created by 周文松 on 2017/6/3.
//
//

#import <Foundation/Foundation.h>

#import "DDPageModel.h"


@protocol DDPageBarPresenterDelegate <NSObject>

- (void)reloadData;

@end

@interface DDPageBarPresenter : NSObject

@property (nonatomic, readonly) NSArray <DDPageModel *>*cellModels;
@property (nonatomic, assign) id<DDPageBarPresenterDelegate>manager;

@property (nonatomic, strong) NSArray *controllers;              //!< VC集合
@property (nonatomic, assign) NSInteger defaultSelected;
@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, strong) UIColor *selectedTitleColor;
@property (nonatomic, strong) UIFont *titleFont;
@property (nonatomic, strong) UIColor *scrollLineColor;

- (void)fetchDatasWithViewWidth:(CGFloat)viewWidth completionHandler:(dispatch_block_t)completionHandler;

@end
