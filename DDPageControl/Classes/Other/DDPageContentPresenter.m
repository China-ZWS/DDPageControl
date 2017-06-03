//
//  DDPageContentPresenter.m
//  Pods
//
//  Created by 周文松 on 2017/6/3.
//
//

#import "DDPageContentPresenter.h"

@interface DDPageContentPresenter ()

@property (nonatomic, strong) NSArray *cellModels;

@end

@implementation DDPageContentPresenter


- (void)fetchControllersWithControllers:(NSArray *)controllers completionHandler:(dispatch_block_t)completionHandler {
    self.cellModels = controllers;
    
    if ([_manager respondsToSelector:@selector(reloadData)]) {
        [_manager reloadData];
    }

    completionHandler();
}

@end
