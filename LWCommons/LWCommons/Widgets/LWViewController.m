//
//  LWViewController.m
//  
//
//  Created by wangliang on 2017/7/3.
//  Copyright © 2017年 wangliang. All rights reserved.
//

#import "LWViewController.h"
//#import "LWNetworkManager.h"
//#import "LWNetworkReachabilityManager.h"
#import "LWShakingView.h"
#import "LWRetryView.h"
#import <objc/runtime.h>
#import "LWLoadingView.h"
#import "Constants.h"
#import "Commons.h"
#import "NSString+Utilities.h"

static CGFloat WARNING_MESSAGE_DELAY = 2.0f;
static CGFloat WARNING_MESSAGE_DISPLAY_DELAY = 0.2f;
static NSString *LWNotificationNumberKey = @"notificationNumber";
static NSString *LWNotificationDataKey = @"notificationData";

@interface LWViewController ()

@end

@implementation LWViewController
{
    NSMutableArray *_refreshTypes;
    NSMutableDictionary *_refreshType2Data;
    BOOL _firstLoad;
    LWRetryView *_retryView;
    LWLoadingView *_loadingView;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        if (IOS7) {
            self.edgesForExtendedLayout = UIRectEdgeAll;
            self.automaticallyAdjustsScrollViewInsets = YES;
        }
        _autorotate = YES;
        _orientationMask = UIInterfaceOrientationMaskAll;
        _preferredOrientation = UIInterfaceOrientationPortrait;
        _interactivePopGestureEnabled = YES;
        _reloadRemoteType = LWReloadRemoteTypeViewDidAppear;
        _shakingEnabled = NO;
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (_firstLoad) {
        _firstLoad = NO;
    }
    else {
        if(self.reloadRemoteType == LWReloadRemoteTypeViewDidAppear){
            [self checkReloadRemoteData];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _isViewVisable = YES;
    [self setAutorotate:_autorotate];
    [self setOrientationMask:_orientationMask];
    [self setPreferredOrientation:_preferredOrientation];
    
    if(_firstLoad) {
        _firstLoad = NO;
    }
    else{
        if(self.reloadRemoteType == LWReloadRemoteTypeViewWillAppear) {
            [self checkReloadRemoteData];
        }
    }
    if (iOS6) {
        [self.view becomeFirstResponder];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    _isViewVisable = NO;
    if (iOS6) {
        [self.view resignFirstResponder];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    DLog(@"############### Dealloc: %@", [self class]);
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if(_shakingEnabled){
        LWShakingView *shakingView = [[LWShakingView alloc] initWithFrame:self.view.bounds];
        __weak id weakSelf = self;
        shakingView.onShaking = ^(void){
            [weakSelf handleShaking];
        };
        self.view = shakingView;
    }
    self.view.backgroundColor = kWhiteColor;
    
    _refreshTypes = [NSMutableArray array];
    _refreshType2Data = [NSMutableDictionary dictionary];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleAppBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleAppWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
}

- (void)handleShaking {
    //DLog(@"####### Shaking........");
}

- (void)handleAppBecomeActive:(NSNotification *)notification {
    [self appBecomeActive:notification];
}

- (void)handleAppWillResignActive:(NSNotification *)notification {
    [self appWillResignActive:notification];
}

- (void)appBecomeActive:(NSNotification *)notification {
    
}

- (void)appWillResignActive:(NSNotification *)notification {
    
}

- (void)handleRefreshNotification:(NSNotification *)notification {
    NSDictionary *dictionary = notification.object;
    if(dictionary){
        NSNumber *number = [dictionary objectForKey:LWNotificationNumberKey];
        if (number) {
            id data = [dictionary objectForKey:LWNotificationDataKey];
            [self addRefreshType:number.integerValue withData:data];
        }
    }
}

- (void)addRefreshType:(NSInteger)refreshType withData:(id)data {
    if(![self containsNotification:refreshType]) {
        [_refreshTypes addObject:[NSNumber numberWithInteger:refreshType]];
        if (data) {
            [_refreshType2Data setObject:data forKey:[NSString stringWithFormat:@"%d", (int)refreshType]];
        }
        if (_isViewVisable) {
            [self checkReloadRemoteData];
        }
    }
}

- (void) checkReloadRemoteData {
    if(_refreshTypes.count > 0) {
        for(NSNumber *number in _refreshTypes) {
            [self didReceiveNotification:number.integerValue withData:[_refreshType2Data objectForKey:[NSString stringWithFormat:@"%d", (int)number.integerValue]]];
        }
        [_refreshTypes removeAllObjects];
    }
}

- (void)setAutorotate:(BOOL)autorotate {
    _autorotate = autorotate;
    if([self.navigationController isKindOfClass:[LWNavigationController class]]){
        [((LWNavigationController *)self.navigationController) setAutorotate:autorotate];
    }
}

- (BOOL)isAutorotate {
    return _autorotate;
}

- (void)setOrientationMask:(UIInterfaceOrientationMask)orientationMask {
    _orientationMask = orientationMask;
    if([self.navigationController isKindOfClass:[LWNavigationController class]]){
        [((LWNavigationController *)self.navigationController) setOrientationMask:orientationMask];
    }
}

- (void)setPreferredOrientation:(UIInterfaceOrientation)preferredOrientation {
    _preferredOrientation = preferredOrientation;
    if([self.navigationController isKindOfClass:[LWNavigationController class]]){
        [((LWNavigationController*)self.navigationController) setPreferredOrientation:preferredOrientation];
    }
    //    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:preferredOrientation] forKey:@"orientation"];
}

- (BOOL)shouldAutorotate {
    return _autorotate;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return UIInterfaceOrientationPortrait;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return _orientationMask;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return _preferredOrientation;
}

- (void) setInteractivePopGestureRecognizerEnabled:(BOOL)enabled{
    _interactivePopGestureEnabled = enabled;
    if([self.navigationController isKindOfClass:[LWNavigationController class]]){
        [((LWNavigationController*)self.navigationController) setInteractivePopGestureRecognizerEnabled:enabled];
    }
}

//Network Related Interfaces
//- (BOOL)isReachable{
//    return [[LWNetworkReachabilityManager sharedManager] isReachable];
//}
//
//- (BOOL)isReachableViaWiFi{
//    return [[LWNetworkReachabilityManager sharedManager] isReachableViaWiFi];
//}
//
//- (BOOL)isReachableViaWWAN{
//    return [[LWNetworkReachabilityManager sharedManager] isReachableViaWWAN];
//}

- (void) startLWLoadingViewWithMessage:(NSString*) message {
    
}

- (void) stopLWLoadingView {
    
}

- (void) stopRefreshing:(UIScrollView*) scrollView refresh:(BOOL) refresh pulling:(BOOL) pulling {
    if (pulling) {
        if (refresh) {
//            [scrollView stopHeaderRefreshing];
        }
        else {
//            [scrollView stopFooterRefreshing];
        }
    } else {
        [self stopLoadingView];
    }
}

- (void)startLoadingViewWithMessage:(NSString *)loadingMessage {
    if (!_loadingView) {
        _loadingView = [[LWLoadingView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight) andRadius:0];
        _loadingView.backgroundColor = _loadingView.maskColor;
        __weak id weakSelf = self;
        _loadingView.popviewDidClose = ^(LWPopoverView *popoverView) {
            [weakSelf handleCloseLoadingView];
        };
    }
    [_loadingView showInView:self.view];
}

- (UIColor*)loadingMaskColor {
    return kClearColor;
}

- (void)handleCloseLoadingView {
    _loadingView = nil;
}

- (void)stopLoadingView{
    [self stopLoadingView:YES];
}

- (void)stopLoadingView:(BOOL)animated{
    if (_loadingView) {
        [_loadingView close/*:animated*/];
    }
}

- (void) rightNavigationItemWithSpacing:(UIBarButtonSystemItem)systemItem target:(id)target action:(SEL)sel{
    BOOL special = NO;
    switch (systemItem) {
        case UIBarButtonSystemItemSearch:
        case UIBarButtonSystemItemAdd:
        case UIBarButtonSystemItemAction:
        case UIBarButtonSystemItemBookmarks:
        case UIBarButtonSystemItemCamera:
        case UIBarButtonSystemItemCompose:
        case UIBarButtonSystemItemFastForward:
        case UIBarButtonSystemItemPlay:
        case UIBarButtonSystemItemTrash:
        case UIBarButtonSystemItemRewind:
        case UIBarButtonSystemItemOrganize:
        case UIBarButtonSystemItemPause:
        case UIBarButtonSystemItemRefresh:
        case UIBarButtonSystemItemReply:
        case UIBarButtonSystemItemStop:
        case UIBarButtonSystemItemPageCurl:
            special = YES;
            break;
            
        default:
            break;
    }
    if (IOS7 && special) {
        UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        space.width = -8;
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:systemItem target:target action:sel], space, nil];
    }
    else{
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:systemItem target:target action:sel];
    }
}

- (UIImage*)screenShot
{
    // Create a graphics context with the target size
    // On iOS 4 and later, use UIGraphicsBeginImageContextWithOptions to take the scale into consideration
    // On iOS prior to 4, fall back to use UIGraphicsBeginImageContext
    CGSize imageSize = [[UIScreen mainScreen] bounds].size;
    if (NULL != &UIGraphicsBeginImageContextWithOptions)
        UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    else
        UIGraphicsBeginImageContext(imageSize);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Iterate over every window from back to front
    for (UIWindow *window in [[UIApplication sharedApplication] windows])
    {
        if (![window respondsToSelector:@selector(screen)] || [window screen] == [UIScreen mainScreen])
        {
            // -renderInContext: renders in the coordinate space of the layer,
            // so we must first apply the layer's geometry to the graphics context
            CGContextSaveGState(context);
            // Center the context around the window's anchor point
            CGContextTranslateCTM(context, [window center].x, [window center].y);
            // Apply the window's transform about the anchor point
            CGContextConcatCTM(context, [window transform]);
            // Offset by the portion of the bounds left of and above the anchor point
            CGContextTranslateCTM(context,
                                  -[window bounds].size.width * [[window layer] anchorPoint].x,
                                  -[window bounds].size.height * [[window layer] anchorPoint].y);
            
            // Render the layer hierarchy to the current context
            [[window layer] renderInContext:context];
            
            // Restore the context
            CGContextRestoreGState(context);
        }
    }
    
    // Retrieve the screenshot image
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

- (void) createRetryViewWithCompletion:(void (^)(void))completion{
    [self createRetryViewWithMessage:nil onCompletion:completion];
}

- (void) createRetryViewWithMessage:(NSString *)message onCompletion:(void (^)(void))completion{
    if(!_retryView){
        CGFloat w = 148, h = 180;
        _retryView = [[LWRetryView alloc] initWithFrame:CGRectMake((self.view.frame.size.width-w)/2, (self.view.frame.size.height-h)/2, w, h) andRadius:8];
        _retryView.layer.opacity = 0.0f;
        _retryView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin;
        //_retryView.backgroundColor = kRGB(245, 245, 245);
        _retryView.layer.opacity = .85;
        if (message) {
            _retryView.retryMessage = message;
        }
        [_retryView setIconBGColor:kClearColor];
        _retryView.onRetry = ^(void){
            if (completion) {
                completion();
            }
        };
        [self.view addSubview:_retryView];
        
        [UIView animateWithDuration:0.5 animations:^{
            _retryView.layer.opacity = 1.0f;
        } completion:^(BOOL finished) {
            
        }];
    }
}

- (void)removeRetryView{
    if (_retryView) {
        [_retryView removeFromSuperview];
        _retryView = nil;
    }
}

- (void)layoutRetryViewAnimate:(BOOL)animated{
    if(_retryView){
        if (animated) {
            [UIView animateWithDuration:0.25 animations:^{
                _retryView.frame  =CGRectMake((self.view.frame.size.width-_retryView.frame.size.width)/2, (self.view.frame.size.height-_retryView.frame.size.height)/2, _retryView.frame.size.width, _retryView.frame.size.height);
            } completion:^(BOOL finished) {
                
            }];
        }
        else{
            _retryView.frame  =CGRectMake((self.view.frame.size.width-_retryView.frame.size.width)/2, (self.view.frame.size.height-_retryView.frame.size.height)/2, _retryView.frame.size.width, _retryView.frame.size.height);
        }
    }
}

- (UIControl*)buttonItemForBarButton:(UIBarButtonItem *)barButtonItem{
    UINavigationBar *toolbar = self.navigationController.navigationBar;
    UIControl *button = nil;
    for (UIView *subview in toolbar.subviews) {
        if ([subview isKindOfClass:[UIControl class]]) {
            for (id target in [(UIControl *)subview allTargets]) {
                if (target == barButtonItem) {
                    button = (UIControl *)subview;
                    break;
                }
            }
            if (button != nil) break;
        }
    }
    return button;
}

- (CGFloat)topLayoutGuideHeight {
    return self.topLayoutGuide.length;
    //return ((UIView*)self.topLayoutGuide).frame.size.height;
}

- (CGFloat)bottomLayoutGuideHeight {
    return self.bottomLayoutGuide.length;
    //return ((UIView*)self.bottomLayoutGuide).frame.size.height;
}

- (CGFloat) layoutGuideHeight {
    return self.topLayoutGuideHeight+self.bottomLayoutGuideHeight;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

@implementation UIViewController (Message)

- (LWView *)warningView {
    return objc_getAssociatedObject(self, @"LWWarningView");
}

- (void)setWarningView:(LWView *)warningView {
    if (warningView) {
        objc_setAssociatedObject(self, @"LWWarningView", warningView, OBJC_ASSOCIATION_RETAIN);
    }
    else {
        //objc_removeAssociatedObjects(self);
        objc_setAssociatedObject(self, @"LWWarningView", nil, OBJC_ASSOCIATION_RETAIN);
    }
}

- (void) showWarningView:(NSString *)warningMessage{
    [self showWarningView:warningMessage autoCloseAfter:WARNING_MESSAGE_DELAY];
}

- (void) showWarningViewWithDisplayDelay:(NSString *)warningMessage{
    [self showWarningView:warningMessage autoDisplayAfter:WARNING_MESSAGE_DISPLAY_DELAY autoCloseAfter:WARNING_MESSAGE_DELAY onCompletion:nil];
}

- (void) showWarningView:(NSString *)warningMessage autoDisplayAfter:(double)displayDelay{
    [self showWarningView:warningMessage autoDisplayAfter:displayDelay autoCloseAfter:WARNING_MESSAGE_DELAY onCompletion:nil];
}

- (void) showWarningView:(NSString *)warningMessage onCompletion:(void (^)(void))completion {
    [self showWarningView:warningMessage autoCloseAfter:WARNING_MESSAGE_DELAY onCompletion:completion];
}

- (void) showWarningView:(NSString *)warningMessage autoCloseAfter:(NSInteger)secondsDelay {
    [self showWarningView:warningMessage autoCloseAfter:secondsDelay onCompletion:nil];
}

- (void) showWarningView:(NSString *)warningMessage autoCloseAfter:(double)secondsDelay onCompletion:(void (^)(void))completion{
    [self showWarningView:warningMessage autoDisplayAfter:0 autoCloseAfter:secondsDelay onCompletion:completion];
}

- (void) showWarningView:(NSString *)warningMessage autoDisplayAfter:(double)displaySecondsDelay autoCloseAfter:(double)secondsDelay onCompletion:(void (^)(void))completion{
    if([NSString isNullOrEmpty:warningMessage]){
        return;
    }
    LWView *_warningView = [self warningView];
    if (_warningView == nil) {
        _warningView = [self createWarningView:warningMessage];
        _warningView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin;
        if (completion) {
            objc_setAssociatedObject(_warningView, @"warningViewCompletionBlock", completion, OBJC_ASSOCIATION_COPY);
        }
        [self setWarningView:_warningView];
        [self.view addSubview:_warningView];
    }
    else{
        UILabel *label = (UILabel*)[_warningView viewWithTag:1000];
        [label removeFromSuperview];
        [self createWarningView:warningMessage];
//        [label setText:warningMessage];
        
    }
    if (displaySecondsDelay > 0.01){
        _warningView.hidden = YES;
        [self performSelector:@selector(displayWarningView:) withObject:_warningView afterDelay:displaySecondsDelay];
    }
    
    if(secondsDelay<=0){
        secondsDelay = WARNING_MESSAGE_DELAY;
    } else {
        secondsDelay += displaySecondsDelay;
    }
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideWarningView:) object:_warningView];
    [self performSelector:@selector(hideWarningView:) withObject:_warningView afterDelay:secondsDelay];
}

- (LWView *)createWarningView:(NSString *)warningMessage {
    UILabel *warningLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, 10, kDeviceWidth-16*2, 50)];
    warningLabel.text = warningMessage;
    warningLabel.textColor = kRGB(225, 225, 225);
    warningLabel.font = kAppFont(14);
    warningLabel.tag = 1000;
    warningLabel.textAlignment = NSTextAlignmentCenter;
    warningLabel.numberOfLines = 0;
    [warningLabel sizeToFit];
    if (warningLabel.frame.size.width<self.view.frame.size.width/2) {
        CGRect r = warningLabel.frame;
        r.size.width = MAX(self.view.frame.size.width/3, r.size.width);
        warningLabel.frame = r;
    }
    
    CGRect frame = CGRectMake((self.view.frame.size.width-warningLabel.frame.size.width-16*2)/2, (self.view.frame.size.height-warningLabel.frame.size.height-20)/2+64/2, warningLabel.frame.size.width+16*2, warningLabel.frame.size.height+20);
    LWView *_warningView = [self warningView];
    if (!_warningView) {
        _warningView = [[LWView alloc]initWithFrame:frame andRadius:0.0f];
    }
    else {
        _warningView.frame = frame;
    }
    
    _warningView.radius = (int)_warningView.frame.size.height/2;
    [_warningView addSubview:warningLabel];
    warningLabel=nil;
    _warningView.backgroundColor = kRGBA(45, 45, 45, 0.85);
    return _warningView;
}

