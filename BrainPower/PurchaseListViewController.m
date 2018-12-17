//
//  PurchaseListViewController.m
//  BrainPower
//
//  Created by nestcode on 9/25/18.
//  Copyright © 2018 nestcode. All rights reserved.
//

#import "PurchaseListViewController.h"


@interface PurchaseListViewController (){
    NSUserDefaults *UserData, *UserAuth, *userPackages;
    NSMutableDictionary *userDictData;
    NSString *strRefer, *strCallType, *strPartnerCode, *strUserCode, *strMobile, *strEmail;
    NSUserDefaults *ColorCode;
    NSString *strColor;
    NSMutableDictionary *dictPackage;
    NSDictionary *dictPayTMRes;
    NSString *strPayTMResData, *strGenerateVerifiedCheck;
    NSString *strOrder;
    NSUserDefaults *isLogin;
    NSUserDefaults *Userprofileimg;
    NSUserDefaults *userLanguage ,*UserPaymentURL;
    long currentTime;
    NSString *strReferCode, *strSelectedFinal;
    NSMutableArray *arrPackages;
    NSMutableArray *arrSelectedIndex, *arrPaid, *arrDiscounts;
    NSString *strCurrencyCode, *strPayable, *strDicountedAmount, *strAllPaid;
    NSArray *arr;
    int payable, discount;
}

@end

@implementation PurchaseListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tblDiscountList.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self reloadView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadView) name:@"ReloadView" object:nil];
}

-(void)reloadView{
    arrPackages = [[NSMutableArray alloc]init];
    arrPaid = [[NSMutableArray alloc]init];
    arrSelectedIndex = [[NSMutableArray alloc]init];
    arrDiscounts = [[NSMutableArray alloc]init];
    
    ColorCode = [NSUserDefaults standardUserDefaults];
    strColor = [NSString stringWithFormat:@"%@",[ColorCode valueForKey:@"colorcode"]];
    
    [self.navigationController.navigationBar setValue:@(YES) forKeyPath:@"hidesShadow"];
    
    _btnCheckOut.backgroundColor = [self colorWithHexString:strColor];
    _viewTop.backgroundColor = [self colorWithHexString:strColor];
    _viewTop.layer.cornerRadius = 5;
    
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
    
    if ([strMobile containsString:@"+91"]) {
        strCurrencyCode = @"₹";
    }
    else{
        strCurrencyCode = @"$";
    }
    
    NSUserDefaults *userCurrency = [NSUserDefaults standardUserDefaults];
    [userCurrency setValue:strCurrencyCode forKey:@"userCurrency"];
    [userCurrency synchronize];
    
    self.tblPurchaseList.allowsMultipleSelectionDuringEditing = YES;
    self.tblPurchaseList.editing = YES;
    
    _viewDiscounts.hidden = YES;
    _viewDiscountList.backgroundColor = [self colorWithHexString:strColor];

    // [_btnDone setTitleColor:[self colorWithHexString:strColor] forState:UIControlStateNormal];
    
    _lblComboDiscount.text = [NSString stringWithFormat:@"%@ 0",strCurrencyCode];
    _lblPayableAmount.text = [NSString stringWithFormat:@"%@ 0",strCurrencyCode];
    
    strPayable = @"0";
    payable = 0;
    discount = 0;
    [self APILoadPackage];
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.tblDiscountList) {
        return arrDiscounts.count;
    }
    else{
        return arrPackages.count;
    }
    //return arrPackages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.tblDiscountList) {
        PurchaseDiscountListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PurchaseDiscountListTableViewCell" forIndexPath:indexPath];
        
     //  NSDictionary *dict = [arrDiscounts objectAtIndex:indexPath.row];
        NSString *strLevel = [NSString stringWithFormat:@"%@",[arr objectAtIndex:indexPath.row]];
        strLevel = [strLevel stringByReplacingOccurrencesOfString:@"levels_"
                                                       withString:@""];
        cell.lblTitle.text = [NSString stringWithFormat:@"Buy %@ Levels",strLevel];
        
        NSString *strLevelDis = [NSString stringWithFormat:@"%@",[arrDiscounts objectAtIndex:indexPath.row]];
        cell.lblDiscountAmount.text = [NSString stringWithFormat:@"%@ %%",strLevelDis];
        
        return cell;
    }
    else{
        PurchaseListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PurchaseListTableViewCell" forIndexPath:indexPath];
        
        NSString *strMSG = NSLocalizedString(@"You save", @"");
        NSDictionary *dict = [arrPackages objectAtIndex:indexPath.row];
        
        cell.lblPackageName.text = [dict valueForKey:@"package_name"];
        cell.lblDiscount.text = [NSString stringWithFormat:@"%@: %@%%",strMSG,[dict valueForKey:@"discount_per"]];
        cell.lblLastAmount.text = [NSString stringWithFormat:@"%@ %@",strCurrencyCode,[dict valueForKey:@"net_amount"]];
        NSString *str = [NSString stringWithFormat:@"%@ %@",strCurrencyCode,[dict valueForKey:@"package_price"]];
        
        NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:str];
        [attributeString addAttribute:NSStrikethroughStyleAttributeName
                                value:@2
                                range:NSMakeRange(0, [attributeString length])];
        
        [cell.lblAmount setAttributedText:attributeString];
        //cell.lblAmount.text = [NSString stringWithFormat:@"%@",attributeString];
        
        NSString *strPaymentStatus = [NSString stringWithFormat:@"%@",[dict valueForKey:@"payment_status"]];
        if ([strPaymentStatus isEqualToString:@"2"]) {        
            cell.contentView.userInteractionEnabled = NO;
            cell.viewPurchased.hidden = NO;
        }
        else if ([strPaymentStatus isEqualToString:@"1"]) {
            cell.contentView.userInteractionEnabled = YES;
            cell.viewPurchased.hidden = YES;
        }
        else if ([strPaymentStatus isEqualToString:@"0"]) {
            cell.contentView.userInteractionEnabled = YES;
            cell.viewPurchased.hidden = YES;
        }
        
        /*
         NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:@"Your String here"];
         [attributeString addAttribute:NSStrikethroughStyleAttributeName
         value:@2
         range:NSMakeRange(0, [attributeString length])];
         */
        return cell;
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.tblPurchaseList) {
        return 100;
    }
    else{
        return 50;
    }
}

