//
//  AppDelegate.m
//  RelaxApp
//
//  Created by JoJo on 9/27/16.
//  Copyright © 2016 JoJo. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeVC.h"
#import "FileHelper.h"
#import "RageIAPHelper.h"
#import "AppCommon.h"
#import <RevMobAds/RevMobAds.h>
#import <RevMobAds/RevMobAdsDelegate.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreLocation/CoreLocation.h>
#import "WelcomeScreenVC.h"
#import "SSTURLShortener.h"

#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
@import UserNotifications;
#endif
@import Firebase;
@import FirebaseInstanceID;
@import FirebaseMessaging;
#import "iRate.h"
// Implement UNUserNotificationCenterDelegate to receive display notification via APNS for devices
// running iOS 10 and above. Implement FIRMessagingDelegate to receive data message via FCM for
// devices running iOS 10 and above.
@interface AppDelegate ()<GADInterstitialDelegate,UNUserNotificationCenterDelegate, FIRMessagingDelegate,RevMobAdsDelegate>
{
    NSTimer* timer;
    HomeVC *viewController1;
    RevMobBanner *banner;
    BOOL isAdsMob;

}
@property (nonatomic, strong) RevMobFullscreen *fullscreen,*video;

@end

@implementation AppDelegate
- (void)initialize
{
    //overriding the default iRate strings
    //set the bundle ID. normally you wouldn't need to do this
    //as it is picked up automatically from your Info.plist file
    //but we want to test with an app that's actually on the store
    [iRate sharedInstance].applicationBundleID = APP_ID_BUNDLE;
    [iRate sharedInstance].onlyPromptIfLatestVersion = NO;
    
    //enable preview mode
//    [iRate sharedInstance].previewMode = YES;
    [iRate sharedInstance].messageTitle = str(kTellUsWhatYouThink);
    [iRate sharedInstance].message = str(kMessageRate);
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Register for remote notifications
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
        // iOS 7.1 or earlier. Disable the deprecation warnings.
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        UIRemoteNotificationType allNotificationTypes =
        (UIRemoteNotificationTypeSound |
         UIRemoteNotificationTypeAlert |
         UIRemoteNotificationTypeBadge);
        [application registerForRemoteNotificationTypes:allNotificationTypes];
#pragma clang diagnostic pop
    } else {
        // iOS 8 or later
        // [START register_for_notifications]
        if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_9_x_Max) {
            UIUserNotificationType allNotificationTypes =
            (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge);
            UIUserNotificationSettings *settings =
            [UIUserNotificationSettings settingsForTypes:allNotificationTypes categories:nil];
            [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        } else {
            // iOS 10 or later
#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
            UNAuthorizationOptions authOptions =
            UNAuthorizationOptionAlert
            | UNAuthorizationOptionSound
            | UNAuthorizationOptionBadge;
            [[UNUserNotificationCenter currentNotificationCenter]
             requestAuthorizationWithOptions:authOptions
             completionHandler:^(BOOL granted, NSError * _Nullable error) {
             }
             ];
            
            // For iOS 10 display notification (sent via APNS)
            [[UNUserNotificationCenter currentNotificationCenter] setDelegate:self];
            // For iOS 10 data message (sent via FCM)
            [[FIRMessaging messaging] setRemoteMessageDelegate:self];
#endif
        }
        
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        // [END register_for_notifications]
    }
    
    // [START configure_firebase]
    [FIRApp configure];
    // [END configure_firebase]
    // Add observer for InstanceID token refresh callback.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tokenRefreshNotification:)
                                                 name:kFIRInstanceIDTokenRefreshNotification object:nil];
    //IAP
    [RageIAPHelper sharedInstance];
    [self reloadIAP];

    // Initialize Google Mobile Ads SDK
    [GADMobileAds configureWithApplicationID:FIREBASE_APP_ID];

    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window setBackgroundColor:[UIColor whiteColor]];
    //

    // Override point for customization after application launch.
    viewController1 = [[HomeVC alloc] initWithNibName:@"HomeVC" bundle:nil];
    
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:viewController1];
    
    [self.window setRootViewController:self.navigationController ];

    [self.window makeKeyAndVisible];
    //
    if (![[NSUserDefaults standardUserDefaults] boolForKey:show_welcome_screen]) {
        WelcomeScreenVC *ws = [[WelcomeScreenVC alloc] initWithNibName:@"WelcomeScreenVC" bundle:nil];
        
        [viewController1 presentViewController:ws animated:NO completion:^{
        }];
    }

    [self timerBackGround];
    //[START configure_revabmod]
    [self startSampleApp3Session];
    //[END configure_revabmod]
    //RATING
    [self initialize];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}



- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
-(void)applicationDidBecomeActive:(UIApplication *)application
{
    if ([COMMON isReachable]) {
        [viewController1 loadCache];
    }
    
}
//MARK: - SHARE SOCIAL
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    NSString *strRoot = @"";
    if (VERSION_PRO) {
        strRoot = @"relaf";
    }
    else
    {
        strRoot = @"relafree";
    }

    if([[url scheme] isEqualToString:strRoot])
    {
        NSLog(@"Calling Application Bundle ID: %@", sourceApplication);
        NSLog(@"URL scheme:%@", [url scheme]);
        NSLog(@"URL query: %@", [url query]);
        //relaf://play?1=2,0.5&1=4,0.5&1=5,0.5&1=6,0.5&1=7,0.5&1=8,0.5&1=9,0.5&1=10,0.5&1=11,0.5
        NSString *strParam = [url query];
        [viewController1 fnGetMusicFromParam:strParam];
    }
    
    return YES;
}
-(void)setCallback:(AppDelegateCallback)callback
{
    _callback = callback;
}
-(void)setCallbackTimerTick:(TimerTickCallback)callbackTimerTick
{
    _callbackTimerTick = callbackTimerTick;
}
-(void)timerBackGround
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        //How often to update the clock labels
        timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(myTimerAction) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
        [[NSRunLoop currentRunLoop] run];
    });


}
-(void)stopTimerBackGround
{
    [timer invalidate];
    timer = nil;
}
-(void)myTimerAction
{

    NSDate *date = [NSDate date];
    NSString *strCurrentDate = [self convertDateToString:date];
    NSString *strPath = [FileHelper pathForApplicationDataFile:FILE_TIMER_SAVE];
    NSArray *arrTmp = [NSArray arrayWithContentsOfFile:strPath];
    if (arrTmp.count> 0) {
        NSMutableArray *arrSave = [arrTmp mutableCopy];
        for (int i = 0; i < arrSave.count; i++) {
            NSDictionary *dicTimer = arrSave[i];
            if ([dicTimer[@"enabled"] boolValue]) {
                if ([dicTimer[@"type"] intValue] == TIMER_CLOCK) {
                    NSString *strTimer = [self convertDateToString:dicTimer[@"timer"]];
                    if ([self checkDateEqualDate:strCurrentDate withTimer:strTimer]) {
                            [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFCATION_TIMER object:dicTimer];
                        if (_callback) {
                            _callback(dicTimer);
                        }
                    }
                }
                else
                {
                    int countDown = [dicTimer[@"countdown"] intValue];
                    if (countDown <= 1) {
                        [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFCATION_TIMER object:dicTimer];
                        if (_callback) {
                            _callback(dicTimer);
                        }
                        NSMutableDictionary *dicTmp = [dicTimer mutableCopy];
                        [dicTmp setObject:@(0) forKey:@"enabled"];
                        [dicTmp setObject:@(0) forKey:@"countdown"];
                        [arrSave replaceObjectAtIndex:i withObject:dicTmp];
                    }
                    else
                    {
                        countDown -= 1;
                        NSMutableDictionary *dicTmp = [dicTimer mutableCopy];
                        [dicTmp setObject:@(countDown) forKey:@"countdown"];
                        [arrSave replaceObjectAtIndex:i withObject:dicTmp];
                    }
                    [arrSave writeToFile:strPath atomically:YES];

                }
            }
        }

    }
    if (_callbackTimerTick) {
        _callbackTimerTick(nil);
    }
}

