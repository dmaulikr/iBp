//
//  HomeViewController.m
//  BrainPower
//
//  Created by nestcode on 1/2/18.
//  1right © 2018 nestcode. All rights reserved.
//

#import "HomeViewController.h"
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface HomeViewController ()

@end

@implementation HomeViewController{
    int i, i1,i2,i3,i4,i5;
    NSMutableArray *arrMain;
    NSString *strCallType, *strLevelID, *strUserStatus, *strPartnerCode, *strPrivacy, *strTnC;
    NSUserDefaults *UserAuth, *UserData, *moduleLock;
    NSMutableDictionary *userDictData;
  //  DGActivityIndicatorView *activityIndicatorView;
    UIImageView *img;
    UIDatePicker *dpDatePicker;
    UIToolbar *toolbar;
    NSUserDefaults *ColorCode;
    NSString *strColor, *strHideShow;
    NSString *strPass, *strSetConfirmPass;
    NSUserDefaults *userFirstTime;
    NSString *strLang;
    NSUserDefaults *userFireBaseToken, *StepFlag;
    NSUserDefaults *isLogin, *userLanguage, *Userprofileimg;
    NSUserDefaults  *UserHideShow, *UserPaymentURL;
}

//NSUInteger lengthOfSections[3] = {1,1,1};

- (void)awakeFromNib
{
    [super awakeFromNib];
    arrMain = [[NSMutableArray alloc]init];
    _ViewCarousel.delegate = self;
    _ViewCarousel.dataSource = self;
    NSUserDefaults *UserHideShow = [NSUserDefaults standardUserDefaults];
    userFireBaseToken = [NSUserDefaults standardUserDefaults];
    strHideShow = [NSString stringWithFormat:@"%@",[UserHideShow valueForKey:@"HideShow"]];
    [self UpdateToken];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (@available(iOS 11, *)) {
       // self.additionalSafeAreaInsets.top = 20asasa
    }
    isLogin = [NSUserDefaults standardUserDefaults];
    Userprofileimg = [NSUserDefaults standardUserDefaults];
    userLanguage = [NSUserDefaults standardUserDefaults];
    
    _txtreferCode.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
    
    _viewMainTnC.hidden = YES;
    StepFlag = [NSUserDefaults standardUserDefaults];
    
    strLang = [userLanguage valueForKey:@"AppleLanguages"];
    
    ColorCode = [NSUserDefaults standardUserDefaults];
    
    strColor = [NSString stringWithFormat:@"%@",[ColorCode valueForKey:@"colorcode"]];
    [self.navigationController.navigationBar setValue:@(YES) forKeyPath:@"hidesShadow"];
    [self.view setBackgroundColor:[self colorWithHexString:strColor]];
    
    _ViewCarousel.type = iCarouselTypeLinear;
    userDictData = [[NSMutableDictionary alloc]init];
    moduleLock = [NSUserDefaults standardUserDefaults];
    UserData = [NSUserDefaults standardUserDefaults];
    userDictData = [UserData valueForKey:@"UserData"];
    
    NSString *strChildName = [userDictData valueForKey:@"child_name"];
    
    if ([strChildName isEqualToString:@""]) {
        _lblUserName.text = [@"GUEST" uppercaseString];
    }
    else{
        _lblUserName.text = [[NSString stringWithFormat:@"%@",strChildName]uppercaseString];
    }
    
    [self DOBDataSet];
    
    [_viewBackColor setBackgroundColor:[self colorWithHexString:strColor]];
    
    [_lblUserName setTextColor:[self colorWithHexString:strColor]];
    
    _viewCompleteProfie.hidden = YES;
    
    
    _txtParentName.delegate = self;
    _txtChildName.delegate = self;
    _txtEmail.delegate = self;
    _txtDob.delegate = self;
    _txtCity.delegate = self;
    _txtreferCode.delegate = self;
    _txtSetConfirmPass.delegate = self;
    _txtSetPass.delegate = self;
    
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
    _btnChecked.layer.borderColor = [self colorWithHexString:strColor].CGColor;
    _btnChecked.layer.borderWidth = 0.5f;
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
    [_viewMainTnC setBackgroundColor:[self colorWithHexString:strColor]];
    
  /*  UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    */
    
    _showcaseView = [MNShowcaseView new];
    _showcaseView.highlightedColorDefault = [UIColor redColor];
    _showcaseView.selectionTypeDefault = MNSelection_Rectangle;
    
    i = 0;
    if (i == 0) {
        [_btnChecked setBackgroundImage:[UIImage imageNamed:@"check_empty.png"] forState:UIControlStateNormal];
    }
    else if(i == 1){
        [_btnChecked setBackgroundImage:[UIImage imageNamed:@"checked.png"] forState:UIControlStateSelected];
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
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
}

-(void) battery
{
    NSString *strError = NSLocalizedString(@"Your Phone battery is below 15%, Please put phone into charging.", @"");
    
    UIDevice *myDevice = [UIDevice currentDevice];
    [myDevice setBatteryMonitoringEnabled:YES];
    
    int state = [myDevice batteryState];
    NSLog(@"battery status: %d",state); // 0 unknown, 1 unplegged, 2 charging, 3 full
    
    double batLeft = (float)[myDevice batteryLevel] * 100;
    NSLog(@"battery left: %2f", batLeft);
    
    if (state == 1 && batLeft <= 15.0f) {
        SCLAlertView *alert = [[SCLAlertView alloc] init];
       [alert showWarning:self title:@"iBrainPowers" subTitle:strError closeButtonTitle:@"Ok" duration:0.0f];
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSMutableDictionary *dictLockAPI = [moduleLock objectForKey:@"dictLockAPI"];
    if ([[dictLockAPI valueForKey:@"moduleLock"]isEqualToString:@"1"]) {
        NSLog(@"Module id: %@",[dictLockAPI valueForKey:@"module_id"]);
        [self ApiLock];
    }else{
      //  [self apiLoadDash];
    }
}

- (void)appDidBecomeActive:(NSNotification *)notification {
    NSMutableDictionary *dictLockAPI = [moduleLock objectForKey:@"dictLockAPI"];
    if ([[dictLockAPI valueForKey:@"moduleLock"]isEqualToString:@"1"]) {
        NSLog(@"Module id: %@",[dictLockAPI valueForKey:@"module_id"]);
        [self ApiLock];
    }else{
        [self apiLoadDash];
    }
}

-(void)setUpShowcaseView
{
    NSMutableArray<MNShowcaseItem*> *arrItems = [NSMutableArray new];
    // About left button
    MNShowcaseItem *item = [[MNShowcaseItem alloc] initWithViewToFocus:_ViewCarousel title:nil description:nil];
    
    // UIView
    item = [[MNShowcaseItem alloc] initWithViewToFocus:_ViewCarousel title:nil description:@"Start to This Level"];
    item.highlightedColor = [UIColor blackColor];
    item.selectionType = MNSelection_CircleInside;
    item.buttonPosition = MNButtonPosition_BottomRight;
    item.titleColor = [UIColor whiteColor];
    item.titleFont = [UIFont boldSystemFontOfSize:22];
   // item.descriptionColor = [UIColor yellowColor];
    item.descriptionFont = [UIFont systemFontOfSize:22];
    [arrItems addObject:item];
    [_showcaseView setShowcaseItems:arrItems];
    // Set button background
    _showcaseView.button.backgroundColor = [UIColor lightGrayColor];
}

-(NSAttributedString*)getAttributedString{
    NSDictionary *bigWhiteAttrib = @{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Italic" size:30], NSForegroundColorAttributeName : [UIColor whiteColor]};
    NSDictionary *italicAttrs = @{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Italic" size:16], NSForegroundColorAttributeName : [UIColor yellowColor]};
    
    NSDictionary *defaultAttrs = @{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Medium" size:16], NSForegroundColorAttributeName : [UIColor colorWithWhite:0.5f alpha:1.0f]};
    
    NSDictionary *bigBoldAttribs = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:27], NSForegroundColorAttributeName : [UIColor greenColor]};
    
    NSDictionary *italicBlueAttrs = @{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Italic" size:16], NSForegroundColorAttributeName : [UIColor blueColor]};
    
    NSDictionary *redAttrs = @{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Italic" size:13], NSForegroundColorAttributeName : [UIColor redColor]};
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
    
    [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@"Title attributed string\n" attributes:bigWhiteAttrib]];
    
    [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@"Italic Attributed String" attributes:italicAttrs]];
    [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@" Text in normal shape " attributes:defaultAttrs]];
    [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@"Big Bold & Green" attributes:bigBoldAttribs]];
    [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@" Italic Blue" attributes:italicBlueAttrs]];
    [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@" Small Red Text" attributes:redAttrs]];
    return attributedString;
}