- (NSIndexPath *)tableView:(UITableView *)tableView
  willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *selectedArray = [self.tblPurchaseList indexPathsForSelectedRows];
    long index = indexPath.row;
    NSString *strIndex = [NSString stringWithFormat:@"%ld",index];
    NSDictionary *dictTemp = [arrPackages objectAtIndex:indexPath.row];
    NSString *strPaymentStatus = [NSString stringWithFormat:@"%@",[dictTemp valueForKey:@"payment_status"]];

    if ([arrPaid count] == 0) {
        if ([strPaymentStatus isEqualToString:@"2"]) {
            NSString *strWarning = NSLocalizedString(@"Already Purchased!", @"");
            CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
            style.messageColor = [self colorWithHexString:strColor];
            [self.view makeToast:strWarning
                        duration:3.0
                        position:CSToastPositionBottom
                           style:style];
            
            [CSToastManager setSharedStyle:style];
            [CSToastManager setTapToDismissEnabled:YES];
            [CSToastManager setQueueEnabled:NO];
        }
    }
    else{
        
        long count = [arrSelectedIndex count];
        int y = 0;
        if (count > 0) {
            count = count - 1;
            NSString *str = [arrDiscounts objectAtIndex:count];
            y = [str intValue];
        }
        
        payable = 0;
        
        for (int i = 0; i < [arrSelectedIndex count]; i ++) {
            NSDictionary *dictTemp1 = [arrPackages objectAtIndex:i];
            NSString *strPay = [NSString stringWithFormat:@"%@",[dictTemp1 valueForKey:@"net_amount"]];
            int x1 = [strPay intValue];
            payable = payable + x1;
        }
        
        strPayable = [NSString stringWithFormat:@"%@",[dictTemp valueForKey:@"net_amount"]];
        int x = [strPayable intValue];
        
        payable = payable + x;
        
        if (y > 0) {
            float precentage = (payable * y)/100;
            int per = (int)precentage;
            payable = payable - per;
            _lblComboDiscount.text = [NSString stringWithFormat:@"%@ %d",strCurrencyCode,per];
        }
        
        _lblPayableAmount.text = [NSString stringWithFormat:@"%@ %d",strCurrencyCode,payable];
        
        NSString *strPaid = [arrPaid objectAtIndex:0];
        if ([strPaymentStatus isEqualToString:@"1"]) {
            if ([arrSelectedIndex count] == 0) {
                if ([strIndex isEqualToString:strPaid]) {
                    [arrSelectedIndex addObject:strIndex];
                    NSLog(@"%@",arrSelectedIndex);
                    return indexPath;
                }
                else{
                    payable = 0;
                    _lblComboDiscount.text = [NSString stringWithFormat:@"%@ 0",strCurrencyCode];
                    _lblPayableAmount.text = [NSString stringWithFormat:@"%@ 0",strCurrencyCode];
                    return nil;
                }
            }
            else{
                NSString *strSelectedIndex = [arrSelectedIndex lastObject];
                long selectIndex = [strSelectedIndex longLongValue];
                if ([arrSelectedIndex containsObject:strIndex]) {
                    [arrSelectedIndex removeObject:strIndex];
                    return nil;
                }
                else if (index == selectIndex+1){
                    [arrSelectedIndex insertObject:strIndex atIndex:[arrSelectedIndex count]];
                    NSLog(@"%@",arrSelectedIndex);
                    return indexPath;
                }
                else{
                    return nil;
                }
            }
        }
    }

    return nil;
}

