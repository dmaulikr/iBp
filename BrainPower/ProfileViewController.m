//
//  ProfileViewController.m
//  BrainPower
//
//  Created by nestcode on 1/4/18.
//  Copyright © 2018 nestcode. All rights reserved.
//

#import "ProfileViewController.h"

static char base64EncodingTable[64] = {
    'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P',
    'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f',
    'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v',
    'w', 'x', 'y', 'z', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '+', '/'
};

@interface ProfileViewController ()

@end

@implementation ProfileViewController{
    int i, i1,i2,i3,i4,i5;
    NSUserDefaults *UserData, *UserAuth,*Userprofileimg,*userPaid;
    NSMutableDictionary *userDictData;
    NSString *strRefer, *strCallType, *strPartnerCode;
    UIView *viewLoader;
    UIImageView *img;
    DGActivityIndicatorView *activityIndicatorView;
    UIDatePicker *dpDatePicker;
    UIToolbar *toolbar;
    NSUserDefaults *ColorCode;
    NSString *strColor, *strImageBase64;
    NSString *strPass, *strSetConfirmPass, *strLevelType, *strPrivacy, *strTnC;
    NSUserDefaults *isLogin, *userLanguage;
}

NSUInteger lengthOfSections[3] = {1,1,1};

- (void)viewDidLoad {
    [super viewDidLoad];
    
    i = 0;
    
    isLogin = [NSUserDefaults standardUserDefaults];
    userLanguage = [NSUserDefaults standardUserDefaults];
    
    userPaid = [NSUserDefaults standardUserDefaults];
    strLevelType = [userPaid valueForKey:@"userPaid"];
    if (![strLevelType isEqualToString:@"0"]) {
        _viewReferenceCode.userInteractionEnabled  =  NO;
    }
    else{
        _viewReferenceCode.userInteractionEnabled  =  YES;
    }
    
    _imgUser.layer.cornerRadius = 50.0f;
    _imgUser.clipsToBounds = YES;
    
    userDictData = [[NSMutableDictionary alloc]init];
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    _imgPicker = [[UIImagePickerController alloc] init];
    _library = [[ALAssetsLibrary alloc] init];
    
    ColorCode = [NSUserDefaults standardUserDefaults];
    strColor = [NSString stringWithFormat:@"%@",[ColorCode valueForKey:@"colorcode"]];
    
    UserData = [NSUserDefaults standardUserDefaults];
    
    userDictData = [UserData valueForKey:@"UserData"];
    NSLog(@"%@",userDictData);
    
     _viewProfile.hidden = YES;
    _viewBack.hidden = YES;
    _viewPass.hidden = YES;
    
    _txtParentName.delegate = self;
    _txtChildName.delegate = self;
    _txtEmail.delegate = self;
    _txtDob.delegate = self;
    _txtCity.delegate = self;
    _txtOldPass.delegate = self;
    _txtNewPass.delegate = self;
    _txtConfirmPass.delegate = self;
    _txtSetConfirmPass.delegate = self;
    _txtSetPass.delegate = self;
    
    //_txtChildName.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
    
    _viewProfile.layer.masksToBounds = NO;
    _viewProfile.layer.shadowOffset = CGSizeMake(-2, 2);
    _viewProfile.layer.shadowRadius = 10;
    _viewProfile.layer.shadowOpacity = 0.7;
    
    _imgUser.layer.backgroundColor = [self colorWithHexString:strColor].CGColor;
    _imgUser.layer.borderWidth = 1;
    _imgUser.layer.borderColor = [self colorWithHexString:strColor].CGColor;
    
    [_lblParentNameStatic setTextColor:[self colorWithHexString:strColor]];
    [_lblCityStatic setTextColor:[self colorWithHexString:strColor]];
    [_lblEmailStatic setTextColor:[self colorWithHexString:strColor]];
    [_lblMobileStatic setTextColor:[self colorWithHexString:strColor]];
    [_lblBDateStatic setTextColor:[self colorWithHexString:strColor]];
    [_lblChildNameStatic setTextColor:[self colorWithHexString:strColor]];
    [_lblReferCodeStatic setTextColor:[self colorWithHexString:strColor]];
    [_btnEditProfile setTintColor:[self colorWithHexString:strColor]];
    [_btnChangePassword setTintColor:[self colorWithHexString:strColor]];
    [_viewProfile setBackgroundColor:[self colorWithHexString:strColor]];
    [_viewMainTnC setBackgroundColor:[self colorWithHexString:strColor]];
    
    _viewReferenceCode.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _viewReferenceCode.layer.borderWidth = 0.5f;
    _viewParentName.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _viewParentName.layer.borderWidth = 0.5f;
    _viewChildName.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _viewChildName.layer.borderWidth = 0.5f;
    _viewDOB.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _viewDOB.layer.borderWidth = 0.5f;
    _viewEmail.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _viewEmail.layer.borderWidth = 0.5f;
    _viewCity.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _viewCity.layer.borderWidth = 0.5f;
    _viewSetPass.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _viewSetPass.layer.borderWidth = 0.5f;
    _viewSetConfirmPass.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _viewSetConfirmPass.layer.borderWidth = 0.5f;
    
    
    [_imgRefer setBackgroundColor:[self colorWithHexString:strColor]];
    [_imgParent setBackgroundColor:[self colorWithHexString:strColor]];
    [_imgChild setBackgroundColor:[self colorWithHexString:strColor]];
    [_imgDOB setBackgroundColor:[self colorWithHexString:strColor]];
    [_imgEmail setBackgroundColor:[self colorWithHexString:strColor]];
    [_imgCity setBackgroundColor:[self colorWithHexString:strColor]];
    [_imgLock1 setBackgroundColor:[self colorWithHexString:strColor]];
    [_imgLock2 setBackgroundColor:[self colorWithHexString:strColor]];
    [_viewTop setBackgroundColor:[self colorWithHexString:strColor]];
    
    //Password View
    _passView.layer.masksToBounds = NO;
    _passView.layer.shadowOffset = CGSizeMake(-2, 2);
    _passView.layer.shadowRadius = 10;
    _passView.layer.shadowOpacity = 0.7;
    
    _viewOldPass.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _viewOldPass.layer.borderWidth = 0.5f;
    _viewNewPass.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _viewNewPass.layer.borderWidth = 0.5f;
    _viewConfirmPass.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _viewConfirmPass.layer.borderWidth = 0.5f;
    
    [_imgOldPass setBackgroundColor:[self colorWithHexString:strColor]];
    [_imgNewPass setBackgroundColor:[self colorWithHexString:strColor]];
    [_imgConfirmPass setBackgroundColor:[self colorWithHexString:strColor]];
    [_btnClose setTintColor:[self colorWithHexString:strColor]];
    [_btnChangePass setBackgroundColor:[self colorWithHexString:strColor]];
    
    [_viewProfile setBackgroundColor:[self colorWithHexString:strColor]];
    
    i = 0;
    if (i == 0) {
        _imgChecked.image = [UIImage imageNamed:@"check_empty.png"];
    }
    else if(i == 1){
        _imgChecked.image = [UIImage imageNamed:@"checked.png"];
    }
    
    i1 = 0;
    if (i1 == 0) {
        _imgChecked1.image = [UIImage imageNamed:@"check_empty.png"];
    }
    else if(i1 == 1){
        _imgChecked1.image = [UIImage imageNamed:@"checked.png"];
    }
    i2 = 0;
    if (i2 == 0) {
        _imgChecked2.image = [UIImage imageNamed:@"check_empty.png"];
    }
    else if(i2 == 1){
        _imgChecked2.image = [UIImage imageNamed:@"checked.png"];
    }
    i3 = 0;
    if (i3 == 0) {
        _imgChecked3.image = [UIImage imageNamed:@"check_empty.png"];
    }
    else if(i3 == 1){
        _imgChecked3.image = [UIImage imageNamed:@"checked.png"];
    }
    i4 = 0;
    if (i4 == 0) {
        _imgPrivacy.image = [UIImage imageNamed:@"check_empty.png"];
    }
    else if(i4 == 1){
        _imgPrivacy.image = [UIImage imageNamed:@"checked.png"];
    }
    i5 = 0;
    if (i5 == 0) {
        _imgTerms.image = [UIImage imageNamed:@"check_empty.png"];
    }
    else if(i5 == 1){
        _imgTerms.image = [UIImage imageNamed:@"checked.png"];
    }
    
    self.referView.keyboardType = UIKeyboardTypeDefault;
    self.referView.textFont = [UIFont fontWithName:@"SFUIText-Regular" size:16.0f];
    self.referView.placeholderFont = [UIFont fontWithName:@"SFUIText-Regular" size:16.0f];
    // self.referView.accessoryView = button;
    self.referView.accessoryViewMode = LUNAccessoryViewModeAlways;
    self.referView.placeholderText = @"Promo Code (XXX-XXX-XXX)";
    self.referView.placeholderAlignment = LUNPlaceholderAlignmentLeft;
    
    
    UIImageView *leftView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"priceIcon"]];
    leftView.clipsToBounds = YES;
    leftView.contentMode = UIViewContentModeScaleAspectFill;
    leftView.frame = CGRectMake(0, 0, self.referView.frame.size.height + 2 *self.referView.borderWidth, self.referView.frame.size.height + 2 *self.referView.borderWidth);
    
    
    for (NSInteger i = 0; i < 3; ++i) {
        lengthOfSections[i] = 3;
    }
    [self.referView reload];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
   
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *currentDate = [NSDate date];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setYear:-6];
    maxDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
    [comps setYear:-16];
    minDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
    
    dpDatePicker = [[UIDatePicker alloc] init];
    dpDatePicker.datePickerMode = UIDatePickerModeDate;
    [dpDatePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    dpDatePicker.minimumDate = minDate;
    dpDatePicker.maximumDate = maxDate;
    
    [dpDatePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    [_txtDob setInputView:dpDatePicker];
    
    toolbar= [[UIToolbar alloc] initWithFrame:CGRectMake(0,0,320,44)];
    [toolbar setBarStyle:UIBarStyleBlackTranslucent];
    UIBarButtonItem *barButtonDone = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                      style:UIBarButtonItemStyleDone target:self action:@selector(done_category:)];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(pickerCancel:)];
    
    UIBarButtonItem *flexibleButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    toolbar.items = @[cancelButton,flexibleButton,barButtonDone];
    barButtonDone.tintColor=[UIColor whiteColor];
    cancelButton.tintColor = [UIColor whiteColor];

    _txtDob.inputAccessoryView = toolbar;
    
    [self APITerms];
    
}

