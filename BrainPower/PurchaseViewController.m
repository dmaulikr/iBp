//
//  PurchaseViewController.m
//  BrainPower
//
//  Created by nestcode on 1/16/18.
//  Copyright © 2018 nestcode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "PurchaseViewController.h"

@interface PurchaseViewController ()

@end

@implementation PurchaseViewController{
    NSString *strReferCode;
    NSUserDefaults *UserData, *UserAuth;
    NSMutableDictionary *userDictData;
    NSString *strRefer, *strCallType, *strPartnerCode, *strUserCode, *strMobile, *strEmail;
    UIView *viewLoader;
    UIImageView *img;
    DGActivityIndicatorView *activityIndicatorView;
    NSMutableDictionary *orderDict, *dictPayTM, *dictGenerateVerified;
    NSUserDefaults *ColorCode;
    NSString *strColor;
    NSMutableDictionary *dictPackage;
    NSDictionary *dictPayTMRes;
    NSString *strPayTMResData, *strGenerateVerifiedCheck;
    NSString *strOrder, *strSelectedFinal;
    NSUserDefaults *isLogin;
    NSUserDefaults *Userprofileimg;
    NSUserDefaults *userLanguage ,*UserPaymentURL;
    long currentTime;
    NSUserDefaults *userSelectedFinal, *userAllPaid;
    NSUserDefaults *userCurrency;
    NSString *strCurrencyCode;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setValue:@(YES) forKeyPath:@"hidesShadow"];
    
    _viewRefundPolicy.hidden = YES;
    _viewRefundPolicyPurchase.hidden = YES;
    _viewBack.hidden = YES;
    _viewBack1.hidden = YES;
    _viewNoInternet.hidden = YES;
    _lblPromotional.hidden = YES;
    _imgPromotional.hidden = YES;
    
    userSelectedFinal = [NSUserDefaults standardUserDefaults];
    
    strSelectedFinal = [NSString stringWithFormat:@"%@",[userSelectedFinal valueForKey:@"userSelectedFinal"]];
    
    UserPaymentURL = [NSUserDefaults standardUserDefaults];
    
    userLanguage = [NSUserDefaults standardUserDefaults];
    isLogin = [NSUserDefaults standardUserDefaults];
    Userprofileimg = [NSUserDefaults standardUserDefaults];
    
    NSUserDefaults *userCurrency = [NSUserDefaults standardUserDefaults];
    strCurrencyCode = [NSString stringWithFormat:@"%@",[userCurrency valueForKey:@"userCurrency"]];
    
    _viewRecipt.hidden =  YES;
    ColorCode = [NSUserDefaults standardUserDefaults];
    strColor = [NSString stringWithFormat:@"%@",[ColorCode valueForKey:@"colorcode"]];
    
    [_lblRefundTitle setBackgroundColor:[self colorWithHexString:strColor]];
    [_btnOK setBackgroundColor:[self colorWithHexString:strColor]];
    
    [_lblRefundTitlePurchase setBackgroundColor:[self colorWithHexString:strColor]];
    [_btnOKPurchase setBackgroundColor:[self colorWithHexString:strColor]];
    
    _imgCart.backgroundColor = [self colorWithHexString:strColor];
    
    [_lblModulePrice setTextColor: [self colorWithHexString:strColor]];
    [_lblTotalAmount setTextColor: [self colorWithHexString:strColor]];
    [_lblGSTPrice setTextColor: [self colorWithHexString:strColor]];
    [_lblComboDiscount setTextColor: [self colorWithHexString:strColor]];
    [_lblDiscountPrice setTextColor: [self colorWithHexString:strColor]];
    [_lblNetAmountPrice setTextColor: [self colorWithHexString:strColor]];
    [_lblCode setTextColor: [self colorWithHexString:strColor]];
    
    _btnPayTm.backgroundColor = [self colorWithHexString:strColor];
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    userDictData = [[NSMutableDictionary alloc]init];
    UserData = [NSUserDefaults standardUserDefaults];
    
    userDictData = [UserData valueForKey:@"UserData"];
    NSLog(@"%@",userDictData);
    
    strReferCode = [userDictData valueForKey:@"partner_code"];
    strUserCode = [userDictData valueForKey:@"user_code"];
    strMobile = [userDictData valueForKey:@"mobile_no"];
    
    ColorCode = [NSUserDefaults standardUserDefaults];
    strColor = [NSString stringWithFormat:@"%@",[ColorCode valueForKey:@"colorcode"]];
    
    NSString *prefixToRemove = @"+91";
    if ([strMobile hasPrefix:prefixToRemove]){
        strMobile = [strMobile substringFromIndex:[prefixToRemove length]];}
    
    strEmail = [userDictData valueForKey:@"email"];
    _lblCode.text = [NSString stringWithFormat:@"%@",strReferCode];
    
    [self APILoadPackage];
}

