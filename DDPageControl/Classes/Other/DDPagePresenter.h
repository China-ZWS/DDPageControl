//
//  DDPagePresenter.h
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

@protocol DDPageContentViewPresenterDelegate <NSObject>

- (void)reloadData;

@end

@interface DDPagePresenter : NSObject

@property (nonatomic, readonly) NSArray <DDPageModel *>*cellModels;
@property (nonatomic, assign) id<DDPageBarPresenterDelegate>pageBarManager;
@property (nonatomic, assign) id<DDPageContentViewPresenterDelegate>contentViewManager;

@property (nonatomic, assign) NSInteger defaultSelected;
@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, strong) UIColor *selectedTitleColor;
@property (nonatomic, strong) UIFont *titleFont;
@property (nonatomic, strong) UIColor *scrollLineColor;

@property (nonatomic, strong) NSOperationQueue *queue;


- (void)fetchDatasWithViewWidth:(CGFloat)viewWidth controllers:(NSArray *)controllers completionHandler:(dispatch_block_t)completionHandler;

@end
