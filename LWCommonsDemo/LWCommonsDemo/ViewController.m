//
//  ViewController.m
//  LWCommonsDemo
//
//  Created by wangliang on 2018/12/4.
//  Copyright © 2018年 wangliang. All rights reserved.
//

#import "ViewController.h"
#import <LWCommons/Commons.h>
#import <LWCommons/Constants.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    LWButton *btn = [[LWButton alloc] initWithFrame:CGRectMake(0, 200, 100, 30) andRadius:5];
    btn.backgroundColor = kRedColor;
    [self.view addSubview:btn];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