+(NSString*)generateOrderIDWithPrefix:(NSString *)prefix
{
    srand ( (unsigned)time(NULL) );
    int randomNo = rand(); //just randomizing the number
    NSString *orderID = [NSString stringWithFormat:@"%@%d", prefix, randomNo];
    return orderID;
}

-(void)showController:(PGTransactionViewController *)controller
{
    if (self.navigationController != nil)
        [self.navigationController pushViewController:controller animated:YES];
    else
        [self presentViewController:controller animated:YES
                         completion:^{
                             
                         }];
}

-(void)removeController:(PGTransactionViewController *)controller
{
    if (self.navigationController != nil)
        [self.navigationController popViewControllerAnimated:YES];
    else
        [controller dismissViewControllerAnimated:YES
                                       completion:^{
                                       }];
}



-(UIColor*)colorWithHexString:(NSString*)hex
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}
    

- (IBAction)onPayTmClicked:(id)sender {
    
  /*  orderDict = [[NSMutableDictionary alloc] init];
    dictGenerateVerified = [[NSMutableDictionary alloc] init];
    currentTime = (long)(NSTimeInterval)([[NSDate date] timeIntervalSince1970]);
  //  strOrder = [NSString stringWithFormat:@"ORDER%ld",currentTime];
    strOrder = @"0000011123";
    orderDict[@"amount"] = [NSString stringWithFormat:@"%@",[dictPackage valueForKey:@"total_amount"]];
    orderDict[@"call_back_url"] = [NSString stringWithFormat:@"https://securegw.paytm.in/theia/paytmCallback?ORDER_ID=%@",strOrder];
    orderDict[@"email"] = strEmail;
    orderDict[@"mobile_no"] = strMobile;
    orderDict[@"order_id"] = strOrder;
    orderDict[@"user_code"] = strUserCode;
    
  //  [self APIGenerateCheckSum];
    
    NSString *strURL = [NSString stringWithFormat:@"http://10.0.1.111/ibrainpowers/public?level_id=%@",strSelectedFinal];
     [[UIApplication sharedApplication] openURL:[NSURL URLWithString: strURL]];
    
 /*  NSString *strNote = NSLocalizedString(@"You will be Redirect to our website for payment", @"");
    NSString *strAlert = NSLocalizedString(@"Attention!!", @"");
    UIAlertController * alertController1 = [UIAlertController alertControllerWithTitle: strAlert message: strNote preferredStyle:UIAlertControllerStyleAlert];
    [alertController1 addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString: strURL]];
    }]];
    [self presentViewController:alertController1 animated:YES completion:nil];*/
    
    
    //Server Side
  //  orderDict[@"CHECKSUMHASH"] = @"4YHj3F2KxPZnqGE5ZIIlZYCNgsWeNuG8E9YU/munoXmBBHsPVLQaCPsiQSxCC+Z6pwdUk/UzI8xPWfYpWw2iypCRkfyFvISRvVHblx0PVeg=";
   
}

-(void)APIGenerateCheckSum{
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable)
    {
        [self CheckConnection];
    }
    else
    {
        NSError* error;
        NSLog(@"param: %@",orderDict);
        NSData* data = [NSJSONSerialization dataWithJSONObject:orderDict options:0 error:&error];
        
        // [SVProgressHUD show];
        [self ShowActivityIndicator];
        UserAuth = [NSUserDefaults standardUserDefaults];
        NSString *strAuth = [UserAuth valueForKey:@"UserAuth"];
        
        NSString *strUrl = [NSString stringWithFormat:@"%@",API_GENERATE_CHECKSUM];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]init];
        request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:strUrl]];
        
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
        [request setValue:strAuth forHTTPHeaderField:@"Authorization"];
        [request setHTTPBody:data];
        
        requestHandler = [[HTTPRequestHandler alloc] initWithRequest:request delegate:self andCallBack:CALL_TYPE_GENERATE_CHECKSUM];
        strCallType = @"checkSum";
    }
}

-(void)APILoadPackage{
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable)
    {
        [self CheckConnection];
        _viewNoInternet.hidden = NO;
    }
    else
    {
        NSDictionary *tmp = [[NSDictionary alloc]initWithObjectsAndKeys:
                             strSelectedFinal,@"level_id",
                             nil];
        NSError* error;
        NSData* data = [NSJSONSerialization dataWithJSONObject:tmp options:0 error:&error];
        
        // [SVProgressHUD show];
        [self ShowActivityIndicator];
        UserAuth = [NSUserDefaults standardUserDefaults];
        NSString *strAuth = [UserAuth valueForKey:@"UserAuth"];
        
        NSString *strUrl = [NSString stringWithFormat:@"%@",API_LOAD_PACKAGE];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]init];
        request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:strUrl]];
        
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
        [request setValue:strAuth forHTTPHeaderField:@"Authorization"];
        [request setHTTPBody:data];
        
        requestHandler = [[HTTPRequestHandler alloc] initWithRequest:request delegate:self andCallBack:CALL_TYPE_LOAD_PACKAGE];
        strCallType = @"package";
    }
}

