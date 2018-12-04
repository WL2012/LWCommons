//
//  LWButton.m
//  EasyGames
//
//  Created by wangliang on 9/1/14.
//  Copyright (c) 2014 iEasynote. All rights reserved.
//

#import "LWButton.h"
#import "Constants.h"

@implementation LWButton

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initRadius:0];
        self.backgroundColor = kClearColor;
        [self checkAlignment];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame andRadius:(CGFloat)radius {
    self = [super initWithFrame:frame];
    if (self) {
        [self initRadius:radius];
        [self checkAlignment];
    }
    return self;
}

- (void)setImage:(UIImage *)image forState:(UIControlState)state {
    [super setImage:image forState:state];
    [self checkAlignment];
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state {
    [super setTitle:title forState:state];
    [self checkAlignment];
}

- (void)setVerticalSpacing:(CGFloat)verticalSpacing {
    if (_verticalSpacing != verticalSpacing) {
        _verticalSpacing = verticalSpacing;
        if (_verticalAlignment) {
            [self checkAlignment];
        }
    }
}

- (void)setVerticalAlignment:(BOOL)verticalAlignment {
    _verticalAlignment = verticalAlignment;
    [self checkAlignment];
}

- (void)checkAlignment {
    if (_verticalAlignment) {
        CGSize titleSize = CGSizeZero;
        if (iOS7_OR_LATER) {
            titleSize = [self.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:self.titleLabel.font}];
        }
        else {
            titleSize = self.titleLabel.frame.size;
        }
        CGSize imageSize = self.imageView.frame.size;
        self.titleEdgeInsets = UIEdgeInsetsMake(0.0, -imageSize.width, - (_verticalSpacing + imageSize.height), 0.0);
        self.imageEdgeInsets = UIEdgeInsetsMake(- (titleSize.height + _verticalSpacing), 0.0, 0.0, - titleSize.width);
    }
    else {
        [self setTitleEdgeInsets:UIEdgeInsetsZero];
        [self setImageEdgeInsets:UIEdgeInsetsZero];
    }
}

- (BOOL)verticalAlignment {
    return _verticalAlignment;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    _backgroundColor = backgroundColor;
    if ([self hasRadius] && _backgroundColor && _backgroundColor!=kClearColor) {
        [super setBackgroundColor:kClearColor];
        [self setNeedsDisplay];
    }
    else {
        [super setBackgroundColor:backgroundColor];
    }
}

- (void)setDisabledBackgroundColor:(UIColor *)disabledBackgroundColor {
    _disabledBackgroundColor = disabledBackgroundColor;
    if ([self hasRadius] &&
        _disabledBackgroundColor &&
        _disabledBackgroundColor != kClearColor) {
        [super setBackgroundColor:kClearColor];
        [self setNeedsDisplay];
    }
    else {
        [super setBackgroundColor:disabledBackgroundColor];
    }
}

- (void)setHighlightedBackgroundColor:(UIColor *)highlightedBackgroundColor {
    _highlightedBackgroundColor = highlightedBackgroundColor;
    if ([self hasRadius] &&
        _highlightedBackgroundColor &&
        _highlightedBackgroundColor != kClearColor) {
        [super setBackgroundColor:kClearColor];
        [self setNeedsDisplay];
    }
    else {
        [super setBackgroundColor:highlightedBackgroundColor];
    }
}

- (void)setSelectedBackgroundColor:(UIColor *)selectedBackgroundColor {
    _selectedBackgroundColor = selectedBackgroundColor;
    if ([self hasRadius] &&
        _selectedBackgroundColor &&
        _selectedBackgroundColor != kClearColor) {
        [super setBackgroundColor:kClearColor];
        [self setNeedsDisplay];
    }
    else {
        [super setBackgroundColor:selectedBackgroundColor];
    }
}

- (BOOL)hasRadius {
    return _ltRadius > 0 || _rtRadius > 0 || _lbRadius > 0 || _rbRadius > 0;
}

- (void)initRadius:(CGFloat)radius {
    _radius = radius;
    _ltRadius = radius;
    _rtRadius = radius;
    _lbRadius = radius;
    _rbRadius = radius;
}

- (void)setLtRadius:(CGFloat)ltRadius {
    _ltRadius =ltRadius;
}

- (CGFloat)ltRadius {
    return _ltRadius;
}

- (void)setRtRadius:(CGFloat)rtRadius {
    _rtRadius = rtRadius;
}

- (CGFloat)rtRadius{
    return _rtRadius;
}

- (void)setLbRadius:(CGFloat)lbRadius {
    _lbRadius = lbRadius;
}

- (CGFloat)lbRadius {
    return _lbRadius;
}

- (void)setRbRadius:(CGFloat)rbRadius {
    _rbRadius = rbRadius;
}

- (CGFloat)rbRadius {
    return _rbRadius;
}