-(NSIndexPath *)tableView:(UITableView *)tableView willDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    long index = indexPath.row;
    NSString *strIndex = [NSString stringWithFormat:@"%ld",index];
    NSDictionary *dictTemp = [arrPackages objectAtIndex:indexPath.row];
    NSString *strSelectedIndex = [arrSelectedIndex objectAtIndex:0];
    long selectIndex = [strSelectedIndex longLongValue];
    
    if ([arrSelectedIndex containsObject:strIndex]) {
        if (selectIndex == index) { //CODE FOR ONLY ONE SELECTED
            _lblPayableAmount.text = [NSString stringWithFormat:@"%@ 0",strCurrencyCode];
            _lblComboDiscount.text = [NSString stringWithFormat:@"%@ 0",strCurrencyCode];
            payable = 0;
            for (NSIndexPath *indexPath in [self.tblPurchaseList indexPathsForSelectedRows]) {
                [self.tblPurchaseList deselectRowAtIndexPath:indexPath animated:NO];
            }
            [arrSelectedIndex removeAllObjects];
            arrSelectedIndex = [[NSMutableArray alloc]init];
        }
        else{ //MULTI SELECTED
            
            strPayable = [NSString stringWithFormat:@"%@",[dictTemp valueForKey:@"net_amount"]];
            if (arrSelectedIndex.count < arrPackages.count) {
                _lblComboDiscount.text = [NSString stringWithFormat:@"%@ 0",strCurrencyCode];
                NSDictionary *dictTemp = [arrPackages objectAtIndex:0];
                strPayable = [NSString stringWithFormat:@"%@",[dictTemp valueForKey:@"net_amount"]];
                _lblPayableAmount.text = [NSString stringWithFormat:@"%@ %@",strCurrencyCode,strPayable];
            }
            else{
                payable = 0;
                for (int i = 0; i < [arrSelectedIndex count]-1; i ++) {
                    NSDictionary *dictTemp1 = [arrPackages objectAtIndex:i];
                    NSString *strPay = [NSString stringWithFormat:@"%@",[dictTemp1 valueForKey:@"net_amount"]];
                    int x1 = [strPay intValue];
                    payable = payable + x1;
                }
                
                long count = [arrSelectedIndex count] - 1;
                int y = 0;
                if (count > 0) {
                    count = count - 2;
                    NSString *str = [arrDiscounts objectAtIndex:count];
                    y = [str intValue];
                }
                
                if (y > 0) {
                    float precentage = (payable * y)/100;
                    int per = (int)precentage;
                    payable = payable - per;
                    _lblComboDiscount.text = [NSString stringWithFormat:@"%@ %d",strCurrencyCode,per];
                    _lblPayableAmount.text = [NSString stringWithFormat:@"%@ %d",strCurrencyCode,payable];
                }
            }
            
            
      //      int x = [strPayable intValue];
      //      payable = payable - x;
            
            long indexValue = [arrSelectedIndex indexOfObject:strIndex];
            NSLog(@"Index position :%ld",indexValue);
            
            long temp_index = index;
            for (long j = indexValue; j < [arrSelectedIndex count]; j++) {
                
                NSIndexPath *indexPathR = [NSIndexPath indexPathForRow:temp_index inSection:0];
                [self.tblPurchaseList deselectRowAtIndexPath:indexPathR animated:NO];
                temp_index++;
                
            }
            arrSelectedIndex = [[NSMutableArray alloc]init];
            NSArray *selectedArray = [self.tblPurchaseList indexPathsForSelectedRows];
            for (NSIndexPath *indexPath in selectedArray) {
                NSString *str = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
                [arrSelectedIndex addObject:str];
            }
            return indexPath;
        }
    }
    return nil;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}