- (IBAction)done_category:(id)sender{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    _txtDob.text = [dateFormatter stringFromDate:dpDatePicker.date];
    [_txtDob resignFirstResponder];
    [self keyboardWillHide];
}

- (void)pickerCancel:(id)sender {
    [_txtDob resignFirstResponder];
    [self keyboardWillHide];
}

- (void)datePickerValueChanged:(id)sender {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    _txtDob.text = [dateFormatter stringFromDate:dpDatePicker.date];
}

-(void)ProfileData{
    NSString *strChildName = [userDictData valueForKey:@"child_name"];
    NSString *strMobileNumber = [userDictData valueForKey:@"mobile_no"];
    _lblMobile.text = [NSString stringWithFormat:@"%@",strMobileNumber];
    if ([strChildName isEqualToString:@""]) {
        _btnChangePassword.userInteractionEnabled = NO;
        [_btnChangePassword setTintColor:[UIColor grayColor]];
    }
    else{
        _btnEditProfile.hidden = NO;
       // [_btnEditProfile setTintColor:[UIColor lightGrayColor]];
        _btnEditProfile.userInteractionEnabled = YES;
        _btnChangePassword.userInteractionEnabled = YES;
        [_btnChangePassword setTintColor:[self colorWithHexString:strColor]];
        _btnChangePassword.layer.frame = CGRectMake(self.view.frame.origin.x/58.0f, 212, 116, 29);
        
        NSString *strParentName = [userDictData valueForKey:@"parent_name"];
        NSString *strCity = [userDictData valueForKey:@"city"];
        NSString *strEmail = [userDictData valueForKey:@"email"];
        NSString *strReferalCode = [userDictData valueForKey:@"partner_code"];
        NSString *strBithDate = [userDictData valueForKey:@"bithdate"];
        
        self.referView.text = [NSString stringWithFormat:@"%@",strReferalCode];
        _lblCity.text = [NSString stringWithFormat:@"%@",strCity];
        _lblChildName.text = [NSString stringWithFormat:@"%@",strChildName];
        _lblNameMain.text = [NSString stringWithFormat:@"%@",strChildName];
        _lblBdate.text = [NSString stringWithFormat:@"%@",strBithDate];
        _lblEmail.text = [NSString stringWithFormat:@"%@",strEmail];
        _lblReferCode.text = [NSString stringWithFormat:@"%@",strReferalCode];
        _lblParentsName.text = [NSString stringWithFormat:@"%@",strParentName];

        Userprofileimg = [NSUserDefaults standardUserDefaults];
        
        
        NSString *str_image = [NSString stringWithFormat:@"%@",[Userprofileimg valueForKey:@"user_profile_image"]];
        
        [self.imgUser startLoaderWithTintColor:[self colorWithHexString:strColor]];
        [self.imgUser sd_setImageWithURL:[NSURL URLWithString:str_image] placeholderImage:[UIImage imageNamed:@"user_image.png"] options:SDWebImageCacheMemoryOnly | SDWebImageRefreshCached progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            [self.imgUser updateImageDownloadProgress:(CGFloat)receivedSize/expectedSize];
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [self.imgUser reveal];
        }];
        
        [_imgUser.layer setBorderWidth:1.0];
        _imgUser.layer.masksToBounds = YES;

    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self ProfileData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
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
    NSLog(@"stopped");
    self.sidebarButton.enabled = YES;
    [activityIndicatorView stopAnimating];
    [activityIndicatorView removeFromSuperview];
}