- (void)setRadius:(CGFloat)radius {
    if (_radius != radius) {
        [self initRadius:radius];
    }
    switch (self.state) {
        case UIControlStateNormal:
            [self setBackgroundColor:_backgroundColor];
            break;
        case UIControlStateHighlighted:
            [self setHighlightedBackgroundColor:_highlightedBackgroundColor];
            break;
        case UIControlStateDisabled:
            [self setDisabledBackgroundColor:_disabledBackgroundColor];
            break;
        case UIControlStateSelected:
            [self setSelectedBackgroundColor:_selectedBackgroundColor];
            break;
        default:
            break;
    }
}

- (CGFloat)getRadius {
    return _radius;
}

- (void)setFrame:(CGRect)frame {
    //    /// Wrapper frame
    //    frame.size.width = ((int)(frame.size.width * 2)) / 2.0f;
    //    frame.size.height = ((int)(frame.size.height * 2)) / 2.0f;
    //    frame.origin.x = ((int)(frame.origin.x * 2)) / 2.0f;
    //    frame.origin.y = ((int)(frame.origin.y * 2)) / 2.0f;
    [super setFrame:frame];
    [self setNeedsDisplay];
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (_backgroundColor && _backgroundColor != kClearColor) {
        if (selected) {
            if (!_selectedBackgroundColor) {
                _selectedBackgroundColor = _backgroundColor;
            }
            [self setSelectedBackgroundColor:_selectedBackgroundColor];
        }
        else {
            [self setBackgroundColor:_backgroundColor];
        }
    }
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    if (_backgroundColor && _backgroundColor != kClearColor) {
        if (highlighted) {
            if (!_highlightedBackgroundColor) {
                _highlightedBackgroundColor = _backgroundColor;
            }
            [self setHighlightedBackgroundColor:_highlightedBackgroundColor];
        }
        else {
            [self setBackgroundColor:_backgroundColor];
        }
    }
}

- (void)setEnabled:(BOOL)enabled {
    [super setEnabled:enabled];
    if (_backgroundColor && _backgroundColor != kClearColor) {
        if (!enabled) {
            if (!_disabledBackgroundColor) {
                _disabledBackgroundColor = kRGB(205, 205, 205);
            }
            [self setDisabledBackgroundColor:_disabledBackgroundColor];
        }
        else {
            [self setBackgroundColor:_backgroundColor];
        }
    }
}

- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state {
    if (state == UIControlStateNormal) {
        [self setBackgroundColor:backgroundColor];
    }
    else if (state == UIControlStateDisabled) {
        [self setDisabledBackgroundColor:backgroundColor];
    }
    else if (state == UIControlStateHighlighted) {
        [self setHighlightedBackgroundColor:backgroundColor];
    }
    else if (state == UIControlStateSelected) {
        [self setSelectedBackgroundColor:backgroundColor];
    }
}

- (UIColor *)backgroundColorForState:(UIControlState)state {
    switch (state) {
        case UIControlStateNormal:
            return _backgroundColor;
        case UIControlStateHighlighted:
            return _highlightedBackgroundColor;
        case UIControlStateDisabled:
            return _disabledBackgroundColor;
        case UIControlStateSelected:
            return _selectedBackgroundColor;
        default:
            break;
    }
    return _backgroundColor;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    UIColor *backgroundColor = nil;
    if (self.state == UIControlStateNormal) {
        backgroundColor = _backgroundColor;
    }
    else if (self.state == UIControlStateHighlighted) {
        backgroundColor = _highlightedBackgroundColor;
    }
    else if (self.state == UIControlStateDisabled) {
        backgroundColor = _disabledBackgroundColor;
    }
    else if (self.state == UIControlStateSelected) {
        backgroundColor = _selectedBackgroundColor;
    }
    
    if([self hasRadius] && backgroundColor) {
        // get the contect
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        // the rest is pretty much copied from Apples example
        CGFloat minx = CGRectGetMinX(rect), midx = CGRectGetMidX(rect), maxx = CGRectGetMaxX(rect);
        CGFloat miny = CGRectGetMinY(rect), midy = CGRectGetMidY(rect), maxy = CGRectGetMaxY(rect);
        
        // Start at 1
        CGContextMoveToPoint(context, minx, midy);
        // Add an arc through 2 to 3
        CGContextAddArcToPoint(context, minx, miny, midx, miny, _ltRadius);
        // Add an arc through 4 to 5
        CGContextAddArcToPoint(context, maxx, miny, maxx, midy, _rtRadius);
        // Add an arc through 6 to 7
        CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, _rbRadius);
        // Add an arc through 8 to 9
        CGContextAddArcToPoint(context, minx, maxy, minx, midy, _lbRadius);
        // Close the path
        CGContextClosePath(context);
        
        //CGContextSetRGBFillColor(context, 1.0, 0.0, 1.0, 1.0);
        CGContextSetFillColorWithColor(context, backgroundColor.CGColor);
        
        // Fill & stroke the path
        CGContextDrawPath(context, kCGPathFill);
    }
}

@end
