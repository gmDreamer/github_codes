//
//  ViewController.m
//  Anmin2
//
//  Created by linyi on 16/4/17.
//  Copyright (c) 2016 infoview. All rights reserved.
//


#import "ViewController.h"
#import "IMBlinklightView.h"

@interface ViewController ()

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    IMBlinklightView *blinklightView = [[IMBlinklightView alloc] initWithFrame:CGRectMake(50,50,5,5)];
    [self.view addSubview:blinklightView];
    [blinklightView startAnimation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end