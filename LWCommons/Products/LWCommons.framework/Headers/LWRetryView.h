//
//  LWRetryView.h
//  EasyBaking
//
//  Created by wangliang on 12/25/14.
//  Copyright (c) 2014 iEasyNote. All rights reserved.
//

#import "LWView.h"

@interface LWRetryView : LWView
{
    UIColor *_iconBGColor, *_titleBGColor;
    NSString *_retryMessage;
}

@property (nonatomic, copy) void(^onRetry)(void);
@property (nonatomic, retain, readwrite, setter = setIconBGColor:, getter = getIcnBGColor) UIColor *iconBGColor;
@property (nonatomic, retain, readwrite, setter = setTitleBGColor:, getter = getTitleBGColor) UIColor *titleBGColor;
@property (nonatomic, strong) NSString *retryMessage;

@end