-(void)DOBDataSet{
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

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    [self battery];
    
    NSMutableDictionary *dictLockAPI = [moduleLock objectForKey:@"dictLockAPI"];
    if ([[dictLockAPI valueForKey:@"moduleLock"]isEqualToString:@"1"]) {
        NSLog(@"Module id: %@",[dictLockAPI valueForKey:@"module_id"]);
        [self ApiLock];
    }else{
      //  [self apiLoadDash];
    }
  
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
}

#pragma mark - keyboard movements
- (void)keyboardWillShow:(NSNotification *)notification
{
    if ([_txtChildName isFirstResponder]||[_txtEmail isFirstResponder]||[_txtCity isFirstResponder]||[_txtDob isFirstResponder]||[_txtSetConfirmPass isFirstResponder]) {
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
    [_txtreferCode resignFirstResponder];
    [self keyboardWillHide];
}

- (IBAction)dismissKeyboard:(id)sender;
{
    [_txtCity resignFirstResponder];
    [_txtEmail resignFirstResponder];
    [_txtDob resignFirstResponder];
    [_txtParentName resignFirstResponder];
    [_txtChildName resignFirstResponder];
    [_txtreferCode resignFirstResponder];
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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
        int allowedLength;
        switch(textField.tag) {
            case 1:
                allowedLength = 11;
                if (range.length == 0 &&
                    (range.location == 3 || range.location == 7)) {
                    textField.text = [NSString stringWithFormat:@"%@-%@", textField.text, string];
                    return NO;
                }
                if (range.length == 1 &&
                    (range.location == 4 || range.location == 8))  {
                    range.location--;
                    range.length = 2;
                    textField.text = [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
                break;
            case 2:
                allowedLength = 12;
                break;
            case 3:
                allowedLength = 12;
                break;
            default:
                allowedLength = 100;
                break;
        }
        
        if (textField.text.length >= allowedLength && range.length == 0) {
            return NO; // Change not allowed
        } else {
            return YES; // Change allowed
        }
    
}

- (IBAction)onEditProfileClicked:(id)sender {
    _viewCompleteProfie.hidden = NO;
  //  self.sidebarButton.enabled = NO;
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

- (void) setupSwipeGestureRecognizer {
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipedScreen:)];
    swipeGesture.direction = (UISwipeGestureRecognizerDirectionLeft | UISwipeGestureRecognizerDirectionRight);
    [self.view addGestureRecognizer:swipeGesture];
}

- (void)swipedScreen:(UISwipeGestureRecognizer*)gesture
{
    gesture.enabled = NO;
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
    _viewBackColor.hidden = NO;
    if (i1 == 1 && i2 == 1  && i3 == 1 && i4 == 1 && i5 == 1) {
        i = 1;
    }
    else{
        i = 0;
    }
    if (i == 0) {
        [_btnChecked setBackgroundImage:[UIImage imageNamed:@"check_empty.png"] forState:UIControlStateNormal];
    }
    else if(i == 1){
        [_btnChecked setBackgroundImage:[UIImage imageNamed:@"checked.png"] forState:UIControlStateSelected];
    }
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

#pragma mark - Carousel Data

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return [arrMain count];
}

- (NSInteger)numberOfVisibleItemsInCarousel:(iCarousel *)carousel
{
    //limit the number of items views loaded concurrently (for performance reasons)
    return 1;
}

-(UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view1{
    view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 180.0f, 250.0f)];
    
    view1.layer.borderWidth = 1.0f;
    view1.layer.borderColor = [UIColor lightGrayColor].CGColor;
    view1.layer.cornerRadius = 10.0f;
    
    view1.layer.masksToBounds = NO;
    view1.layer.shadowOffset = CGSizeMake(-2, 2);
    view1.layer.shadowRadius = 5;
    view1.layer.shadowOpacity = 0.5;
    
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(view1.frame.origin.x/2+50.0f, 15, 80.0f, 80.0f)];
    imgView.layer.cornerRadius = 40.0f;
    imgView.backgroundColor = [UIColor grayColor];
    [view1 addSubview:imgView];
    
    UILabel *lblLevel = [[UILabel alloc]initWithFrame:CGRectMake(view1.frame.size.width/2-100,170.0f,200.0f,20.0f)];
    
    UILabel *lblLevelName = [[UILabel alloc]initWithFrame:CGRectMake(view1.frame.size.width/2-70,110.0f,140.0f,50.0f)];
    
    lblLevelName.numberOfLines = 2;

    UILabel *lblStatus = [[UILabel alloc]initWithFrame:CGRectMake(view1.frame.origin.x/2.0f+30.0f,view1.bounds.size.height - 45.0f,120.0f,30.0f)];
    
    lblStatus.backgroundColor = [UIColor whiteColor];
    lblStatus.layer.cornerRadius = 5.0f;
    lblStatus.textAlignment = NSTextAlignmentCenter;
    lblLevel.textAlignment = NSTextAlignmentCenter;
    lblLevelName.textAlignment = NSTextAlignmentCenter;
    
    i = 0;
    if (i == 0) {
        [_btnChecked setBackgroundImage:[UIImage imageNamed:@"check_empty.png"] forState:UIControlStateNormal];
    }
    else if(i == 1){
        [_btnChecked setBackgroundImage:[UIImage imageNamed:@"checked.png"] forState:UIControlStateSelected];
    }
    
    //lblStatus.layer.backgroundColor = [self colorWithHexString:strColor].CGColor;
    lblStatus.textColor = [UIColor whiteColor];
    
    
    [view1 addSubview:lblLevelName];
    [view1 addSubview:lblStatus];
    [view1 addSubview:lblLevel];
    
    lblLevelName.text = @"TEST";
    [lblLevel setTextColor:[self colorWithHexString:strColor]];
    [lblLevel setFont:[UIFont systemFontOfSize:15]];
    [lblLevelName setFont:[UIFont systemFontOfSize:15]];
    lblStatus.layer.masksToBounds = YES;
    
    NSDictionary *dict = [arrMain objectAtIndex:index];
    lblLevelName.text = [[NSString stringWithFormat:@"%@",[dict valueForKey:@"level_name"]]uppercaseString];
    
    strLevelID = [NSString stringWithFormat:@"%@",[dict valueForKey:@"level_id"]];
    NSString *strLevelType = [NSString stringWithFormat:@"%@",[dict valueForKey:@"level_type"]];
    NSString *strLevelStatus = [NSString stringWithFormat:@"%@",[dict valueForKey:@"level_status"]];
    NSString *strCanOpen = [NSString stringWithFormat:@"%@",[dict valueForKey:@"can_open"]];
    
    NSString *strBuyNow = NSLocalizedString(@"BUY NOW", @"");
    NSString *strCompltPurchase = NSLocalizedString(@"COMPLETE PURCHASE", @"");
    NSString *strActive = NSLocalizedString(@"ACTIVE", @"");
    NSString *strComplt = NSLocalizedString(@"COMPLETED", @"");
    NSString *strLocked = NSLocalizedString(@"LOCKED", @"");
    NSString *strFree = NSLocalizedString(@"FREE", @"");
    NSString *strOPEN = NSLocalizedString(@"OPEN", @"");
    NSString *strAlreadyPurchased = NSLocalizedString(@"ALREADY PURCHASED", @"");
    
    
    if ([strHideShow isEqualToString:@"0"]) {
        lblLevel.hidden = YES;
    }
    else{
        lblLevel.hidden = NO;
    }
    
    if ([strCanOpen isEqualToString:@"0"]) {
        if ([strLevelType isEqualToString:@"0"]) {
            lblStatus.text = strBuyNow;
            imgView.image = [UIImage imageNamed:@"cartMain.png"];
            [lblStatus setBackgroundColor:[UIColor colorWithRed:120.0f/255.0f green:47.0f/255.0f blue:74.0f/255.0f alpha:1]];
            lblLevel.text = strCompltPurchase;
        }
        else if ([strLevelType isEqualToString:@"1"]) {
            lblLevel.text = strAlreadyPurchased;
            if ([strLevelStatus isEqualToString:@"0"]) {
                imgView.image = [UIImage imageNamed:@"activeMain.png"];
                lblStatus.text = strActive;
                [lblStatus setBackgroundColor:[UIColor colorWithRed:228.0f/255.0f green:174.0f/255.0f blue:114.0f/255.0f alpha:1]];
                
                NSString* documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
                NSString* Brainfile = [documentsPath stringByAppendingPathComponent:@"brain.zip"];
                BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:Brainfile];
                
                
                
                if (!fileExists) {
                    NSString  *strFreqURL = [NSString stringWithFormat:@"%@",[dict valueForKey:@"frequency"]];
                    NSString  *strFreqPass = [NSString stringWithFormat:@"%@",[dict valueForKey:@"package_id"]];
                    NSUserDefaults *userPass = [NSUserDefaults standardUserDefaults];
                    [userPass setValue:strFreqPass forKey:@"userPass"];
                    [userPass synchronize];
                    
                    [SVProgressHUD showWithStatus:@"Downloading File"];
                    
               //     self.sidebarButton.enabled = NO;
                    self.view.userInteractionEnabled = NO;
                    
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        
                        NSLog(@"Downloading Started");
                        NSURL  *url = [NSURL URLWithString:strFreqURL];
                        NSData *urlData = [NSData dataWithContentsOfURL:url];
                        NSArray   *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                        NSString  *documentsDirectory = [paths objectAtIndex:0];
                        NSString  *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,@"brain.zip"];
                        
                        NSUserDefaults *userFilePath = [NSUserDefaults standardUserDefaults];
                        [userFilePath setValue:filePath forKey:@"userFilePath"];
                        [userFilePath synchronize];
                        
                        NSLog(@"%@",filePath);
                        //saving is done on main thread
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [urlData writeToFile:filePath atomically:YES];
                            NSLog(@"File Saved !");
                            [SVProgressHUD showSuccessWithStatus:@"Downloaded Successfully"];
                            self.sidebarButton.enabled = YES;
                            self.view.userInteractionEnabled = YES;
                        });
                    });
                }
            }
            else if ([strLevelStatus isEqualToString:@"1"]) {
                imgView.image = [UIImage imageNamed:@"lockedMain.png"];
                lblStatus.text = strLocked;
                [lblStatus setBackgroundColor:[UIColor colorWithRed:225.0f/255.0f green:128.0f/255.0f blue:111.0f/255.0f alpha:1]];
            }
            else if ([strLevelStatus isEqualToString:@"2"]) {
                imgView.image = [UIImage imageNamed:@"completedMain.png"];
                lblStatus.text = strComplt;
                [lblStatus setBackgroundColor:[UIColor colorWithRed:92.0f/255.0f green:160.0f/255.0f blue:163.0f/255.0f alpha:1]];
            }
        }
        else if ([strLevelType isEqualToString:@"2"]) {
            lblLevel.text = strFree;
            if ([strLevelStatus isEqualToString:@"0"]) {
                imgView.image = [UIImage imageNamed:@"activeMain.png"];
                lblStatus.text = strActive;
                [lblStatus setBackgroundColor:[UIColor colorWithRed:228.0f/255.0f green:174.0f/255.0f blue:114.0f/255.0f alpha:1]];
                
                NSString* documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
                NSString* Brainfile = [documentsPath stringByAppendingPathComponent:@"brain.zip"];
                BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:Brainfile];
                
                if (!fileExists) {
                    NSString  *strFreqURL = [NSString stringWithFormat:@"%@",[dict valueForKey:@"frequency"]];
                    NSString  *strFreqPass = [NSString stringWithFormat:@"%@",[dict valueForKey:@"package_id"]];
                    NSUserDefaults *userPass = [NSUserDefaults standardUserDefaults];
                    [userPass setValue:strFreqPass forKey:@"userPass"];
                    [userPass synchronize];
                    
                    [SVProgressHUD showWithStatus:@"Downloading File"];
                   // self.sidebarButton.enabled = NO;
                    self.view.userInteractionEnabled = NO;
                    
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        
                        NSLog(@"Downloading Started");
                        NSURL  *url = [NSURL URLWithString:strFreqURL];
                        NSData *urlData = [NSData dataWithContentsOfURL:url];
                        NSArray   *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                        NSString  *documentsDirectory = [paths objectAtIndex:0];
                        NSString  *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,@"brain.zip"];
                        
                        NSUserDefaults *userFilePath = [NSUserDefaults standardUserDefaults];
                        [userFilePath setValue:filePath forKey:@"userFilePath"];
                        [userFilePath synchronize];
                        
                        NSLog(@"%@",filePath);
                        //saving is done on main thread
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [urlData writeToFile:filePath atomically:YES];
                            NSLog(@"File Saved !");
                            [SVProgressHUD showSuccessWithStatus:@"Downloaded Successfully"];
                            self.sidebarButton.enabled = YES;
                            self.view.userInteractionEnabled = YES;
                        });
                    });
                }
            }
            else if ([strLevelStatus isEqualToString:@"1"]) {
                imgView.image = [UIImage imageNamed:@"lockedMain.png"];
                lblStatus.text = strLocked;
                [lblStatus setBackgroundColor:[UIColor colorWithRed:225.0f/255.0f green:128.0f/255.0f blue:111.0f/255.0f alpha:1]];
            }
            else if ([strLevelStatus isEqualToString:@"2"]) {
                imgView.image = [UIImage imageNamed:@"completedMain.png"];
                lblStatus.text = strComplt;
                [lblStatus setBackgroundColor:[UIColor colorWithRed:92.0f/255.0f green:160.0f/255.0f blue:163.0f/255.0f alpha:1]];
            }
        }
    }
    else{
        lblLevel.text = strOPEN;
        imgView.image = [UIImage imageNamed:@"open.png"];
        lblStatus.text = strActive;
        [lblStatus setBackgroundColor:[UIColor colorWithRed:24.0f/255.0f green:168.0f/255.0f blue:224.0f/255.0f alpha:1]];
    }
    
    view1.layer.backgroundColor = [UIColor whiteColor].CGColor;
    [view1 addSubview:lblLevel];
    
    // UIImage *image  = [UIImage imageNamed:[arrDesigns objectAtIndex:index]];
    // ((UIImageView *)view).image = image;
    
    //[carousel setScrollSpeed:0.8f];
    //[carousel scrollToItemAtIndex:5 duration:0.5f];
    
   /* [carousel scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:10 inSection:indexPath.section]
                     atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
    */
    view1.layer.contentsScale = UIViewContentModeScaleAspectFill;
    return view1;
}

