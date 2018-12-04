//
//  LWTableViewCell.m
//  
//
//  Created by wangliang on 2017/11/23.
//  Copyright © 2017年 wangliang. All rights reserved.
//

#import "LWTableViewCell.h"

@implementation LWTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initView];
    }
    return self;
}

- (void)initView {
    
}

@end
