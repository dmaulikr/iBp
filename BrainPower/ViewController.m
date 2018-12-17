//
//  ViewController.m
//  BrainPower
//
//  Created by nestcode on 1/2/18.
//  Copyright © 2018 nestcode. All rights reserved.
//

#import "ViewController.h"

#define kMiddleSize CGSizeMake(40, 40)
@interface ViewController ()

@end

@implementation ViewController{
    int pageCounter, isRegistered, flagPassword;
    CATransition *transition;
    NSString *strMobile, *strOTP, *strPassword, *strCallType, *strIsRegistered;
    NSString *statusCode;
    NSUserDefaults *isLogin;
    NSString *strForgotMobile, *strForgotOTP, *strForgotPass;
    UIView *viewLoader;
    UIImageView *img;
    DGActivityIndicatorView *activityIndicatorView;
    NSString *strAuth;
    NSTimer *timer;
    NSUserDefaults *ColorCode;
    NSString *strColor;
    NSUserDefaults *userFirstTime;
    NSUserDefaults *Userprofileimg;
    NSUserDefaults *userLanguage;
    NSString *strLang;
    NSString *strMob;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _lblTime.text = @"59";
    
    [self APIGetCountries];
    
    ColorCode = [NSUserDefaults standardUserDefaults];
    strColor = [NSString stringWithFormat:@"%@",[ColorCode valueForKey:@"colorcode"]];
     userFirstTime = [NSUserDefaults standardUserDefaults];
    
    userLanguage = [NSUserDefaults standardUserDefaults];
    strLang = [userLanguage valueForKey:@"AppleLanguages"];
    
    Userprofileimg = [NSUserDefaults standardUserDefaults];
    
    [_btnPassVisible setImage:[UIImage imageNamed:@"showPassword.png"] forState:UIControlStateNormal];
    
    [_btnPassVisible setImage:[UIImage imageNamed:@"hidePassword.png"] forState:UIControlStateSelected];
    
    _btnNext.titleLabel.text = @"NEXT";
    pageCounter = 0;
    isRegistered = 0;
    _pageController.numberOfPages = 3;
    _pageController.currentPage = 0;
    transition = nil;
    
    [self viewPages];
    [self hideView];
    _viewSlider1.hidden = NO;
    _btnBack.hidden = YES;
    
    _view1.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _view1.layer.borderWidth = 1;
    
    
    [_txtMobileNo setTintColor:[self colorWithHexString:strColor]];
    [_txtPassWord setTintColor:[self colorWithHexString:strColor]];
    [_txtOTP setTintColor:[self colorWithHexString:strColor]];
    
    [_imgPhone setBackgroundColor:[self colorWithHexString:strColor]];
    [_imgPass setBackgroundColor:[self colorWithHexString:strColor]];
    [_imgPass1 setBackgroundColor:[self colorWithHexString:strColor]];
    [_imgPass2 setBackgroundColor:[self colorWithHexString:strColor]];
    
    _view2.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _view2.layer.borderWidth = 1;
    
    _view3.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _view3.layer.borderWidth = 1;
    
    _view4.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _view4.layer.borderWidth = 1;
    _view5.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _view5.layer.borderWidth = 1;
    _view6.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _view6.layer.borderWidth = 1;
    
    _pageController.currentPageIndicatorTintColor = [self colorWithHexString:strColor];
    
    _txtOTP.delegate = self;
    _txtPassWord.delegate = self;
    _txtMobileNo.delegate = self;
    _txtCheckPassword.delegate = self;
    _txtPassWord.delegate = self;
    _txtConfirmPass.delegate = self;
    
    self.referView.keyboardType = UIKeyboardTypeNumberPad;
    self.referView.textFont = [UIFont fontWithName:@"SFUIText-Regular" size:16.0f];
    self.referView.placeholderFont = [UIFont fontWithName:@"SFUIText-Regular" size:16.0f];
    // self.referView.accessoryView = button;
    self.referView.accessoryViewMode = LUNAccessoryViewModeAlways;
    self.referView.placeholderText = @"Referral Number";
    self.referView.placeholderAlignment = LUNPlaceholderAlignmentLeft;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    
}

-(void)dismissKeyboard {
    [_txtMobileNo resignFirstResponder];
    [_txtOTP resignFirstResponder];
    [_txtPassWord resignFirstResponder];
    [_txtConfirmPass resignFirstResponder];
    [_txtCheckPassword resignFirstResponder];
    [self keyboardWillHide];
}

