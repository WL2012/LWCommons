//
//  LWButton.h
//  EasyGames
//
//  Created by wangliang on 9/1/14.
//  Copyright (c) 2014 iEasynote. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LWButton : UIButton
{
    UIColor *_backgroundColor;
    UIColor *_highlightedBackgroundColor;
    UIColor *_disabledBackgroundColor;
    UIColor *_selectedBackgroundColor;
    
    CGFloat _radius;
    CGFloat _ltRadius;
    CGFloat _rtRadius;
    CGFloat _lbRadius;
    CGFloat _rbRadius;
    
    BOOL _verticalAlignment;
}
@property (nonatomic, assign) BOOL verticalAlignment;
@property (nonatomic, assign) CGFloat verticalSpacing;

@property (nonatomic, assign) CGFloat radius;
@property (nonatomic, assign) CGFloat ltRadius;
@property (nonatomic, assign) CGFloat rtRadius;
@property (nonatomic, assign) CGFloat lbRadius;
@property (nonatomic, assign) CGFloat rbRadius;

- (id)initWithFrame:(CGRect)frame andRadius:(CGFloat)radius;
- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state;
- (UIColor *)backgroundColorForState:(UIControlState)state;

@end