- (void)displayWarningView:(LWView*)warningView{
    warningView.hidden = NO;
}

- (void)hideWarningView:(LWView *)warningView {
    [UIView animateWithDuration:0.25 animations:^{
        warningView.layer.opacity = 0.0f;
    } completion:^(BOOL finished) {
        [warningView removeFromSuperview];
        void (^completionBlock)(void) = objc_getAssociatedObject(warningView, @"warningViewCompletionBlock");
        if (completionBlock) {
            completionBlock();
        }
        [self setWarningView:nil];
    }];
}

- (void) showAlertMessage:(NSString *)message {
    [self showAlertMessage:message withTitle:nil];
}

- (void) showAlertMessage:(NSString *)message withTitle:(NSString *)title{
    [self showAlertMessage:message withTitle:title onCompletion:nil];
}

- (void) showAlertMessage:(NSString *)message onCompletion:(LWAlertControllerAlertCompletionBlock)completion {
    [self showAlertMessage:message withTitle:nil onCompletion:completion];
}

- (void) showAlertMessage:(NSString*) message withTitle:(NSString *)title onCompletion:(LWAlertControllerAlertCompletionBlock)completion {
    [self showConfirmMessage:message withTitle:title cancelButtonTitle:@"关闭" okButtonTitle:nil onCompletion:completion];
}