- (IBAction)dismissKeyboard:(id)sender;
{
    [_txtMobileNo resignFirstResponder];
    [_txtOTP resignFirstResponder];
    [_txtPassWord resignFirstResponder];
    [_txtConfirmPass resignFirstResponder];
    [_txtCheckPassword resignFirstResponder];
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
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    int allowedLength;
    switch(textField.tag) {
        case 1:
            allowedLength = 10;      // triggered for input fields with tag = 1
            break;
        case 2:
            allowedLength = 12;   // triggered for input fields with tag = 2
            break;
        default:
            allowedLength = 12;   // length default when no tag (=0) value =255
            break;
    }
    
    if (textField.text.length >= allowedLength && range.length == 0) {
        return NO; // Change not allowed
    } else {
        return YES; // Change allowed
    }
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


-(void)ShowActivityIndicator{
    NSArray *activityTypes = @[@(DGActivityIndicatorAnimationTypeBallClipRotateMultiple)];
    
    viewLoader = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [viewLoader setBackgroundColor:[UIColor clearColor]];
    
    img = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, viewLoader.frame.size.width, viewLoader.frame.size.height)];
    [img setBackgroundColor:[UIColor whiteColor]];
    img.alpha = 0.65;
   
    self.view.userInteractionEnabled = NO;
    
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
    self.view.userInteractionEnabled = YES;
    
    [activityIndicatorView stopAnimating];
    [activityIndicatorView removeFromSuperview];
    
}


// Swipe View [ Left & Right Side ]
-(void)viewPages
{
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeLeft];
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeRight];
}

// Swipe direction To Swipe
- (void)handleSwipe:(UISwipeGestureRecognizer *)swipe
{
    if (swipe.direction == UISwipeGestureRecognizerDirectionLeft)
    {
        if (pageCounter == 0) {
            NSString *numberRegEx = @"[0-9]{10}";
            NSPredicate *numberTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numberRegEx];
            if ([numberTest evaluateWithObject:self.txtMobileNo.text] == YES)
            {
                strMobile = [NSString stringWithFormat:@"%@",_txtMobileNo.text];
                [self APIMobile];
                
                //Code for Response
                
            }
            else
            {
                CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
                style.messageColor = [UIColor orangeColor];
                [self.view makeToast:@"Invalid Mobile Number"
                            duration:3.0
                            position:CSToastPositionBottom
                               style:style];
                
                [CSToastManager setSharedStyle:style];
                [CSToastManager setTapToDismissEnabled:YES];
                [CSToastManager setQueueEnabled:NO];
            }
        }
        else if (pageCounter == 1) {
            if ([_txtOTP.text isEqualToString:@""]) {
                CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
                style.messageColor = [UIColor orangeColor];
                [self.view makeToast:@"Please Enter OTP First"
                            duration:3.0
                            position:CSToastPositionBottom
                               style:style];
                
                [CSToastManager setSharedStyle:style];
                [CSToastManager setTapToDismissEnabled:YES];
                [CSToastManager setQueueEnabled:NO];
            }
            else if ([_txtOTP.text length]<4){
                CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
                style.messageColor = [UIColor orangeColor];
                [self.view makeToast:@"OTP Should be 4 Digits"
                            duration:3.0
                            position:CSToastPositionBottom
                               style:style];
                
                [CSToastManager setSharedStyle:style];
                [CSToastManager setTapToDismissEnabled:YES];
                [CSToastManager setQueueEnabled:NO];
            }
            else{
                strOTP = [NSString stringWithFormat:@"%@",_txtOTP.text];
                [self APIVerifyOTP];
            }
            
            ////Code for Response - Login or Register
            
        }
        else if (pageCounter == 2){
            if (flagPassword == 0) {
                if ([_txtConfirmPass.text isEqualToString:_txtPassWord.text]) {
                    strPassword = [NSString stringWithFormat:@"%@",_txtConfirmPass.text];
                    [self apiRegister];
                }
                else{
                    CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
                    style.messageColor = [UIColor orangeColor];
                    [self.view makeToast:@"Password not matched!!"
                                duration:3.0
                                position:CSToastPositionBottom
                                   style:style];
                    
                    [CSToastManager setSharedStyle:style];
                    [CSToastManager setTapToDismissEnabled:YES];
                    [CSToastManager setQueueEnabled:NO];
                }
            }
            else if (flagPassword == 1) {
                if (_txtCheckPassword.text.length == 0) {
                    CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
                    style.messageColor = [UIColor orangeColor];
                    [self.view makeToast:@"Enter Password"
                                duration:3.0
                                position:CSToastPositionBottom
                                   style:style];
                    
                    [CSToastManager setSharedStyle:style];
                    [CSToastManager setTapToDismissEnabled:YES];
                    [CSToastManager setQueueEnabled:NO];
                }
                else{
                    strPassword = [NSString stringWithFormat:@"%@",_txtCheckPassword.text];
                    [self apiRegister];
                }
            }
            
        }
        else if (pageCounter == 3) {
            
        }
    }
    else if (swipe.direction == UISwipeGestureRecognizerDirectionRight)
    {
        [timer invalidate];
        _btnNext.hidden = NO;
        if (pageCounter ==0)
        {
            _btnBack.hidden = YES;
            pageCounter =0;
        }
        else if (pageCounter == 3){
            _btnBack.hidden = YES;
        }
        else
        {
            if (flagPassword == 0) {
                pageCounter -=1;
                _pageController.currentPage = pageCounter;
                transition = [CATransition animation];
                transition.duration = 0.9;//kAnimationDuration
                transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                transition.type = kCATransitionPush;
                transition.subtype =kCATransitionFromLeft;
                transition.delegate = self;
                
                [_viewSlider1.layer addAnimation:transition forKey:nil];
                [_viewSlider2.layer addAnimation:transition forKey:nil];
                [_viewSlider3.layer addAnimation:transition forKey:nil];
                [_viewSliderPass.layer addAnimation:transition forKey:nil];
            }
            else{
                pageCounter -=2;
                _pageController.currentPage = pageCounter;
                transition = [CATransition animation];
                transition.duration = 0.9;//kAnimationDuration
                transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                transition.type = kCATransitionPush;
                transition.subtype =kCATransitionFromLeft;
                transition.delegate = self;
                
                [_viewSlider1.layer addAnimation:transition forKey:nil];
                [_viewSlider2.layer addAnimation:transition forKey:nil];
                [_viewSlider3.layer addAnimation:transition forKey:nil];
                [_viewSliderPass.layer addAnimation:transition forKey:nil];
                flagPassword = 0;
            }
            
        }
        [self pagination:pageCounter];
    }
    
}


