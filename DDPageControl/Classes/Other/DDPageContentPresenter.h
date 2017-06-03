//
//  DDPageContentPresenter.h
//  Pods
//
//  Created by 周文松 on 2017/6/3.
//
//

#import <Foundation/Foundation.h>

@protocol DDPageContentPresenterDelegate <NSObject>

- (void)reloadData;

@end

@interface DDPageContentPresenter : NSObject

@property (nonatomic, readonly) NSArray *cellModels;
@property (nonatomic, assign) id<DDPageContentPresenterDelegate>manager;

- (void)fetchControllersWithControllers:(NSArray *)controllers completionHandler:(dispatch_block_t)completionHandler;

@end
