//
//  LWActionSheet.h
//  EasyBaking
//
//  Created by wangliang on 16/3/15.
//  Copyright (c) 2015 iEasyNote. All rights reserved.
//

#import "LWPopoverView.h"
#import "LWButton.h"

@interface LWActionSheet : LWPopoverView

@property (nonatomic, copy) void (^selectAtIndex)(NSInteger index);
@property (nonatomic, assign) NSTextAlignment titleAlignment;
- (id) initWithTitle:(NSString*) title maxColumns:(NSInteger) columns items:(NSArray*) items;
- (id) initWithTitle:(NSString*) title cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;
- (id) initWithTitle:(NSString*) title cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitlesInArray:(NSArray*)otherButtonTitles;

- (void) setActionEnabled:(BOOL) enabled atIndex:(NSInteger) buttonIndex;
- (LWButton*) buttonAtIndex:(NSInteger) buttonIndex;

@end

@interface LWActionSheetItem : NSObject
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *normalImage;
@property (nonatomic, strong) NSString *selectedImage;
@property (nonatomic, strong) NSString *highlightImage;
@property (nonatomic, strong) NSString *disabledImage;
@end