- (IBAction)onCheckoutClicked:(id)sender {
    
    if ([strAllPaid isEqualToString:@"0"]) {
        NSArray *selectedArray = [self.tblPurchaseList indexPathsForSelectedRows];
        NSString *strWarning = NSLocalizedString(@"Please Select Package to Continue Purchase!", @"");
        
        if ([selectedArray count] == 0) {
            CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
            style.messageColor = [UIColor whiteColor];
            style.backgroundColor = [self colorWithHexString:strColor];
            [self.view makeToast:strWarning
                        duration:3.0
                        position:CSToastPositionBottom
                           style:style];
            
            [CSToastManager setSharedStyle:style];
            [CSToastManager setTapToDismissEnabled:YES];
            [CSToastManager setQueueEnabled:NO];
        }
        else{
            NSMutableArray *arrIDs = [[NSMutableArray alloc]init];
            for (NSIndexPath *indexPath in selectedArray) {
                NSDictionary *dictTemp = [arrPackages objectAtIndex:indexPath.row];
                NSString *strID = [NSString stringWithFormat:@"%@",[dictTemp valueForKey:@"level_id"]];
                [arrIDs addObject:strID];
            }
            strSelectedFinal = [arrIDs componentsJoinedByString:@","];
            NSLog(@"%@",strSelectedFinal);
            NSUserDefaults *userSelectedFinal = [NSUserDefaults standardUserDefaults];
            [userSelectedFinal setValue:strSelectedFinal forKey:@"userSelectedFinal"];
            [userSelectedFinal synchronize];
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:[Global getStoryBoardName] bundle:nil];
            PurchaseViewController *purchaseVC = (PurchaseViewController *)[storyboard instantiateViewControllerWithIdentifier:@"PurchaseViewController"];
            [self.navigationController pushViewController:purchaseVC animated:YES];
        }
    }
    else{
        NSString *strWarning = NSLocalizedString(@"You Have Purchased All Packages!", @"");
        CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
        style.messageColor = [UIColor whiteColor];
        style.backgroundColor = [self colorWithHexString:strColor];
        [self.view makeToast:strWarning
                    duration:3.0
                    position:CSToastPositionBottom
                       style:style];
        
        [CSToastManager setSharedStyle:style];
        [CSToastManager setTapToDismissEnabled:YES];
        [CSToastManager setQueueEnabled:NO];
        
    }
    
    
    
}

- (IBAction)onCloseDiscountClicked:(id)sender {
    _viewDiscounts.hidden = YES;
}

- (IBAction)onDoneClicked:(id)sender {
    _viewDiscounts.hidden = YES;
}

- (IBAction)onShowDiscountClicked:(id)sender {
    _viewDiscounts.hidden = NO;
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
      [SVProgressHUD dismiss];
    self.view.userInteractionEnabled = YES;
}


