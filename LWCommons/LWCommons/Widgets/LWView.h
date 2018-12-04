//
//  LWView.h
//  
//
//  Created by wangliang on 2017/7/3.
//  Copyright © 2017年 wangliang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LWView : UIView
{
    UIColor *_backgroundColor;
    
    CGFloat _radius;
    CGFloat _ltRadius;
    CGFloat _rtRadius;
    CGFloat _lbRadius;
    CGFloat _rbRadius;
}
@property (nonatomic, assign) CGFloat radius;   // Radius
@property (nonatomic, assign) CGFloat ltRadius; // Left Top Radius
@property (nonatomic, assign) CGFloat rtRadius; // Right Top Radius
@property (nonatomic, assign) CGFloat lbRadius; // Left Bottom Radius
@property (nonatomic, assign) CGFloat rbRadius; // Right Bottom Radius

- (id)initWithFrame:(CGRect)frame andRadius:(CGFloat)radius;

- (void)loadSubviews;

@end