-(NSDate*)convertStringToDate:(NSString*)dateString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss"];

    NSDate *date = [dateFormatter dateFromString:dateString];
    return date;
}
-(NSString*)convertDateToString:(NSDate*)date
{
    //
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    [formatter1 setDateFormat:@"HH:mm"];
    NSString *stringFromDate1 = [formatter1 stringFromDate:date];

    NSDate *date1 =[formatter1 dateFromString:stringFromDate1];
    //
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm:ss"];
    NSString *stringFromDate = [formatter stringFromDate:date1];
    return stringFromDate;
}
-(BOOL)checkDateEqualDate:(NSString*)time1 withTimer:(NSString*)time2
{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm:ss"];
    
    NSDate *date1= [formatter dateFromString:time1];
    NSDate *date2 = [formatter dateFromString:time2];
    
    NSComparisonResult result = [date1 compare:date2];
    if(result == NSOrderedSame)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}
#pragma mark Game logic
-(void)setCallbackDismissAds:(DismisAdsDelegateCallback)callbackDismissAds
{
    _callbackDismissAds = callbackDismissAds;
}
- (void)startNewAds {
    [self createAndLoadInterstitial];
}
-(void)showAds
{
    if (self.interstitial.isReady) {
        [self.interstitial presentFromRootViewController:viewController1];
    } else {
        NSLog(@"Ad wasn't ready");
        isAdsMob = NO;

        [self showVideo];
    }
    
}
- (void)createAndLoadInterstitial {
    self.interstitial =
    [[GADInterstitial alloc] initWithAdUnitID:FIREBASE_INTERSTITIAL_UnitID];
    self.interstitial.delegate = self;
    GADRequest *request = [GADRequest request];
    // Request test ads on devices you specify. Your test device ID is printed to the console when
    [self.interstitial loadRequest:request];
}
- (void)interstitialDidReceiveAd:(GADInterstitial *)ad
{
    isAdsMob = YES;
    [self showAds];

}
- (void)interstitial:(GADInterstitial *)ad didFailToReceiveAdWithError:(GADRequestError *)error
{
    isAdsMob = NO;
    [self showVideo];
}
- (void)interstitialDidDismissScreen:(GADInterstitial *)interstitial {
    if (_callbackDismissAds) {
        _callbackDismissAds();
    }
}
//MARK: -AIP
-(void)setCallbackAIP:(AIPDelegateCallback)callbackAIP
{
    _callbackAIP = callbackAIP;
}
- (void)reloadIAP {
    [[RageIAPHelper sharedInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
        if (success) {
            _arrAIP = products;
            if (_callbackAIP) {
                _callbackAIP();
            }
        }
    }];
}
// [START receive_message]
// To receive notifications for iOS 9 and below.
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    // If you are receiving a notification message while your app is in the background,
    // this callback will not be fired till the user taps on the notification launching the application.
    // TODO: Handle data of notification
    
    // Print message ID.
    NSLog(@"Message ID: %@", userInfo[@"gcm.message_id"]);
    
    // Print full message.
    NSLog(@"%@", userInfo);
}
// [END receive_message]

// [START ios_10_message_handling]
// Receive displayed notifications for iOS 10 devices.
#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
       willPresentNotification:(UNNotification *)notification
         withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    // Print message ID.
    NSDictionary *userInfo = notification.request.content.userInfo;
    NSLog(@"Message ID: %@", userInfo[@"gcm.message_id"]);
    
    // Print full message.
    NSLog(@"%@", userInfo);
}

