//
//  PurchaseViewController.h
//  BrainPower
//
//  Created by nestcode on 1/16/18.
//  Copyright © 2018 nestcode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"
#import "Constants.h"
#import "PaymentsSDK.h"
#import "ApiCallManager.h"
#import "HTTPRequestHandler.h"
#import "JSON.h"
#import "Reachability.h"
#import "SCLAlertView.h"
#import "DGActivityIndicatorView.h"
#import "UIView+Toast.h"

@interface PurchaseViewController : UIViewController<PGTransactionDelegate,ApiCallManagerDelegate,HTTPRequestHandlerDelegate>{
    HTTPRequestHandler *requestHandler;
    id<ApiCallManagerDelegate>_delegate;
}

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;

@property (weak, nonatomic) IBOutlet UIImageView *imgCart;

@property (weak, nonatomic) IBOutlet UILabel *lblModules;
@property (weak, nonatomic) IBOutlet UILabel *lblModulePrice;

@property (weak, nonatomic) IBOutlet UILabel *lblDiscount;
@property (weak, nonatomic) IBOutlet UILabel *lblDiscountPrice;

@property (weak, nonatomic) IBOutlet UILabel *lblNetAmountPrice;

@property (weak, nonatomic) IBOutlet UILabel *lblGSTPrice;

@property (weak, nonatomic) IBOutlet UILabel *lblTotalAmount;

@property (weak, nonatomic) IBOutlet UIButton *btnPayTm;
- (IBAction)onPayTmClicked:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *viewReferCode;

@property (weak, nonatomic) IBOutlet UILabel *lblCode;

- (IBAction)onChangeClicked:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *viewRecipt;

@property (weak, nonatomic) IBOutlet UILabel *lblUserName;
@property (weak, nonatomic) IBOutlet UILabel *lblUserMobile;
@property (weak, nonatomic) IBOutlet UILabel *lblUserName1;
@property (weak, nonatomic) IBOutlet UILabel *lblTransactionID;
@property (weak, nonatomic) IBOutlet UILabel *lblOrderID;
@property (weak, nonatomic) IBOutlet UILabel *lblPurchasePackage;
@property (weak, nonatomic) IBOutlet UILabel *lblPurchaseDiscount;
@property (weak, nonatomic) IBOutlet UILabel *lblPurchaseGST;
@property (weak, nonatomic) IBOutlet UILabel *lblPurchaseDate;
@property (weak, nonatomic) IBOutlet UILabel *lblPackageName;
@property (weak, nonatomic) IBOutlet UILabel *lblTotal;

@property (weak, nonatomic) IBOutlet UILabel *lblCGST;
@property (weak, nonatomic) IBOutlet UILabel *lblSGST;

@property (weak, nonatomic) IBOutlet UILabel *lblCGSTPurchase;
@property (weak, nonatomic) IBOutlet UILabel *lblSGSTPurchase;

- (IBAction)onRefundPolicyClicked:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *viewRefundPolicy;
@property (weak, nonatomic) IBOutlet UILabel *lblRefundTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblRefundBody;
@property (weak, nonatomic) IBOutlet UIButton *btnRefundInvoice;
@property (weak, nonatomic) IBOutlet UIButton *btnOK;
- (IBAction)onOkClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *viewBack1;

@property (weak, nonatomic) IBOutlet UIButton *btnRefundPurchase;
@property (weak, nonatomic) IBOutlet UIView *viewRefundPolicyPurchase;
@property (weak, nonatomic) IBOutlet UILabel *lblRefundTitlePurchase;
@property (weak, nonatomic) IBOutlet UILabel *lblRefundBodyPurchase;
@property (weak, nonatomic) IBOutlet UIButton *btnOKPurchase;
- (IBAction)onOKClickedPurchase:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *viewBack;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *titlePurchase;

@property (weak, nonatomic) IBOutlet UIView *viewNoInternet;

@property (weak, nonatomic) IBOutlet UILabel *lblPatmentVia;

@property (weak, nonatomic) IBOutlet UIImageView *imgPromotional;
@property (weak, nonatomic) IBOutlet UILabel *lblPromotional;
@property (weak, nonatomic) IBOutlet UILabel *lblNote1;
@property (weak, nonatomic) IBOutlet UILabel *lblNote;
@property (weak, nonatomic) IBOutlet UILabel *lblComboDiscount;

@end