-(void)hideView{
    _viewSlider1.hidden = YES;
    _viewSlider2.hidden = YES;
    _viewSlider3.hidden = YES;
    _viewSliderPass.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pagination:(int)count{
    switch (count) {
        case 0:
            [self hideView];
            _viewSlider1.hidden = NO;
            break;
        case 1:
            [self hideView];
            _viewSlider2.hidden = NO;
            _lblTime.text = @"59";
            currSeconds = 59;
            _lblTime.hidden = NO;
            break;
        case 2:
            [self hideView];
            _viewSliderPass.hidden = NO;
            break;
        case 3:
            [self hideView];
            _viewSlider3.hidden = NO;
        default:
            break;
    }
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

-(void)APIGetCountries{
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable)
    {
        [self CheckConnection];
    }
    else
    {
         [self ShowActivityIndicator];
        
        self.view.userInteractionEnabled = NO;
        NSString *strUrl = [NSString stringWithFormat:@"%@",API_GETCOUNTRY];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]init];
        request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:strUrl]];
        
        [request setHTTPMethod:@"GET"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
        //   [request setValue:strUserToken forHTTPHeaderField:@"Authorization"];
        [request setHTTPBody:nil];
        
        requestHandler = [[HTTPRequestHandler alloc] initWithRequest:request delegate:self andCallBack:CALL_TYPE_GETCOUNTRY];
        strCallType = @"country";
    }
}

-(void)APIMobile{
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable)
    {
        [self CheckConnection];
    }
    else
    {
        strMob = [NSString stringWithFormat:@"%@%@",_lblCountryCode.text,strMobile];
        NSDictionary *tmp = [[NSDictionary alloc] initWithObjectsAndKeys:
                             strMob, @"mobile_no",
                             nil];
        NSError* error;
        NSData* data = [NSJSONSerialization dataWithJSONObject:tmp options:0 error:&error];
        
        // [SVProgressHUD show];
        
        self.view.userInteractionEnabled = NO;
        NSString *strUrl = [NSString stringWithFormat:@"%@",API_REGISTER];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]init];
        request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:strUrl]];
        
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
        //   [request setValue:strUserToken forHTTPHeaderField:@"Authorization"];
        [request setHTTPBody:data];
        
        requestHandler = [[HTTPRequestHandler alloc] initWithRequest:request delegate:self andCallBack:CALL_TYPE_REGISTER];
        strCallType = @"mobile";
    }
}

-(void)APIVerifyOTP{
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable)
    {
        [self CheckConnection];
    }
    else
    {
        NSString *strMob1 = [NSString stringWithFormat:@"%@%@",_lblCountryCode.text,strMobile];
        NSDictionary *tmp = [[NSDictionary alloc] initWithObjectsAndKeys:
                             strMob1, @"mobile_no",
                             strOTP,@"otp",
                             nil];
        NSError* error;
        NSData* data = [NSJSONSerialization dataWithJSONObject:tmp options:0 error:&error];
        
        [self ShowActivityIndicator];
        
        self.view.userInteractionEnabled = NO;
        NSString *strUrl = [NSString stringWithFormat:@"%@",API_REGISTER];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]init];
        request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:strUrl]];
        
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:data];
        
        requestHandler = [[HTTPRequestHandler alloc] initWithRequest:request delegate:self andCallBack:CALL_TYPE_REGISTER];
        strCallType = @"mobile";
    }
}

-(void)apiRegister{
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable)
    {
        [self CheckConnection];
    }
    else
    {
        NSString *strMob = [NSString stringWithFormat:@"%@%@",_lblCountryCode.text,strMobile];
        NSDictionary *tmp;
        if (flagPassword == 0) {
            tmp  = [[NSDictionary alloc] initWithObjectsAndKeys:
                    strMob, @"mobile_no",
                    strOTP, @"otp",
                    strPassword, @"password",
                    nil];
        }
        else{
            tmp  = [[NSDictionary alloc] initWithObjectsAndKeys:
                    strMob, @"mobile_no",
                    strPassword, @"password",
                    nil];
        }
      
        NSError* error;
        NSData* data = [NSJSONSerialization dataWithJSONObject:tmp options:0 error:&error];
        
        [self ShowActivityIndicator];
        
        self.view.userInteractionEnabled = NO;
        NSString *strUrl = [NSString stringWithFormat:@"%@",API_REGISTER];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]init];
        request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:strUrl]];
        
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:data];
        
        requestHandler = [[HTTPRequestHandler alloc] initWithRequest:request delegate:self andCallBack:CALL_TYPE_REGISTER];
        strCallType = @"mobile";
    }
}