// Receive data message on iOS 10 devices.
- (void)applicationReceivedRemoteMessage:(FIRMessagingRemoteMessage *)remoteMessage {
    // Print full message
    NSLog(@"%@", [remoteMessage appData]);
}
#endif
// [END ios_10_message_handling]

// [START refresh_token]
- (void)tokenRefreshNotification:(NSNotification *)notification {
    // Note that this callback will be fired everytime a new token is generated, including the first
    // time. So if you need to retrieve the token as soon as it is available this is where that
    // should be done.
    NSString *refreshedToken = [[FIRInstanceID instanceID] token];
    NSLog(@"InstanceID token: %@", refreshedToken);
    
    // Connect to FCM since connection may have failed when attempted before having a token.
    [self connectToFcm];
    
    // TODO: If necessary send token to application server.
}
// [END refresh_token]

// [START connect_to_fcm]
- (void)connectToFcm {
    [[FIRMessaging messaging] connectWithCompletion:^(NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Unable to connect to FCM. %@", error);
        } else {
            NSLog(@"Connected to FCM.");
        }
    }];
}
// [END connect_to_fcm]
//
//- (void)applicationDidBecomeActive:(UIApplication *)application {
//    [self connectToFcm];
//}
//
//// [START disconnect_from_fcm]
//- (void)applicationDidEnterBackground:(UIApplication *)application {
//    [[FIRMessaging messaging] disconnect];
//    NSLog(@"Disconnected from FCM");
//}
//// [END disconnect_from_fcm]

#pragma mark RevMob methods

- (void)startSampleApp3Session {
    [RevMobAds startSessionWithAppID:REVMOB_ID
                  withSuccessHandler:^{
                      NSLog(@"Session started with block");
                      [self startingAds];
                  } andFailHandler:^(NSError *error) {
                      NSLog(@"Session failed to start with block");
                      isAdsMob = NO;
                  }];
}

- (void) startingAds {
//    [self showBanner];
    [self loadFullscreen];
    [self loadVideo];
}

- (void)printEnvironmentInformation {
    [[RevMobAds session] printEnvironmentInformation];
}

- (void)showBanner {
    //Creating the banner with delegate
    banner = [[RevMobAds session] banner];
    banner.delegate = self;
    [banner showAd];
}

- (void)openAdLink {
    [[RevMobAds session] openAdLinkWithDelegate:self];
}

- (void)loadFullscreen {
    self.fullscreen = [[RevMobAds session] fullscreen];
    self.fullscreen.delegate = self;
    [self.fullscreen loadAd];
}

- (void)showPreLoadedFullscreen{
    if (isAdsMob) {
        return;
    }
    if (self.fullscreen) [self.fullscreen showAd];
}

-(void) loadVideo {

    self.video = [[RevMobAds session] fullscreen];
    self.video.delegate = self;
    [self.video loadVideo];
}

-(void) showVideo{
    if (isAdsMob) {
        return;
    }
    if(self.video) [self.video showVideo];
}

- (void)showPopup {
    [[RevMobAds session] showPopup];
}

#pragma mark - RevMobAdsDelegate methods


/////Fullscreen Listeners/////

-(void) revmobUserDidClickOnFullscreen:(NSString *)placementId{
    NSLog(@"[RevMob Sample App] User clicked in the Fullscreen.");
}
-(void) revmobFullscreenDidReceive:(NSString *)placementId{
    NSLog(@"[RevMob Sample App] Fullscreen loaded.");
}
-(void) revmobFullscreenDidFailWithError:(NSError *)error onPlacement:(NSString *)placementId{
    NSLog(@"[RevMob Sample App] Fullscreen failed: %@. ID: %@", error, placementId);
}
-(void) revmobFullscreenDidDisplay:(NSString *)placementId{
    NSLog(@"[RevMob Sample App] Fullscreen displayed.");
}
-(void) revmobUserDidCloseFullscreen:(NSString *)placementId{
    NSLog(@"[RevMob Sample App] User closed the fullscreen.");
    if (_callbackDismissAds) {
        _callbackDismissAds();
    }

}

