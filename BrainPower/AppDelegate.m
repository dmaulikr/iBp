//
//  AppDelegate.m
//  BrainPower
//
//  Created by nestcode on 1/2/18.
//  Copyright © 2018 nestcode. All rights reserved.
//

#import "AppDelegate.h"
#import <AVFoundation/AVFoundation.h>
#import "LaunchScreenViewController.h"
@import UIKit;
@import Firebase;
@import FirebaseInstanceID;
@import FirebaseMessaging;
#import "SSZipArchive.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    NSString *storyboardName = [Global getStoryBoardName];
    NSLog(@"storyboardName : %@", storyboardName);
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    
    if (IS_IPHONE_X){
       [application setStatusBarHidden:NO];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAudioSessionEvent:) name:AVAudioSessionInterruptionNotification object:nil];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    // [[InAppPurchaseManager sharedInAppPurchaseManager] provideContent:kInAppRemoveAds];
    [self.window makeKeyAndVisible];
    
    self.window.rootViewController = (UINavigationController *)[storyboard instantiateInitialViewController];
    
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    
    UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
    AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute,sizeof (audioRouteOverride),&audioRouteOverride);
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else
    {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
    }
    
    // [START configure_firebase]
    [FIRApp configure];
    // [END configure_firebase]
    
   // [self UnZipMusic];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tokenRefreshNotification:)
                                                 name:kFIRInstanceIDTokenRefreshNotification object:nil];
    [FIRMessaging messaging].delegate = self;
    
    NSString *fcmToken = [FIRMessaging messaging].FCMToken;
    [[NSUserDefaults standardUserDefaults]setValue:fcmToken forKey:@"FireBaseToken"];
    return YES;
}

- (void)messaging:(FIRMessaging *)messaging didReceiveRegistrationToken:(NSString *)fcmToken {
    NSLog(@"FCM registration token: %@", fcmToken);
    // TODO: If necessary send token to application server.
    // Note: This callback is fired at each app startup and whenever a new token is generated.
}

- (void) onAudioSessionEvent: (NSNotification *) notification
{
    if ([notification.name isEqualToString:AVAudioSessionInterruptionNotification]) {
        NSLog(@"Interruption notification received!");
        if ([[notification.userInfo valueForKey:AVAudioSessionInterruptionTypeKey] isEqualToNumber:[NSNumber numberWithInt:AVAudioSessionInterruptionTypeBegan]]) {
            NSLog(@"Interruption began!");
        }
        else {
            NSLog(@"Interruption ended!");
        }
    }
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    NSLog(@"Notification : %@",userInfo);
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    UIApplicationState state = [application applicationState];
    if (state == UIApplicationStateActive)
    {
        /*UIAlertController *alertController = [UIAlertController
         alertControllerWithTitle:@"Reminder"
         message:notification.alertBody
         preferredStyle:UIAlertControllerStyleAlert];
         [self presentViewController:alertController animated:YES completion:nil];*/
        //   UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Reminder"message:notification.alertBody delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        //  [alert show];
    }
    // Request to reload table view data
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadData" object:self];
    // Set icon badge number to zero
    application.applicationIconBadgeNumber = 0;
}

// [START refresh_token]
- (void)tokenRefreshNotification:(NSNotification *)notification {
    // Note that this callback will be fired everytime a new token is generated, including the first
    // time. So if you need to retrieve the token as soon as it is available this is where that
    // should be done.
    NSString *refreshedToken = [[FIRInstanceID instanceID] token];
    NSLog(@"InstanceID token: %@", refreshedToken);
    // Connect to FCM since connection may have failed when attempted before having a token.
    [self connectToFcm];
    
    // TODO: If necessary send token to appliation server.
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

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    NSLog(@"Hooray! I'm registered!");
    [[FIRMessaging messaging] subscribeToTopic:@"Brain"];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionInterruptionNotification error:nil];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [[FIRMessaging messaging] disconnect];
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    [FIRMessaging messaging].APNSToken = deviceToken;
    NSString * token = [NSString stringWithFormat:@"%@", deviceToken];
    //Format token as you need:
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    token = [token stringByReplacingOccurrencesOfString:@">" withString:@""];
    token = [token stringByReplacingOccurrencesOfString:@"<" withString:@""];
    NSUserDefaults *pref=[NSUserDefaults standardUserDefaults];
    [pref setObject:token forKey:@"DeviceId"];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionMediaServicesWereResetNotification error:nil];
    [self connectToFcm];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadView" object:self];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)UnZipMusic{
    NSString *unzipPath = [self tempUnzipPath];
    if (!unzipPath) {
        return;
    }
    NSString *path = [[NSBundle mainBundle] pathForResource:@"iBrainpower" ofType:@"zip"];
    NSLog(@"%@",unzipPath);
    NSLog(@"%@",path);
    NSString *password = @"ibrainpowers@maulik";
    
    
    BOOL success = [SSZipArchive unzipFileAtPath:path
                                   toDestination:unzipPath
                                       overwrite:YES
                                        password:password.length > 0 ? password : nil
                                           error:nil];
    
    if (!success) {
        NSLog(@"No success");
        return;
    }
    NSError *error = nil;
    
    NSMutableArray<NSString *> *items = [[[NSFileManager defaultManager]
                                          contentsOfDirectoryAtPath:unzipPath
                                          error:&error] mutableCopy];
    if (error) {
        return;
    }
    [items enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *strTemp = [NSString stringWithFormat:@"%@/%@",unzipPath,obj];
        NSURL *TempUrl = [NSURL URLWithString:strTemp];
        NSLog(@"file url: %@",TempUrl);
        [[NSUserDefaults standardUserDefaults] setURL:TempUrl forKey:@"UnZipPath"];
    }];
}

- (NSString *)tempUnzipPath {
    NSString *path1 = [NSString stringWithFormat:@"%@/\%@",
                       NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0],
                       [NSUUID UUID].UUIDString];
    NSURL *url = [NSURL fileURLWithPath:path1];
    NSError *error = nil;
    [[NSFileManager defaultManager] createDirectoryAtURL:url
                             withIntermediateDirectories:YES
                                              attributes:nil
                                                   error:&error];
    if (error) {
        return nil;
    }
    return url.path;
}

@end
