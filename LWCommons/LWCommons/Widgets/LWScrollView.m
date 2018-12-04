//
//  LWScrollView.m
//  EasyBaking
//
//  Created by wangliang on 11/7/14.
//  Copyright (c) 2014 iEasyNote. All rights reserved.
//

#import "LWScrollView.h"

@implementation LWScrollView

- (instancetype) init{
    self = [super init];
    if(self){
        [self loadSubviews];
    }
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self loadSubviews];
    }
    return self;
}

- (id) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self loadSubviews];
    }
    return self;
}

- (void) loadSubviews {
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
}

@end