///Banner Listeners///

-(void) revmobUserDidClickOnBanner:(NSString *)placementId{
    NSLog(@"[RevMob Sample App] User clicked in the Banner.");
}
-(void) revmobBannerDidReceive:(NSString *)placementId{
    NSLog(@"[RevMob Sample App] Banner loaded.");
}
-(void) revmobBannerDidFailWithError:(NSError *)error onPlacement:(NSString *)placementId{
    NSLog(@"[RevMob Sample App] Banner failed: %@. ID: %@", error, placementId);
}
-(void) revmobBannerDidDisplay:(NSString *)placementId{
    NSLog(@"[RevMob Sample App] Banner displayed.");

}


/////Video Listeners/////
-(void)revmobVideoDidLoad:(NSString *)placementId {
    NSLog(@"[RevMob Sample App] Video loaded. ID: %@", placementId);
}

-(void)revmobVideoNotCompletelyLoaded:(NSString *)placementId {
    NSLog(@"[RevMob Sample App] Video not completely loaded. ID: %@", placementId);
    [self showPreLoadedFullscreen];
}

-(void)revmobVideoDidStart:(NSString *)placementId {
    NSLog(@"[RevMob Sample App] Video started. ID: %@", placementId);
}

-(void)revmobVideoDidFinish:(NSString *)placementId {
    NSLog(@"[RevMob Sample App] Video started. ID: %@", placementId);
}
- (void)revmobUserDidCloseVideo:(NSString *)placementId
{
    if (_callbackDismissAds) {
        _callbackDismissAds();
    }

}
//MARK: - share Socical
//Share
- (void)shareSocial:(NSDictionary*)dicMusic {
    
    NSMutableString *str = [NSMutableString new];
    NSArray *arrMusic = dicMusic[@"music"];
    //relaf://play?1=1,1,20&2,4,20&4,2,8
    for (NSDictionary *dic in arrMusic) {
        [str appendString:[NSString stringWithFormat:@"%@=%@,%@&",dic[@"category_id"],dic[@"id"],dic[@"volume"]]];
    }
    if (str.length > 0) {
        NSString *subString = [str substringToIndex:[str length] - 1];
        NSString *strRoot = @"";
        if (VERSION_PRO) {
            strRoot = @"https://relafapp.com/play?";
        }
        else
        {
            strRoot = @"https://www.relafapp.com/fplay?";
        }
        NSString *strLink = [NSString stringWithFormat:@"￼%@%@",strRoot,subString];
        NSString *codeString = @"\uFFFC";
        strLink =[strLink stringByReplacingOccurrencesOfString:codeString withString:@""];
        
        NSURL *url = [NSURL URLWithString:[self characterTrimming:strLink]];
        [SSTURLShortener shortenURL:url
                        accessToken:BITLY_ACCESSTOKEN
                withCompletionBlock:^(NSURL *shortenedURL, NSError *error) {
                    [self handleShortenedURL:shortenedURL error:error];
                }];
        
        
    }
    
}
- (void)handleShortenedURL:(NSURL *)shortenedURL error:(NSError *)error {
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:str(kBadNetwork)
                                                        message:str(kPleaseConnectInternet)
                                                       delegate:self
                                              cancelButtonTitle:kuOK
                                              otherButtonTitles:nil];
        [alert show];
    }
    else {
        NSString *message = [NSString stringWithFormat:@"I'm relaxing with @relafapp, let's relax with me %@",shortenedURL.absoluteString] ;
        NSArray * shareItems = @[message];
        ///0838999666
        UIActivityViewController * avc = [[UIActivityViewController alloc] initWithActivityItems:shareItems applicationActivities:nil];
        
        [viewController1 presentViewController:avc animated:YES completion:nil];
        
    }
}
-(NSString *)characterTrimming:(NSString *)str{
    str = [[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return str;
}

@end
