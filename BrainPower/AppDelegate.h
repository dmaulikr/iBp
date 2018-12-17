//
//  AppDelegate.h
//  BrainPower
//
//  Created by nestcode on 1/2/18.
//  Copyright © 2018 nestcode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "Global.h"

@import Firebase;
@import FirebaseInstanceID;
@import FirebaseMessaging;

@interface AppDelegate : UIResponder <UIApplicationDelegate,FIRMessagingDelegate>

@property (strong, nonatomic) UIWindow *window;


@end