- (NSInteger)numberOfPlaceholdersInCarousel:(iCarousel *)carousel
{
    return 0;
}

- (CGFloat)carouselItemWidth:(iCarousel *)carousel
{
    return 210;
}

-(void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index
{
    NSDictionary *dict = [arrMain objectAtIndex:index];
    NSString *strLevelType = [NSString stringWithFormat:@"%@",[dict valueForKey:@"level_type"]];
    NSString *strLevelStatus = [NSString stringWithFormat:@"%@",[dict valueForKey:@"level_status"]];
    NSString *strCanOpen = [NSString stringWithFormat:@"%@",[dict valueForKey:@"can_open"]];
    
    NSString *strLocked = NSLocalizedString(@"This Level is Locked", @"");
    NSString *strComplt = NSLocalizedString(@"You have aleady completed this Level", @"");
    
    if ([strCanOpen isEqualToString:@"1"]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:[Global getStoryBoardName] bundle:nil];
        ModuleListTableViewController *modulesVC = (ModuleListTableViewController *)[storyboard instantiateViewControllerWithIdentifier:@"ModuleListTableViewController"];
        modulesVC.strLevelID = [NSString stringWithFormat:@"%@",[dict valueForKey:@"level_id"]];
        modulesVC.strLevelName = [NSString stringWithFormat:@"%@",[dict valueForKey:@"level_name"]];
        modulesVC.strLevelCanOpen = [NSString stringWithFormat:@"%@",[dict valueForKey:@"can_open"]];
        [self.navigationController pushViewController:modulesVC animated:YES];
    }
    else{
    if([strUserStatus isEqualToString:@"0"]){
        _viewCompleteProfie.hidden = NO;
     //   _sidebarButton.enabled = NO;
    }
    else{
        if ([strCanOpen isEqualToString:@"0"]) {
            if ([strLevelType isEqualToString:@"0"]) {
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:[Global getStoryBoardName] bundle:nil];
                PurchaseListViewController *purchaseVC = (PurchaseListViewController *)[storyboard instantiateViewControllerWithIdentifier:@"PurchaseListViewController"];
                
                [self.navigationController pushViewController:purchaseVC animated:YES];
            }
            else if ([strLevelType isEqualToString:@"1"]) {
                if ([strLevelStatus isEqualToString:@"0"]) {
                    
                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:[Global getStoryBoardName] bundle:nil];
                    NSUserDefaults *userSelectedDict = [NSUserDefaults standardUserDefaults];
                    [userSelectedDict setObject:dict forKey:@"userSelectedDict"];
                    [userSelectedDict synchronize];
                    
                    ModuleListTableViewController *modulesVC = (ModuleListTableViewController *)[storyboard instantiateViewControllerWithIdentifier:@"ModuleListTableViewController"];
                    modulesVC.strLevelID = [NSString stringWithFormat:@"%@",[dict valueForKey:@"level_id"]];
                    modulesVC.strLevelCanOpen = [NSString stringWithFormat:@"%@",[dict valueForKey:@"can_open"]];
                    [self.navigationController pushViewController:modulesVC animated:YES];
                    
                    
                }
                else if ([strLevelStatus isEqualToString:@"1"]) {
                    CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
                    style.messageColor = [self colorWithHexString:strColor];
                    [self.view makeToast:strLocked
                                duration:3.0
                                position:CSToastPositionBottom
                                   style:style];
                    
                    [CSToastManager setSharedStyle:style];
                    [CSToastManager setTapToDismissEnabled:YES];
                    [CSToastManager setQueueEnabled:NO];
                }
                else if ([strLevelStatus isEqualToString:@"2"]) {
                    CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
                    style.messageColor = [self colorWithHexString:strColor];
                    [self.view makeToast:strComplt
                                duration:3.0
                                position:CSToastPositionBottom
                                   style:style];
                    
                    [CSToastManager setSharedStyle:style];
                    [CSToastManager setTapToDismissEnabled:YES];
                    [CSToastManager setQueueEnabled:NO];
                }
            }
            else if ([strLevelType isEqualToString:@"2"]) {
                if ([strLevelStatus isEqualToString:@"0"]) {
                    
                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:[Global getStoryBoardName] bundle:nil];
                    NSUserDefaults *userSelectedDict = [NSUserDefaults standardUserDefaults];
                    [userSelectedDict setObject:dict forKey:@"userSelectedDict"];
                    [userSelectedDict synchronize];
                    
                    ModuleListTableViewController *modulesVC = (ModuleListTableViewController *)[storyboard instantiateViewControllerWithIdentifier:@"ModuleListTableViewController"];
                    modulesVC.strLevelID = [NSString stringWithFormat:@"%@",[dict valueForKey:@"level_id"]];
                    modulesVC.strLevelCanOpen = [NSString stringWithFormat:@"%@",[dict valueForKey:@"can_open"]];
                    [self.navigationController pushViewController:modulesVC animated:YES];
                    
                }
                else if ([strLevelStatus isEqualToString:@"1"]) {
                    CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
                    style.messageColor = [self colorWithHexString:strColor];
                    [self.view makeToast:strLocked
                                duration:3.0
                                position:CSToastPositionBottom
                                   style:style];
                    
                    [CSToastManager setSharedStyle:style];
                    [CSToastManager setTapToDismissEnabled:YES];
                    [CSToastManager setQueueEnabled:NO];
                }
                else if ([strLevelStatus isEqualToString:@"2"]) {
                    CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
                    style.messageColor = [self colorWithHexString:strColor];
                    [self.view makeToast:strComplt
                                duration:3.0
                                position:CSToastPositionBottom
                                   style:style];
                    
                    [CSToastManager setSharedStyle:style];
                    [CSToastManager setTapToDismissEnabled:YES];
                    [CSToastManager setQueueEnabled:NO];
                }
            }
        }
        else{
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:[Global getStoryBoardName] bundle:nil];
            NSUserDefaults *userSelectedDict = [NSUserDefaults standardUserDefaults];
            [userSelectedDict setObject:dict forKey:@"userSelectedDict"];
            [userSelectedDict synchronize];
            
            ModuleListTableViewController *modulesVC = (ModuleListTableViewController *)[storyboard instantiateViewControllerWithIdentifier:@"ModuleListTableViewController"];
            modulesVC.strLevelID = [NSString stringWithFormat:@"%@",[dict valueForKey:@"level_id"]];
            modulesVC.strLevelCanOpen = [NSString stringWithFormat:@"%@",[dict valueForKey:@"can_open"]];
            [self.navigationController pushViewController:modulesVC animated:YES];
        }
    }}
}

