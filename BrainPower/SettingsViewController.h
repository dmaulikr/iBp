//
//  SettingsViewController.h
//  BrainPower
//
//  Created by nestcode on 1/16/18.
//  Copyright © 2018 nestcode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"
#import "Constants.h"
#import "UIView+Toast.h"
#import "DGActivityIndicatorView.h"
#import "HTTPRequestHandler.h"
#import "JSON.h"
#import "Reachability.h"
#import "ApiCallManager.h"

@interface SettingsViewController : UIViewController<UITextViewDelegate,UITextFieldDelegate,ApiCallManagerDelegate,HTTPRequestHandlerDelegate>{
    HTTPRequestHandler *requestHandler;
    id<ApiCallManagerDelegate>_delegate;
}

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet UIImageView *imgContact;


@property (weak, nonatomic) IBOutlet UIView *viewName;
@property (weak, nonatomic) IBOutlet UITextField *txtName;
@property (weak, nonatomic) IBOutlet UIImageView *imgName;


@property (weak, nonatomic) IBOutlet UIView *viewEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UIImageView *imgEmail;


@property (weak, nonatomic) IBOutlet UIView *viewMessage;
@property (weak, nonatomic) IBOutlet UITextView *txtMessage;
@property (weak, nonatomic) IBOutlet UIImageView *imgMessage;


@property (weak, nonatomic) IBOutlet UILabel *lblEmail;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Contact;
@property (weak, nonatomic) IBOutlet UILabel *lblAddress;


@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;
- (IBAction)onSubmitClicked:(id)sender;




@end
