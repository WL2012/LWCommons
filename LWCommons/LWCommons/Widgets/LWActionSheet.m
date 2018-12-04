//
//  LWActionSheet.m
//  EasyBaking
//
//  Created by wangliang on 16/3/15.
//  Copyright (c) 2015 iEasyNote. All rights reserved.
//

#import "LWActionSheet.h"
#import "LWScrollView.h"
#import "NSString+Utilities.h"
#import "Constants.h"

@implementation LWActionSheet
{
    NSString *_title;
    NSString *_cancelButtonTitle, *_destructiveButtonTitle;
    NSInteger _maxColumns;
    NSArray *_items;
    NSMutableArray *_otherButtons;
    
    UILabel *_titleLabel;
    LWScrollView *_scrollView;
    
    LWView *_buttonsView, *_cancelButtonView;
}

- (void)removeFromSuperview {
    self.selectAtIndex = nil;
    [super removeFromSuperview];
}

- (id)initWithTitle:(NSString *)title maxColumns:(NSInteger)columns items:(NSArray *)items {
    self = [super init];
    if (self) {
        _title = title;
        _maxColumns = columns;
        _items = items;
        [self _initialize];
    }
    return self;
}

- (id)initWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(id)otherButtonTitles, ... {
    self = [super init];
    if (self) {
        _title = title;
        _cancelButtonTitle = cancelButtonTitle;
        _destructiveButtonTitle = destructiveButtonTitle;
        _otherButtons = [NSMutableArray array];
        va_list args;
        va_start(args, otherButtonTitles);
        for (NSString *arg = otherButtonTitles; arg != nil; arg = va_arg(args, NSString*)) {
            [_otherButtons addObject:arg];
        }
        va_end(args);
        
        [self loadSubviews];
    }
    return self;
}

- (id)initWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitlesInArray:(NSArray *)otherButtonTitles {
    self = [super init];
    if (self) {
        _title = title;
        _cancelButtonTitle = cancelButtonTitle;
        _destructiveButtonTitle = destructiveButtonTitle;
        _otherButtons = [NSMutableArray array];
        [_otherButtons addObjectsFromArray:otherButtonTitles];
        [self loadSubviews];
    }
    return self;
}

