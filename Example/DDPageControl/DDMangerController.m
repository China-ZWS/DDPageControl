//
//  DDMangerController.m
//  DDPageControl
//
//  Created by 周文松 on 2017/4/24.
//  Copyright © 2017年 China-ZWS. All rights reserved.
//

#import "DDMangerController.h"

@implementation DDMangerController

- (instancetype) initWithControllers:(NSArray *)controllers {
    if ((self = [super initWithControllers:controllers])) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(dismiss)];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = [UIColor grayColor];
    self.navigationController.navigationBar.translucent = NO;
}
- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
