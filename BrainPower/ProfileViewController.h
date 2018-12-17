//
//  ProfileViewController.h
//  BrainPower
//
//  Created by nestcode on 1/4/18.
//  Copyright © 2018 nestcode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+Toast.h"
#import "SWRevealViewController.h"
#import "Constants.h"
#import "LUNField.h"
#import "ApiCallManager.h"
#import "Constants.h"
#import "HTTPRequestHandler.h"
#import "JSON.h"
#import "Reachability.h"
#import "DGActivityIndicatorView.h"
#import "ActionSheetPicker.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "XWPhotoEditorViewController.h"
#import "NSData+Base64.h"
#import "UIImageView+RJLoader.h"
#import "UIImageView+WebCache.h"
#import "PoliciesViewController.h"
#import "Global.h"

@interface ProfileViewController : UIViewController<ApiCallManagerDelegate,CAAnimationDelegate,UITextFieldDelegate,LUNFieldDataSource, LUNFieldDelegate,ActionSheetCustomPickerDelegate,HTTPRequestHandlerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,XWFinishEditPhoto>{
    HTTPRequestHandler *requestHandler;
    id<ApiCallManagerDelegate>_delegate;
    NSDate *maxDate, *minDate;
}

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;

@property (weak, nonatomic) IBOutlet UIImageView *imgUser;
@property (weak, nonatomic) IBOutlet UILabel *lblNameMain;

@property (weak, nonatomic) IBOutlet UIButton *btnEditProfile;
@property (weak, nonatomic) IBOutlet UIButton *btnChangePassword;

- (IBAction)onEditProfileClicked:(id)sender;
- (IBAction)onChangePassClicked:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *lblReferCodeStatic;
@property (weak, nonatomic) IBOutlet UILabel *lblReferCode;

@property (weak, nonatomic) IBOutlet UILabel *lblChildNameStatic;
@property (weak, nonatomic) IBOutlet UILabel *lblChildName;

@property (weak, nonatomic) IBOutlet UILabel *lblParentNameStatic;
@property (weak, nonatomic) IBOutlet UILabel *lblParentsName;

@property (weak, nonatomic) IBOutlet UILabel *lblEmailStatic;
@property (weak, nonatomic) IBOutlet UILabel *lblEmail;

@property (weak, nonatomic) IBOutlet UILabel *lblMobileStatic;
@property (weak, nonatomic) IBOutlet UILabel *lblMobile;

@property (weak, nonatomic) IBOutlet UILabel *lblBDateStatic;
@property (weak, nonatomic) IBOutlet UILabel *lblBdate;

@property (weak, nonatomic) IBOutlet UILabel *lblCityStatic;
@property (weak, nonatomic) IBOutlet UILabel *lblCity;



@property (weak, nonatomic) IBOutlet UIView *viewProfile;
@property (weak, nonatomic) IBOutlet UIView *viewBack;

@property (weak, nonatomic) IBOutlet UIView *viewReferenceCode;
@property (weak, nonatomic) IBOutlet UIView *viewParentName;
@property (weak, nonatomic) IBOutlet UIView *viewChildName;
@property (weak, nonatomic) IBOutlet UIView *viewDOB;
@property (weak, nonatomic) IBOutlet UIView *viewEmail;
@property (weak, nonatomic) IBOutlet UIView *viewCity;
@property (weak, nonatomic) IBOutlet UIView *viewSetPass;
@property (weak, nonatomic) IBOutlet UIView *viewSetConfirmPass;



@property (weak, nonatomic) IBOutlet LUNField *referView;
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
@property (weak, nonatomic) IBOutlet UIImageView *imgChecked;


- (IBAction)onCheckedClicked:(id)sender;
- (IBAction)onUpdateClicked:(id)sender;
- (IBAction)onCloseProfileClicked:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *viewPass;
@property (weak, nonatomic) IBOutlet UIView *passView;
@property (weak, nonatomic) IBOutlet UIView *viewOldPass;
@property (weak, nonatomic) IBOutlet UIView *viewNewPass;
@property (weak, nonatomic) IBOutlet UIView *viewConfirmPass;

- (IBAction)onCloseClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnChangePass;
- (IBAction)onChangePass:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *imgOldPass;
@property (weak, nonatomic) IBOutlet UIImageView *imgNewPass;
@property (weak, nonatomic) IBOutlet UIImageView *imgConfirmPass;

@property (weak, nonatomic) IBOutlet UITextField *txtOldPass;
@property (weak, nonatomic) IBOutlet UITextField *txtNewPass;
@property (weak, nonatomic) IBOutlet UITextField *txtConfirmPass;

@property (weak, nonatomic) IBOutlet UIButton *btnClose;
@property (weak, nonatomic) IBOutlet UIView *viewTop;


- (IBAction)onProfileClicked:(id)sender;

@property (strong, nonatomic) UIImagePickerController *imgPicker;
@property (strong, nonatomic) XWPhotoEditorViewController *photoEditor;
@property (strong, nonatomic) ALAssetsLibrary *library;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *profileHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *profileDistance;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *profileSapcing;

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

@property (weak, nonatomic) IBOutlet UIButton *btnNewPassVisible;
- (IBAction)onShowNewPassClicked:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *btnNewConfirmPassVisible;
- (IBAction)onShowNewConfirmPassClicked:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *btnOldPassVisible;
- (IBAction)onShowOldPassClicked:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *btnSetNewPassVisible;

@property (weak, nonatomic) IBOutlet UIButton *btnSetNewConfirmPassVisible;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnToTnCSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomSpace;

- (IBAction)onPrivacyClicked:(id)sender;
- (IBAction)onTermsClicked:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *imgPrivacy;
@property (weak, nonatomic) IBOutlet UIImageView *imgTerms;

- (IBAction)onPrivacyCheckClicked:(id)sender;
- (IBAction)onTermsCheckClicked:(id)sender;


@end