-(void)APIForgotPass{
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable)
    {
        [self CheckConnection];
    }
    else
    {
     //   NSString *strMob = [NSString stringWithFormat:@"%@%@",_lblCountryCode.text,strForgotMobile];
        NSDictionary *tmp = [[NSDictionary alloc] initWithObjectsAndKeys:
                             strMob, @"mobile_no",
                             nil];
        NSError* error;
        NSData* data = [NSJSONSerialization dataWithJSONObject:tmp options:0 error:&error];
        
        [self ShowActivityIndicator];
        
        self.view.userInteractionEnabled = NO;
        NSString *strUrl = [NSString stringWithFormat:@"%@",API_FORGOT_PASS];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]init];
        request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:strUrl]];
        
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:data];
        
        requestHandler = [[HTTPRequestHandler alloc] initWithRequest:request delegate:self andCallBack:CALL_TYPE_FORGOT_PASS];
        strCallType = @"ForgotMobile";
    }
}

-(void)APIForgotPassOTP{
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable)
    {
        [self CheckConnection];
    }
    else
    {
        NSString *strMob = [NSString stringWithFormat:@"%@%@",_lblCountryCode.text,strForgotMobile];
        NSDictionary *tmp = [[NSDictionary alloc] initWithObjectsAndKeys:
                             strMob, @"mobile_no",
                             strForgotOTP,@"otp",
                             nil];
        NSError* error;
        NSData* data = [NSJSONSerialization dataWithJSONObject:tmp options:0 error:&error];
        
        [self ShowActivityIndicator];
        
        self.view.userInteractionEnabled = NO;
        NSString *strUrl = [NSString stringWithFormat:@"%@",API_FORGOT_PASS];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]init];
        request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:strUrl]];
        
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:data];
        
        requestHandler = [[HTTPRequestHandler alloc] initWithRequest:request delegate:self andCallBack:CALL_TYPE_FORGOT_PASS];
        strCallType = @"ForgotOtp";
    }
}

-(void)APISetNewPass{
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable)
    {
        [self CheckConnection];
    }
    else
    {
        NSString *strMob = [NSString stringWithFormat:@"%@%@",_lblCountryCode.text,strForgotMobile];
        NSDictionary *tmp = [[NSDictionary alloc] initWithObjectsAndKeys:
                             strMob, @"mobile_no",
                             strForgotOTP,@"otp",
                             strForgotPass,@"password",
                             nil];
        NSError* error;
        NSData* data = [NSJSONSerialization dataWithJSONObject:tmp options:0 error:&error];
        
        [self ShowActivityIndicator];
        
        self.view.userInteractionEnabled = NO;
        NSString *strUrl = [NSString stringWithFormat:@"%@",API_FORGOT_PASS];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]init];
        request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:strUrl]];
        
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:data];
        
        requestHandler = [[HTTPRequestHandler alloc] initWithRequest:request delegate:self andCallBack:CALL_TYPE_FORGOT_PASS];
        strCallType = @"newpass";
    }
}

-(void)APIStoreDevice{
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable)
    {
        [self CheckConnection];
    }
    else
    {
       // NSArray *versionArray = [[UIDevice currentDevice] systemVersion]; //Keeping Calm In a Crisis Makes All The Difference
        
        NSString *ver = [[UIDevice currentDevice] systemVersion];
        
        NSString *strOS = [NSString stringWithFormat:@"%@",ver];
        NSString *strIOS = @"iOS";
        NSString *strVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
     //   NSUUID *myDevice = [NSUUID UUID];
        NSString *strdeviceUDID = [[[UIDevice currentDevice] identifierForVendor] UUIDString]; //myDevice.UUIDString;
        
        NSDictionary *tmp = [[NSDictionary alloc] initWithObjectsAndKeys:
                             strIOS, @"os",
                             strOS,@"os_version",
                             strVersion,@"app_version",
                             strdeviceUDID,@"unique_id",
                             nil];
        NSError* error;
        NSData* data = [NSJSONSerialization dataWithJSONObject:tmp options:0 error:&error];
        
        [self ShowActivityIndicator];
        
        self.view.userInteractionEnabled = NO;
        NSString *strUrl = [NSString stringWithFormat:@"%@",API_STORE_DEVICE];
        NSMutableURLRequest *request1 = [[NSMutableURLRequest alloc]init];
        request1 = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:strUrl]];
        
        [request1 setHTTPMethod:@"POST"];
        [request1 setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request1 setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
        [request1 setValue:strAuth forHTTPHeaderField:@"Authorization"];
        [request1 setHTTPBody:data];
        
        requestHandler1 = [[HTTPRequestHandler alloc] initWithRequest:request1 delegate:self];
        strCallType = @"device";
    }
    
}