#pragma mark - keyboard movements
- (void)keyboardWillShow:(NSNotification *)notification
{
     if ([_txtChildName isFirstResponder]||[_txtEmail isFirstResponder]||[_txtCity isFirstResponder]||[_txtDob isFirstResponder]||[_txtConfirmPass isFirstResponder]) {
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect f = self.view.frame;
        f.origin.y = -keyboardSize.height;
        [self.view setFrame:CGRectMake(0,-110,self.view.frame.size.width,self.view.frame.size.height)];
    }];}
     else if ([_txtSetConfirmPass isFirstResponder]|| [_txtSetPass isFirstResponder]){
         CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
         
         [UIView animateWithDuration:0.3 animations:^{
             CGRect f = self.view.frame;
             f.origin.y = -keyboardSize.height;
             [self.view setFrame:CGRectMake(0,-190,self.view.frame.size.width,self.view.frame.size.height)];
         }];
     }
}


-(void)dismissKeyboard {
    [_txtCity resignFirstResponder];
    [_txtEmail resignFirstResponder];
    [_txtDob resignFirstResponder];
    [_txtParentName resignFirstResponder];
    [_txtChildName resignFirstResponder];
    [_txtConfirmPass resignFirstResponder];
    [_txtNewPass resignFirstResponder];
    [_txtOldPass resignFirstResponder];
    [_txtSetConfirmPass resignFirstResponder];
    [_txtSetPass resignFirstResponder];
    
    [self keyboardWillHide];
}

