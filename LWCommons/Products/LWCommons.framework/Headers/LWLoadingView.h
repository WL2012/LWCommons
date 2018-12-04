//
//  LWLoadingView.h
//  EasyBaking
//
//  Created by wangliang on 1/21/15.
//  Copyright (c) 2015 iEasyNote. All rights reserved.
//

#import "LWPopoverView.h"

@interface LWLoadingView : LWPopoverView

@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) UIImageView *gifImageView;

- (void) stopLoading;

@end