-(void)APIResendOTP{
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable)
    {
        [self CheckConnection];
    }
    else
    {
        NSString *strMob = [NSString stringWithFormat:@"%@%@",_lblCountryCode.text,strMobile];
        NSDictionary *tmp = [[NSDictionary alloc] initWithObjectsAndKeys:
                             strMob, @"mobile_no",
                             nil];
        NSError* error;
        NSData* data = [NSJSONSerialization dataWithJSONObject:tmp options:0 error:&error];
        
        [self ShowActivityIndicator];
        
        self.view.userInteractionEnabled = NO;
        NSString *strUrl = [NSString stringWithFormat:@"%@",API_REGISTER];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]init];
        request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:strUrl]];
        
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:data];
        
        requestHandler = [[HTTPRequestHandler alloc] initWithRequest:request delegate:self andCallBack:CALL_TYPE_REGISTER];
        strCallType = @"otp";
    }
}

- (IBAction)onNextClicked:(id)sender {
    
    if (pageCounter == 0) {
        strMobile = [NSString stringWithFormat:@"%@",_txtMobileNo.text];
        [self APIMobile];
      /*  NSString *numberRegEx = @"[0-9]{10}";
        NSPredicate *numberTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numberRegEx];
        if ([numberTest evaluateWithObject:self.txtMobileNo.text] == YES)
        {
            strMobile = [NSString stringWithFormat:@"%@",_txtMobileNo.text];
            [self APIMobile];
            
            //Code for Response
            
        }
        else
        {
            CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
            style.messageColor = [UIColor orangeColor];
            [self.view makeToast:@"Invalid Mobile Number"
                        duration:3.0
                        position:CSToastPositionBottom
                           style:style];
            
            [CSToastManager setSharedStyle:style];
            [CSToastManager setTapToDismissEnabled:YES];
            [CSToastManager setQueueEnabled:NO];
        }*/
    }
    else if (pageCounter == 1) {
        if ([_txtOTP.text isEqualToString:@""]) {
            CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
            style.messageColor = [UIColor orangeColor];
            [self.view makeToast:@"Please Enter OTP First"
                        duration:3.0
                        position:CSToastPositionBottom
                           style:style];
            
            [CSToastManager setSharedStyle:style];
            [CSToastManager setTapToDismissEnabled:YES];
            [CSToastManager setQueueEnabled:NO];
        }
        else if ([_txtOTP.text length]<4){
            CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
            style.messageColor = [UIColor orangeColor];
            [self.view makeToast:@"OTP Should be 4 Digits"
                        duration:3.0
                        position:CSToastPositionBottom
                           style:style];
            
            [CSToastManager setSharedStyle:style];
            [CSToastManager setTapToDismissEnabled:YES];
            [CSToastManager setQueueEnabled:NO];
        }
        else{
            strOTP = [NSString stringWithFormat:@"%@",_txtOTP.text];
            [self APIVerifyOTP];
        }
        
        ////Code for Response - Login or Register
        
    }
    else if (pageCounter == 2){
        if (flagPassword == 0) {
            if ([_txtConfirmPass.text isEqualToString:_txtPassWord.text]) {
                strPassword = [NSString stringWithFormat:@"%@",_txtConfirmPass.text];
                [self apiRegister];
            }
            else{
                CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
                style.messageColor = [UIColor orangeColor];
                [self.view makeToast:@"Password not matched!!"
                            duration:3.0
                            position:CSToastPositionBottom
                               style:style];
                
                [CSToastManager setSharedStyle:style];
                [CSToastManager setTapToDismissEnabled:YES];
                [CSToastManager setQueueEnabled:NO];
            }
        }
        else if (flagPassword == 1) {
            if (_txtCheckPassword.text.length == 0) {
                CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
                style.messageColor = [UIColor orangeColor];
                [self.view makeToast:@"Enter Password"
                            duration:3.0
                            position:CSToastPositionBottom
                               style:style];
                
                [CSToastManager setSharedStyle:style];
                [CSToastManager setTapToDismissEnabled:YES];
                [CSToastManager setQueueEnabled:NO];
            }
            else{
                strPassword = [NSString stringWithFormat:@"%@",_txtCheckPassword.text];
                [self apiRegister];
            }
        }
        
    }
    else if (pageCounter == 3) {
        
    }
}

