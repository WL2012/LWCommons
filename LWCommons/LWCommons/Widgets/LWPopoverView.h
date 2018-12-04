//
//  LWPopoverView.h
//  
//
//  Created by wangliang on 2017/7/3.
//  Copyright © 2017年 wangliang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LWView.h"

typedef NS_ENUM(NSInteger, LWPopoverViewDirection) {
    LWPopoverViewDirectionFromTop,
    LWPopoverViewDirectionFromCenter,
    LWPopoverViewDirectionFromBottom,
};

typedef NS_ENUM(NSInteger, LWPopoverViewCloseDirection) {
    LWPopoverViewCloseDirectionFromTop,
    LWPopoverViewCloseDirectionFromCenter,
    LWPopoverViewCloseDirectionFromBottom,
};

typedef NS_ENUM(NSInteger, LWPopoverViewPosition) {
    LWPopoverViewPositionTop,
    LWPopoverViewPositionMiddle,
    LWPopoverViewPositionBottom,
    LWPopoverViewPositionCustom,
};

@interface LWPopoverView : LWView
{
    LWView *_maskView;
    BOOL _enableDynamicAnimator;
}
@property (nonatomic, copy) void (^popviewWillShow)(LWPopoverView *view);
@property (nonatomic, copy) void (^popviewDidShow)(LWPopoverView *view);
@property (nonatomic, copy) void (^popviewWillClose)(LWPopoverView *view);
@property (nonatomic, copy) void (^popviewDidClose)(LWPopoverView *view);

@property (nonatomic, assign) BOOL closable; // Enable tap to close
@property (nonatomic, assign) BOOL enableDynamicAnimator;

@property (nonatomic, assign) LWPopoverViewDirection direction;
@property (nonatomic, assign) LWPopoverViewPosition position;
@property (nonatomic, assign) CGFloat positionY; // Only take effect when position set to LWPopoverViewPositionCustom
@property (nonatomic, assign) LWPopoverViewCloseDirection closeDirection;
@property (nonatomic, strong) UIColor *maskColor;

- (void)show;
- (void)showInView:(UIView *)view;
- (void)close;
- (void)closeOnCompletion:(void(^)(LWPopoverView *popoverView))completionBlock;

@end