-(void)APIChangeCode{
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable)
    {
        [self CheckConnection];
    }
    else
    {
        NSDictionary *tmp = [[NSDictionary alloc]initWithObjectsAndKeys:
                             strReferCode,@"partner_code",
                             strSelectedFinal,@"level_id",
                             nil];
        NSError* error;
        NSData* data = [NSJSONSerialization dataWithJSONObject:tmp options:0 error:&error];
        
        // [SVProgressHUD show];
        [self ShowActivityIndicator];
        UserAuth = [NSUserDefaults standardUserDefaults];
        NSString *strAuth = [UserAuth valueForKey:@"UserAuth"];
        
        NSString *strUrl = [NSString stringWithFormat:@"%@",API_CHANGE_PARTNER];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]init];
        request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:strUrl]];
        
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
        [request setValue:strAuth forHTTPHeaderField:@"Authorization"];
        [request setHTTPBody:data];
        
        requestHandler = [[HTTPRequestHandler alloc] initWithRequest:request delegate:self andCallBack:CALL_TYPE_CHANGE_PARTNER];
        strCallType = @"change";
    }
}

-(void)APIPayTm{
    NSLog(@"PayTM Param: %@", dictPayTM);
    PGMerchantConfiguration *mc = [PGMerchantConfiguration defaultConfiguration];
    PGOrder *order = [PGOrder orderWithParams:dictPayTM];
    
    //Step 3: Choose the PG server. In your production build dont call selectServerDialog. Just create a instance of the
    //PGTransactionViewController and set the serverType to eServerTypeProduction
    PGTransactionViewController *txnController = [[PGTransactionViewController alloc] initTransactionForOrder:order];
    txnController.serverType = eServerTypeProduction;
    txnController.merchant = mc;
    txnController.delegate = self;
    [self showController:txnController];
   
}

-(void)ShowActivityIndicator{
    NSArray *activityTypes = @[@(DGActivityIndicatorAnimationTypeBallClipRotateMultiple)];
    
    viewLoader = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    [viewLoader setBackgroundColor:[UIColor clearColor]];
    
    img = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, viewLoader.frame.size.width, viewLoader.frame.size.height)];
    
    [img setBackgroundColor:[UIColor whiteColor]];
    img.alpha = 0.65;
    
    self.sidebarButton.enabled = NO;
    
    
    [viewLoader addSubview:img];
    NSLog(@"started");
    
    for (int i = 0; i < activityTypes.count; i++) {
        activityIndicatorView = [[DGActivityIndicatorView alloc] initWithType:(DGActivityIndicatorAnimationType)[activityTypes[i] integerValue] tintColor:[self colorWithHexString:strColor]];
        activityIndicatorView.center = viewLoader.center;
        [viewLoader addSubview:activityIndicatorView];
        [activityIndicatorView startAnimating];
    }
    [self.view addSubview:viewLoader];
}

-(void)HideActivityIndicator{
    viewLoader.hidden = YES;
    NSLog(@"stoped");
    self.sidebarButton.enabled = YES;
    [activityIndicatorView stopAnimating];
    [activityIndicatorView removeFromSuperview];
}

-(void)CheckConnection{
    NSString *strError = NSLocalizedString(@"Device is not connected to Internet!! Please connect to the Internet and try again!!", @"");
    NSString *strAlert = NSLocalizedString(@"Alert!!", @"");
    UIAlertController * alertController1 = [UIAlertController alertControllerWithTitle: strAlert
                                                                               message: strError
                                                                        preferredStyle:UIAlertControllerStyleAlert];
    [alertController1 addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
    }]];
    [self presentViewController:alertController1 animated:YES completion:nil];
    //  [SVProgressHUD dismiss];
    self.view.userInteractionEnabled = YES;
}