- (void) showConfirmMessage:(NSString *)message withTitle:(NSString *)title onCompletion:(LWAlertControllerAlertCompletionBlock)completion {
    [self showConfirmMessage:message withTitle:title cancelButtonTitle:@"取消" okButtonTitle:@"确定" onCompletion:completion];
}

- (void) showConfirmMessage:(NSString *)message withTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle okButtonTitle:(NSString *)okButtonTitle onCompletion:(LWAlertControllerAlertCompletionBlock)completion {
//    [[LWAlert sharedAlert] showConfirmMessage:message withTitle:title cancelButtonTitle:cancelButtonTitle okButtonTitle:okButtonTitle onCompletion:completion];
    [[LWAlert sharedAlert] showConfirmMessageInViewController:self message:message withTitle:title cancelButtonTitle:cancelButtonTitle okButtonTitle:okButtonTitle onCompletion:completion];
}

- (void) showActionSheetOnCompletion:(LWAlertControllerActionSheetCompletionBlock)completion withTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString*) cancelButtonTitle destructiveButtonTitle:(NSString*) destructiveButtonTitle otherButtonTitles:(NSString*) otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION {
    NSMutableArray *otherButtonTitlesArray = [NSMutableArray array];
    va_list args;
    va_start(args, otherButtonTitles);
    for (NSString *arg = otherButtonTitles; arg != nil; arg = va_arg(args, NSString*)) {
        [otherButtonTitlesArray addObject:arg];
    }
    va_end(args);
    [[LWAlert sharedAlert] showActionSheetInViewController:self completion:completion
                                withTitle:title
                                  message:message
                        cancelButtonTitle:cancelButtonTitle
                   destructiveButtonTitle:destructiveButtonTitle
                 otherButtonTitlesInArray:otherButtonTitlesArray];
}

