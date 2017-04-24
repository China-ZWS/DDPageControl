//
//  DDCViewController.m
//  DDPageControl
//
//  Created by 周文松 on 2017/4/24.
//  Copyright © 2017年 China-ZWS. All rights reserved.
//

#import "DDCViewController.h"

@interface DDCViewController ()

@end

@implementation DDCViewController

- (instancetype) init {
    if ((self = [super init])) {
        self.title = @"司厅局级";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor orangeColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
