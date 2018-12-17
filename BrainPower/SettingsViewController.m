//
//  SettingsViewController.m
//  BrainPower
//
//  Created by nestcode on 1/16/18.
//  Copyright © 2018 nestcode. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController{
    NSUserDefaults *ColorCode;
    NSString *strColor, *strName, *strEmail;
    NSUserDefaults *UserData, *UserAuth;
    NSMutableDictionary *userDictData;
    NSUserDefaults *isLogin, *userLanguage, *Userprofileimg;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ColorCode = [NSUserDefaults standardUserDefaults];
    strColor = [NSString stringWithFormat:@"%@",[ColorCode valueForKey:@"colorcode"]];
    
    isLogin = [NSUserDefaults standardUserDefaults];
    Userprofileimg = [NSUserDefaults standardUserDefaults];
    userLanguage = [NSUserDefaults standardUserDefaults];
    
    NSString *strMessage = NSLocalizedString(@"Message", @"");
    
    _txtMessage.delegate = self;
    _txtMessage.text = strMessage;
    _txtMessage.textColor = [UIColor lightGrayColor];
    
    _txtEmail.delegate = self;
    _txtName.delegate = self;
    
    [self.navigationController.navigationBar setValue:@(YES) forKeyPath:@"hidesShadow"];
    
 /*
    if (IS_IPHONE_X){
        NSUInteger fontSize = 10;
        UIFont *font = [UIFont systemFontOfSize:fontSize];
        NSDictionary *attributes = @{NSFontAttributeName: font};
        
        UIBarButtonItem *item = [[UIBarButtonItem alloc] init];
        
        [item setTitle:@"CONTACT US"];
        [item setTitleTextAttributes:attributes forState:UIControlStateNormal];
        [item setTintColor:[UIColor darkGrayColor]];
        self.navigationItem.rightBarButtonItem = item;
    }*/
    
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    [_imgContact setBackgroundColor:[self colorWithHexString:strColor]];
    [_btnSubmit setBackgroundColor:[self colorWithHexString:strColor]];
    
    _viewName.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _viewName.layer.borderWidth = 1;
    [_txtName setTintColor:[self colorWithHexString:strColor]];
    [_imgName setBackgroundColor:[self colorWithHexString:strColor]];
    
    _viewEmail.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _viewEmail.layer.borderWidth = 1;
    [_txtEmail setTintColor:[self colorWithHexString:strColor]];
    [_imgEmail setBackgroundColor:[self colorWithHexString:strColor]];
    
    _viewMessage.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _viewMessage.layer.borderWidth = 1;
    [_txtMessage setTintColor:[self colorWithHexString:strColor]];
    [_imgMessage setBackgroundColor:[self colorWithHexString:strColor]];
    
    _lblEmail.textColor = [self colorWithHexString:strColor];
    _lbl_Contact.textColor = [self colorWithHexString:strColor];
    _lblAddress.textColor = [self colorWithHexString:strColor];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    userDictData = [[NSMutableDictionary alloc]init];
    
    UserData = [NSUserDefaults standardUserDefaults];
    
    userDictData = [UserData valueForKey:@"UserData"];
    NSLog(@"%@",userDictData);
    
    strEmail = [userDictData valueForKey:@"email"];
    strName = [userDictData valueForKey:@"child_name"];
    
    if ([strName isEqualToString:@""]) {
        
    }
    else{
        _txtName.text = [NSString stringWithFormat:@"%@",strName];
        _txtEmail.userInteractionEnabled = NO;
        _txtName.userInteractionEnabled = NO;
        _txtEmail.text = [NSString stringWithFormat:@"%@",strEmail];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
}

- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    if([_txtMessage.text isEqualToString:@"Message"]){
        _txtMessage.text = @"";
        _txtMessage.textColor = [UIColor blackColor];
    }
    return YES;
}

-(void) textViewDidChange:(UITextView *)textView
{
    
    if(_txtMessage.text.length == 0){
        _txtMessage.textColor = [UIColor lightGrayColor];
        _txtMessage.text = @"Message";
        [_txtMessage resignFirstResponder];
    }
}

#pragma mark - keyboard movements
- (void)keyboardWillShow:(NSNotification *)notification
{
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect f = self.view.frame;
        f.origin.y = -keyboardSize.height;
        [self.view setFrame:CGRectMake(0,-110,self.view.frame.size.width,self.view.frame.size.height)];
    }];
}


-(void)dismissKeyboard {
    
    if(_txtMessage.text.length == 0){
        _txtMessage.textColor = [UIColor lightGrayColor];
        _txtMessage.text = @"Message";
        [_txtMessage resignFirstResponder];
    }
    [_txtName resignFirstResponder];
    [_txtEmail resignFirstResponder];
    [_txtMessage resignFirstResponder];
    [self keyboardWillHide];
}

