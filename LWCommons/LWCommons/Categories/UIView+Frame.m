//
//  UIView+Frame.m
//  YYAlert
//
//  Created by wangliang on 2018/12/4.
//  Copyright © 2018年 wangliang. All rights reserved.
//

#import "UIView+Frame.h"

@implementation UIView (Frame)

- (CGFloat)x {
    return self.frame.origin.x;
}

- (void)setX:(CGFloat)newX {
    CGRect frame = self.frame;
    frame.origin.x = newX;
    self.frame = frame;
}

- (CGFloat)y {
    return self.frame.origin.y;
}

- (void)setY:(CGFloat)newY {
    CGRect frame = self.frame;
    frame.origin.y = newY;
    self.frame = frame;
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)newWidth {
    CGRect frame = self.frame;
    frame.size.width = newWidth;
    self.frame = frame;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)newHeight {
    CGRect frame = self.frame;
    frame.size.height = newHeight;
    self.frame = frame;
}

- (CGFloat)maxY {
    return self.y + self.height;
}

- (void)setMaxY:(CGFloat)maxY {
    [self setY:maxY - self.height];
}

- (CGFloat)maxX {
    return self.x + self.width;
}

- (void)setMaxX:(CGFloat)maxX {
    [self setX:maxX - self.width];
}

- (CGPoint)origin {
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin {
    CGRect r = self.frame;
    r.origin = origin;
    self.frame = r;
}

- (CGSize)size {
    return self.frame.size;
}

- (void)setSize:(CGSize)size {
    CGRect r = self.frame;
    r.size = size;
    self.frame = r;
}

@end