- (void) showActionSheetOnCompletion:(LWAlertControllerActionSheetCompletionBlock)completion withTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitlesInArray:(NSArray *)otherButtonTitles {
    [[LWAlert sharedAlert] showActionSheetInViewController:self completion:completion withTitle:title message:message cancelButtonTitle:cancelButtonTitle destructiveButtonTitle:destructiveButtonTitle otherButtonTitlesInArray:otherButtonTitles];
}

@end

@implementation LWViewController (Notification)

- (void)sendNotification:(NSInteger)notification {
    [self sendNotification:notification withData:nil];
}

- (void)sendNotification:(NSInteger)notification withData:(id)data {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setObject:[NSNumber numberWithInteger:notification] forKey:LWNotificationNumberKey];
    if (data) {
        [dictionary setObject:data forKey:LWNotificationDataKey];
    }
}

- (void)didReceiveNotification:(NSInteger)notification withData:(id)data {
    
}

- (BOOL)containsNotification:(NSInteger)notification {
    NSNumber *number = [NSNumber numberWithInteger:notification];
    return [_refreshTypes containsObject:number];
}

@end

@implementation UIViewController (Helper)

- (void)setInteractivePopGestureEnabled:(BOOL)enabled {
    if (self.navigationController && [self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = enabled;
    }
}

@end

