//
//  DDViewController.m
//  DDPageControl
//
//  Created by China-ZWS on 04/24/2017.
//  Copyright (c) 2017 China-ZWS. All rights reserved.
//

#import "DDViewController.h"

#import "DDMangerController.h"
#import "DDAViewController.h"
#import "DDBViewController.h"
#import "DDCViewController.h"

@interface DDViewController ()

@end

@implementation DDViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onClickWithPush:(id)sender {
    NSArray *vcs = @[DDAViewController.new,DDBViewController.new,DDCViewController.new,DDBViewController.new,DDCViewController.new,DDBViewController.new,DDCViewController.new,DDBViewController.new,DDCViewController.new];
//    DDMangerController *pageControl = [[DDMangerController alloc] initWithControllers:vcs];
//    DDMangerController *pageControl = [DDMangerController controllers:vcs];
    DDMangerController *pageControl = DDMangerController.new;
    pageControl.controllers = vcs;
    pageControl.titleColor = [UIColor blackColor];
    pageControl.selectedTitleColor = [UIColor redColor];
    pageControl.scrollEnabled = YES;
//    pageControl.defaultSelected = 1;
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:pageControl] animated:YES completion:NULL];
}

@end
