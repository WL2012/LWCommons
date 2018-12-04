//
//  LWNavigationController.m
//  EasyGames
//
//  Created by wangliang on 9/1/14.
//  Copyright (c) 2014 iEasynote. All rights reserved.
//

#import "LWNavigationController.h"

@interface LWNavigationController ()

@end

@implementation LWNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _autorotate = NO;
        _orientationMask = UIInterfaceOrientationMaskAll;
        _preferredOrientation = UIInterfaceOrientationPortrait;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void) setAutorotate:(BOOL)autorotate{
    _autorotate = autorotate;
}

- (BOOL) isAutorotate{
    return _autorotate;
}

- (void) setOrientationMask:(UIInterfaceOrientationMask)orientationMask{
    _orientationMask = orientationMask;
}

- (void) setPreferredOrientation:(UIInterfaceOrientation)preferredOrientation{
    _preferredOrientation = preferredOrientation;
}

- (BOOL)shouldAutorotate{
    return  _autorotate;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return _orientationMask;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return _preferredOrientation;
}

- (void) setInteractivePopGestureRecognizerEnabled:(BOOL)enabled {
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.enabled = enabled;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
