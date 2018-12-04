//
//  LWPickerView.m
//  EasyBaking
//
//  Created by wangliang on 19/3/15.
//  Copyright (c) 2015 iEasyNote. All rights reserved.
//

#import "LWPickerView.h"
#import "LWButton.h"
#import "Constants.h"

@interface LWPickerView (PickerDelegate) <UIPickerViewDelegate, UIPickerViewDataSource>

@end

@implementation LWPickerView
{
    UIToolbar *_actionBar;
    UIBarButtonItem *_cancelButton, *_okButton;
    NSInteger _components;
    BOOL _showing;
    NSMutableDictionary *_selectedValues;
    UILabel *_titleLabel;
}

- (void) removeFromSuperview {
    self.onOk = nil;
    [super removeFromSuperview];
}

- (void) loadSubviews {
    [super loadSubviews];
    _actionBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 44)];
    [self addSubview:_actionBar];
    
    _cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(handleCancel:)];
    _cancelButton.tintColor = kGrayColor;
    _okButton = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(handleOk:)];
    _okButton.tintColor = kHRGB(0xD2B569);
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    NSArray *buttons = [NSArray arrayWithObjects:_cancelButton, spacer, _okButton, nil];
    _actionBar.items = buttons;
    
    _titleLabel = [[UILabel alloc] initWithFrame:_actionBar.frame];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.text = self.title;
    _titleLabel.textColor = kHRGB(0x666666);
    _titleLabel.font = kAppFont(18);
    [self addSubview:_titleLabel];
    
    _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, _actionBar.frame.origin.y+_actionBar.frame.size.height, self.frame.size.width, self.frame.size.height-_actionBar.frame.origin.y-_actionBar.frame.size.height)];
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    [self addSubview:_pickerView];
    
    self.direction = LWPopoverViewCloseDirectionFromBottom;
    self.position = LWPopoverViewPositionBottom;
}

- (void) selectRow:(NSInteger)row inComponent:(NSInteger)component {
    [_selectedValues setObject:[NSNumber numberWithInteger:row] forKey:[NSString stringWithFormat:@"%d", (int)component]];
}

- (void) setItems:(id)items {
    _selectedValues = [NSMutableDictionary dictionary];
    _components = 0;
    _items = items;
    [_pickerView reloadAllComponents];
}

- (void)setTitle:(NSString *)title {
    _titleLabel.text = title;
}

- (void) handleCancel:(id) sender {
    __weak id weakSelf = self;
    [self closeOnCompletion:^(LWPopoverView *popoverView){
        if ([weakSelf popviewDidClose]) {
            [weakSelf popviewDidClose](weakSelf);
        }
    }];
}

- (void) handleOk:(id) sender {
    __weak id weakSelf = self;
    [self closeOnCompletion:^(LWPopoverView *popoverView){
        [weakSelf handleApplyOk];
    }];
}

- (void) handleApplyOk {
    if (self.onOk) {
        self.onOk(_pickerView);
    }
}

- (void) setFrame:(CGRect)frame {
    //_pickerView.frame = CGRectMake(0, _actionView.frame.origin.y+_actionView.frame.size.height, self.frame.size.width, self.frame.size.height-_actionView.frame.origin.y-_actionView.frame.size.height);
    [super setFrame:frame];
}