-(void)APILoadPackage{
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable)
    {
        [self CheckConnection];
    }
    else
    {
        NSDictionary *tmp = [[NSDictionary alloc]initWithObjectsAndKeys:
                             strReferCode,@"partner_code",
                             nil];
        NSError* error;
        NSData* data = [NSJSONSerialization dataWithJSONObject:tmp options:0 error:&error];
        
         [SVProgressHUD show];
        UserAuth = [NSUserDefaults standardUserDefaults];
        NSString *strAuth = [UserAuth valueForKey:@"UserAuth"];
        
        NSString *strUrl = [NSString stringWithFormat:@"%@",API_LOAD_PACKAGE];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]init];
        request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:strUrl]];
        
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
        [request setValue:strAuth forHTTPHeaderField:@"Authorization"];
        [request setHTTPBody:nil];
        
        requestHandler = [[HTTPRequestHandler alloc] initWithRequest:request delegate:self andCallBack:CALL_TYPE_LOAD_PACKAGE];
        strCallType = @"package";
    }
}

-(void)APILoadPackageFinal{
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable)
    {
        [self CheckConnection];
    }
    else
    {
        NSDictionary *tmp = [[NSDictionary alloc]initWithObjectsAndKeys:
                             strSelectedFinal,@"level_id",
                             nil];
        NSError* error;
        NSData* data = [NSJSONSerialization dataWithJSONObject:tmp options:0 error:&error];
        
        [SVProgressHUD show];
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
        strCallType = @"packagefinal";
    }
}

#pragma mark - API HANDLER

- (void)parserDidFailWithError:(NSError *)error andCallType:(CallTypeEnum)callType{
    [SVProgressHUD dismiss];
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
    [SVProgressHUD dismiss];
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
     [SVProgressHUD dismiss];
    
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
                
                strAllPaid = [NSString stringWithFormat:@"%@",[[jsonRes valueForKey:@"data"] valueForKey:@"paid_all"]];
                arrPackages = [[jsonRes valueForKey:@"data"]valueForKey:@"packages"];
                NSDictionary *dict = [[jsonRes valueForKey:@"data"]valueForKey:@"combo_discount"];
                
                if (dict.count != 0) {
                    arr = [[NSArray alloc]init];
                    arr = [dict allKeys];
                    arr = [arr sortedArrayUsingComparator:^(id a, id b) {
                        return [a compare:b options:NSNumericSearch];
                    }];
                    
                    for (int i = 0; i < [dict count]; i++) {
                        NSString *strTemp = [NSString stringWithFormat:@"%@",[arr objectAtIndex:i]];
                        [arrDiscounts insertObject:[dict valueForKey:strTemp] atIndex:i];
                    }
                }
                
                for (int i = 0; i <[arrPackages count]; i ++) {
                    NSDictionary *dictTemp = [arrPackages objectAtIndex:i];
                    NSString *strPaymentStatus = [NSString stringWithFormat:@"%@",[dictTemp valueForKey:@"payment_status"]];
                    if ([strPaymentStatus isEqualToString:@"1"]) {
                        [arrPaid addObject:[NSString stringWithFormat:@"%d",i]];
                    }
                }
                [_tblDiscountList reloadData];
                [_tblPurchaseList reloadData];
                
                
                if ([strAllPaid isEqualToString:@"0"]) {
                    _btnCheckOut.userInteractionEnabled = YES;
                    _btnCheckOut.enabled = YES;
                }
                else{
                    _btnCheckOut.userInteractionEnabled = NO;
                    _btnCheckOut.enabled = NO;

                /*standardUserDefaults];
                    [userAllPaid setValue:strAllPaid forKey:@"userAllPaid"];
                    [userAllPaid synchronize];

                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:[Global getStoryBoardName] bundle:nil];
                    PurchaseViewController *purchaseVC = (PurchaseViewController *)[storyboard instantiateViewControllerWithIdentifier:@"PurchaseViewController"];

                    [self.navigationController pushViewController:purchaseVC animated:YES];*/
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
    }
}




@end
