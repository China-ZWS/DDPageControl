//
//  DDPagePresenter.m
//  Pods
//
//  Created by 周文松 on 2017/6/3.
//
//

#import "DDPagePresenter.h"

/** 按钮之间的间距 */
static CGFloat const DDPageTitleMargin = 20;

@interface DDPagePresenter ()

@property (nonatomic, strong) NSMutableArray *cellModels;

@end

@implementation DDPagePresenter

- (instancetype) init {
    if ((self = [super init])) {
        _cellModels = NSMutableArray.array;
    }
    return self;
}

- (void)fetchDatasWithViewWidth:(CGFloat)viewWidth controllers:(NSArray *)controllers completionHandler:(dispatch_block_t)completionHandler {

    // 如果 _pageModels 有值清空
    if (_cellModels && _cellModels.count) [_cellModels removeAllObjects];
    __block CGFloat totalTextSizeWidth = 0;
    __block CGFloat maxTextSizeWidth = 0;

    // 计算所有按钮的文字宽度
    [controllers enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIViewController *vc = (UIViewController *)obj;
        CGFloat tempWidth = [self getSizeWithText:vc.title font:_titleFont] + DDPageTitleMargin;
        DDPageModel *model = DDPageModel.new;
        model.viewController = obj;
        model.originalItemX = totalTextSizeWidth;
        model.originalItemWidth = tempWidth;
        totalTextSizeWidth += tempWidth;
        model.targetItemX = totalTextSizeWidth;
        [_cellModels addObject:model];
        
        if (_defaultSelected == idx) {
            model.currentColor = _selectedTitleColor;
        } else {
            model.currentColor = _titleColor;
        }
        
        if (maxTextSizeWidth < tempWidth) {
            maxTextSizeWidth = tempWidth;
        }
    }];

    if (maxTextSizeWidth <= viewWidth / _cellModels.count) {
        maxTextSizeWidth = viewWidth / _cellModels.count;
    }
    
    if (totalTextSizeWidth <= viewWidth) {
        totalTextSizeWidth = 0;
        for (DDPageModel *model in _cellModels) {
            model.originalItemX = totalTextSizeWidth;
            model.originalItemWidth = maxTextSizeWidth;
            totalTextSizeWidth += maxTextSizeWidth;
            model.targetItemX = totalTextSizeWidth;
        }
    }
    
    completionHandler();

    if ([_pageBarManager respondsToSelector:@selector(reloadData)]) {
        [_pageBarManager reloadData];
    }
    if ([_contentViewManager respondsToSelector:@selector(reloadData)]) {
        [_contentViewManager reloadData];
    }
}


- (CGFloat)getSizeWithText:(NSString *)text font:(UIFont *)font;
{
    
    if (text.length) {
        NSDictionary * attributes = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
        NSAttributedString *attributedText =[[NSAttributedString alloc]initWithString:text attributes:attributes];
        CGRect rect = [attributedText boundingRectWithSize:CGSizeZero
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                   context:nil];
        return rect.size.width;
    }
    return 0;
}

@end
