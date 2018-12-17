//
//  Global.h
//  MyRecipes
//
//  Created by Sweet Games on 30/05/11.
//  Copyright 2011 Sweet Games LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
#import <UIKit/UIColor.h>

#define FONT_NAME @"Agency FB"



@interface Global : NSObject
{

}

+ (BOOL)isPad;
+ (BOOL)isPhone;
+ (BOOL)isPhone5;
+ (BOOL)isPhone6;
+ (BOOL)isPhone6plus;
+ (BOOL)isPhoneX;


+ (void)setBackBarButtonItem:(UINavigationItem *)navItem;
+ (void)showAlertWithOKButton:(NSString *)title message:(NSString *)message;
+ (void)decorateButton:(UIButton *)btn isImage:(BOOL)isImage andImageName:(NSString *)strImageName;
+ (UIColor *)getThemeColorLight;
+ (UIColor *)getThemeColorDark;
+ (NSString *)getStoryBoardName;
+ (NSString *)getNibNameByControllerName:(NSString *)strControllerName;

@end