- (IBAction)onCheckedClicked:(id)sender {
    if (i == 0) {
        [_btnChecked setBackgroundImage:[UIImage imageNamed:@"checked.png"] forState:UIControlStateNormal];
        _viewMainTnC.hidden = NO;
        _viewBackColor.hidden = YES;
    }
    else if(i == 1){
        [_btnChecked setBackgroundImage:[UIImage imageNamed:@"check_empty.png"] forState:UIControlStateNormal];
    }
}

- (IBAction)onUpdateClicked:(id)sender {
    NSString *strError1 = NSLocalizedString(@"Please Fill All Details to Continue", @"");
    NSString *strError2 = NSLocalizedString(@"Please Enter Parent's Name", @"");
    NSString *strError3 = NSLocalizedString(@"Please Enter Child's Name", @"");
    NSString *strError4 = NSLocalizedString(@"Please Enter Email", @"");
    NSString *strError5 = NSLocalizedString(@"Please Enter Date of Birth of Child", @"");
    NSString *strError6 = NSLocalizedString(@"Please Enter City", @"");
    NSString *strError7 = NSLocalizedString(@"Promocode Must be 9 Digits!!!", @"");
    NSString *strError8 = NSLocalizedString(@"Password Can't be less then 8 Digits!!!", @"");
    NSString *strError9 = NSLocalizedString(@"Password and Confirm Password not matched!!!", @"");
    NSString *strError10 = NSLocalizedString(@"You must agree on Terms and Conditions to continue!!", @"");
    
    if (_txtParentName.text.length == 0 || _txtChildName.text.length == 0 || _txtEmail.text.length == 0 || _txtDob.text.length == 0 || _txtCity.text.length == 0 || _txtSetPass.text.length<8 || _txtSetConfirmPass.text.length<8 || i == 0) {
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
            [self.view makeToast:strError8
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
            [self.view makeToast:strError9
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
            [self.view makeToast:strError10
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

- (IBAction)onCloseClicked:(id)sender {
    if (i1 == 1 && i2 == 1  && i3 == 1 && i4 == 1  && i5 == 1) {
        i = 1;
    }
    else{
        i = 0;
    }
    if (i == 0) {
        [_btnChecked setBackgroundImage:[UIImage imageNamed:@"check_empty.png"] forState:UIControlStateNormal];
    }
    else if(i == 1){
        [_btnChecked setBackgroundImage:[UIImage imageNamed:@"checked.png"] forState:UIControlStateSelected];
    }
    
    _viewCompleteProfie.hidden = YES;
    self.sidebarButton.enabled = YES;
    [self dismissKeyboard];
}

#pragma mark - api calls

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

-(void)ApiLock{
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable)
    {
        [self CheckConnection];
    }
    else
    {
        NSMutableDictionary *dictLockAPI = [moduleLock objectForKey:@"dictLockAPI"];
        NSDictionary *tmp = [[NSDictionary alloc] initWithObjectsAndKeys:
                             [dictLockAPI valueForKey:@"module_id"], @"module_id",
                             nil];
        NSError* error;
        
        NSData* data = [NSJSONSerialization dataWithJSONObject:tmp options:0 error:&error];
        
        // [SVProgressHUD show];
        UserAuth = [NSUserDefaults standardUserDefaults];
        NSString *strAuth = [UserAuth valueForKey:@"UserAuth"];
        
        NSString *strUrl = [NSString stringWithFormat:@"%@",API_USER_MODULE_COMPLETE];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]init];
        request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:strUrl]];
        
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
        [request setValue:strAuth forHTTPHeaderField:@"Authorization"];
        [request setHTTPBody:data];
        
        requestHandler = [[HTTPRequestHandler alloc] initWithRequest:request delegate:self andCallBack:CALL_TYPE_USER_MODULE_COMPLETE];
        strCallType = @"lock";
    }
}

