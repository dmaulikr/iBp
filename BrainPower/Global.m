//
//  Global.m
//  MyRecipes
//
//  Created by Sweet Games on 30/05/11.
//  Copyright 2011 Sweet Games LLC. All rights reserved.
//

#import "Global.h"
#import "AppDelegate.h"

@implementation Global


+ (BOOL)isPad
{
    return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
}

+ (BOOL)isPhone
{
    return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone;
}

+ (BOOL)isPhone5
{
    if ([[UIScreen mainScreen] bounds].size.height == 568)
        return YES;
    else
        return NO;
}

+ (BOOL)isPhone6
{
    if ([[UIScreen mainScreen] bounds].size.height == 667)
        return YES;
    else
        return NO;
}

+ (BOOL)isPhone6plus
{
    if ([[UIScreen mainScreen] bounds].size.height == 736)
        return YES;
    else
        return NO;
}

+ (BOOL)isPhoneX
{
    if ([[UIScreen mainScreen] bounds].size.height >= 812.0f)
        return YES;
    else
        return NO;
}

+ (void)setBackBarButtonItem:(UINavigationItem *)navItem
{
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    [backButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                        [Global getThemeColorLight], NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    navItem.backBarButtonItem = backButton;
    
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[Global getThemeColorLight], NSForegroundColorAttributeName,nil]
                                                                                            forState:UIControlStateNormal];}

+ (void)showAlertWithTitle:(NSString *)alertTitle andMessage:(NSString *)message andTag:(int)tag;
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:alertTitle
                                                    message:message delegate:nil
                                          cancelButtonTitle:@"OK" otherButtonTitles:nil];
    alert.tag = tag;
    [alert show];
}

+ (void)decorateButton:(UIButton *)btn isImage:(BOOL)isImage andImageName:(NSString *)strImageName
{
    if (isImage) {
        [btn setImage:[UIImage imageNamed:strImageName] forState:UIControlStateNormal];
    }
    else
    {
        [btn setBackgroundColor:[UIColor blackColor]];
        if ([Global isPad])
        {
            btn.titleLabel.font = [UIFont fontWithName:FONT_NAME size:30];
            btn.layer.cornerRadius = 15;
        }
        else
        {
            btn.titleLabel.font = [UIFont fontWithName:FONT_NAME size:20];
            btn.layer.cornerRadius = 10;
        }
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
}

+ (UIColor *)getThemeColorLight
{
    return [UIColor colorWithRed:0.0/255 green:172.0/255 blue:248.0/255 alpha:1.0];
}

+ (UIColor *)getThemeColorDark
{
    return [UIColor colorWithRed:1/255 green:1/255 blue:1/255 alpha:1.0];
}

+ (NSString *)getStoryBoardName
{
    NSString *storyboardName = @"Main";
    
    if ([Global isPhone])
    {
        if ([Global isPhone5])
            storyboardName = @"Main";
        else if ([Global isPhone6])
            storyboardName = @"Main_6";
        else if ([Global isPhone6plus])
            storyboardName = @"Main_6Plus";
        else if ([Global isPhoneX])
            storyboardName = @"Main_X";
        else
            storyboardName = @"Main";
    }
    
    return storyboardName;
}

+ (NSString *)getNibNameByControllerName:(NSString *)strControllerName
{
    NSString *strNibName = @"";
    
    if ([Global isPad])
    {
        strNibName = [NSString stringWithFormat:@"%@_iPad", strControllerName];
    }
    else
    {
        strNibName = strControllerName;
    }
    
    return strNibName;
}


@end

