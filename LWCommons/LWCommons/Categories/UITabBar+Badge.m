//
//  UITabBar+Badge.m
//  wangliang
//
//  Created by wangliang on 16/8/4.
//  Copyright © 2016年 wangliang. All rights reserved.
//

#import "UITabBar+Badge.h"
#import "LWBadgeView.h"
#import "Constants.h"

@implementation UITabBar (Badge)

- (void)showBadgeOnItemIndex:(int)index corner:(CGFloat)corner {
    [self removeBadgeOnItemIndex:index];

    CGFloat wh = corner * 2;
    CGFloat percentX = (index + 0.56) / self.items.count;
    CGFloat x = percentX * CGRectGetWidth(self.frame);
    CGFloat y = CGRectGetHeight(self.frame) * 0.10;
    
    LWBadgeView *badgeView = [[LWBadgeView alloc] initWithFrame:CGRectMake(x, y, wh, wh)];
    badgeView.tag = 888 + index;
    badgeView.borderColor = kHRGB(0xF9F9F9);
    badgeView.borderWidth = 1.0f;
    badgeView.badgeColor = kHRGB(0xff5b49);
    
    [self addSubview:badgeView];
}

- (void)removeBadgeOnItemIndex:(int)index {
    UIView * badgeView = [self viewWithTag:(888 + index)];
    [badgeView removeFromSuperview];
}

@end