-(void)APILoadModules{
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable)
    {
        [self CheckConnection];
    }
    else
    {
        strLang = [strLang uppercaseString];
        NSDictionary *tmp = [[NSDictionary alloc] initWithObjectsAndKeys:
                             strLang, @"language",
                             strLevelID, @"level_id",
                             nil];
        NSError* error;
        NSData* data = [NSJSONSerialization dataWithJSONObject:tmp options:0 error:&error];
        
        [SVProgressHUD show];
        
        UserAuth = [NSUserDefaults standardUserDefaults];
        NSString *strAuth = [UserAuth valueForKey:@"UserAuth"];
        NSString *strUrl = [NSString stringWithFormat:@"%@",API_LOAD_MODULES];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]init];
        request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:strUrl]];
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
        [request setValue:strAuth forHTTPHeaderField:@"Authorization"];
        [request setHTTPBody:data];
        requestHandler = [[HTTPRequestHandler alloc] initWithRequest:request delegate:self andCallBack:CALL_TYPE_LOAD_MODULES];
        strCallType = @"module";
    }
}

-(void)apiLoadDash{
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable)
    {
        [self CheckConnection];
    }
    else
    {
        strLang = [strLang uppercaseString];
        NSDictionary *tmp = [[NSDictionary alloc] initWithObjectsAndKeys:
                             strLang, @"language",
                             nil];
        NSError* error;
        NSData* data = [NSJSONSerialization dataWithJSONObject:tmp options:0 error:&error];
        [SVProgressHUD show];
     //   self.sidebarButton.enabled = NO;
        UserAuth = [NSUserDefaults standardUserDefaults];
        NSString *strAuth = [UserAuth valueForKey:@"UserAuth"];
        
        NSString *strUrl = [NSString stringWithFormat:@"%@",API_LOAD_DASHBOARD];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]init];
        request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:strUrl]];
        
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
        [request setValue:strAuth forHTTPHeaderField:@"Authorization"];
        [request setHTTPBody:data];
        
        requestHandler = [[HTTPRequestHandler alloc] initWithRequest:request delegate:self andCallBack:CALL_TYPE_LOAD_DASHBOARD];
        strCallType = @"dash";
    }
}

