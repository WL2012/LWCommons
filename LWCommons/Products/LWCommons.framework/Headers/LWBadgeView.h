//
//  LWBadgeView.h
//  
//
//  Created by wangliang on 24/5/2016.
//
#import <UIKit/UIKit.h>
#import "LWView.h"
typedef NS_ENUM(NSInteger, LWBadgeViewStyle) {
    LWBadgeViewStyleText,
    LWBadgeViewStyleDot,
};

@interface LWBadgeView : LWView

@property (nonatomic, assign) LWBadgeViewStyle badgeStyle;

@property (nonatomic, strong) UIColor *badgeColor;

@property (nonatomic, strong) UIColor *borderColor;

@property (nonatomic, strong) UIColor *badgeTextColor;

@property (nonatomic, strong) UIFont *badgeFont;

@property (nonatomic, assign) CGFloat borderWidth;

@property (nonatomic, strong) NSString *badgeText;

@property (nonatomic, assign) CGFloat badgeTextMargin; // Default 2 pixel,

- (void)show:(BOOL)show;

- (void)show:(BOOL)show badgeText:(NSString *)badgeText;

- (void)show:(BOOL)show badgeNumber:(NSInteger)badgeNumber;

@end
