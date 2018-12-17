//
//  ViewController.h
//  BrainPower
//
//  Created by nestcode on 1/2/18.
//  Copyright © 2018 nestcode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+Toast.h"
#import "ActionSheetPicker.h"
#import "LUNField.h"
#import "WTReTextField.h"
#import "Constants.h"
#import "SCLAlertView.h"
#import "ApiCallManager.h"
#import "Constants.h"
#import "HTTPRequestHandler.h"
#import "JSON.h"
#import "Reachability.h"
#import "SCLAlertView.h"
#import "DGActivityIndicatorView.h"
#import "CircleTimer.h"
#import "PoliciesViewController.h"
#import "Global.h"
#import "PCCPViewController.h"

@interface ViewController : UIViewController<ApiCallManagerDelegate,HTTPRequestHandlerDelegate,CAAnimationDelegate,UITextFieldDelegate,LUNFieldDataSource, LUNFieldDelegate, CircleTimerDelegate>{
    HTTPRequestHandler *requestHandler;
    HTTPRequestHandler *requestHandler1;
    id<ApiCallManagerDelegate>_delegate;
    int currSeconds;
}

@property (weak, nonatomic) IBOutlet UIPageControl *pageController;

@property (weak, nonatomic) IBOutlet UIButton *btnNext;
@property (weak, nonatomic) IBOutlet UIButton *btnBack;


@property (weak, nonatomic) IBOutlet UILabel *lblCountryCode;
- (IBAction)onCountryCodeClicked:(id)sender;


@property (weak, nonatomic) IBOutlet UITextField *txtMobileNo;
@property (weak, nonatomic) IBOutlet UIView *viewSlider1;
@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIImageView *imgPhone;
- (IBAction)onTnCclicked:(id)sender;
- (IBAction)onPrivacyPolicyClicked:(id)sender;



@property (weak, nonatomic) IBOutlet UIView *viewSlider2;
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UITextField *txtOTP;

@property (weak, nonatomic) IBOutlet UITextField *txtVerifyOTP;

@property (weak, nonatomic) IBOutlet UIImageView *imgPass1;


@property (weak, nonatomic) IBOutlet UIView *viewSlider3;

@property (weak, nonatomic) IBOutlet WTReTextField *txt_pareny;

@property (weak, nonatomic) IBOutlet LUNField *referView;

@property (weak, nonatomic) IBOutlet UIImageView *imgChecked;


@property (weak, nonatomic) IBOutlet UIView *viewSliderPass;
@property (weak, nonatomic) IBOutlet UIView *viewPass;
@property (weak, nonatomic) IBOutlet UIView *view3;
@property (weak, nonatomic) IBOutlet UITextField *txtPassWord;
@property (weak, nonatomic) IBOutlet UITextField *txtConfirmPass;

@property (weak, nonatomic) IBOutlet UIView *view4;
@property (weak, nonatomic) IBOutlet UIView *view5;
@property (weak, nonatomic) IBOutlet UIView *view6;


@property (weak, nonatomic) IBOutlet UIImageView *imgPass;
@property (weak, nonatomic) IBOutlet UIImageView *imgPass2;
@property (weak, nonatomic) IBOutlet UIImageView *imgPass3;
@property (weak, nonatomic) IBOutlet UITextField *txtCheckPassword;


@property (weak, nonatomic) IBOutlet UIView *viewCheckPass;

@property (weak, nonatomic) IBOutlet UIButton *btnResendOTP;

- (IBAction)onNextClicked:(id)sender;
- (IBAction)onBackClicked:(id)sender;
- (IBAction)onResendOTPClicked:(id)sender;
- (IBAction)onForgotPassClicked:(id)sender;

@property (weak, nonatomic) IBOutlet CircleTimer *otpCountdown;
@property (weak, nonatomic) IBOutlet UIButton *btnPassVisible;
- (IBAction)onShowPassClicked:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *lblTime;

@end