- (IBAction)dismissKeyboard:(id)sender;
{
    [_txtCity resignFirstResponder];
    [_txtEmail resignFirstResponder];
    [_txtDob resignFirstResponder];
    [_txtParentName resignFirstResponder];
    [_txtChildName resignFirstResponder];
    [_txtConfirmPass resignFirstResponder];
    [_txtNewPass resignFirstResponder];
    [_txtOldPass resignFirstResponder];
    [_txtSetConfirmPass resignFirstResponder];
    [_txtSetPass resignFirstResponder];
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
    [textField setKeyboardType:UIKeyboardTypeASCIICapable];
    [textField reloadInputViews];
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


#pragma mark LUN_RectangleFieldDataSource

- (NSUInteger)numberOfSectionsInTextField:(LUNField *)LUNField {
    return 3;
}

- (NSUInteger)numberOfCharactersInSection:(NSInteger)section inTextField:(LUNField *)LUNField
{
    return lengthOfSections[section];
}
- (BOOL)LUNField:(LUNField *)LUNField containsValidText:(NSString *)text {
    
    if (LUNField == self.referView) {
        [self keyboardWillHide];
        text = [text uppercaseString];
        strPartnerCode = text;
        NSLog(@"%@",strPartnerCode);
        return text.length==9;
        
    }
    [self keyboardWillHide];
    return YES;
}

- (void)nextFieldTapped:(UIButton *)sender {
    if (sender != self.referView.accessoryView && [self.referView isFirstResponder]) {
    [self.view endEditing:YES];
    }else{
        [self.view endEditing:YES];
    }
}

- (IBAction)onEditProfileClicked:(id)sender {
    _viewProfile.hidden = NO;
    _viewMainTnC.hidden = YES;
    self.sidebarButton.enabled = NO;
    _viewBack.hidden = NO;
    NSString *strChildName = [userDictData valueForKey:@"child_name"];
    if ([strChildName isEqualToString:@""]) {
        if (i == 1) {
            _imgChecked.image = [UIImage imageNamed:@"checked.png"];
        }
        else if(i == 0){
            _imgChecked.image = [UIImage imageNamed:@"check_empty.png"];
        }
    }
    else{
        NSString *strParentName = [userDictData valueForKey:@"parent_name"];
        NSString *strCity = [userDictData valueForKey:@"city"];
        NSString *strEmail = [userDictData valueForKey:@"email"];
        NSString *strBithDate = [userDictData valueForKey:@"bithdate"];
        
        
        _txtCity.text = [NSString stringWithFormat:@"%@",strCity];
        _txtChildName.text = [NSString stringWithFormat:@"%@",strChildName];
        _txtDob.text = [NSString stringWithFormat:@"%@",strBithDate];
        _txtEmail.text = [NSString stringWithFormat:@"%@",strEmail];
        _txtParentName.text = [NSString stringWithFormat:@"%@",strParentName];
        _txtSetPass.text = @"*******";
        _txtSetConfirmPass.text = @"*******";
        
        _viewEmail.hidden = YES;
        _viewSetPass.hidden = YES;
        _viewSetConfirmPass.hidden = YES;
        
        _profileHeight.constant = 345;
        _profileDistance.constant = 8;
        _profileSapcing.constant = 50;
        _btnHeight.constant = 40;
        _bottomSpace.constant = 40;
        if (i == 0) {
            _imgChecked.image = [UIImage imageNamed:@"check_empty.png"];
        }
        else if(i == 1){
            _imgChecked.image = [UIImage imageNamed:@"checked.png"];
        }
    }
    
}

- (IBAction)onChangePassClicked:(id)sender {
    _viewPass.hidden = NO;
    self.sidebarButton.enabled = NO;
}

- (IBAction)onCheckedClicked:(id)sender {
    if (i == 0) {
        _imgChecked.image = [UIImage imageNamed:@"checked.png"];
        _viewMainTnC.hidden = NO;
        _viewProfile.hidden = YES;
    }
    else if(i == 1){
        _imgChecked.image = [UIImage imageNamed:@"check_empty.png"];
        i = 0;
        i1 = 0;
        if (i1 == 0) {
            _imgChecked1.image = [UIImage imageNamed:@"check_empty.png"];
        }
        else if(i1 == 1){
            _imgChecked1.image = [UIImage imageNamed:@"checked.png"];
        }
        i2 = 0;
        if (i2 == 0) {
            _imgChecked2.image = [UIImage imageNamed:@"check_empty.png"];
        }
        else if(i2 == 1){
            _imgChecked2.image = [UIImage imageNamed:@"checked.png"];
        }
        i3 = 0;
        if (i3 == 0) {
            _imgChecked3.image = [UIImage imageNamed:@"check_empty.png"];
        }
        else if(i3 == 1){
            _imgChecked3.image = [UIImage imageNamed:@"checked.png"];
        }
        i4 = 0;
        if (i4 == 0) {
            _imgPrivacy.image = [UIImage imageNamed:@"check_empty.png"];
        }
        else if(i4 == 1){
            _imgPrivacy.image = [UIImage imageNamed:@"checked.png"];
        }
        i5 = 0;
        if (i5 == 0) {
            _imgTerms.image = [UIImage imageNamed:@"check_empty.png"];
        }
        else if(i5 == 1){
            _imgTerms.image = [UIImage imageNamed:@"checked.png"];
        }
    }
}

- (IBAction)onUpdateClicked:(id)sender {
    
    NSString *strError1 = NSLocalizedString(@"Please Fill All Details to Continue", @"");
    NSString *strError2 = NSLocalizedString(@"Please Enter Parent's Name", @"");
    NSString *strError3 = NSLocalizedString(@"Please Enter Child's Name", @"");
    NSString *strError4 = NSLocalizedString(@"Please Enter Email", @"");
    NSString *strError5 = NSLocalizedString(@"Please Enter Date of Birth of Child", @"");
    NSString *strError6 = NSLocalizedString(@"Please Enter City", @"");
    NSString *strError10 = NSLocalizedString(@"Promocode Must be 9 Digits!!!", @"");
    NSString *strError7 = NSLocalizedString(@"Password Can't be less then 8 Digits!!!", @"");
    NSString *strError8 = NSLocalizedString(@"Password and Confirm Password not matched!!!", @"");
    NSString *strError9 = NSLocalizedString(@"You must agree on Terms and Conditions to continue!!", @"");
    
    NSString *strChildName = [userDictData valueForKey:@"child_name"];
    if ([strChildName isEqualToString:@""]) {
        if (_txtParentName.text.length == 0 || _txtChildName.text.length == 0 || _txtEmail.text.length == 0 || _txtDob.text.length == 0 || _txtCity.text.length == 0 ||_txtSetPass.text.length<8 || _txtSetConfirmPass.text.length<8 || i == 0) {
            if (_txtParentName.text.length == 0 && _txtChildName.text.length == 0 && _txtEmail.text.length == 0 && _txtDob.text.length == 0 && _txtCity.text.length == 0) {
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
            else if (_txtParentName.text.length == 0){
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
            else if (_txtChildName.text.length == 0){
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
            else if (_txtEmail.text.length == 0){
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
            else if (_txtDob.text.length == 0){
                CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
                style.messageColor = [self colorWithHexString:strColor];
                [self.view makeToast:strError5
                            duration:3.0
                            position:CSToastPositionBottom
                               style:style];
                
                [CSToastManager setSharedStyle:style];
                [CSToastManager setTapToDismissEnabled:YES];
                [CSToastManager setQueueEnabled:NO];
            }
            else if (_txtCity.text.length == 0){
                CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
                style.messageColor = [self colorWithHexString:strColor];
                [self.view makeToast:strError6
                            duration:3.0
                            position:CSToastPositionBottom
                               style:style];
                
                [CSToastManager setSharedStyle:style];
                [CSToastManager setTapToDismissEnabled:YES];
                [CSToastManager setQueueEnabled:NO];
            }
            else if (_txtSetPass.text.length < 8 || _txtSetConfirmPass.text.length<8){
                CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
                style.messageColor = [self colorWithHexString:strColor];
                [self.view makeToast:strError7
                            duration:3.0
                            position:CSToastPositionBottom
                               style:style];
                
                [CSToastManager setSharedStyle:style];
                [CSToastManager setTapToDismissEnabled:YES];
                [CSToastManager setQueueEnabled:NO];
            }
            else if (![_txtSetConfirmPass.text isEqualToString:_txtSetPass.text]){
                CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
                style.messageColor = [self colorWithHexString:strColor];
                [self.view makeToast:strError8
                            duration:3.0
                            position:CSToastPositionBottom
                               style:style];
                
                [CSToastManager setSharedStyle:style];
                [CSToastManager setTapToDismissEnabled:YES];
                [CSToastManager setQueueEnabled:NO];
            }
            else if (i == 0){
                CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
                style.messageColor = [self colorWithHexString:strColor];
                [self.view makeToast:strError9
                            duration:3.0
                            position:CSToastPositionBottom
                               style:style];
                
                [CSToastManager setSharedStyle:style];
                [CSToastManager setTapToDismissEnabled:YES];
                [CSToastManager setQueueEnabled:NO];
            }
            
        }
        else{
            strPass = _txtSetPass.text;
            strSetConfirmPass = _txtSetConfirmPass.text;
            [self APIUpdateProfile];
        }
    }
    else{
        if (_txtDob.text.length == 0 || _txtCity.text.length == 0 || _txtChildName.text.length == 0 ||_txtParentName.text.length == 0 || i == 0) {
            if (_txtDob.text.length == 0 && _txtCity.text.length == 0 && _txtChildName.text.length == 0 &&_txtParentName.text.length == 0 ) {
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
            else if (_txtParentName.text.length == 0){
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
            else if (_txtChildName.text.length == 0){
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
            else if (_txtDob.text.length == 0){
                CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
                style.messageColor = [self colorWithHexString:strColor];
                [self.view makeToast:strError5
                            duration:3.0
                            position:CSToastPositionBottom
                               style:style];
                
                [CSToastManager setSharedStyle:style];
                [CSToastManager setTapToDismissEnabled:YES];
                [CSToastManager setQueueEnabled:NO];
            }
            else if (_txtCity.text.length == 0){
                CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
                style.messageColor = [self colorWithHexString:strColor];
                [self.view makeToast:strError6
                            duration:3.0
                            position:CSToastPositionBottom
                               style:style];
                
                [CSToastManager setSharedStyle:style];
                [CSToastManager setTapToDismissEnabled:YES];
                [CSToastManager setQueueEnabled:NO];
            }
            else if (i == 0){
                CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
                style.messageColor = [self colorWithHexString:strColor];
                [self.view makeToast:strError9
                            duration:3.0
                            position:CSToastPositionBottom
                               style:style];
                
                [CSToastManager setSharedStyle:style];
                [CSToastManager setTapToDismissEnabled:YES];
                [CSToastManager setQueueEnabled:NO];
            }
        }
        else{
            [self keyboardWillHide];
            [self APIEditProfile];
        }
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

-(void)APIUpdateProfile{
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable)
    {
        [self CheckConnection];
    }
    else
    {
        NSDictionary *tmp = [[NSDictionary alloc]initWithObjectsAndKeys:
                             _txtParentName.text,@"parent_name",
                             _txtChildName.text,@"child_name",
                             _txtEmail.text,@"email",
                             _txtCity.text,@"city",
                             _txtDob.text,@"bithdate",
                             strPartnerCode,@"partner_code",
                             strSetConfirmPass,@"confirm_password",
                             strPass,@"new_password",
                             nil];
        NSError* error;
        NSData* data = [NSJSONSerialization dataWithJSONObject:tmp options:0 error:&error];
        
        // [SVProgressHUD show];
        [self ShowActivityIndicator];
        UserAuth = [NSUserDefaults standardUserDefaults];
        NSString *strAuth = [UserAuth valueForKey:@"UserAuth"];
        
        NSString *strUrl = [NSString stringWithFormat:@"%@",API_COMPLETE_PROFILE];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]init];
        request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:strUrl]];
        
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
        [request setValue:strAuth forHTTPHeaderField:@"Authorization"];
        [request setHTTPBody:data];
        
        requestHandler = [[HTTPRequestHandler alloc] initWithRequest:request delegate:self andCallBack:CALL_TYPE_COMPLETE_PROFILE];
        strCallType = @"profile";
    }
}

-(void)APIEditProfile{
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable)
    {
        [self CheckConnection];
    }
    else
    {
        NSDictionary *tmp = [[NSDictionary alloc]initWithObjectsAndKeys:
                             _txtParentName.text,@"parent_name",
                             _txtChildName.text,@"child_name",
                             _txtCity.text,@"city",
                             _txtDob.text,@"bithdate",
                             strPartnerCode,@"partner_code",
                             nil];
        NSError* error;
        NSData* data = [NSJSONSerialization dataWithJSONObject:tmp options:0 error:&error];
        
        // [SVProgressHUD show];
        [self ShowActivityIndicator];
        UserAuth = [NSUserDefaults standardUserDefaults];
        NSString *strAuth = [UserAuth valueForKey:@"UserAuth"];
        
        NSString *strUrl = [NSString stringWithFormat:@"%@",API_EDIT_PROFILE];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]init];
        request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:strUrl]];
        
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
        [request setValue:strAuth forHTTPHeaderField:@"Authorization"];
        [request setHTTPBody:data];
        
        requestHandler = [[HTTPRequestHandler alloc] initWithRequest:request delegate:self andCallBack:CALL_TYPE_EDIT_PROFILE];
        strCallType = @"edit";
    }
}

