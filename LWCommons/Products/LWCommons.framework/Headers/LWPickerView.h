//
//  LWPickerView.h
//  EasyBaking
//
//  Created by wangliang on 19/3/15.
//  Copyright (c) 2015 iEasyNote. All rights reserved.
//

#import "LWPopoverView.h"

@interface LWPickerView : LWPopoverView
{
    id _items;
}

@property (nonatomic, copy) void (^onOk)(UIPickerView* picker);

@property (nonatomic, assign) BOOL isModal;
@property (nonatomic, strong) id items;
@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong, readonly) UIPickerView *pickerView;

- (void) showInView:(UIView*) view;
- (void) selectRow:(NSInteger) row inComponent:(NSInteger)component;

@end
