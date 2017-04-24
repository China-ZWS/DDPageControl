//
//  DDAViewController.m
//  DDPageControl
//
//  Created by 周文松 on 2017/4/24.
//  Copyright © 2017年 China-ZWS. All rights reserved.
//

#import "DDAViewController.h"

@interface DDAViewController ()

@end

@implementation DDAViewController

- (instancetype) init {
    if ((self = [super init])) {
        self.title = @"国级";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    // Do any additional setup after loading the view.
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
