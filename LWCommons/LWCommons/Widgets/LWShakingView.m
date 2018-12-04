//
//  LWShakingView.m
//  
//
//  Created by wangliang on 2017/7/3.
//  Copyright © 2017年 wangliang. All rights reserved.
//

#import "LWShakingView.h"

@implementation LWShakingView

- (void)dealloc{
    self.onShaking = nil;
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if ( [super respondsToSelector:@selector(motionEnded:withEvent:)] ) {
        [super motionEnded:motion withEvent:event];
    }
    if(event.subtype==UIEventSubtypeMotionShake){
        if(self.onShaking){
            self.onShaking();
        }
    }
}

- (BOOL)canBecomeFirstResponder{
    return YES;
}

@end
