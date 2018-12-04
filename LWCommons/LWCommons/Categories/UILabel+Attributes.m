//
//  UILabel+Attributes.m
//  EasyBaking
//
//  Created by wangliang on 9/15/14.
//  Copyright (c) 2014 iEasyNote. All rights reserved.
//

#import "UILabel+Attributes.h"
#import "NSString+Utilities.h"

@implementation UILabel (Attributes)

- (void)setPartString:(NSString *)str attributes:(NSDictionary *)attrs {

    NSMutableAttributedString *attributedString =[[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    if (attributedString == nil) {
        attributedString = [[NSMutableAttributedString alloc] initWithString:self.text];
    }
    
    NSArray* rangeArray = [self.text rangesArrayOfString:str];
    for (NSValue* value in rangeArray) {
        NSRange range = value.rangeValue;
        [attributedString setAttributes:attrs range:range];
    }
    
    self.attributedText = attributedString;
}


- (void)addPrefixString:(NSString *)str attributes:(NSDictionary *)attrs {
    
    self.text  = [NSString stringWithFormat:@"%@%@",str,self.text];
    [self setPartString:str attributes:attrs];
}

- (void)addSuffixString:(NSString *)str attributes:(NSDictionary *)attrs {
    
    self.text  = [NSString stringWithFormat:@"%@%@",self.text,str];
    [self setPartString:str attributes:attrs];
}

- (CGSize)boundingRectWithSize:(CGSize)size {
    
    NSDictionary *attribute = @{NSFontAttributeName: self.font};
    
    CGSize retSize = [self.text boundingRectWithSize:size
                                             options:\
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                          attributes:attribute
                                             context:nil].size;
    
    if ([self.text isEqualToString:@""] || self.text == nil) {
        retSize.height = 0;
    }
    
    return retSize;
}

@end