-(void)APIPayTMResponse{
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable)
    {
        [self CheckConnection];
    }
    else
    {
        NSDictionary *tmp = [[NSDictionary alloc]initWithObjectsAndKeys:
                             [dictPackage valueForKey:@"package_price"],@"pack_price",
                             [dictPackage valueForKey:@"discount"],@"discount_amt",
                             [dictPackage valueForKey:@"tax_amount"],@"gst_amt",
                             [dictPayTMRes valueForKey:@"CHECKSUMHASH"],@"checksumhash",
                             [dictPayTMRes valueForKey:@"TXNDATE"],@"txn_date",
                             [dictPayTMRes valueForKey:@"ORDERID"],@"order_id",
                             [dictPayTMRes valueForKey:@"TXNID"],@"txn_id",
                             [dictPayTMRes valueForKey:@"TXNAMOUNT"],@"txn_amount",
                             strPayTMResData,@"paytm_data",
                             nil];
        NSError* error;
        NSData* data = [NSJSONSerialization dataWithJSONObject:tmp options:0 error:&error];
        
        // [SVProgressHUD show];
        [self ShowActivityIndicator];
        UserAuth = [NSUserDefaults standardUserDefaults];
        NSString *strAuth = [UserAuth valueForKey:@"UserAuth"];
        
        NSString *strUrl = [NSString stringWithFormat:@"%@",API_USERPAYMENT];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]init];
        request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:strUrl]];
        
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
        [request setValue:strAuth forHTTPHeaderField:@"Authorization"];
        [request setHTTPBody:data];
        
        requestHandler = [[HTTPRequestHandler alloc] initWithRequest:request delegate:self andCallBack:CALL_TYPE_USERPAYMENT];
        strCallType = @"payment";
    }
}

-(void)ApiGenerateCheck{
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable)
    {
        [self CheckConnection];
    }
    else
    {
        NSDictionary *tmp = [[NSDictionary alloc]initWithObjectsAndKeys:
                             strOrder,@"order_id",
                             nil];
        NSError* error;
        NSData* data = [NSJSONSerialization dataWithJSONObject:tmp options:0 error:&error];
        
        // [SVProgressHUD show];
        [self ShowActivityIndicator];
        UserAuth = [NSUserDefaults standardUserDefaults];
        NSString *strAuth = [UserAuth valueForKey:@"UserAuth"];
        
        NSString *strUrl = [NSString stringWithFormat:@"%@",API_VERIFY_CHECK];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]init];
        request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:strUrl]];
        
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
        [request setValue:strAuth forHTTPHeaderField:@"Authorization"];
        [request setHTTPBody:data];
        
        requestHandler = [[HTTPRequestHandler alloc] initWithRequest:request delegate:self andCallBack:CALL_TYPE_USERPAYMENT];
        strCallType = @"generateVerify";
    }
}

-(void)ApiVerifyTransaction{
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable)
    {
        [self CheckConnection];
    }
    else
    {
    
        NSString *jsonString = [NSString stringWithFormat:@"{\"MID\":\"BraiNM07608992950622\",\"ORDERID\":\"%@\",\"CHECKSUMHASH\":\"%@\"}",strOrder,strGenerateVerifiedCheck];
        
        NSString *str = [jsonString stringByAddingPercentEncodingWithAllowedCharacters: [NSCharacterSet URLQueryAllowedCharacterSet]];
        
        NSString *strUrl = [NSString stringWithFormat:@"https://secure.paytm.in/oltp/HANDLER_INTERNAL/getTxnStatus?JsonData=%@",str];
        
     //   strUrl = [strUrl stringByReplacingOccurrencesOfString:@"\\" withString:@""];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]init];
 
        request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:strUrl]];
        
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:nil];
        
        requestHandler = [[HTTPRequestHandler alloc] initWithRequest:request delegate:self andCallBack:CALL_TYPE_USERPAYMENT];
        strCallType = @"verifiedTrans";
    }
}

#pragma mark PGTransactionViewController delegate

//-(void)didFinishedResponse:(PGTransactionViewController *)controller response:(NSString *)responseString {
//    DEBUGLOG(@"ViewController::didFinishedResponse:response = %@", responseString);
//    NSString *title = [NSString stringWithFormat:@"Response"];
//    [[[UIAlertView alloc] initWithTitle:title message:[responseString description] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
//    [self removeController:controller];
//}