- (IBAction)onBackClicked:(id)sender {
    [timer invalidate];
    _btnNext.hidden = NO;
    if (pageCounter ==0)
    {
        _btnBack.hidden = YES;
        pageCounter =0;
    }
    else if (pageCounter == 3){
        _btnBack.hidden = YES;
    }
    else
    {
        if (flagPassword == 0) {
            pageCounter -=1;
            _pageController.currentPage = pageCounter;
            transition = [CATransition animation];
            transition.duration = 0.9;//kAnimationDuration
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            transition.type = kCATransitionPush;
            transition.subtype =kCATransitionFromLeft;
            transition.delegate = self;
            
            [_viewSlider1.layer addAnimation:transition forKey:nil];
            [_viewSlider2.layer addAnimation:transition forKey:nil];
            [_viewSlider3.layer addAnimation:transition forKey:nil];
            [_viewSliderPass.layer addAnimation:transition forKey:nil];
        }
        else{
            pageCounter -=2;
            _pageController.currentPage = pageCounter;
            transition = [CATransition animation];
            transition.duration = 0.9;//kAnimationDuration
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            transition.type = kCATransitionPush;
            transition.subtype =kCATransitionFromLeft;
            transition.delegate = self;
            
            [_viewSlider1.layer addAnimation:transition forKey:nil];
            [_viewSlider2.layer addAnimation:transition forKey:nil];
            [_viewSlider3.layer addAnimation:transition forKey:nil];
            [_viewSliderPass.layer addAnimation:transition forKey:nil];
            flagPassword = 0;
        }
        
    }
    [self pagination:pageCounter];
}

- (IBAction)onResendOTPClicked:(id)sender {
    [self APIResendOTP];
}

- (IBAction)onForgotPassClicked:(id)sender {
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    alert.customViewColor = [self colorWithHexString:strColor];
    SCLTextView *textField = [alert addTextField:@"Enter your Mobile No."];
    textField.keyboardType = UIKeyboardTypeNumberPad;
    textField.text = strMob;
    textField.userInteractionEnabled = NO;
    [alert addButton:@"OK" actionBlock:^(void) {
        NSLog(@"Text value: %@", textField.text);
        strForgotMobile = [NSString stringWithFormat:@"%@",textField.text];
        [self APIForgotPass];
    }];
    
    [alert showEdit:self title:@"Mobile No." subTitle:nil closeButtonTitle:@"CLOSE" duration:0.0f];
}


- (IBAction)onTnCclicked:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:[Global getStoryBoardName] bundle:nil];
    PoliciesViewController *policyVC = (PoliciesViewController *)[storyboard instantiateViewControllerWithIdentifier:@"PoliciesViewController"];
    policyVC.strTypeOfPolicy = @"1";
    [self presentViewController:policyVC animated:YES completion:nil];
}

- (IBAction)onPrivacyPolicyClicked:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:[Global getStoryBoardName] bundle:nil];
    PoliciesViewController *policyVC = (PoliciesViewController *)[storyboard instantiateViewControllerWithIdentifier:@"PoliciesViewController"];
    policyVC.strTypeOfPolicy = @"2";
    [self presentViewController:policyVC animated:YES completion:nil];
}

