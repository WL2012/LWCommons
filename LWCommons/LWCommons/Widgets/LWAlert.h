//
//  LWAlert.h
//  JiFenLianMeng
//
//  Created by 魏欣 on 2017/7/3.
//  Copyright © 2017年 JF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

typedef void(^LWAlertControllerAlertCompletionBlock)(NSInteger buttonIndex, UIAlertController *alertController);

//typedef void(^LWAlertViewCompletionBlock)(NSInteger buttonIndex, UIAlertView *alertView);

typedef void(^LWAlertControllerActionSheetCompletionBlock)(NSInteger buttonIndex, UIAlertController *alertController);

//typedef void(^LWActionSheetCompletionBlock)(NSInteger buttonIndex, UIActionSheet *actionSheet);

@interface LWAlert : NSObject
//{
//    UIAlertView *_alertView;
//    UIActionSheet *_actionSheet;
//}

+ (LWAlert*) sharedAlert;

// Wanring Actions
- (void)showWarningMessage:(NSString *)message;

- (void)showWarningMessage:(NSString *)message autoCloseAfter:(double)duration;

- (void)showWarningMessageInView:(UIView *)view message:(NSString *)message;

- (void)showWarningMessageInView:(UIView *)view message:(NSString *)message onCompletion:(void(^)(void))completion;

- (void)showWarningMessageInView:(UIView *)view message:(NSString *)message autoCloseAfter:(double) duration;

- (void)showWarningMessageInView:(UIView *)view message:(NSString *)message autoCloseAfter:(double) duration onCompletion:(void(^)(void))completion;

// Notification View Actions
- (void)showNotificationMessage:(NSString *)message;

- (void)showNotificationMessage:(NSString *)message onCompletion:(void(^)(void))completion;

// Alert Actions
- (void) showAlertMessage:(NSString*) message;

- (void) showAlertMessage:(NSString*) message withTitle:(NSString*) title;

- (void)showAlertMessageInViewController:(UIViewController *)viewController message:(NSString *)message;

- (void)showAlertMessageInViewController:(UIViewController *)viewController message:(NSString *)message withTitle:(NSString *)title;

- (void)showAlertMessageInViewController:(UIViewController *)viewController message:(NSString *)message onCompletion:(LWAlertControllerAlertCompletionBlock)completion;

- (void)showAlertMessageInViewController:(UIViewController *)viewController
                                 message:(NSString *)message
                               withTitle:(NSString *)title
                            onCompletion:(LWAlertControllerAlertCompletionBlock)completion;

- (void)showConfirmMessageInViewController:(UIViewController *)viewController
                                   message:(NSString *)message
                                 withTitle:(NSString *)title
                              onCompletion:(LWAlertControllerAlertCompletionBlock)completion;

- (void)showConfirmMessageInViewController:(UIViewController *)viewController
                                   message:(NSString *)message
                                 withTitle:(NSString *)title
                         cancelButtonTitle:(NSString *)cancelButtonTitle
                             okButtonTitle:(NSString *)okButtonTitle
                              onCompletion:(LWAlertControllerAlertCompletionBlock)completion;

// Action Sheet Actions
- (void)showActionSheetInViewController:(UIViewController *)viewController
                             completion:(LWAlertControllerActionSheetCompletionBlock)completion
                              withTitle:(NSString *)title
                                message:(NSString *)message
                      cancelButtonTitle:(NSString *)cancelButtonTitle
                 destructiveButtonTitle:(NSString *)destructiveButtonTitle
                      otherButtonTitles:(NSString *)otherButtonTitles,... NS_REQUIRES_NIL_TERMINATION;

- (void)showActionSheetInViewController:(UIViewController *)viewController
                             completion:(LWAlertControllerActionSheetCompletionBlock)completion
                              withTitle:(NSString *)title
                                message:(NSString *)message
                      cancelButtonTitle:(NSString *)cancelButtonTitle
                 destructiveButtonTitle:(NSString *)destructiveButtonTitle
               otherButtonTitlesInArray:(NSArray *)otherButtonTitles;

@end

//@interface LWAlert (AlertView)
//
//// Alert view actions
//- (void) showAlertMessage:(NSString*) message;
//
//- (void) showAlertMessage:(NSString*) message withTitle:(NSString*) title;
//
//- (void) showAlertMessage:(NSString*) message onCompletion:(LWAlertViewCompletionBlock)completion;
//
//- (void) showAlertMessage:(NSString*) message
//                withTitle:(NSString*) title
//             onCompletion:(LWAlertViewCompletionBlock)completion;
//
//- (void) showConfirmMessage:(NSString*) message
//                  withTitle:(NSString*) title
//               onCompletion:(LWAlertViewCompletionBlock)completion;
//
//- (void) showConfirmMessage:(NSString*) message
//                  withTitle:(NSString*) title
//          cancelButtonTitle:(NSString*) cancelButtonTitle
//              okButtonTitle:(NSString*) okButtonTitle
//               onCompletion:(LWAlertViewCompletionBlock)completion;
//
//@end

//@interface LWAlert (ActionSheet)
//
//// Action sheet
//- (void) showActionSheetInView:(UIView*) view
//                    completion:(LWActionSheetCompletionBlock)completion
//                     withTitle:(NSString *)title
//             cancelButtonTitle:(NSString*) cancelButtonTitle
//        destructiveButtonTitle:(NSString*) destructiveButtonTitle
//             otherButtonTitles:(NSString*) otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;
//
//- (void) showActionSheetInView:(UIView*) view
//                    completion:(LWActionSheetCompletionBlock)completion
//                     withTitle:(NSString *)title
//             cancelButtonTitle:(NSString*) cancelButtonTitle
//        destructiveButtonTitle:(NSString*) destructiveButtonTitle
//      otherButtonTitlesInArray:(NSArray*) otherButtonTitles;
//
//@end

@interface LWAlert (LoadingView)

- (void)showLoadingViewWithMessage:(NSString *)message inView:(UIView *)view;

- (void)removeLoadingView;

@end

@interface LWAlert (MBProgressHUD)

+ (void)showHUDAddedTo:(UIView *)view animated:(BOOL)animated;
+ (MBProgressHUD *)showHUDAddedTo:(UIView *)view animated:(BOOL)animated message:(NSString *)message;
+ (BOOL)hideHUDForView:(UIView *)view animated:(BOOL)animated;

@end

