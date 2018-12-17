//
//  HomeViewController.h
//  BrainPower
//
//  Created by nestcode on 1/2/18.
//  Copyright © 2018 nestcode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"
#import "AppDelegate.h"
#import "SWRevealViewController.h"
#import "Constants.h"
#import "ModuleListTableViewController.h"
#import "SCLAlertView.h"
#import "ApiCallManager.h"
#import "HTTPRequestHandler.h"
#import "JSON.h"
#import "Reachability.h"
#import "UIView+Toast.h"
#import "PurchaseViewController.h"
#import "DGActivityIndicatorView.h"
#import "SVProgressHUD.h"
#import "MNShowcaseView.h"
#import "UIView+MNShowcase.h"
#import "Global.h"
#import "PurchaseListViewController.h"
#import "NonCopyPasteField.h"
#import "PoliciesViewController.h"

@interface HomeViewController : UIViewController<iCarouselDataSource, iCarouselDelegate,UIGestureRecognizerDelegate, ApiCallManagerDelegate,HTTPRequestHandlerDelegate, UITextFieldDelegate>{
    HTTPRequestHandler *requestHandler;
    id<ApiCallManagerDelegate>_delegate;
    NSDate *maxDate, *minDate;
}
@property (nonatomic, strong) MNShowcaseView *showcaseView;
@property (weak, nonatomic) IBOutlet iCarousel *ViewCarousel;
@property (nonatomic) BOOL wrap;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;

@property (weak, nonatomic) IBOutlet UIView *viewCompleteProfie;

@property (weak, nonatomic) IBOutlet UIView *viewReferenceCode;
@property (weak, nonatomic) IBOutlet UIView *viewParentName;
@property (weak, nonatomic) IBOutlet UIView *viewChildName;
@property (weak, nonatomic) IBOutlet UIView *viewDOB;
@property (weak, nonatomic) IBOutlet UIView *viewEmail;
@property (weak, nonatomic) IBOutlet UIView *viewCity;
@property (weak, nonatomic) IBOutlet UIView *viewSetPass;
@property (weak, nonatomic) IBOutlet UIView *viewSetConfirmPass;

@property (weak, nonatomic) IBOutlet NonCopyPasteField *txtreferCode;
@property (weak, nonatomic) IBOutlet UITextField *txtParentName;
@property (weak, nonatomic) IBOutlet UITextField *txtChildName;
@property (weak, nonatomic) IBOutlet UITextField *txtDob;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtCity;
@property (weak, nonatomic) IBOutlet UITextField *txtSetPass;
@property (weak, nonatomic) IBOutlet UITextField *txtSetConfirmPass;

@property (weak, nonatomic) IBOutlet UIImageView *imgRefer;
@property (weak, nonatomic) IBOutlet UIImageView *imgParent;
@property (weak, nonatomic) IBOutlet UIImageView *imgChild;
@property (weak, nonatomic) IBOutlet UIImageView *imgDOB;
@property (weak, nonatomic) IBOutlet UIImageView *imgEmail;
@property (weak, nonatomic) IBOutlet UIImageView *imgCity;
@property (weak, nonatomic) IBOutlet UIButton *btnChecked;
@property (weak, nonatomic) IBOutlet UIImageView *imgLock1;
@property (weak, nonatomic) IBOutlet UIImageView *imgLock2;

- (IBAction)onCheckedClicked:(id)sender;
- (IBAction)onUpdateClicked:(id)sender;
- (IBAction)onCloseClicked:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *lblUserName;
@property (weak, nonatomic) IBOutlet UIView *viewLoader;

@property (weak, nonatomic) IBOutlet UIView *viewBackColor;
@property (nonatomic) IBOutlet DGActivityIndicatorView *activity;

@property (weak, nonatomic) IBOutlet UIView *viewMainTnC;
@property (weak, nonatomic) IBOutlet UIImageView *imgChecked1;
@property (weak, nonatomic) IBOutlet UIButton *btnChecked1;
- (IBAction)onChecked1Clicked:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *imgChecked2;
@property (weak, nonatomic) IBOutlet UIButton *btnChecked2;
- (IBAction)onChecked2Clicked:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *imgChecked3;
@property (weak, nonatomic) IBOutlet UIButton *btnChecked3;

- (IBAction)onChecked3Clicked:(id)sender;
- (IBAction)onAgreeClicked:(id)sender;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgHeight;
@property (weak, nonatomic) IBOutlet UIImageView *imgTopView;

@property (weak, nonatomic) IBOutlet UIImageView *imgPrivacy;
@property (weak, nonatomic) IBOutlet UIImageView *imgTerms;

- (IBAction)onPrivacyCheckClicked:(id)sender;
- (IBAction)onTermsCheckClicked:(id)sender;

- (IBAction)onPrivacyClicked:(id)sender;
- (IBAction)onTermsClicked:(id)sender;


@end
