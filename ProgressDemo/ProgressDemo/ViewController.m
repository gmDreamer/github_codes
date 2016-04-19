//
//  ViewController.m
//  ProgressDemo
//
//  Created by linyi on 16/4/13.
//  Copyright (c) 2016 infoview. All rights reserved.
//


#import "ViewController.h"
#import "IMProgressView.h"

@interface ViewController ()

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    IMProgressView *progressView = [[IMProgressView alloc] initWithFrame:CGRectMake(40,50,50,50)];
    [progressView setProgressWidth:5];
    [progressView setTrackColor:[UIColor grayColor]];
    [progressView setProgressColor:[UIColor orangeColor]];
    [progressView setProgress:0.5];
    [self.view addSubview:progressView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end