//
//  Constants.h
//  BrainPower
//
//  Created by nestcode on 1/3/18.
//  Copyright © 2018 nestcode. All rights reserved.
//

#ifndef Constants_h
#define Constants_h

#define ThemeColor [UIColor colorWithRed:220.0/255.0 green:147.0/255.0 blue:255.0/255.0 alpha:1.0]
#define CompletionColor [UIColor colorWithRed:122.0/255.0 green:207.0/255.0 blue:173.0/255.0 alpha:1.0]
#define MainColor @"20B973"
#define CompletedColor @"367678"
#define ActiveColor @"DDAC67"
#define LockedColor @"E1806F"


//codeNew
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))
#define IS_ZOOMED (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)
#define IS_IPHONE_X (IS_IPHONE && SCREEN_MAX_LENGTH == 812.0)

#define iPhoneVersion ([[UIScreen mainScreen] bounds].size.height == 568 ? 5 : ([[UIScreen mainScreen] bounds].size.height == 812 ? 10 : ([[UIScreen mainScreen] bounds].size.height == 667 ? 6 : ([[UIScreen mainScreen] bounds].size.height == 736 ? 61 : 999))))


#define URL_BASE    @"http://10.0.1.111/public/api/"

#define API_LOGIN    URL_BASE@"login"
#define API_REGISTER  URL_BASE@"register"
#define API_LOAD_DASHBOARD  URL_BASE@"loadDashboard"
#define API_LOAD_MODULES   URL_BASE@"loadModule"
#define API_LOAD_PARTS   URL_BASE@"loadParts"
#define API_CHANGE_PASS    URL_BASE@"changePassword"
#define API_USER_MODULE_COMPLETE    URL_BASE@"userModuleCompleted"
#define API_COMPLETE_PROFILE     URL_BASE@"profileComplete"
#define API_LOAD_PRACTICE_SESSION     URL_BASE@"loadPracticeSession"
#define API_LOAD_PACKAGE   URL_BASE@"loadPackage"
#define API_CHANGE_PARTNER    URL_BASE@"changePartnerCode"
#define API_FORGOT_PASS    URL_BASE@"resetPassword"
#define API_GENERATE_CHECKSUM   URL_BASE@"generateChecksum"
#define API_STORE_DEVICE    URL_BASE@"storeDevice"
#define API_GET_COLOR   URL_BASE@"getColor"
#define API_USERPAYMENT    URL_BASE@"userPayment"
#define API_CONTACT    URL_BASE@"contact"
#define API_FAQ    URL_BASE@"faq"
#define API_UPLOAD_USER_IMAGE    URL_BASE@"uploadUserImage"
#define API_EDIT_PROFILE    URL_BASE@"editProfile"
#define API_UPDATE_TOKEN   URL_BASE@"updateToken"
#define API_VERIFY_CHECK    URL_BASE@"generateVerifyStatusChecksum"
#define API_GETCOUNTRY    URL_BASE@"getCountry"
#define API_LANGUAGE    URL_BASE@"language"
#define API_LOAD_CATEGORIES    URL_BASE@"loadCategory"
#define API_LOAD_TICKETS    URL_BASE@"loadTickets"
#define API_LOAD_TICKET_DETAILS    URL_BASE@"loadTicketDetails"
#define API_CREATE_TICKETS    URL_BASE@"createTicket"
#define API_RESPONSE_TICKETS    URL_BASE@"responseTicket"
#define API_DELETE_TICKETS    URL_BASE@"closeTicket"
#define API_GET_TERMS    URL_BASE@"getTerms"

typedef enum
{
    CALL_TYPE_NONE,
    CALL_TYPE_LOGIN,
    CALL_TYPE_REGISTER,
    CALL_TYPE_LOAD_DASHBOARD,
    CALL_TYPE_LOAD_MODULES,
    CALL_TYPE_LOAD_PARTS,
    CALL_TYPE_CHANGE_PASS,
    CALL_TYPE_USER_MODULE_COMPLETE,
    CALL_TYPE_COMPLETE_PROFILE,
    CALL_TYPE_LOAD_PRACTICE_SESSION,
    CALL_TYPE_LOAD_PACKAGE,
    CALL_TYPE_CHANGE_PARTNER,
    CALL_TYPE_FORGOT_PASS,
    CALL_TYPE_GENERATE_CHECKSUM,
    CALL_TYPE_STORE_DEVICE,
    CALL_TYPE_GET_COLOR,
    CALL_TYPE_USERPAYMENT,
    CALL_TYPE_CONTACT,
    CALL_TYPE_FAQ,
    CALL_TYPE_UPLOAD_USER_IMAGE,
    CALL_TYPE_EDIT_PROFILE,
    CALL_TYPE_UPDATE_TOKEN,
    CALL_TYPE_VERIFY_CHECK,
    CALL_TYPE_GETCOUNTRY,
    CALL_TYPE_LANGUAGE,
    CALL_TYPE_LOAD_CATEGORIES,
    CALL_TYPE_LOAD_TICKETS,
    CALL_TYPE_LOAD_TICKETS_DETAILS,
    CALL_TYPE_CREATE_TICKETS,
    CALL_TYPE_RESPONSE_TICKETS,
    CALL_TYPE_DELETE_TICKETS,
    CALL_TYPE_GET_TERMS,
}CallTypeEnum;


#endif /* Constants_h */