-(void)NEWPASS{
    
    NSString *strNewPass = NSLocalizedString(@"Enter New Password", @"");
    NSString *strConfirmNewPass = NSLocalizedString(@"Enter Confirm Password", @"");
    NSString *strTitle = NSLocalizedString(@"Set New Password", @"");
    
    NSString *strError1 = NSLocalizedString(@"Please Enter New Password", @"");
    NSString *strError2 = NSLocalizedString(@"Please Enter Confirm Password", @"");
    NSString *strError3 = NSLocalizedString(@"Confirm Password not Matched!!", @"");
    
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    alert.customViewColor = [self colorWithHexString:strColor];
    SCLTextView *txtNewPass = [alert addTextField:strNewPass];
    txtNewPass.keyboardType = UIKeyboardTypeDefault;
    txtNewPass.secureTextEntry = YES;
    
    SCLTextView *txtConfirmPass = [alert addTextField:strConfirmNewPass];
    txtConfirmPass.keyboardType = UIKeyboardTypeDefault;
    txtConfirmPass.secureTextEntry = YES;
    
    [alert addButton:@"Confirm" validationBlock:^BOOL{
        if (txtNewPass.text.length == 0)
        {
            [[[UIAlertView alloc] initWithTitle:@"Whoops!" message:strError1 delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            [txtNewPass becomeFirstResponder];
            return NO;
        }
        
       else if (txtConfirmPass.text.length == 0)
        {
            [[[UIAlertView alloc] initWithTitle:@"Whoops!" message:strError2 delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            [txtConfirmPass becomeFirstResponder];
            return NO;
        }
       
       else if (![txtConfirmPass.text isEqualToString:txtNewPass.text]) {
            [[[UIAlertView alloc] initWithTitle:@"Whoops!" message:strError3 delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            [txtConfirmPass becomeFirstResponder];
            return NO;
        }
       else{
           strForgotPass = [NSString stringWithFormat:@"%@",txtConfirmPass.text];
           return YES;
       }
        
    } actionBlock:^{
        [self APISetNewPass];
    }];
    
    [alert showEdit:self title:strTitle subTitle:nil closeButtonTitle:@"Cancel" duration:0];
}

-(void)TimerStart:(int )time
{ currSeconds = 60;
    self.otpCountdown.delegate = self;
    self.otpCountdown.totalTime = time;
    self.otpCountdown.active = YES;
    self.otpCountdown.elapsedTime = 0;
    [self.otpCountdown start];
    timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
    _btnResendOTP.enabled = NO;
    
}

- (void)updateCircle:(NSTimer *)theTimer
{
    if (theTimer == 00) {
       // [_otpCountdown stop];
    }
}

-(void)timerFired
{
    _lblTime.text = [NSString stringWithFormat:@"%d",currSeconds];
    
    if(currSeconds>0)
    {
        if(currSeconds==0)
        {
            currSeconds=59;
        }
        else if(currSeconds>0)
        {
            currSeconds-=1;
        }
        
        if (currSeconds == 00) {
            _btnResendOTP.enabled = YES;
            _lblTime.hidden = YES;
        }
    }
    else
    {
        [timer invalidate];
        timer = nil;
    }
}


#pragma mark - API HANDLER

- (void)parserDidFailWithError:(NSError *)error andCallType:(CallTypeEnum)callType{
    NSLog(@"%s : Error : %@",__FUNCTION__, [error localizedDescription]);
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
    self.view.userInteractionEnabled = YES;
    
    self.navigationItem.hidesBackButton = NO;
    
    NSString *response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *jsonRes = [response JSONValue];
    NSLog(@"%@",jsonRes);
    
    if ([[jsonRes valueForKey:@"message"] isEqualToString:@"Unauthenticated."]) {

        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@"Error"
                                     message:[jsonRes valueForKey:@"message"]
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"OK"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {
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
        
        if ([strCallType isEqualToString:@"country"]) {
            [_delegate parserSuccessDelegateDidFinish:jsonRes andCallType:CALL_TYPE_REGISTER];
            NSLog(@"%@",jsonRes);
            
            NSString *status = [NSString stringWithFormat:@"%@",[jsonRes valueForKey:@"status"]];
            NSLog(@"%@",status);
            if ([status isEqualToString:@"1"]) {
                NSUserDefaults *userCountry = [NSUserDefaults standardUserDefaults];
                [userCountry setObject:[jsonRes valueForKey:@"data"] forKey:@"userCountry"];
                [userCountry synchronize];
                [self updateViewsWithCountryDic:[PCCPViewController infoFromSimCardAndiOSSettings]];
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
        
        else if ([strCallType isEqualToString:@"mobile"]) {
            [_delegate parserSuccessDelegateDidFinish:jsonRes andCallType:CALL_TYPE_REGISTER];
            NSLog(@"%@",jsonRes);
            
            NSString *status = [NSString stringWithFormat:@"%@",[jsonRes valueForKey:@"status"]];
            NSLog(@"%@",status);
            if ([status isEqualToString:@"1"]) {
                pageCounter +=1;
                flagPassword = 0;
                currSeconds = 60;
                [self TimerStart:currSeconds];
                
                statusCode = [NSString stringWithFormat:@"%@",[jsonRes valueForKey:@"statusCode"]];
                if ([statusCode isEqualToString:@"524"]) {
                    pageCounter = 2;
                    flagPassword = 1;
                    _viewCheckPass.hidden = NO;
                    _viewPass.hidden = YES;
                }
                if ([statusCode isEqualToString:@"525"]) {
                    
                    _viewSliderPass.hidden = YES;
                    [userFirstTime setInteger:0 forKey:@"userFirstTime"];
                    [userFirstTime synchronize];
                    
                }
                else if ([statusCode isEqualToString:@"528"]) {
                    _viewCheckPass.hidden = YES;
                    _viewPass.hidden = NO;
                    [userFirstTime setInteger:1 forKey:@"userFirstTime"];
                    [userFirstTime synchronize];
                }
                else if([statusCode isEqualToString:@"527"]){
                    //pageCounter = 4;
                    
                    _viewCheckPass.hidden = YES;
                    _viewPass.hidden = YES;
                    
                    NSMutableDictionary *UserDictData = [[NSMutableDictionary  alloc] init];
                    UserDictData = [jsonRes valueForKey:@"data"];
                    NSUserDefaults *UserData = [NSUserDefaults standardUserDefaults];
                    [UserData setObject:UserDictData forKey:@"UserData"];
                    [UserData synchronize];
                    
                    strAuth = [NSString stringWithFormat:@"Bearer %@",[[UserDictData valueForKey:@"tokenData"] valueForKey:@"access_token"] ];
                    NSUserDefaults *UserAuth = [NSUserDefaults standardUserDefaults];
                    [UserAuth setValue:strAuth forKey:@"UserAuth"];
                    [UserAuth synchronize];
                    
                    NSUserDefaults *UserHideShow = [NSUserDefaults standardUserDefaults];
                    NSUserDefaults *UserPaymentURL = [NSUserDefaults standardUserDefaults];
                    NSString *strHideShow = [NSString stringWithFormat:@"%@",[UserDictData valueForKey:@"is_paid"]];
                    NSString *strURL = [NSString stringWithFormat:@"%@",[UserDictData valueForKey:@"web_url"]];
                    
                    [UserHideShow setValue:strHideShow forKey:@"HideShow"];
                    [UserHideShow synchronize];
                    
                    [UserPaymentURL setValue:strURL forKey:@"PaymentURL"];
                    [UserPaymentURL synchronize];
                    
                    NSString *str_image = [NSString stringWithFormat:@"%@",[UserDictData valueForKey:@"user_image"]];
                    
                    [Userprofileimg setObject:str_image forKey:@"user_profile_image"];
                    [Userprofileimg synchronize];
                    
                    isLogin = [NSUserDefaults standardUserDefaults];
                    [isLogin setInteger:1 forKey:@"LoggedIn"];
                    [isLogin synchronize];
                    _btnBack.hidden = YES;
                    
                    [self APIStoreDevice];
                }
                if (pageCounter==2)
                {
                    pageCounter = 2;
                }
                else
                {
                    _pageController.currentPage = pageCounter;
                    transition = [CATransition animation];
                    transition.duration = 1.0;//kAnimationDuration
                    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                    transition.type = kCATransitionPush;
                    transition.subtype =kCATransitionFromRight;
                    transition.delegate = self;
                    [_viewSlider1.layer addAnimation:transition forKey:nil];
                    [_viewSlider2.layer addAnimation:transition forKey:nil];
                    [_viewSlider3.layer addAnimation:transition forKey:nil];
                    [_viewSliderPass.layer addAnimation:transition forKey:nil];
                    _btnBack.hidden = NO;
                }
                _btnBack.hidden = NO;
                [self pagination:pageCounter];
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
        else if ([strCallType isEqualToString:@"otp"]){
            [_delegate parserSuccessDelegateDidFinish:jsonRes andCallType:CALL_TYPE_REGISTER];
            NSLog(@"%@",jsonRes);
            NSString *status = [NSString stringWithFormat:@"%@",[jsonRes valueForKey:@"status"]];
            NSLog(@"%@",status);
            if ([status isEqualToString:@"1"]) {
                currSeconds = 60;
                [self TimerStart:currSeconds];
                _lblTime.hidden = NO;
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
        else if ([strCallType isEqualToString:@"ForgotMobile"]){
            [_delegate parserSuccessDelegateDidFinish:jsonRes andCallType:CALL_TYPE_FORGOT_PASS];
            NSLog(@"%@",jsonRes);
            NSString *status = [NSString stringWithFormat:@"%@",[jsonRes valueForKey:@"status"]];
            NSLog(@"%@",status);
            if ([status isEqualToString:@"1"]) {
                SCLAlertView *alert = [[SCLAlertView alloc] init];
                alert.customViewColor = [self colorWithHexString:strColor];
                SCLTextView *textField = [alert addTextField:@"Enter OTP."];
                textField.keyboardType = UIKeyboardTypeNumberPad;
                [alert addButton:@"OK" actionBlock:^(void) {
                    NSLog(@"Text value: %@", textField.text);
                    strForgotOTP = [NSString stringWithFormat:@"%@",textField.text];
                    [self APIForgotPassOTP];
                }];
                
                [alert showEdit:self title:@"OTP" subTitle:nil closeButtonTitle:@"CLOSE" duration:0.0f];
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
        else if ([strCallType isEqualToString:@"ForgotOtp"]){
            [_delegate parserSuccessDelegateDidFinish:jsonRes andCallType:CALL_TYPE_FORGOT_PASS];
            NSLog(@"%@",jsonRes);
            NSString *status = [NSString stringWithFormat:@"%@",[jsonRes valueForKey:@"status"]];
            NSLog(@"%@",status);
            if ([status isEqualToString:@"1"]) {
                [self NEWPASS];
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
        else if ([strCallType isEqualToString:@"newpass"]){
            [_delegate parserSuccessDelegateDidFinish:jsonRes andCallType:CALL_TYPE_FORGOT_PASS];
            NSLog(@"%@",jsonRes);
            NSString *status = [NSString stringWithFormat:@"%@",[jsonRes valueForKey:@"status"]];
            NSLog(@"%@",status);
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
        else if ([strCallType isEqualToString:@"device"]){
            [self performSegueWithIdentifier:@"toHome" sender:self];
        }
    }
}


- (IBAction)onShowPassClicked:(id)sender {
    if (_btnPassVisible.selected)
    {
        _btnPassVisible.selected = NO;
        _txtCheckPassword.secureTextEntry = YES;
        
        if (_txtCheckPassword.isFirstResponder) {
            [_txtCheckPassword resignFirstResponder];
            [_txtCheckPassword becomeFirstResponder];
        }
    }
    else
    {
        _btnPassVisible.selected = YES;
        _txtCheckPassword.secureTextEntry = NO;
        if (_txtCheckPassword.isFirstResponder) {
            [_txtCheckPassword resignFirstResponder];
            [_txtCheckPassword becomeFirstResponder];
        }
    }
}


- (IBAction)onCountryCodeClicked:(id)sender {
    PCCPViewController * vc = [[PCCPViewController alloc] initWithCompletion:^(id countryDic) {
        [self updateViewsWithCountryDic:countryDic];
    }];
    UINavigationController *naviVC = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:naviVC animated:YES completion:NULL];
}

- (void)updateViewsWithCountryDic:(NSDictionary*)countryDic{
    [_lblCountryCode setText:[NSString stringWithFormat:@"%@",countryDic[@"dialing"]]];
}


@end