- (void)didCancelTransaction:(PGTransactionViewController *)controller error:(NSError*)error response:(NSDictionary *)response
{
    DEBUGLOG(@"ViewController::didCancelTransaction error = %@ response= %@", error, response);
    NSString *msg = nil;
    if (!error) msg = [NSString stringWithFormat:@"Successful"];
    else msg = [NSString stringWithFormat:@"UnSuccessful"];
    
    [[[UIAlertView alloc] initWithTitle:@"Transaction Cancel" message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    [self removeController:controller];
}

- (void)didFinishedResponse:(PGTransactionViewController *)controller response:(NSDictionary *)response
{
    NSLog(@"ViewController::didFinishCASTransaction:response = %@", response);
    [self removeController:controller];
    
    strPayTMResData = [NSString stringWithFormat:@"%@",response];
    
    NSData *data = [strPayTMResData dataUsingEncoding:NSUTF8StringEncoding];
    id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    NSLog(@"%@",[json description]);
    
    
    dictPayTMRes = [[NSDictionary alloc]init];
    dictPayTMRes = json;
    
    if ([[json valueForKey:@"STATUS"] isEqualToString:@"TXN_FAILURE"]) {
        CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
        style.messageColor = [self colorWithHexString:strColor];
        [self.view makeToast:[json valueForKey:@"RESPMSG"]
                    duration:3.0
                    position:CSToastPositionBottom
                       style:style];
        
        [CSToastManager setSharedStyle:style];
        [CSToastManager setTapToDismissEnabled:YES];
        [CSToastManager setQueueEnabled:NO];
    }else{
        [self APIPayTMResponse];
    }
}


-(void)didCancelTrasaction:(PGTransactionViewController *)controller{
    NSLog(@"Transaction is Cancelled");
    [self removeController:controller];
}

- (IBAction)onChangeClicked:(id)sender {
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    alert.customViewColor = [self colorWithHexString:strColor];
    SCLTextView *textField = [alert addTextField:@"Enter New Promo code"];
   // textField.keyboardType = UIKeyboardTypeNumberPad;
    [alert addButton:@"OK" actionBlock:^(void) {
        NSLog(@"Text value: %@", textField.text);
        _lblCode.text = [NSString stringWithFormat:@"%@",textField.text];
        strReferCode = [NSString stringWithFormat:@"%@",textField.text];
        [self APIChangeCode];
    }];
    [alert showEdit:self title:@"New Promo Code" subTitle:nil closeButtonTitle:@"CLOSE" duration:0.0f];
}

#pragma mark - API HANDLER

- (void)parserDidFailWithError:(NSError *)error andCallType:(CallTypeEnum)callType{
    CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
    style.messageColor = [self colorWithHexString:strColor];
    [self.view makeToast:@"Something went wrong!!, Please try again"
                duration:3.0
                position:CSToastPositionBottom
                   style:style];
    
    [CSToastManager setSharedStyle:style];
    [CSToastManager setTapToDismissEnabled:YES];
    [CSToastManager setQueueEnabled:NO];
}

- (void)requestHandler:(HTTPRequestHandler *)requestHandler didFailedWithError:(NSError *)error andCallBack:(CallTypeEnum)callType
{
    [self HideActivityIndicator];
    NSString *strError = NSLocalizedString(@"Something went wrong!!, Please try again", @"");
    
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"Error"
                                 message:strError
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"OK"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                    
                                }];
    [alert addAction:yesButton];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)requestHandler:(HTTPRequestHandler *)requestHandler didFinishWithData:(NSData *)data andCallBack:(CallTypeEnum)callType
{
    // [SVProgressHUD dismiss];
    
    [self HideActivityIndicator];
    
    NSString *response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *jsonRes = [response JSONValue];
    if ([[jsonRes valueForKey:@"message"] isEqualToString:@"Unauthenticated."]) {

        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@"Error"
                                     message:@"Unauthenticated"
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"OK"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {
                                        
                                        NSFileManager *fileManager = [NSFileManager defaultManager];
                                        NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                                        
                                        NSString *filePath = [documentsPath stringByAppendingPathComponent:@"brain.zip"];
                                        NSError *error;
                                        BOOL success = [fileManager removeItemAtPath:filePath error:&error];
                                        if (success) {
                                            NSLog(@"DONE");
                                        }
                                        else
                                        {
                                            NSLog(@"Could not delete file -:%@ ",[error localizedDescription]);
                                        }
                                        
                                        [isLogin setInteger:0 forKey:@"LoggedIn"];
                                        [isLogin synchronize];
                                        [userLanguage setValue:@"EN" forKey:@"AppleLanguages"];
                                        [Userprofileimg setObject:@"" forKey:@"user_profile_image"];
                                        [Userprofileimg synchronize];
                                     //   [self performSegueWithIdentifier:@"OutToLogin" sender:self];
                                    }];
        [alert addAction:yesButton];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
    else  {
        if ([strCallType isEqualToString:@"package"]) {
            [_delegate parserSuccessDelegateDidFinish:jsonRes andCallType:CALL_TYPE_LOAD_PACKAGE];
            NSLog(@"%@",jsonRes);
            NSString *status = [NSString stringWithFormat:@"%@",[jsonRes valueForKey:@"status"]];
            NSLog(@"%@",status);
            if ([status isEqualToString:@"1"]) {
                NSString *statusCode  = [NSString stringWithFormat:@"%@",[jsonRes valueForKey:@"statusCode"]];
                if ([statusCode isEqualToString:@"200"]) {
                    dictPackage = [[NSMutableDictionary  alloc] init];
                    NSArray *arr = [jsonRes valueForKey:@"data"];
                    dictPackage = [arr objectAtIndex:0];
                    _lblModulePrice.text = [NSString stringWithFormat:@"%@ %@",strCurrencyCode, [dictPackage valueForKey:@"package_price"]];
                    _lblGSTPrice.text = [NSString stringWithFormat:@"%@ %@",strCurrencyCode, [dictPackage valueForKey:@"tax_amount"]];
                    _lblNetAmountPrice.text = [NSString stringWithFormat:@"%@ %@",strCurrencyCode, [dictPackage valueForKey:@"net_amount"]];
                    _lblDiscountPrice.text = [NSString stringWithFormat:@"%@ %@",strCurrencyCode, [dictPackage valueForKey:@"discount"]];
                    _lblTotalAmount.text = [NSString stringWithFormat:@"%@ %@",strCurrencyCode, [dictPackage valueForKey:@"total_amount"]];
                    _lblCGSTPurchase.text = [NSString stringWithFormat:@"CGST(%@%%)",[dictPackage valueForKey:@"CGST"]];
                    _lblSGSTPurchase.text = [NSString stringWithFormat:@"SGST(%@%%)",[dictPackage valueForKey:@"SGST"]];
                    _lblComboDiscount.text = [NSString stringWithFormat:@"%@ %@",strCurrencyCode, [dictPackage valueForKey:@"combo_discount_amount"]];
                }
                else if ([statusCode isEqualToString:@"533"]) {
                    NSDictionary *dict = [[NSDictionary alloc]init];
                    dict = [jsonRes valueForKey:@"data"];
                    
                    _lblUserMobile.hidden = YES;
                    _lblUserName.text = [NSString stringWithFormat:@"%@",[dict valueForKey:@"user_name"]];
                    _lblUserName1.text = [NSString stringWithFormat:@"%@",[dict valueForKey:@"user_name"]];
                    _lblPurchasePackage.text = [NSString stringWithFormat:@"%@",[dict valueForKey:@"package_price"]];
                    _lblPurchaseGST.text = [NSString stringWithFormat:@"%@",[dict valueForKey:@"gst_price"]];
                    _lblPurchaseDiscount.text = [NSString stringWithFormat:@"%@",[dict valueForKey:@"discount_price"]];
                    _lblOrderID.text = [NSString stringWithFormat:@"%@",[dict valueForKey:@"order_id"]];
                    _lblTransactionID.text = [NSString stringWithFormat:@"%@",[dict valueForKey:@"transaction_id"]];
                    _lblPurchaseDate.text = [NSString stringWithFormat:@"%@",[dict valueForKey:@"payment_date"]];
                    _lblPackageName.text = [NSString stringWithFormat:@"%@",[dict valueForKey:@"package_name"]];
                    _lblTotal.text = [NSString stringWithFormat:@"%@",[dict valueForKey:@"total"]];
                    _lblCGST.text = [NSString stringWithFormat:@"CGST(%@%%)",[dict valueForKey:@"CGST"]];
                    _lblSGST.text = [NSString stringWithFormat:@"SGST(%@%%)",[dict valueForKey:@"SGST"]];
                    
                    NSString *strPaymentThrough = [NSString stringWithFormat:@"%@",[dict valueForKey:@"Payment_type"]];
                    
                    if ([strPaymentThrough isEqualToString:@"1"]) {
                        _lblPatmentVia.text = @"iBrainPowers";
                    }
                    else if ([strPaymentThrough isEqualToString:@"0"]){
                        _lblPatmentVia.text = @"PayTM";
                    }
                    else{
                        _lblPatmentVia.text = @"Personal";
                        _lblPromotional.hidden = NO;
                        _imgPromotional.hidden = NO;
                    }
                    
                    _viewRecipt.hidden = NO;
                }
            }
            else{
                CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
                style.messageColor = [self colorWithHexString:strColor];
                [self.view makeToast:[jsonRes valueForKey:@"message"]
                            duration:3.0
                            position:CSToastPositionBottom
                               style:style];
                
                [CSToastManager setSharedStyle:style];
                [CSToastManager setTapToDismissEnabled:YES];
                [CSToastManager setQueueEnabled:NO];
            }
        }
        else if([strCallType isEqualToString:@"change"]){
            [_delegate parserSuccessDelegateDidFinish:jsonRes andCallType:CALL_TYPE_CHANGE_PARTNER];
            NSLog(@"%@",jsonRes);
            NSString *status = [NSString stringWithFormat:@"%@",[jsonRes valueForKey:@"status"]];
            NSLog(@"%@",status);
            if ([status isEqualToString:@"1"]) {
                dictPackage = [[NSMutableDictionary  alloc] init];
                 NSArray *arr = [jsonRes valueForKey:@"data"];
                dictPackage = [arr objectAtIndex:0];
                _lblModulePrice.text = [NSString stringWithFormat:@"%@ %@",strCurrencyCode, [dictPackage valueForKey:@"package_price"]];
                _lblGSTPrice.text = [NSString stringWithFormat:@"%@ %@",strCurrencyCode, [dictPackage valueForKey:@"gst_price"]];
                _lblNetAmountPrice.text = [NSString stringWithFormat:@"%@ %@",strCurrencyCode, [dictPackage valueForKey:@"net_amount"]];
                _lblDiscountPrice.text = [NSString stringWithFormat:@"%@ %@",strCurrencyCode, [dictPackage valueForKey:@"discount"]];
                _lblTotalAmount.text = [NSString stringWithFormat:@"%@ %@",strCurrencyCode, [dictPackage valueForKey:@"total_amount"]];
                _lblComboDiscount.text = [NSString stringWithFormat:@"%@ %@",strCurrencyCode, [dictPackage valueForKey:@"combo_discount_amount"]];
            }
            else{
                CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
                style.messageColor = [self colorWithHexString:strColor];
                [self.view makeToast:[jsonRes valueForKey:@"message"]
                            duration:3.0
                            position:CSToastPositionBottom
                               style:style];
                
                [CSToastManager setSharedStyle:style];
                [CSToastManager setTapToDismissEnabled:YES];
                [CSToastManager setQueueEnabled:NO];
            }
        }
        else if([strCallType isEqualToString:@"checkSum"]){
            [_delegate parserSuccessDelegateDidFinish:jsonRes andCallType:CALL_TYPE_GENERATE_CHECKSUM];
            NSLog(@"%@",jsonRes);
            NSString *status = [NSString stringWithFormat:@"%@",[jsonRes valueForKey:@"status"]];
            NSLog(@"%@",status);
            if ([status isEqualToString:@"1"]) {
                dictPayTM = [[NSMutableDictionary  alloc] init];
                dictPayTM = [jsonRes valueForKey:@"data"];
                [self APIPayTm];
            }
            else{
                CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
                style.messageColor = [self colorWithHexString:strColor];
                [self.view makeToast:[jsonRes valueForKey:@"message"]
                            duration:3.0
                            position:CSToastPositionBottom
                               style:style];
                
                [CSToastManager setSharedStyle:style];
                [CSToastManager setTapToDismissEnabled:YES];
                [CSToastManager setQueueEnabled:NO];
            }
        }
        else if([strCallType isEqualToString:@"generateVerify"]){
            [_delegate parserSuccessDelegateDidFinish:jsonRes andCallType:CALL_TYPE_GENERATE_CHECKSUM];
            NSLog(@"%@",jsonRes);
            NSString *status = [NSString stringWithFormat:@"%@",[jsonRes valueForKey:@"status"]];
            NSLog(@"%@",status);
            if ([status isEqualToString:@"1"]) {
                strGenerateVerifiedCheck = [jsonRes valueForKey:@"data"];
                [self ApiVerifyTransaction];
           
            }
            else{
                CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
                style.messageColor = [self colorWithHexString:strColor];
                [self.view makeToast:[jsonRes valueForKey:@"message"]
                            duration:3.0
                            position:CSToastPositionBottom
                               style:style];
                
                [CSToastManager setSharedStyle:style];
                [CSToastManager setTapToDismissEnabled:YES];
                [CSToastManager setQueueEnabled:NO];
            }
        }
        else if([strCallType isEqualToString:@"verifiedTrans"]){
            [_delegate parserSuccessDelegateDidFinish:jsonRes andCallType:CALL_TYPE_USERPAYMENT];
            NSLog(@"%@",jsonRes);
            if ([[jsonRes valueForKey:@"STATUS"] isEqualToString:@"TXN_FAILURE"]) {
                CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
                style.messageColor = [self colorWithHexString:strColor];
                [self.view makeToast:[jsonRes valueForKey:@"RESPMSG"]
                            duration:3.0
                            position:CSToastPositionBottom
                               style:style];
                
                [CSToastManager setSharedStyle:style];
                [CSToastManager setTapToDismissEnabled:YES];
                [CSToastManager setQueueEnabled:NO];
            }else{
                [self APIPayTMResponse];
            }
           
        }
        else if([strCallType isEqualToString:@"payment"]){
            [_delegate parserSuccessDelegateDidFinish:jsonRes andCallType:CALL_TYPE_USERPAYMENT];
            NSLog(@"%@",jsonRes);
            NSString *status = [NSString stringWithFormat:@"%@",[jsonRes valueForKey:@"status"]];
            if ([status isEqualToString:@"1"]) {
                
                NSDictionary *dict = [[NSDictionary alloc]init];
                dict = [jsonRes valueForKey:@"data"];
                
                CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
                style.messageColor = [self colorWithHexString:strColor];
                [self.view makeToast:[jsonRes valueForKey:@"message"]
                            duration:3.0
                            position:CSToastPositionBottom
                               style:style];
                
                [CSToastManager setSharedStyle:style];
                [CSToastManager setTapToDismissEnabled:YES];
                [CSToastManager setQueueEnabled:NO];
                
                _lblUserMobile.hidden = YES;
                
                _lblUserName.text = [NSString stringWithFormat:@"%@",[dict valueForKey:@"user_name"]];
                _lblUserName1.text = [NSString stringWithFormat:@"%@",[dict valueForKey:@"user_name"]];
                _lblPurchasePackage.text = [NSString stringWithFormat:@"%@",[dict valueForKey:@"package_price"]];
                _lblPurchaseGST.text = [NSString stringWithFormat:@"%@",[dict valueForKey:@"gst_price"]];
                _lblPurchaseDiscount.text = [NSString stringWithFormat:@"%@",[dict valueForKey:@"discount_price"]];
                _lblOrderID.text = [NSString stringWithFormat:@"%@",[dict valueForKey:@"order_id"]];
                _lblTransactionID.text = [NSString stringWithFormat:@"%@",[dict valueForKey:@"transaction_id"]];
                
                _lblPurchaseDate.text = [NSString stringWithFormat:@"%@",[dict valueForKey:@"payment_date"]];
                _lblPackageName.text = [NSString stringWithFormat:@"%@",[dict valueForKey:@"package_name"]];
                _lblTotal.text = [NSString stringWithFormat:@"%@",[dict valueForKey:@"total"]];
                _lblCGST.text = [NSString stringWithFormat:@"CGST(%@%%)",[dict valueForKey:@"CGST"]];
                _lblSGST.text = [NSString stringWithFormat:@"SGST(%@%%)",[dict valueForKey:@"SGST"]];
                
                NSString *strPaymentThrough = [NSString stringWithFormat:@"%@",[dict valueForKey:@"Payment_type"]];
                
                if ([strPaymentThrough isEqualToString:@"1"]) {
                    _lblPatmentVia.text = @"iBrainPowers";
                }
                else if ([strPaymentThrough isEqualToString:@"0"]){
                    _lblPatmentVia.text = @"PayTM";
                }
                else{
                    _lblPatmentVia.text = @"Personal";
                    _lblPromotional.hidden = NO;
                    _imgPromotional.hidden = NO;
                }
                
                _viewRecipt.hidden = NO;
                
            }
            else{
                CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
                style.messageColor = [self colorWithHexString:strColor];
                [self.view makeToast:[jsonRes valueForKey:@"message"]
                            duration:3.0
                            position:CSToastPositionBottom
                               style:style];
                
                [CSToastManager setSharedStyle:style];
                [CSToastManager setTapToDismissEnabled:YES];
                [CSToastManager setQueueEnabled:NO];
            }
        }
    }
}

