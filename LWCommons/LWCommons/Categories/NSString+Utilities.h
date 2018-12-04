//
//  NSString+Utilities.h
//  
//
//  Created by wangliang on 2017/7/3.
//  Copyright © 2017年 wangliang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (Utilities)
- (BOOL)contains:(NSString*)string;
- (BOOL)containsCaseInsensitive:(NSString*)string;
- (NSString*) replace:(NSString*) string withString:(NSString*) replace;
- (NSString*) add:(NSString*)string;
- (NSDictionary*) firstAndLastName;
- (BOOL)isValidEmail;
- (BOOL)isValidMobile;
- (BOOL)isValidUserName;
- (BOOL)isCorrectPassword;
- (BOOL)isCorrectPaymentCode;
- (BOOL)isValidateIDCard;
- (BOOL)checkCardNo;
- (BOOL)containsOnlyLetters;
- (BOOL)containsOnlyNumbers;
- (BOOL)containsOnlyNumbersAndLetters;
- (NSString*)safeSubstringToIndex:(NSUInteger)index;
- (NSString*)stringByRemovingPrefix:(NSString*)prefix;
- (NSString*)stringByRemovingPrefixes:(NSArray*)prefixes;
- (BOOL)hasPrefixes:(NSArray*)prefixes;
- (BOOL)hasSufixes:(NSArray*)sufixes;
- (BOOL)isEqualToOneOf:(NSArray*)strings;
- (NSString*)md5;
- (NSString*)telephoneWithReformat;
- (NSString*)trim;
- (NSArray*)splitBy:(NSString*) splitString;
- (NSInteger)getIntegerValue;
- (int)getIntValue;
- (int)getLength;
- (int)getLength2;
- (NSString*)base64:(BOOL) encoding;
+ (NSString*)safeString:(NSString*)str;
+ (BOOL)isNullOrEmpty:(NSString*)str;
+ (BOOL)equals:(NSString*) str1 to:(NSString*) str2;
+ (NSString*)generateRandomString:(int) length;
+ (NSString*)generateRandomString:(int) length fromSource:(NSString*) source;
+ (NSString*)generateRandomPassword:(int) length;
- (NSComparisonResult)caseSensitiveCompare:(NSString *)aString;
- (int)countWord;
- (CGSize)returnSize:(UIFont *)fnt;
- (CGSize)returnSize:(UIFont *)fnt MaxWidth:(CGFloat)maxWidth;
- (CGSize)returnSize:(UIFont *)fnt MaxWidth:(CGFloat)maxWidth lineSpacing:(CGFloat)lineSpacing;
- (CGFloat)widthForContentWithFontSize:(UIFont*)font;
- (NSString*)confusedMobileNumber;
- (BOOL)isPureInteger;
- (BOOL)isPureFloat;
- (BOOL)isPureDouble;
- (NSArray*)rangesArrayOfString:(NSString*)str;
+ (NSString *)countNumAndChangeformat:(NSString *)str;
+ (NSString*)randomStringFromZeroToOne;
- (NSString *)safeNumbers;
@end