- (IBAction)dismissKeyboard:(id)sender;
{
    [_txtName resignFirstResponder];
    [_txtEmail resignFirstResponder];
    [_txtMessage resignFirstResponder];
}

-(void)keyboardWillHide
{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect f = self.view.frame;
        f.origin.y = 0.0f;
        [self.view setFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height)];
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    
    [self keyboardWillHide];
    [textField resignFirstResponder];
    return NO;
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


- (IBAction)onSubmitClicked:(id)sender {
    
    NSString *strError1 = NSLocalizedString(@"Enter Details to Continue", @"");
    NSString *strError2 = NSLocalizedString(@"Please Enter Name", @"");
    NSString *strError3 = NSLocalizedString(@"Please Enter Email", @"");
    NSString *strError4 = NSLocalizedString(@"Please Enter Message", @"");
    
    if (_txtName.text.length == 0 || _txtEmail.text.length == 0 || [_txtMessage.text isEqualToString:@"Message"] || [_txtMessage.text isEqualToString:@"संदेश"]) {
        if (_txtMessage.text.length == 0 && _txtName.text.length == 0 && [_txtMessage.text isEqualToString:@"Message"] && [_txtMessage.text isEqualToString:@"संदेश"]) {
            CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
            style.messageColor = [self colorWithHexString:strColor];
            [self.view makeToast:strError1
                        duration:3.0
                        position:CSToastPositionBottom
                           style:style];
            
            [CSToastManager setSharedStyle:style];
            [CSToastManager setTapToDismissEnabled:YES];
            [CSToastManager setQueueEnabled:NO];
        }
        else if (_txtName.text.length == 0) {
            CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
            style.messageColor = [self colorWithHexString:strColor];
            [self.view makeToast:strError2
                        duration:3.0
                        position:CSToastPositionBottom
                           style:style];
            
            [CSToastManager setSharedStyle:style];
            [CSToastManager setTapToDismissEnabled:YES];
            [CSToastManager setQueueEnabled:NO];
        }
        else if (_txtEmail.text.length == 0) {
            CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
            style.messageColor = [self colorWithHexString:strColor];
            [self.view makeToast:strError3
                        duration:3.0
                        position:CSToastPositionBottom
                           style:style];
            
            [CSToastManager setSharedStyle:style];
            [CSToastManager setTapToDismissEnabled:YES];
            [CSToastManager setQueueEnabled:NO];
        }
        else if (_txtMessage.text.length == 0 || [_txtMessage.text isEqualToString:@"Message"]) {
            CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
            style.messageColor = [self colorWithHexString:strColor];
            [self.view makeToast:strError4
                        duration:3.0
                        position:CSToastPositionBottom
                           style:style];
            
            [CSToastManager setSharedStyle:style];
            [CSToastManager setTapToDismissEnabled:YES];
            [CSToastManager setQueueEnabled:NO];
        }
    }
    else{
        [self APIContactUs];
    }
}

-(void)APIContactUs{
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
        NSDictionary *tmp = [[NSDictionary alloc]initWithObjectsAndKeys:
                             _txtEmail.text,@"email",
                             _txtName.text,@"name",
                             _txtMessage.text,@"message",
                             nil];
        NSError* error;
        NSData* data = [NSJSONSerialization dataWithJSONObject:tmp options:0 error:&error];
        
        self.view.userInteractionEnabled = NO;
        UserAuth = [NSUserDefaults standardUserDefaults];
        NSString *strAuth = [UserAuth valueForKey:@"UserAuth"];
        
        NSString *strUrl = [NSString stringWithFormat:@"%@",API_CONTACT];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]init];
        request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:strUrl]];
        
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
        [request setValue:strAuth forHTTPHeaderField:@"Authorization"];
        [request setHTTPBody:data];
        
        requestHandler = [[HTTPRequestHandler alloc] initWithRequest:request delegate:self andCallBack:CALL_TYPE_CONTACT];
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
            [_delegate parserSuccessDelegateDidFinish:jsonRes andCallType:CALL_TYPE_CONTACT];
            NSLog(@"%@",jsonRes);
        CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
        style.messageColor = [self colorWithHexString:strColor];
        [self.view makeToast:[jsonRes valueForKey:@"message"]
                    duration:3.0
                    position:CSToastPositionBottom
                       style:style];
        
        [CSToastManager setSharedStyle:style];
        [CSToastManager setTapToDismissEnabled:YES];
        [CSToastManager setQueueEnabled:NO];
        _txtMessage.text = @"";
    }
}

@end