- (void)loadSubviews {
    [super loadSubviews];
    
    CGFloat height = _otherButtons.count*44;
    CGFloat cancelHeight = 8;
    if (![NSString isNullOrEmpty:_title]) {
        height += 44;
    }
    if (![NSString isNullOrEmpty:_destructiveButtonTitle]) {
        height += 44;
    }
    if (![NSString isNullOrEmpty:_cancelButtonTitle]) {
        cancelHeight += 44+8;
    }
    self.frame = CGRectMake(0, 0, kDeviceWidth, height+cancelHeight);
    NSInteger buttonIndex = 100;
    if (height>0) {
        _buttonsView = [[LWView alloc] initWithFrame:CGRectMake(8, 0, self.frame.size.width-8*2, height) andRadius:4];
        _buttonsView.backgroundColor = kWhiteColor;
        [self addSubview:_buttonsView];
        CGFloat top = 0;
        BOOL line = NO;
        CGFloat buttonRadius = _buttonsView.radius;
        if (![NSString isNullOrEmpty:_title]) {
            _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_buttonsView.radius, _buttonsView.radius, _buttonsView.frame.size.width-_buttonsView.radius*2, 44-_buttonsView.radius*2)];
            _titleLabel.textAlignment = NSTextAlignmentCenter;
            _titleLabel.text = _title;
            _titleLabel.font = kAppFont(10);
            _titleLabel.textColor = kGrayColor;
            [_buttonsView addSubview:_titleLabel];
            top += 44;
            line = YES;
            buttonRadius = 0;
        }
        if (![NSString isNullOrEmpty:_destructiveButtonTitle]) {
            if (line) {
                LWView *lineView = [[LWView alloc] initWithFrame:CGRectMake(0, top, _buttonsView.frame.size.width, kAppSepratorLineHeight)];
                lineView.backgroundColor = kRGB(225, 225, 225);
                [_buttonsView addSubview:lineView];
            }
            LWButton *destructiveButton = [LWButton buttonWithType:UIButtonTypeCustom];
            destructiveButton.frame = CGRectMake(0, top, _buttonsView.frame.size.width, 44);
            [destructiveButton setTitleColor:kRedColor forState:UIControlStateNormal];
            [destructiveButton setTitle:_destructiveButtonTitle forState:UIControlStateNormal];
            destructiveButton.tag = buttonIndex++;
            destructiveButton.titleLabel.font = kAppFont(18);
            [destructiveButton addTarget:self action:@selector(handleButtonClicked2:) forControlEvents:UIControlEventTouchUpInside];
            [_buttonsView addSubview:destructiveButton];
            if (buttonRadius>0) {
                destructiveButton.ltRadius = destructiveButton.rtRadius = buttonRadius;
            }
            if (_otherButtons.count==0) {
                destructiveButton.lbRadius = destructiveButton.rbRadius = _buttonsView.radius;
            }
            top += 44;
            line = YES;
            buttonRadius = 0;
        }
        for (NSInteger i=0,n=_otherButtons.count;i<n;++i) {
            if (line) {
                LWView *lineView = [[LWView alloc] initWithFrame:CGRectMake(0, top, _buttonsView.frame.size.width, kAppSepratorLineHeight)];
                lineView.backgroundColor = kRGB(225, 225, 225);
                [_buttonsView addSubview:lineView];
            }
            LWButton *btn = [LWButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(0, top, _buttonsView.frame.size.width, 44);
            [btn setTitle:[_otherButtons objectAtIndex:i] forState:UIControlStateNormal];
            [btn setTitleColor:kRGB(52, 138, 247) forState:UIControlStateNormal];
            btn.titleLabel.font = kAppFont(18);
            [btn setTitleColor:kGrayColor forState:UIControlStateDisabled];
            if (buttonRadius>0 && i==0) {
                btn.ltRadius = btn.rtRadius = buttonRadius;
                buttonRadius = 0;
            }
            if (i==n-1) {
                btn.lbRadius = btn.rbRadius = _buttonsView.radius;
            }
            [btn addTarget:self action:@selector(handleButtonClicked2:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = buttonIndex++;
            [_buttonsView addSubview:btn];
            top += 44;
            line = YES;
        }
    }
    if (cancelHeight>8) {
        _cancelButtonView = [[LWView alloc] initWithFrame:CGRectMake(_buttonsView.frame.origin.x, _buttonsView.frame.origin.y+_buttonsView.frame.size.height+8, _buttonsView.frame.size.width, 44) andRadius:_buttonsView.radius];
        _cancelButtonView.backgroundColor = kWhiteColor;
        [self addSubview:_cancelButtonView];
        LWButton *cancelButton = [LWButton buttonWithType:UIButtonTypeCustom];
        [cancelButton setTitle:_cancelButtonTitle forState:UIControlStateNormal];
        cancelButton.frame = _cancelButtonView.bounds;
        cancelButton.radius = _cancelButtonView.radius;
        cancelButton.titleLabel.font = kAppFontBold(18);
        [cancelButton setTitleColor:kRGB(52, 138, 247) forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(handleButtonClicked2:) forControlEvents:UIControlEventTouchUpInside];
        cancelButton.tag = buttonIndex++;
        [_cancelButtonView addSubview:cancelButton];
    }
}

- (void)handleButtonClicked2:(LWButton*) sender {
    __weak id weakSelf = self;
    [self closeOnCompletion:^(LWPopoverView *popoverView){
        if ([weakSelf selectAtIndex]) {
            [weakSelf selectAtIndex](sender.tag-100);
        }
    }];
}

- (void)setActionEnabled:(BOOL)enabled atIndex:(NSInteger)buttonIndex {
    if (_buttonsView) {
        LWButton *btn = (LWButton*)[_buttonsView viewWithTag:buttonIndex+100];
        if (btn) {
            btn.enabled = enabled;
        }
    }
}

- (LWButton*)buttonAtIndex:(NSInteger)buttonIndex {
    if (_buttonsView) {
        return (LWButton*)[_buttonsView viewWithTag:buttonIndex+100];
    }
    return nil;
}

- (void)_initialize {
    self.backgroundColor = kWhiteColor;
    CGFloat w = kDeviceWidth/_maxColumns;
    CGFloat h = w + 20;
    NSInteger rows = _items.count/_maxColumns;
    if (_items.count%_maxColumns>0) {
        rows++;
    }
    CGFloat top = 8;
    CGFloat height = rows * h;
    if (![NSString isNullOrEmpty:_title]) {
        height += 44;
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 8, kDeviceWidth-8*2, 44)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = _title;
        _titleLabel.font = kAppFont(14);
        [self addSubview:_titleLabel];
        
        LWView *lineView = [[LWView alloc] initWithFrame:CGRectMake(0, _titleLabel.frame.origin.y+_titleLabel.frame.size.height, kDeviceWidth, 1)];
        lineView.backgroundColor = kRGB(225, 225, 225);
        [self addSubview:lineView];
        top = lineView.frame.origin.y + lineView.frame.size.height;
    }
    height += 8;
    _scrollView = [[LWScrollView alloc] initWithFrame:CGRectMake(0, top, kDeviceWidth, MIN(height, kDeviceHeight-top-64))];
    [self addSubview:_scrollView];
    
    for (NSInteger i = 0, n = _items.count; i<n; ++i) {
        [self createItem:[_items objectAtIndex:i] atIndex:i];
    }
    self.frame = CGRectMake(0, 0, kDeviceWidth, MIN(height, kDeviceHeight-64));
}