-(void)APITerms{
    
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable)
    {
        [self CheckConnection];
    }
    else
    {
        //    self.view.userInteractionEnabled = NO;
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

-(void)APIUpdateProfile{
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable)
    {
        [self CheckConnection];
    }
    else
    {
        NSString *stringRefer = [_txtreferCode.text stringByReplacingOccurrencesOfString:@"-" withString:@""];
        
        NSDictionary *tmp = [[NSDictionary alloc]initWithObjectsAndKeys:
                             _txtParentName.text,@"parent_name",
                             _txtChildName.text,@"child_name",
                             _txtEmail.text,@"email",
                             _txtCity.text,@"city",
                             _txtDob.text,@"bithdate",
                             stringRefer,@"partner_code",
                             strSetConfirmPass,@"confirm_password",
                             strPass,@"new_password",
                             nil];
        NSError* error;
        NSData* data = [NSJSONSerialization dataWithJSONObject:tmp options:0 error:&error];
        
        [SVProgressHUD show];
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

-(void)UpdateToken{
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable)
    {
        [self CheckConnection];
    }
    else
    {
        NSString *strToken = [userFireBaseToken valueForKey:@"FireBaseToken"];
        
        
        NSDictionary *tmp = [[NSDictionary alloc] initWithObjectsAndKeys:
                             strToken, @"notification_token",
                             nil];
        NSError* error;
        
        NSData* data = [NSJSONSerialization dataWithJSONObject:tmp options:0 error:&error];
        
        // [SVProgressHUD show];
        UserAuth = [NSUserDefaults standardUserDefaults];
        NSString *strAuth = [UserAuth valueForKey:@"UserAuth"];
        
        NSString *strUrl = [NSString stringWithFormat:@"%@",API_UPDATE_TOKEN];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]init];
        request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:strUrl]];
        
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
        [request setValue:strAuth forHTTPHeaderField:@"Authorization"];
        [request setHTTPBody:data];
        
        requestHandler = [[HTTPRequestHandler alloc] initWithRequest:request delegate:self andCallBack:CALL_TYPE_UPDATE_TOKEN];
        strCallType = @"Token";
    }
}