- (IBAction)onRefundPolicyClicked:(id)sender {
    
    _btnRefundInvoice.userInteractionEnabled = NO;
    _btnRefundPurchase.userInteractionEnabled = NO;
    
    NSString *strRefund = NSLocalizedString(@"1. We thank you for choosing iBrainPowers App Level 1 & 2.\n2. To be eligible for refund\n\t2.1. Even if module  1 & 2 are completed you can opt for 100%% refund.\n\t2.2. If you completed between module 3 - 5 you can opt for 50%% refund.\n\t2.3. If you complete module 6 then no refund initiated.\n3. No refund after 15 days of purchase.\n4. For any refund please contact support@ibrainpowers.com with your registered mobile number in subject line for speedy initiation.", @"");
    
    switch ([sender tag]) {
        case 0:
            _viewBack.hidden = NO;
            _viewRefundPolicyPurchase.hidden = NO;
            _lblRefundBodyPurchase.text = strRefund;
            _btnPayTm.userInteractionEnabled = NO;
            _btnPayTm.enabled = NO;
            break;
        case 1:
            _viewBack1.hidden = NO;
            _viewRefundPolicy.hidden = NO;
            _lblRefundBody.text = strRefund;
            break;
        default:
            break;
    }
}
- (IBAction)onOkClicked:(id)sender {
    _btnRefundInvoice.userInteractionEnabled = YES;
    _viewRefundPolicy.hidden = YES;
    _viewBack1.hidden = YES;
}
- (IBAction)onOKClickedPurchase:(id)sender {
    _btnRefundPurchase.userInteractionEnabled = YES;
    _viewRefundPolicyPurchase.hidden = YES;
    _btnPayTm.userInteractionEnabled = YES;
    _btnPayTm.enabled = YES;
    _viewBack.hidden =YES;
}
@end