- (void)setTitleAlignment:(NSTextAlignment)titleAlignment {
    _titleLabel.textAlignment = titleAlignment;
}

- (NSTextAlignment)titleAlignment {
    return _titleLabel.textAlignment;
}

- (LWView *)createItem:(LWActionSheetItem*)item atIndex:(NSInteger) index {
    CGFloat w = (kDeviceWidth-8*2)/_maxColumns;
    CGFloat h = w + 12;
    LWView *view = [[LWView alloc] initWithFrame:CGRectMake(index%_maxColumns*w+8, index/_maxColumns*h+8, w, h)];
    LWButton *button = [LWButton buttonWithType:UIButtonTypeCustom];
    button.radius = 3.0f;
    button.layer.cornerRadius = button.radius;
    button.layer.borderColor = kRGB(225, 225, 225).CGColor;
    button.layer.borderWidth = 1.0f;
    [button setImage:[UIImage imageNamed:item.normalImage] forState:UIControlStateNormal];
    if (![NSString isNullOrEmpty:item.highlightImage]) {
        [button setImage:[UIImage imageNamed:item.highlightImage] forState:UIControlStateHighlighted];
    }
    if ([NSString isNullOrEmpty:item.selectedImage]) {
        [button setImage:[UIImage imageNamed:item.selectedImage] forState:UIControlStateSelected];
    }
    
    button.tag = index;
    button.frame = CGRectMake(8, 8, w-8*2, w-8*2);
    [button addTarget:self action:@selector(handleButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = self.backgroundColor;
    [view addSubview:button];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, button.frame.origin.y+button.frame.size.height, view.frame.size.width, 20)];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = kAppFont(12);
    label.textColor = kGrayColor;
    label.text = item.title;
    [view addSubview:label];
    [_scrollView addSubview:view];
    _scrollView.contentSize = CGSizeMake(kDeviceWidth, MAX(view.frame.origin.y+view.frame.size.height+8, _scrollView.frame.size.height+1));
    return view;
}

- (void)_showInView:(UIView*) view {
    CGRect rect = self.frame;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    rect.origin.y = window.frame.size.height;
    rect.origin.x = 0;
    self.frame = rect;
    [window addSubview:self];
    rect.origin.y = window.frame.size.height-self.frame.size.height;
    [UIView animateWithDuration:0.25 animations:^{
        self.frame = rect;
    } completion:^(BOOL finished) {
        [self __popviewDidShow];
    }];
}

- (void)__popviewDidShow {
    if (self.popviewDidShow) {
        self.popviewDidShow(self);
    }
}

- (void)handleButtonClicked:(LWButton*)sender {
    __weak id weakSelf = self;
    [self closeOnCompletion:^(LWPopoverView *popoverView){
        if ([weakSelf selectAtIndex]) {
            [weakSelf selectAtIndex](sender.tag);
        }
    }];
}

@end

@implementation LWActionSheetItem

@end
