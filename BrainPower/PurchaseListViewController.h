//
//  PurchaseListViewController.h
//  BrainPower
//
//  Created by nestcode on 9/25/18.
//  Copyright © 2018 nestcode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PurchaseListTableViewCell.h"
#import "UIView+Toast.h"
#import "Constants.h"
#import "SCLAlertView.h"
#import "ApiCallManager.h"
#import "Constants.h"
#import "HTTPRequestHandler.h"
#import "JSON.h"
#import "Reachability.h"
#import "Global.h"
#import "SWRevealViewController.h"
#import "DGActivityIndicatorView.h"
#import "SVProgressHUD.h"
#import "PurchaseViewController.h"
#import "PurchaseDiscountListTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface PurchaseListViewController : UIViewController<ApiCallManagerDelegate,HTTPRequestHandlerDelegate,UITableViewDelegate,UITableViewDataSource>
{
    HTTPRequestHandler *requestHandler;
    id<ApiCallManagerDelegate>_delegate;
}

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;

@property (weak, nonatomic) IBOutlet UITableView *tblPurchaseList;

- (IBAction)onCheckoutClicked:(id)sender;
- (IBAction)onCloseDiscountClicked:(id)sender;
- (IBAction)onDoneClicked:(id)sender;
- (IBAction)onShowDiscountClicked:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *btnCheckOut;
@property (weak, nonatomic) IBOutlet UIButton *btnDone;

@property (weak, nonatomic) IBOutlet UIView *viewDiscounts;
@property (weak, nonatomic) IBOutlet UIView *viewDiscountList;

@property (weak, nonatomic) IBOutlet UITableView *tblDiscountList;

@property (weak, nonatomic) IBOutlet UILabel *lblComboDiscount;
@property (weak, nonatomic) IBOutlet UILabel *lblPayableAmount;

@property (weak, nonatomic) IBOutlet UIView *viewTop;


@end

NS_ASSUME_NONNULL_END