-(void)APIChangePass{
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable)
    {
       [self CheckConnection];
    }
    else
    {
        NSDictionary *tmp = [[NSDictionary alloc]initWithObjectsAndKeys:
                             _txtOldPass.text,@"old_pwd",
                             _txtNewPass.text,@"new_pwd",
                             _txtConfirmPass.text,@"confirm_new_pwd",
                             nil];
        NSError* error;
        NSData* data = [NSJSONSerialization dataWithJSONObject:tmp options:0 error:&error];
        
        // [SVProgressHUD show];
        [self ShowActivityIndicator];
        UserAuth = [NSUserDefaults standardUserDefaults];
        NSString *strAuth = [UserAuth valueForKey:@"UserAuth"];
        
        NSString *strUrl = [NSString stringWithFormat:@"%@",API_CHANGE_PASS];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]init];
        request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:strUrl]];
        
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
        [request setValue:strAuth forHTTPHeaderField:@"Authorization"];
        [request setHTTPBody:data];
        
        requestHandler = [[HTTPRequestHandler alloc] initWithRequest:request delegate:self andCallBack:CALL_TYPE_CHANGE_PASS];
        strCallType = @"pass";
    }
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    _photoEditor = [[XWPhotoEditorViewController alloc] initWithNibName:@"XWPhotoEditorViewController" bundle:nil];
    
    // set photo editor value
    _photoEditor.panEnabled = YES;
    _photoEditor.scaleEnabled = YES;
    _photoEditor.tapToResetEnabled = YES;
    _photoEditor.rotateEnabled = NO;
    _photoEditor.delegate = self;
    // crop window's value
    _photoEditor.cropSize = CGSizeMake(300, 300);
    
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSURL *assetURL = [info objectForKey:UIImagePickerControllerMediaURL];
    
    [self.library assetForURL:assetURL resultBlock:^(ALAsset *asset) {
        self.photoEditor.sourceImage = image;
        [picker pushViewController:self.photoEditor animated:YES];
        [picker setNavigationBarHidden:YES animated:NO];
    } failureBlock:^(NSError *error) {
        NSLog(@"failed to get asset from library");
    }];
}

-(void)APIUploadPhoto{
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable)
    {
        [self CheckConnection];
    }
    else
    {
        NSDictionary *tmp = [[NSDictionary alloc]initWithObjectsAndKeys:
                             strImageBase64,@"image_base_data",
                             @"jpeg",@"image_extension",
                             nil];
        NSError* error;
        NSData* data = [NSJSONSerialization dataWithJSONObject:tmp options:0 error:&error];
        
        // [SVProgressHUD show];
        [self ShowActivityIndicator];
        UserAuth = [NSUserDefaults standardUserDefaults];
        NSString *strAuth = [UserAuth valueForKey:@"UserAuth"];
        
        NSString *strUrl = [NSString stringWithFormat:@"%@",API_UPLOAD_USER_IMAGE];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]init];
        request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:strUrl]];
        
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
        [request setValue:strAuth forHTTPHeaderField:@"Authorization"];
        [request setHTTPBody:data];
        
        requestHandler = [[HTTPRequestHandler alloc] initWithRequest:request delegate:self andCallBack:CALL_TYPE_UPLOAD_USER_IMAGE];
        strCallType = @"photo";
    }
}

-(void)APITerms{
    
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable)
    {
        [self CheckConnection];
    }
    else
    {
        self.view.userInteractionEnabled = NO;
        UserAuth = [NSUserDefaults standardUserDefaults];
        NSString *strAuth = [UserAuth valueForKey:@"UserAuth"];
        
        NSString *strUrl = [NSString stringWithFormat:@"%@",API_GET_TERMS];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]init];
        request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:strUrl]];
        
        [request setHTTPMethod:@"GET"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
        [request setValue:strAuth forHTTPHeaderField:@"Authorization"];
        [request setHTTPBody:nil];
        
        requestHandler = [[HTTPRequestHandler alloc] initWithRequest:request delegate:self andCallBack:CALL_TYPE_GET_TERMS];
        
        strCallType = @"Terms";
    }
}

