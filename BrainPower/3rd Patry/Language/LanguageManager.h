//
//  LanguageManager.h
//  ios_language_manager
//
//  Created by Maxim Bilan on 12/23/14.
//  Copyright (c) 2014 Maxim Bilan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ELanguage)
{
    ELanguageEnglish,
    ELanguageHindi,
    ELanguageGujarati,
    ELanguageMarathi,
    ELanguageTamil,
    ELanguageMalyalam,
    ELanguageSpanish,
    ELanguageArabic,
    ELanguageFrench,
    ELanguageChinese,
    ELanguageCount
};

@interface LanguageManager : NSObject

+ (void)setupCurrentLanguage;
+ (NSArray *)languageStrings;
+ (NSString *)currentLanguageString;
+ (NSString *)currentLanguageCode;
+ (NSInteger)currentLanguageIndex;
+ (void)saveLanguageByIndex:(NSInteger)index;
+ (void)saveLanguageID:(NSString *)ID;
+ (BOOL)isCurrentLanguageRTL;

@end
