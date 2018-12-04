//
//  LWNavigationController.h
//  EasyGames
//
//  Created by wangliang on 9/1/14.
//  Copyright (c) 2014 iEasynote. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LWNavigationController : UINavigationController
{
    BOOL _autorotate;
    UIInterfaceOrientationMask _orientationMask;
    UIInterfaceOrientation _preferredOrientation;
}
@property (nonatomic, assign, readwrite, setter = setAutorotate:, getter = isAutorotate) BOOL autorotate;
- (void) setOrientationMask:(UIInterfaceOrientationMask) orientationMask;
- (void) setPreferredOrientation:(UIInterfaceOrientation) preferredOrientation;
- (void) setInteractivePopGestureRecognizerEnabled:(BOOL) enabled;
@end