-(void)finish:(UIImage *)image didCancel:(BOOL)cancel {
    if (!cancel) {
        // store this new picture in the library
        [_library
         writeImageToSavedPhotosAlbum:[image CGImage]
         orientation:(ALAssetOrientation)image.imageOrientation
         completionBlock:^(NSURL *assetURL, NSError *error){
             if (error) {
                 UIAlertView *alert =
                 [[UIAlertView alloc] initWithTitle:@"Error Saving"
                                            message:[error localizedDescription]
                                           delegate:nil
                                  cancelButtonTitle:@"Ok"
                                  otherButtonTitles: nil];
                 [alert show];
             }
         }];
        _imgUser.image = image;
   
        NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
        NSString *str = [imageData base64EncodedString];
        NSString *base64Str = [self base64StringFromData:imageData length:[imageData length]];
        NSArray* words = [str componentsSeparatedByCharactersInSet :[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSString* nospacestring = [words componentsJoinedByString:@""];
        strImageBase64 = nospacestring;
        NSLog(@"%@",strImageBase64);
        [self APIUploadPhoto];
        
        // [self encode:imageData];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSString *)base64StringFromData:(NSData *)data length:(unsigned long)length
{
    unsigned long ixtext, lentext;
    long ctremaining;
    unsigned char input[3], output[4];
    short i, charsonline = 0, ctcopy;
    const unsigned char *raw;
    NSMutableString *result1;
    
    lentext = [data length];
    if (lentext < 1)
        return @"";
    result1 = [NSMutableString stringWithCapacity: lentext];
    raw = [data bytes];
    ixtext = 0;
    while (true) {
        
        ctremaining = lentext - ixtext;
        if (ctremaining <= 0)
            break;
        for (i = 0; i < 3; i++) {
            unsigned long ix = ixtext + i;
            if (ix < lentext)
                input[i] = raw[ix];
            else
                input[i] = 0;
        }
        output[0] = (input[0] & 0xFC) >> 2;
        output[1] = ((input[0] & 0x03) << 4) | ((input[1] & 0xF0) >> 4);
        output[2] = ((input[1] & 0x0F) << 2) | ((input[2] & 0xC0) >> 6);
        output[3] = input[2] & 0x3F;
        ctcopy = 4;
        switch (ctremaining) {
            case 1:
                ctcopy = 2;
                break;
            case 2:
                ctcopy = 3;
                break;
        }
        for (i = 0; i < ctcopy; i++)
            [result1 appendString: [NSString stringWithFormat: @"%c", base64EncodingTable[output[i]]]];
        
        for (i = ctcopy; i < 4; i++)
            [result1 appendString: @"="];
        
        ixtext += 3;
        charsonline += 4;
        
        if ((length > 0) && (charsonline >= length))
            charsonline = 0;
    }
    return result1;
}

-(void)encode:(NSData *)data
{
    [self encodeWithBase64:data];
}

-(void)encodeWithBase64:(NSData *)data
{
    NSString *dataString = [data base64EncodedStringWithOptions:0];
   
    dispatch_async(dispatch_get_main_queue(), ^{
        strImageBase64 = [NSString stringWithFormat:@"%@",dataString];
        NSLog(@"%@",dataString);
        [self APIUploadPhoto];
    });
}

-(NSString *)encodeToBase64String:(UIImage *)image {
    NSLog(@"%@",[UIImagePNGRepresentation(image) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength]);
    return [UIImagePNGRepresentation(image) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}

#pragma mark -
#pragma mark UIActionSheetDelegate Methods
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        [self showImagePicker:UIImagePickerControllerSourceTypePhotoLibrary];
    } else if (buttonIndex == 1) {
        [self showImagePicker:UIImagePickerControllerSourceTypeCamera];
    }
}


-(void)showImagePicker:(UIImagePickerControllerSourceType) sourceType {
    _imgPicker.sourceType = sourceType;
    [_imgPicker setAllowsEditing:NO];
    _imgPicker.delegate = self;
    if (_imgPicker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        _imgPicker.showsCameraControls = YES;
    }
    if ( [UIImagePickerController isSourceTypeAvailable:sourceType]) {
        [self presentViewController:_imgPicker animated:YES completion:nil];
    }
}


- (IBAction)onCloseProfileClicked:(id)sender {
    self.sidebarButton.enabled = YES;
    _viewProfile.hidden = YES;
    _viewBack.hidden = YES;
    
    if (i1 == 1 && i2 == 1  && i3 == 1 && i4 == 1 && i5 == 1) {
        i = 1;
    }
    else{
        i = 0;
    }
    if (i == 0) {
        _imgChecked.image = [UIImage imageNamed:@"check_empty.png"];
    }
    else if(i == 1){
        _imgChecked.image = [UIImage imageNamed:@"checked.png"];
    }
    [self dismissKeyboard];
}

- (IBAction)onCloseClicked:(id)sender {
    self.sidebarButton.enabled = YES;
    _viewPass.hidden = YES;
    if (i1 == 1 && i2 == 1  && i3 == 1 && i4 == 1 && i5 == 1) {
        i = 1;
    }
    else{
        i = 0;
    }
    if (i == 0) {
        _imgChecked.image = [UIImage imageNamed:@"check_empty.png"];
    }
    else if(i == 1){
        _imgChecked.image = [UIImage imageNamed:@"checked.png"];
    }
    [self dismissKeyboard];
}

- (IBAction)onChangePass:(id)sender {
    
    NSString *strError1 = NSLocalizedString(@"Please Fill All Details to Continue", @"");
    NSString *strError2 = NSLocalizedString(@"Please Enter Old Password", @"");
    NSString *strError3 = NSLocalizedString(@"Please Enter New Password", @"");
    NSString *strError4 = NSLocalizedString(@"Please Enter Confirm Password", @"");
    NSString *strError5 = NSLocalizedString(@"Confirm Password should be equal to New Password", @"");
    
    if (_txtOldPass.text.length == 0 || _txtNewPass.text.length == 0 || _txtConfirmPass.text.length == 0) {
        if (_txtOldPass.text.length == 0 && _txtNewPass.text.length == 0 && _txtConfirmPass.text.length == 0) {
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
        else if (_txtOldPass.text.length == 0){
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
        else if (_txtNewPass.text.length == 0){
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
        else if (_txtConfirmPass.text.length == 0){
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
        else if (![_txtConfirmPass.text isEqualToString:_txtNewPass.text]){
            CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
            style.messageColor = [self colorWithHexString:strColor];
            [self.view makeToast:strError5
                        duration:3.0
                        position:CSToastPositionBottom
                           style:style];
            
            [CSToastManager setSharedStyle:style];
            [CSToastManager setTapToDismissEnabled:YES];
            [CSToastManager setQueueEnabled:NO];
        }
    }
    else{
        [self keyboardWillHide];
        [self APIChangePass];
    }
}

- (IBAction)onProfileClicked:(id)sender {
    NSString *libraryTitle = @"From Library";
    NSString *takePhotoTitle = @"Take A Photo";
    NSString *cancelTitle = @"Cancel";
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:cancelTitle
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:libraryTitle,takePhotoTitle, nil];
    [actionSheet showInView:self.view];
}

- (IBAction)onChecked1Clicked:(id)sender {
    if (i1 == 0) {
        _imgChecked1.image = [UIImage imageNamed:@"checked.png"];
        i1 = 1;
    }
    else if(i1 == 1){
        _imgChecked1.image = [UIImage imageNamed:@"check_empty.png"];
        i1 = 0;
    }
}
- (IBAction)onChecked2Clicked:(id)sender {
    if (i2 == 0) {
        _imgChecked2.image = [UIImage imageNamed:@"checked.png"];
        i2 = 1;
    }
    else if(i2 == 1){
        _imgChecked2.image = [UIImage imageNamed:@"check_empty.png"];
        i2 = 0;
    }
}
- (IBAction)onChecked3Clicked:(id)sender {
    if (i3 == 0) {
        _imgChecked3.image = [UIImage imageNamed:@"checked.png"];
        
        i3 = 1;
    }
    else if(i3 == 1){
        _imgChecked3.image = [UIImage imageNamed:@"check_empty.png"];
        i3 = 0;
    }
}

- (IBAction)onAgreeClicked:(id)sender {
    _viewMainTnC.hidden = YES;
    _viewProfile.hidden = NO;
    if (i1 == 1 && i2 == 1  && i3 == 1 && i4 == 1 && i5 == 1) {
        i = 1;
    }
    else{
        i = 0;
    }
    if (i == 0) {
        _imgChecked.image = [UIImage imageNamed:@"check_empty.png"];
    }
    else if(i == 1){
        _imgChecked.image = [UIImage imageNamed:@"checked.png"];
    }
}
- (IBAction)onShowNewPassClicked:(id)sender {
    if (_btnNewPassVisible.selected)
    {
        _btnNewPassVisible.selected = NO;
        _txtSetPass.secureTextEntry = YES;
        
        if (_txtSetPass.isFirstResponder) {
            [_txtSetPass resignFirstResponder];
            [_txtSetPass becomeFirstResponder];
        }
    }
    else
    {
        _btnNewPassVisible.selected = YES;
        _txtSetPass.secureTextEntry = NO;
        if (_txtSetPass.isFirstResponder) {
            [_txtSetPass resignFirstResponder];
            [_txtSetPass becomeFirstResponder];
        }
    }
    [_btnNewPassVisible setImage:[UIImage imageNamed:@"showPassword.png"] forState:UIControlStateNormal];
    [_btnNewPassVisible setImage:[UIImage imageNamed:@"hidePassword.png"] forState:UIControlStateSelected];
}

- (IBAction)onShowNewConfirmPassClicked:(id)sender {
    if (_btnNewConfirmPassVisible.selected)
    {
        _btnNewConfirmPassVisible.selected = NO;
        _txtSetConfirmPass.secureTextEntry = YES;
        
        if (_txtSetConfirmPass.isFirstResponder) {
            [_txtSetConfirmPass resignFirstResponder];
            [_txtSetConfirmPass becomeFirstResponder];
        }
    }
    else
    {
        _btnNewConfirmPassVisible.selected = YES;
        _txtSetConfirmPass.secureTextEntry = NO;
        if (_txtSetConfirmPass.isFirstResponder) {
            [_txtSetConfirmPass resignFirstResponder];
            [_txtSetConfirmPass becomeFirstResponder];
        }
    }
    [_btnNewConfirmPassVisible setImage:[UIImage imageNamed:@"showPassword.png"] forState:UIControlStateNormal];
    
    [_btnNewConfirmPassVisible setImage:[UIImage imageNamed:@"hidePassword.png"] forState:UIControlStateSelected];
}
- (IBAction)onShowOldPassClicked:(id)sender {
    switch ([sender tag]) {
        case 0:
            if (_btnOldPassVisible.selected)
            {
                _btnOldPassVisible.selected = NO;
                _txtOldPass.secureTextEntry = YES;
                
                if (_txtOldPass.isFirstResponder) {
                    [_txtOldPass resignFirstResponder];
                    [_txtOldPass becomeFirstResponder];
                }
            }
            else
            {
                _btnOldPassVisible.selected = YES;
                _txtOldPass.secureTextEntry = NO;
                if (_txtOldPass.isFirstResponder) {
                    [_txtOldPass resignFirstResponder];
                    [_txtOldPass becomeFirstResponder];
                }
            }
            [_btnOldPassVisible setImage:[UIImage imageNamed:@"showPassword.png"] forState:UIControlStateNormal];
            
            [_btnOldPassVisible setImage:[UIImage imageNamed:@"hidePassword.png"] forState:UIControlStateSelected];
            break;
        case 1:
            if (_btnSetNewPassVisible.selected)
            {
                _btnSetNewPassVisible.selected = NO;
                _txtNewPass.secureTextEntry = YES;
                
                if (_txtNewPass.isFirstResponder) {
                    [_txtNewPass resignFirstResponder];
                    [_txtNewPass becomeFirstResponder];
                }
            }
            else
            {
                _btnSetNewPassVisible.selected = YES;
                _txtNewPass.secureTextEntry = NO;
                if (_txtNewPass.isFirstResponder) {
                    [_txtNewPass resignFirstResponder];
                    [_txtNewPass becomeFirstResponder];
                }
            }
            [_btnSetNewPassVisible setImage:[UIImage imageNamed:@"showPassword.png"] forState:UIControlStateNormal];
            
            [_btnSetNewPassVisible setImage:[UIImage imageNamed:@"hidePassword.png"] forState:UIControlStateSelected];
            break;
        case 2:
            if (_btnSetNewConfirmPassVisible.selected)
            {
                _btnSetNewConfirmPassVisible.selected = NO;
                _txtConfirmPass.secureTextEntry = YES;
                
                if (_txtConfirmPass.isFirstResponder) {
                    [_txtConfirmPass resignFirstResponder];
                    [_txtConfirmPass becomeFirstResponder];
                }
            }
            else
            {
                _btnSetNewConfirmPassVisible.selected = YES;
                _txtConfirmPass.secureTextEntry = NO;
                if (_txtConfirmPass.isFirstResponder) {
                    [_txtConfirmPass resignFirstResponder];
                    [_txtConfirmPass becomeFirstResponder];
                }
            }
            [_btnSetNewConfirmPassVisible setImage:[UIImage imageNamed:@"showPassword.png"] forState:UIControlStateNormal];
            
            [_btnSetNewConfirmPassVisible setImage:[UIImage imageNamed:@"hidePassword.png"] forState:UIControlStateSelected];
            break;
            
        default:
            break;
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
    Userprofileimg = [NSUserDefaults standardUserDefaults];
    NSString *response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *jsonRes = [response JSONValue];
    
    if ([[jsonRes valueForKey:@"message"] isEqualToString:@"Unauthenticated."]) {
        //  [SVProgressHUD dismiss];
        //  [isLogin setInteger:0 forKey:@"LoggedIn"];
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
        if ([strCallType isEqualToString:@"profile"]) {
            [_delegate parserSuccessDelegateDidFinish:jsonRes andCallType:CALL_TYPE_COMPLETE_PROFILE];
            NSLog(@"%@",jsonRes);
            
            NSString *status = [NSString stringWithFormat:@"%@",[jsonRes valueForKey:@"status"]];
            NSLog(@"%@",status);
            if ([status isEqualToString:@"1"]) {
                userDictData = [jsonRes valueForKey:@"data"];
                UserData = [NSUserDefaults standardUserDefaults];
                [UserData setObject:userDictData forKey:@"UserData"];
                [UserData synchronize];
                
                i = 0;
                if (i == 0) {
                    _imgChecked.image = [UIImage imageNamed:@"check_empty.png"];
                }
                else if(i == 1){
                    _imgChecked.image = [UIImage imageNamed:@"checked.png"];
                }
                
                i1 = 0;
                if (i1 == 0) {
                    _imgChecked1.image = [UIImage imageNamed:@"check_empty.png"];
                }
                else if(i1 == 1){
                    _imgChecked1.image = [UIImage imageNamed:@"checked.png"];
                }
                i2 = 0;
                if (i2 == 0) {
                    _imgChecked2.image = [UIImage imageNamed:@"check_empty.png"];
                }
                else if(i2 == 1){
                    _imgChecked2.image = [UIImage imageNamed:@"checked.png"];
                }
                i3 = 0;
                if (i3 == 0) {
                    _imgChecked3.image = [UIImage imageNamed:@"check_empty.png"];
                }
                else if(i3 == 1){
                    _imgChecked3.image = [UIImage imageNamed:@"checked.png"];
                }
                i4 = 0;
                if (i4 == 0) {
                    _imgPrivacy.image = [UIImage imageNamed:@"check_empty.png"];
                }
                else if(i4 == 1){
                    _imgPrivacy.image = [UIImage imageNamed:@"checked.png"];
                }
                i5 = 0;
                if (i5 == 0) {
                    _imgTerms.image = [UIImage imageNamed:@"check_empty.png"];
                }
                else if(i5 == 1){
                    _imgTerms.image = [UIImage imageNamed:@"checked.png"];
                }
                
                NSString *str_image = [NSString stringWithFormat:@"%@",[userDictData valueForKey:@"user_image"]];
                [Userprofileimg setObject:str_image forKey:@"user_profile_image"];
                [Userprofileimg synchronize];
                
                [self ProfileData];
                self.sidebarButton.enabled = YES;
                
                
                _viewProfile.hidden = YES;
                _viewBack.hidden = YES;
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
        else if ([strCallType isEqualToString:@"Terms"]) {
            [_delegate parserSuccessDelegateDidFinish:jsonRes andCallType:CALL_TYPE_GET_TERMS];
            NSLog(@"%@",jsonRes);
            NSString *strStatus = [NSString stringWithFormat:@"%@",[jsonRes valueForKey:@"status"]];
            if ([strStatus isEqualToString:@"1"]) {
                strTnC = [NSString stringWithFormat:@"%@",[[jsonRes valueForKey:@"data"]valueForKey:@"terms_condition"]];
                strPrivacy = [NSString stringWithFormat:@"%@",[[jsonRes valueForKey:@"data"]valueForKey:@"privacy_policy"]];
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
        
        else  if ([strCallType isEqualToString:@"pass"]) {
            [_delegate parserSuccessDelegateDidFinish:jsonRes andCallType:CALL_TYPE_CHANGE_PASS];
            NSLog(@"%@",jsonRes);
            NSString *status = [NSString stringWithFormat:@"%@",[jsonRes valueForKey:@"status"]];
            NSLog(@"%@",status);
            if ([status isEqualToString:@"1"]) {
                CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
                style.messageColor = [self colorWithHexString:strColor];
                [self.view makeToast:[jsonRes valueForKey:@"message"]
                            duration:3.0
                            position:CSToastPositionBottom
                               style:style];
                
                [CSToastManager setSharedStyle:style];
                [CSToastManager setTapToDismissEnabled:YES];
                [CSToastManager setQueueEnabled:NO];
                self.sidebarButton.enabled = YES;
                _viewPass.hidden = YES;
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
        
        else if ([strCallType isEqualToString:@"photo"]) {
            [_delegate parserSuccessDelegateDidFinish:jsonRes andCallType:CALL_TYPE_UPLOAD_USER_IMAGE];
            NSLog(@"%@",jsonRes);
            
            NSString *str_image = [NSString stringWithFormat:@"%@",[jsonRes valueForKey:@"data"]];
            
            
            [Userprofileimg setObject:str_image forKey:@"user_profile_image"];
            [Userprofileimg synchronize];
            
            
            [self.imgUser startLoaderWithTintColor:[UIColor greenColor]];
            [self.imgUser sd_setImageWithURL:[NSURL URLWithString:str_image] placeholderImage:[UIImage imageNamed:@"user_image.png"] options:SDWebImageCacheMemoryOnly | SDWebImageRefreshCached progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                [self.imgUser updateImageDownloadProgress:(CGFloat)receivedSize/expectedSize];
            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                [self.imgUser reveal];
            }];
            
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
        else  if ([strCallType isEqualToString:@"edit"]) {
            [_delegate parserSuccessDelegateDidFinish:jsonRes andCallType:CALL_TYPE_EDIT_PROFILE];
            NSLog(@"%@",jsonRes);
            
            NSString *strStatus = [NSString stringWithFormat:@"%@",[jsonRes valueForKey:@"status"]];
            if ([strStatus isEqualToString:@"1"]) {
                userDictData = [jsonRes valueForKey:@"data"];
                UserData = [NSUserDefaults standardUserDefaults];
                [UserData setObject:userDictData forKey:@"UserData"];
                [UserData synchronize];
                [self ProfileData];
                i = 0;
                if (i == 0) {
                    _imgChecked.image = [UIImage imageNamed:@"check_empty.png"];
                }
                else if(i == 1){
                    _imgChecked.image = [UIImage imageNamed:@"checked.png"];
                }
                
                i1 = 0;
                if (i1 == 0) {
                    _imgChecked1.image = [UIImage imageNamed:@"check_empty.png"];
                }
                else if(i1 == 1){
                    _imgChecked1.image = [UIImage imageNamed:@"checked.png"];
                }
                i2 = 0;
                if (i2 == 0) {
                    _imgChecked2.image = [UIImage imageNamed:@"check_empty.png"];
                }
                else if(i2 == 1){
                    _imgChecked2.image = [UIImage imageNamed:@"checked.png"];
                }
                i3 = 0;
                if (i3 == 0) {
                    _imgChecked3.image = [UIImage imageNamed:@"check_empty.png"];
                }
                else if(i3 == 1){
                    _imgChecked3.image = [UIImage imageNamed:@"checked.png"];
                }
                i4 = 0;
                if (i4 == 0) {
                    _imgPrivacy.image = [UIImage imageNamed:@"check_empty.png"];
                }
                else if(i4 == 1){
                    _imgPrivacy.image = [UIImage imageNamed:@"checked.png"];
                }
                i5 = 0;
                if (i5 == 0) {
                    _imgTerms.image = [UIImage imageNamed:@"check_empty.png"];
                }
                else if(i5 == 1){
                    _imgTerms.image = [UIImage imageNamed:@"checked.png"];
                }
                self.sidebarButton.enabled = YES;
                _viewProfile.hidden = YES;
                _viewBack.hidden = YES;
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
}


- (IBAction)onPrivacyClicked:(id)sender {
    NSUserDefaults *userTnC = [NSUserDefaults standardUserDefaults];
    [userTnC setValue:strPrivacy forKey:@"userTnC"];
    [userTnC synchronize];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:[Global getStoryBoardName] bundle:nil];
    PoliciesViewController *policyVC = (PoliciesViewController *)[storyboard instantiateViewControllerWithIdentifier:@"PoliciesViewController"];
    policyVC.strTypeOfPolicy = @"3";
    [self presentViewController:policyVC animated:YES completion:nil];
}

- (IBAction)onTermsClicked:(id)sender {
    NSUserDefaults *userTnC = [NSUserDefaults standardUserDefaults];
    [userTnC setValue:strTnC forKey:@"userTnC"];
    [userTnC synchronize];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:[Global getStoryBoardName] bundle:nil];
    PoliciesViewController *policyVC = (PoliciesViewController *)[storyboard instantiateViewControllerWithIdentifier:@"PoliciesViewController"];
    policyVC.strTypeOfPolicy = @"3";
    [self presentViewController:policyVC animated:YES completion:nil];
}

- (IBAction)onPrivacyCheckClicked:(id)sender {
    if (i4 == 0) {
        _imgPrivacy.image = [UIImage imageNamed:@"checked.png"];
        i4 = 1;
    }
    else if(i3 == 1){
        _imgPrivacy.image = [UIImage imageNamed:@"check_empty.png"];
        i4 = 0;
    }
}

- (IBAction)onTermsCheckClicked:(id)sender {
    if (i5 == 0) {
        _imgTerms.image = [UIImage imageNamed:@"checked.png"];
        i5 = 1;
    }
    else if(i5 == 1){
        _imgTerms.image = [UIImage imageNamed:@"check_empty.png"];
        i5 = 0;
    }
}

@end