- (LWButton*) createActionButtonWithTitle:(NSString*) title andBackground:(UIColor*) backgroundColor andRadius:(CGFloat) radius {
    LWButton *button = [LWButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = backgroundColor;
    button.radius = radius;
    button.titleLabel.font = kAppFont(14);
    [button setTitle:title forState:UIControlStateNormal];
    return button;
}

- (void) showInView:(UIView *)view {
    if (_showing) {
        return;
    }
    _showing = YES;
    if (self.isModal) {
        [super showInView:view];
    }
    else {
        [self _showInView:view];
    }
    [self __popviewDidShow];
}

- (void) _showInView:(UIView*) view {
    CGRect rect = self.frame;
    rect.origin.y = view.frame.size.height;
    rect.origin.x = 0;
    self.frame = rect;
    if (!self.superview) {
        [view addSubview:self];
        rect.origin.y = view.frame.size.height-self.frame.size.height;
    }
    else {
        rect.origin.y = view.frame.size.height;
    }
    [UIView animateWithDuration:0.25 animations:^{
        self.frame = rect;
    } completion:^(BOOL finished) {
        _showing = NO;
    }];
}

- (void) __popviewDidShow {
    if (_selectedValues) {
        for (NSInteger i=0,n=_selectedValues.allKeys.count; i<n; ++i) {
            NSNumber *number = [_selectedValues valueForKey:[NSString stringWithFormat:@"%d", (int)i]];
            if (number) {
                [_pickerView selectRow:number.integerValue inComponent:i animated:NO];
                [_pickerView reloadComponent:i];
            }
        }
    }
    if (self.popviewDidShow) {
        self.popviewDidShow(self);
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

@implementation LWPickerView (PickerDelegate)

- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if ([_items isKindOfClass:[NSArray class]]) {
        return ((NSArray*)_items).count;
    }
    else if ([_items isKindOfClass:[NSDictionary class]]) {
        if (_components==0) {
            id obj = _items;
            while ((obj=[obj objectForKey:[NSNumber numberWithInteger:0]])) {
                _components++;
                if ([obj isKindOfClass:[NSDictionary class]]) {
                    obj = [obj objectForKey:@"items"];
                }
                if ([obj isKindOfClass:[NSArray class]]) {
                    _components++;
                    break;
                }
            }
        }
        return _components;
    }
    return 0;
}

- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if ([_items isKindOfClass:[NSArray class]]) {
        NSInteger components = ((NSArray*)_items).count;
        if (components>0 && component<components) {
            NSArray *items = [_items objectAtIndex:component];
            return items.count;
        }
    }
    else if ([_items isKindOfClass:[NSDictionary class]]) {
        NSInteger c = 0;
        id obj = _items;
        while (c<component && (obj = [((NSDictionary*)obj) objectForKey:[NSNumber numberWithInteger:[pickerView selectedRowInComponent:c++]]])) {
            if ([obj isKindOfClass:[NSDictionary class]]) {
                obj = [obj objectForKey:@"items"];
            }
        }
        if (c==component) {
            if ([obj isKindOfClass:[NSArray class]]) {
                return ((NSArray*)obj).count;
            }
            else if ([obj isKindOfClass:[NSDictionary class]]) {
                return ((NSDictionary*)obj).allKeys.count;
            }
        }
    }
    return 0;
}

//- (NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
//    if ([_items isKindOfClass:[NSArray class]]) {
//        NSArray *items = [_items objectAtIndex:component];
//        return [items objectAtIndex:row];
//    }
//    else if ([_items isKindOfClass:[NSDictionary class]]) {
//        NSInteger c = 0;
//        id obj = _items;
//        while (c<component && (obj = [((NSDictionary*)obj) objectForKey:[NSNumber numberWithInteger:[pickerView selectedRowInComponent:c++]]])) {
//            if ([obj isKindOfClass:[NSDictionary class]]) {
//                obj = [obj objectForKey:@"items"];
//            }
//        }
//        if (c==component) {
//            if (!obj) {
//                obj = _items;
//            }
//            if ([obj isKindOfClass:[NSArray class]]) {
//                if (row<((NSArray*)obj).count) {
//                    return [obj objectAtIndex:row];
//                }
//            }
//            else if ([obj isKindOfClass:[NSDictionary class]]) {
//                return [[obj objectForKey:[NSNumber numberWithInteger:row]] objectForKey:@"key"];
//            }
//        }
//    }
//    return nil;
//}

- (nullable NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *str = nil;
    if ([_items isKindOfClass:[NSArray class]]) {
        NSArray *items = [_items objectAtIndex:component];
        str = [items objectAtIndex:row];
    }
    else if ([_items isKindOfClass:[NSDictionary class]]) {
        NSInteger c = 0;
        id obj = _items;
        while (c<component && (obj = [((NSDictionary*)obj) objectForKey:[NSNumber numberWithInteger:[pickerView selectedRowInComponent:c++]]])) {
            if ([obj isKindOfClass:[NSDictionary class]]) {
                obj = [obj objectForKey:@"items"];
            }
        }
        if (c==component) {
            if (!obj) {
                obj = _items;
            }
            if ([obj isKindOfClass:[NSArray class]]) {
                if (row<((NSArray*)obj).count) {
                    str = [obj objectAtIndex:row];
                }
            }
            else if ([obj isKindOfClass:[NSDictionary class]]) {
                str = [[obj objectForKey:[NSNumber numberWithInteger:row]] objectForKey:@"key"];
            }
        }
    }
    NSAttributedString *aStr = nil;
    if([[_selectedValues objectForKey:[NSString stringWithFormat:@"%d", (int)component]] integerValue] == row) {
        aStr = [[NSAttributedString alloc] initWithString:str attributes:@{NSForegroundColorAttributeName : kHRGB(0xD2B569)}];
    }
    else {
        aStr = [[NSAttributedString alloc] initWithString:str attributes:@{NSForegroundColorAttributeName : kHRGB(0x333333)}];
    }
    return aStr;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    [_selectedValues setObject:[NSNumber numberWithInteger:row] forKey:[NSString stringWithFormat:@"%d", (int)component]];
    if ([_items isKindOfClass:[NSDictionary class]]) {
        NSInteger c = component;
        while (c<_components) {
            if (c > component) {
                [pickerView selectRow:0 inComponent:c animated:YES];
                [_selectedValues setObject:[NSNumber numberWithInteger:0] forKey:[NSString stringWithFormat:@"%d", (int)c]];
            }
            [pickerView reloadComponent:c];
            c++;
        }
    }
    else {
        [pickerView reloadComponent:component];
    }
}

@end