#pragma mark - API HANDLER

- (void)parserDidFailWithError:(NSError *)error andCallType:(CallTypeEnum)callType{
    NSLog(@"%s : Error : %@",__FUNCTION__, [error localizedDescription]);
    self.sidebarButton.enabled = YES;
}

- (void)requestHandler:(HTTPRequestHandler *)requestHandler didFailedWithError:(NSError *)error andCallBack:(CallTypeEnum)callType
{
    [SVProgressHUD dismiss];
    self.sidebarButton.enabled = YES;
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
    self.sidebarButton.enabled = YES;
    self.view.userInteractionEnabled = YES;
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
                                        [self performSegueWithIdentifier:@"OutToLogin" sender:self];
                                    }];
        [alert addAction:yesButton];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
    else  {
        if ([strCallType isEqualToString:@"dash"]) {
            [_delegate parserSuccessDelegateDidFinish:jsonRes andCallType:CALL_TYPE_LOAD_DASHBOARD];
            NSLog(@"%@",jsonRes);
            self.sidebarButton.enabled = YES;
            NSString *status = [NSString stringWithFormat:@"%@",[jsonRes valueForKey:@"status"]];
            
            if ([status isEqualToString:@"1"]) {
                arrMain = [[jsonRes valueForKey:@"data"]valueForKey:@"level"];
                for (int i = 0; i < [arrMain count]; i++) {
                    NSDictionary *dict = [arrMain objectAtIndex:i];
                    NSString *strLevelType = [NSString stringWithFormat:@"%@",[dict valueForKey:@"level_type"]];
                    if ([strLevelType isEqualToString:@"0"]) {
                        NSUserDefaults *userPaid = [NSUserDefaults standardUserDefaults];
                        [userPaid setValue:strLevelType forKey:@"userPaid"];
                        [userPaid synchronize];
                        break;
                    }
                    else{
                        NSUserDefaults *userPaid = [NSUserDefaults standardUserDefaults];
                        [userPaid setValue:strLevelType forKey:@"userPaid"];
                        [userPaid synchronize];
                    }
                }
                if ([strUserStatus isEqualToString:@"0"]){
                    [self APITerms];
                }
                
                
                strUserStatus = [NSString stringWithFormat:@"%@",[[jsonRes valueForKey:@"data"]valueForKey:@"userStatus"]];
                NSLog(@"%@",arrMain);
                [_ViewCarousel reloadData];
                userFirstTime = [NSUserDefaults standardUserDefaults];
                NSInteger firsttTime = [userFirstTime integerForKey:@"userFirstTime"];
                if (firsttTime == 0) {
                    [self setUpShowcaseView];
                    [_showcaseView showOnMainWindow];
                    [userFirstTime setInteger:1 forKey:@"userFirstTime"];
                    [userFirstTime synchronize];
                }
               // [self UpdateToken];
            }else{
                SCLAlertView *alert = [[SCLAlertView alloc] init];
                [alert addButton:@"OK" actionBlock:^(void) {                
                }];
                [alert showWarning:self.parentViewController title:@"iBrainPowers" subTitle:[jsonRes valueForKey:@"message"] closeButtonTitle:nil duration:0.0f];
            }
            
        }
        else if ([strCallType isEqualToString:@"module"]) {
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
        else if([strCallType isEqualToString:@"lock"]){
            [_delegate parserSuccessDelegateDidFinish:jsonRes andCallType:CALL_TYPE_USER_MODULE_COMPLETE];
            NSLog(@"%@",jsonRes);
            
            NSString *status = [NSString stringWithFormat:@"%@",[jsonRes valueForKey:@"status"]];
            NSLog(@"%@",status);
            NSMutableDictionary *dictLockAPI = [[NSMutableDictionary alloc]init];
            [dictLockAPI setValue:@"0" forKey:@"moduleLock"];
            
            [moduleLock setObject:dictLockAPI forKey:@"dictLockAPI"];
            [moduleLock synchronize];
            
            [StepFlag setInteger:0 forKey:@"StepFlag"];
            [StepFlag synchronize];
            
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
            
            [self apiLoadDash];
        }
        else if ([strCallType isEqualToString:@"profile"]) {
            [_delegate parserSuccessDelegateDidFinish:jsonRes andCallType:CALL_TYPE_COMPLETE_PROFILE];
            NSLog(@"%@",jsonRes);
            
            NSString *status = [NSString stringWithFormat:@"%@",[jsonRes valueForKey:@"status"]];
            NSLog(@"%@",status);
            if ([status isEqualToString:@"1"]) {
                NSMutableDictionary *UserDataDict = [[NSMutableDictionary  alloc] init];
                UserDataDict = [jsonRes valueForKey:@"data"];
                UserData = [NSUserDefaults standardUserDefaults];
                [UserData setObject:UserDataDict forKey:@"UserData"];
                [UserData synchronize];
                _viewCompleteProfie.hidden = YES;
                _sidebarButton.enabled = YES;
                strUserStatus = @"1";
                
                NSUserDefaults *userProfileStatus = [NSUserDefaults standardUserDefaults];
                [userProfileStatus setValue:@"1" forKey:@"userProfileStatus"];
                [userProfileStatus synchronize];
                
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
        else if([strCallType isEqualToString:@"Token"]){
            [_delegate parserSuccessDelegateDidFinish:jsonRes andCallType:CALL_TYPE_UPDATE_TOKEN];
            NSLog(@"%@",jsonRes);
            [self apiLoadDash];
        }
    }
}

@end
