//
//  main.m
//  BrainPower
//
//  Created by nestcode on 1/2/18.
//  Copyright © 2018 nestcode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "LanguageManager.h"

int main(int argc, char * argv[]) {
    @autoreleasepool {
        [LanguageManager setupCurrentLanguage];
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
