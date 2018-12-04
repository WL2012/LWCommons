//
//  LWViewController.h
//  
//
//  Created by wangliang on 2017/7/3.
//  Copyright © 2017年 wangliang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LWAlert.h"
#import "LWView.h"

typedef enum{
    LWReloadRemoteTypeViewDidAppear,
    LWReloadRemoteTypeViewWillAppear,
}LWReloadRemoteType;

@interface LWViewController : UIViewController
{
    BOOL _autorotate;
    UIInterfaceOrientationMask _orientationMask;
    UIInterfaceOrientation _preferredOrientation;
    BOOL _interactivePopGestureEnabled;
    BOOL _shakingEnabled;
    BOOL _isRequestEverSuccessed;
}
@property (nonatomic, assign) LWReloadRemoteType reloadRemoteType;
@property (nonatomic, assign, readonly) CGFloat topLayoutGuideHeight;
@property (nonatomic, assign, readonly) CGFloat bottomLayoutGuideHeight;
@property (nonatomic, assign, readonly) CGFloat layoutGuideHeight;
@property (nonatomic, assign, readwrite, setter = setAutorotate:, getter = isAutorotate) BOOL autorotate;
@property (nonatomic, assign) BOOL shakingEnabled;
- (void) setOrientationMask:(UIInterfaceOrientationMask) orientationMask;
- (void) setPreferredOrientation:(UIInterfaceOrientation) preferredOrientation;
- (void) setInteractivePopGestureRecognizerEnabled:(BOOL) enabled;

@property (readonly, nonatomic, assign, getter = isReachable) BOOL reachable;
@property (readonly, nonatomic, assign, getter = isReachableViaWWAN) BOOL reachableViaWWAN;
@property (readonly, nonatomic, assign, getter = isReachableViaWiFi) BOOL reachableViaWiFi;

@property (nonatomic, assign) BOOL isViewVisable;

- (UIImage*) screenShot;

- (void) handleErrorResponse:(id) responseData;
- (void) startLoadingViewWithMessage: (NSString*) loadingMessage;
- (void) stopLoadingView;
- (void) stopLoadingView:(BOOL) animated;
- (void) rightNavigationItemWithSpacing:(UIBarButtonSystemItem) systemItem target:(id) target action:(SEL) sel;

- (void) stopRefreshing:(UIScrollView*) scrollView refresh:(BOOL) refresh pulling:(BOOL) pulling;

- (void) appBecomeActive:(NSNotification*) notification;
- (void) appWillResignActive:(NSNotification*) notification;

//Create retry view
- (void) createRetryViewWithCompletion:(void(^)(void)) completion;
- (void) createRetryViewWithMessage:(NSString*) message onCompletion:(void(^)(void)) completion;
- (void) removeRetryView;
- (void) layoutRetryViewAnimate:(BOOL) animated;


- (UIControl*) buttonItemForBarButton:(UIBarButtonItem*) barButtonItem;

@end

@interface UIViewController (Message)

- (void) showWarningView:(NSString *)warningMessage;
- (void) showWarningViewWithDisplayDelay:(NSString *)warningMessage;
- (void) showWarningView:(NSString *)warningMessage autoDisplayAfter:(double)displayDelay;
- (void) showWarningView:(NSString *)warningMessage onCompletion:(void(^)(void))completion;
- (void) showWarningView:(NSString *)warningMessage autoCloseAfter:(NSInteger) secondsDelay;
- (void) showWarningView:(NSString *)warningMessage autoCloseAfter:(double) secondsDelay onCompletion:(void(^)(void))completion;
- (LWView *)createWarningView:(NSString *)warningMessage;

//Show Alert Message
- (void) showAlertMessage:(NSString*) message;
- (void) showAlertMessage:(NSString*) message withTitle:(NSString*) title;
- (void) showAlertMessage:(NSString*) message onCompletion:(LWAlertControllerAlertCompletionBlock)completion;
- (void) showAlertMessage:(NSString*) message withTitle:(NSString*) title onCompletion:(LWAlertControllerAlertCompletionBlock)completion;
- (void) showConfirmMessage:(NSString*) message withTitle:(NSString*) title onCompletion:(LWAlertControllerAlertCompletionBlock)completion;
- (void) showConfirmMessage:(NSString*) message withTitle:(NSString*) title cancelButtonTitle:(NSString*) cancelButtonTitle okButtonTitle:(NSString*) okButtonTitle onCompletion:(LWAlertControllerAlertCompletionBlock)completion;

//Show action sheet
- (void) showActionSheetOnCompletion:(LWAlertControllerActionSheetCompletionBlock)completion withTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString*) cancelButtonTitle destructiveButtonTitle:(NSString*) destructiveButtonTitle otherButtonTitles:(NSString*) otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;
- (void) showActionSheetOnCompletion:(LWAlertControllerActionSheetCompletionBlock)completion withTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitlesInArray:(NSArray *)otherButtonTitles;

@end

@interface LWViewController (Notification)

- (void)sendNotification:(NSInteger)notification;

- (void)sendNotification:(NSInteger)notification withData:(id)data;

- (void)didReceiveNotification:(NSInteger)notification withData:(id)data;

- (BOOL)containsNotification:(NSInteger)notification;

@end

@interface UIViewController (Helper)

- (void)setInteractivePopGestureEnabled:(BOOL)enabled;

@end
