//
//  DDPageContentView.m
//  DDKit
//
//  Created by Song on 16/9/26.
//  Copyright © 2016年 https://github.com/China-ZWS. All rights reserved.
//

#import "DDPageContentView.h"

#import "DDPageDefine.h"

@implementation DDPageContentViewCell

@end

@implementation DDPageContentView

- (instancetype) initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
{
    if ((self = [super initWithFrame:frame collectionViewLayout:layout])) {
        
        self.backgroundColor = DDPageWhiteColor(1);
        self.showsHorizontalScrollIndicator = NO;
        self.pagingEnabled = YES;
        self.bounces = NO;
    }
    return self;
}

@end
