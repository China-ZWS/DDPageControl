//
//  DDPageModel.h
//  Pods
//
//  Created by 周文松 on 2017/5/19.
//
//

#import <Foundation/Foundation.h>

@interface DDPageModel : NSObject

@property (nonatomic, assign) CGFloat originalItemX;
@property (nonatomic, assign) CGFloat originalItemWidth;
@property (nonatomic, assign) CGFloat targetItemX;
@property (nonatomic, strong) UIColor *currentColor;
@property (nonatomic, strong) UIFont *titleFont;
@property (nonatomic, assign) CGFloat targetItemWidth;
@property (nonatomic, strong) UIViewController *viewController;
@property (nonatomic, assign) CGFloat indicatorCenterX;

@end
