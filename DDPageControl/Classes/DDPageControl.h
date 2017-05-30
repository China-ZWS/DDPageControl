//
//  DDPageControl.h
//  DDKit
//
//  Created by Song on 16/9/26.
//  Copyright © 2016年 https://github.com/China-ZWS. All rights reserved.
//

#import <UIKit/UIKit.h>

// Protocol
#import "DDPageProtocol.h"

@interface DDPageControl : UIViewController

@property (nonatomic, assign) CGRect barFrame;
@property (nonatomic, assign) id <DDPageDelegate> delegate;
@property (nonatomic, assign) id <DDPageDataSource> dataSource;
@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, strong) UIColor *selectedTitleColor;
@property (nonatomic, strong) UIFont *titleFont;
@property (nonatomic, strong) UIColor *scrollLineColor;
@property (nonatomic, strong) NSArray *controllers;              //!< VC集合
@property (nonatomic, assign) NSInteger defaultSelected;
@property (nonatomic, assign) BOOL scrollEnabled;

- (instancetype)initWithControllers:(NSArray *)controllers;
+ (instancetype)controllers:(NSArray *)controllers;
- (void)reloadData;

@end
