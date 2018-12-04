//
//  LWShakingView.h
//  
//
//  Created by wangliang on 2017/7/3.
//  Copyright © 2017年 wangliang. All rights reserved.
//

#import "LWView.h"

@interface LWShakingView : LWView

@property (nonatomic, copy) void (^onShaking)(void);

@end
