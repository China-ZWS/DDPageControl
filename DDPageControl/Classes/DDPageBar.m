//
//  DDPageBar.m
//  DDKit
//
//  Created by Song on 16/9/26.
//  Copyright © 2016年 https://github.com/China-ZWS. All rights reserved.
//

#import "DDPageBar.h"

#import "DDPageDefine.h"

@implementation DDPageBarItem

- (UILabel *)titleLabel
{

    return _titleLabel = ({

        UILabel *lb = UILabel.new;
        if (_titleLabel) {
            lb = _titleLabel;
        } else {
            lb = [[UILabel alloc] initWithFrame:self.contentView.bounds];
            lb.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
            lb.textAlignment = NSTextAlignmentCenter;
//            lb.textColor = [UIColor whiteColor];
        }
        lb;
    });
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.titleLabel];
        self.contentView.backgroundColor = DDPageWhiteColor(1);
    }
    return self;
}

@end

@interface DDPageBar ()

@property (nonatomic, strong) CALayer *line;

@end

@implementation DDPageBar

- (instancetype) initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
{
    if ((self = [super initWithFrame:frame collectionViewLayout:layout])) {

        self.backgroundColor = DDPageWhiteColor(1);

        _line = CALayer.new;
        _line.backgroundColor = DDPageLineColor.CGColor;
        [self.layer addSublayer:_line];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _line.frame = CGRectMake(0, CGRectGetHeight(self.frame) - DDPageScreenScale, CGRectGetWidth(self.frame), DDPageScreenScale);
}

@end
