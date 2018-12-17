//
//  ContactUsViewController.m
//  BrainPower
//
//  Created by nestcode on 1/16/18.
//  Copyright © 2018 nestcode. All rights reserved.
//

#import "ContactUsViewController.h"

@interface ContactUsViewController ()

@end

@implementation ContactUsViewController{
    NSUserDefaults *ColorCode;
    NSString *strColor;
    UIPickerView *CatPickerView;
    UIToolbar *Cat_toolbar;
    NSArray *arrLanguage;
    NSString *strLanguage;
    NSArray *data;
    NSInteger rowIndex;
    NSUserDefaults *userLanguage, *UserAuth;
    NSString *strLang;
    NSMutableArray *arrLanguages;
    NSUserDefaults *isLogin, *Userprofileimg;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    isLogin = [NSUserDefaults standardUserDefaults];
    Userprofileimg = [NSUserDefaults standardUserDefaults];
    
    self.tblLanguage.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    arrLanguages = [[NSMutableArray alloc]init];
    ColorCode = [NSUserDefaults standardUserDefaults];
    strColor = [NSString stringWithFormat:@"%@",[ColorCode valueForKey:@"colorcode"]];
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    arrLanguage = [[NSArray alloc]init];
    arrLanguage = @[@"English",@"Hindi"];
    
    userLanguage = [NSUserDefaults standardUserDefaults];
    strLang = [userLanguage valueForKey:@"AppleLanguages"];
    
    if ([strLang isEqualToString:@"EN"]) {
        self.select_language.selectedSegmentIndex=0;
    }
    else{
        self.select_language.selectedSegmentIndex=1;
    }
    
    CatPickerView = [[UIPickerView alloc]init];
    CatPickerView.layer.masksToBounds = false;
    CatPickerView.layer.shadowColor = [[UIColor lightGrayColor]CGColor];
    CatPickerView.layer.shadowOffset = CGSizeMake(1.0, 1.0);
    CatPickerView.layer.shadowOpacity = 1.0;
    CatPickerView.dataSource = self;
    CatPickerView.delegate = self;
    CatPickerView.backgroundColor= [UIColor whiteColor];
    Cat_toolbar= [[UIToolbar alloc] initWithFrame:CGRectMake(0,0,320,44)];
    [Cat_toolbar setBarStyle:UIBarStyleBlackTranslucent];
    [Cat_toolbar setBarTintColor:[self colorWithHexString:strColor]];
    UIBarButtonItem *barButtonDone = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                      style:UIBarButtonItemStyleDone target:self action:@selector(done_category:)];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(pickerCancel:)];
    
    UIBarButtonItem *flexibleButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    Cat_toolbar.items = @[cancelButton,flexibleButton,barButtonDone];
    barButtonDone.tintColor=[UIColor whiteColor];
    cancelButton.tintColor = [UIColor whiteColor];
    _txtLanguage.inputView = CatPickerView;
    _txtLanguage.inputAccessoryView = Cat_toolbar;
    
    data = [LanguageManager languageStrings];
    
    [_select_language setTintColor:[self colorWithHexString:strColor]];
    
    [self APILanguages];
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
    
        return arrLanguages.count;
    //return arrPackages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LanguagesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LanguagesTableViewCell" forIndexPath:indexPath];
    NSDictionary *dict = [arrLanguages objectAtIndex:indexPath.row];
    cell.lblLanguageName.text = [dict valueForKey:@"language"];
    NSString *strLanguageCode = [dict valueForKey:@"code"];
    
    NSString *str = [strLang uppercaseString];
    
    if ([strLanguageCode isEqualToString:str]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = [arrLanguages objectAtIndex:indexPath.row];
    NSString *strLanguageCode = [[dict valueForKey:@"code"]lowercaseString];
    [LanguageManager saveLanguageID:strLanguageCode];
    [self reloadRootViewController];
}

- (IBAction)done_category:(id)sender{
    _txtLanguage.text = [NSString stringWithFormat:@"%@",strLanguage];
   // [LanguageManager saveLanguageByIndex:rowIndex];
    [_txtLanguage resignFirstResponder];
    [self reloadRootViewController];
}

- (void)reloadRootViewController
{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSString *storyboardName = @"Main";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:[Global getStoryBoardName] bundle:nil];
    delegate.window.rootViewController = [storyboard instantiateInitialViewController];
}

/*
 if (indexPath.row == [LanguageManager currentLanguageIndex]) {
 cell.accessoryType = UITableViewCellAccessoryCheckmark;
 }
 else {
 cell.accessoryType = UITableViewCellAccessoryNone;
 }
 */


/*
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return ELanguageCount;
}

- (void)pickerCancel:(id)sender {
    [_txtLanguage resignFirstResponder];
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    strLanguage = [[arrLanguage objectAtIndex:row]lowercaseString];
    [LanguageManager saveLanguageByIndex:row];
    return strLanguage;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
   // _txtLanguage.text = [arrLanguage objectAtIndex:row];
    rowIndex = row;
}

- (IBAction)onLangugageSelectClicked:(id)sender {
    if (self.select_language.selectedSegmentIndex == 0)
    {
       [LanguageManager saveLanguageByIndex:0];
    }
    else
    {
        [LanguageManager saveLanguageByIndex:1];
    }
    [self reloadRootViewController];
}*/

#pragma mark - API WORK

-(void)APILanguages{
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable)
    {
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
    else
    {
       /* NSDictionary *tmp = [[NSDictionary alloc]initWithObjectsAndKeys:
                             _txtEmail.text,@"email",
                             _txtName.text,@"name",
                             _txtMessage.text,@"message",
                             nil];
        NSError* error;
        NSData* data = [NSJSONSerialization dataWithJSONObject:tmp options:0 error:&error];
        */
        self.view.userInteractionEnabled = NO;
        UserAuth = [NSUserDefaults standardUserDefaults];
        NSString *strAuth = [UserAuth valueForKey:@"UserAuth"];
        
        NSString *strUrl = [NSString stringWithFormat:@"%@",API_LANGUAGE];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]init];
        request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:strUrl]];
        
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
        [request setValue:strAuth forHTTPHeaderField:@"Authorization"];
        [request setHTTPBody:nil];
        
        requestHandler = [[HTTPRequestHandler alloc] initWithRequest:request delegate:self andCallBack:CALL_TYPE_LANGUAGE];
    }
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
    self.view.userInteractionEnabled = YES;
    
    
    NSString *response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *jsonRes = [response JSONValue];
    
    if ([[jsonRes valueForKey:@"message"] isEqualToString:@"Unauthenticated."]) {
        //    [SVProgressHUD dismiss];
        // [isLogin setInteger:0 forKey:@"LoggedIn"];
        //  [isLogin synchronize];
        
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
                                        [self performSegueWithIdentifier:@"OutToLogin" sender:self];
                                    }];
        [alert addAction:yesButton];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
    else  {
        [_delegate parserSuccessDelegateDidFinish:jsonRes andCallType:CALL_TYPE_LANGUAGE];
        NSLog(@"%@",jsonRes);
        NSString *strStatus = [NSString stringWithFormat:@"%@",[jsonRes valueForKey:@"status"]];
        if ([strStatus isEqualToString:@"1"]) {
            arrLanguages = [jsonRes valueForKey:@"data"];
            [_tblLanguage reloadData];
        }
        
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


@end
