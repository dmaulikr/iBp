//
//  SupportViewController.m
//  BrainPower
//
//  Created by nestcode on 10/15/18.
//  Copyright © 2018 nestcode. All rights reserved.
//

#import "SupportViewController.h"

@interface SupportViewController ()

@end

@implementation SupportViewController{
    NSUserDefaults *ColorCode;
    NSString *strColor, *strCategory, *strCategoryID, *strDesc;
    UIPickerView *CatPickerView;
    UIToolbar *Cat_toolbar;
    NSArray *data;
    NSInteger rowIndex;
    NSUserDefaults *userLanguage, *UserAuth;
    NSString *strLang, *strCallType;
    NSMutableArray *arrCategories, *arrTickets;
    NSUserDefaults *isLogin, *Userprofileimg;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    arrTickets = [[NSMutableArray alloc]init];
    arrCategories = [[NSMutableArray alloc]init];
    
    ColorCode = [NSUserDefaults standardUserDefaults];
    strColor = [NSString stringWithFormat:@"%@",[ColorCode valueForKey:@"colorcode"]];
    
    
    isLogin = [NSUserDefaults standardUserDefaults];
    Userprofileimg = [NSUserDefaults standardUserDefaults];
    userLanguage = [NSUserDefaults standardUserDefaults];
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    _viewNotickets.hidden = YES;
    _tblTickets.hidden = YES;
    
    [self APILoadCategories];
    
    _viewCreateTicket.backgroundColor = [self colorWithHexString:strColor];
    _btnAddTickets.backgroundColor = [self colorWithHexString:strColor];
    
    _txtTitle.delegate = self;
    _txtCategories.delegate = self;
    _txtDescription.delegate = self;
    
    _btnAddTickets.layer.cornerRadius = 25.0f;
    
    _viewTitle.layer.borderWidth = 1;
    _viewDesc.layer.borderWidth = 1;
    _viewCategory.layer.borderWidth = 1;
    
    _viewTitle.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _viewDesc.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _viewCategory.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
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
    _txtCategories.inputView = CatPickerView;
    _txtCategories.inputAccessoryView = Cat_toolbar;
    
    strCategoryID = @"1";
    
    strDesc = NSLocalizedString(@"Description", @"");
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   // [self APILoadCategories];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
}

- (IBAction)done_category:(id)sender{
    _txtCategories.text = [NSString stringWithFormat:@"%@",strCategory];
    [_txtCategories resignFirstResponder];
    [self dismissKeyboard];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return arrCategories.count;
}

- (void)pickerCancel:(id)sender {
    [_txtCategories resignFirstResponder];
    [self dismissKeyboard];
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSDictionary *dict = [arrCategories objectAtIndex:row];
    strCategory = [dict valueForKey:@"category_name"];
    strCategoryID = [NSString stringWithFormat:@"%@",[dict valueForKey:@"category_id"]];
    return strCategory;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSDictionary *dict = [arrCategories objectAtIndex:row];
    strCategory = [dict valueForKey:@"category_name"];
    strCategoryID = [NSString stringWithFormat:@"%@",[dict valueForKey:@"category_id"]];
    rowIndex = row;
}


- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    if([_txtDescription.text isEqualToString:strDesc]){
        _txtDescription.text = @"";
        _txtDescription.textColor = [UIColor blackColor];
    }
    return YES;
}

-(void) textViewDidChange:(UITextView *)textView
{
    
    if(_txtDescription.text.length == 0){
        _txtDescription.textColor = [UIColor lightGrayColor];
        _txtDescription.text = strDesc;
        [_txtDescription resignFirstResponder];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        [self dismissKeyboard];
        return NO;
    }
    
    return YES;
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
    
    if(_txtDescription.text.length == 0){
        _txtDescription.textColor = [UIColor lightGrayColor];
        _txtDescription.text = strDesc;
        [_txtDescription resignFirstResponder];
    }
    [_txtDescription resignFirstResponder];
    [_txtCategories resignFirstResponder];
    [_txtTitle resignFirstResponder];
    [self keyboardWillHide];
}

- (IBAction)dismissKeyboard:(id)sender;
{
    [_txtDescription resignFirstResponder];
    [_txtCategories resignFirstResponder];
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

- (IBAction)onAddTicketClicked:(id)sender {
    _viewNotickets.hidden = NO;
}
- (IBAction)onCloseNewTicketsClicked:(id)sender {
    _viewNotickets.hidden = YES;
}

- (IBAction)onCreateTicketClicked:(id)sender {
    
    NSString *strError = NSLocalizedString(@"Please Fill All Details!!", @"");
    NSString *strError1 = NSLocalizedString(@"Please Select Category First!!", @"");
    NSString *strError2 = NSLocalizedString(@"Please Write Title First!!", @"");
    NSString *strError3 = NSLocalizedString(@"Please Write Description First!!", @"");
    
    if (_txtCategories.text.length == 0||_txtTitle.text.length == 0||_txtDescription.text.length == 0 || [_txtDescription.text isEqualToString:strDesc]) {
        if (_txtCategories.text.length == 0 && _txtTitle.text.length == 0 && _txtDescription.text.length == 0) {
            CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
            style.messageColor = [self colorWithHexString:strColor];
            [self.view makeToast:strError
                        duration:3.0
                        position:CSToastPositionBottom
                           style:style];
            
            [CSToastManager setSharedStyle:style];
            [CSToastManager setTapToDismissEnabled:YES];
            [CSToastManager setQueueEnabled:NO];
        }
        else if (_txtCategories.text.length == 0) {
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
        else if (_txtTitle.text.length == 0) {
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
        else if ([_txtDescription.text isEqualToString:strDesc]) {
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
        else if (_txtDescription.text.length == 0) {
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
    }
    else{
        [self APICreateTickets];
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrTickets.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SupportTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SupportTableViewCell" forIndexPath:indexPath];
    
    NSDictionary *dict = [arrTickets objectAtIndex:indexPath.row];
    
    cell.lblDate.text = [NSString stringWithFormat:@"%@",[dict valueForKey:@"created_on"]];
    cell.lblTitle.text = [NSString stringWithFormat:@"%@",[dict valueForKey:@"title"]];
    cell.lblCategory.text = [NSString stringWithFormat:@"%@",[dict valueForKey:@"category"]];
    NSString *strStatus = [NSString stringWithFormat:@"%@",[dict valueForKey:@"status"]];
    
    if ([strStatus isEqualToString:@"3"]) {
        cell.lblStatus.text = @"Closed";
        cell.lblStatus.textColor = [UIColor redColor];
    }
    else if ([strStatus isEqualToString:@"0"]) {
        cell.lblStatus.text = @"Created";
        cell.lblStatus.textColor = [UIColor blueColor];
    }
    else if ([strStatus isEqualToString:@"1"]) {
        cell.lblStatus.text = @"Answered";
        cell.lblStatus.textColor = [UIColor greenColor];
    }
    else if ([strStatus isEqualToString:@"2"]) {
        cell.lblStatus.text = @"Waiting";
        cell.lblStatus.textColor = [UIColor orangeColor];
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 85;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *dict = [arrTickets objectAtIndex:indexPath.row];
    NSString *strTicketID = [NSString stringWithFormat:@"%@",[dict valueForKey:@"ticket_id"]];
    
    NSUserDefaults *userTicketID = [NSUserDefaults standardUserDefaults];
    [userTicketID setValue:strTicketID forKey:@"userTicketID"];
    [userTicketID synchronize];
    
    [self performSegueWithIdentifier:@"toTickets" sender:self];
    
}



#pragma mark - API WORK

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


-(void)APILoadCategories{
    
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable)
    {
        [self CheckConnection];
    }
    else
    {
        [SVProgressHUD show];
        self.view.userInteractionEnabled = NO;
        UserAuth = [NSUserDefaults standardUserDefaults];
        NSString *strAuth = [UserAuth valueForKey:@"UserAuth"];
        
        NSString *strUrl = [NSString stringWithFormat:@"%@",API_LOAD_CATEGORIES];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]init];
        request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:strUrl]];
        
        [request setHTTPMethod:@"GET"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
        [request setValue:strAuth forHTTPHeaderField:@"Authorization"];
        [request setHTTPBody:nil];
        
        requestHandler = [[HTTPRequestHandler alloc] initWithRequest:request delegate:self andCallBack:CALL_TYPE_LOAD_CATEGORIES];
        strCallType = @"loadcategories";
    }
}

-(void)APILoadTickets{
    
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable)
    {
        [self CheckConnection];
    }
    else
    {
        [SVProgressHUD show];
        self.view.userInteractionEnabled = NO;
        UserAuth = [NSUserDefaults standardUserDefaults];
        NSString *strAuth = [UserAuth valueForKey:@"UserAuth"];
        
        NSString *strUrl = [NSString stringWithFormat:@"%@",API_LOAD_TICKETS];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]init];
        request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:strUrl]];
        
        [request setHTTPMethod:@"GET"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
        [request setValue:strAuth forHTTPHeaderField:@"Authorization"];
        [request setHTTPBody:nil];
        
        requestHandler = [[HTTPRequestHandler alloc] initWithRequest:request delegate:self andCallBack:CALL_TYPE_LOAD_TICKETS];
        strCallType = @"loadTickets";
    }
}

-(void)APICreateTickets{
    
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable)
    {
        [self CheckConnection];
    }
    else
    {
        [SVProgressHUD show];
        NSDictionary *tmp = [[NSDictionary alloc]initWithObjectsAndKeys:
                             _txtDescription.text,@"message",
                             _txtTitle.text,@"title",
                            strCategoryID,@"category_id",
                             nil];
        NSError* error;
        NSData* data = [NSJSONSerialization dataWithJSONObject:tmp options:0 error:&error];
        
        self.view.userInteractionEnabled = NO;
        UserAuth = [NSUserDefaults standardUserDefaults];
        NSString *strAuth = [UserAuth valueForKey:@"UserAuth"];
        
        NSString *strUrl = [NSString stringWithFormat:@"%@",API_CREATE_TICKETS];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]init];
        request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:strUrl]];
        
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
        [request setValue:strAuth forHTTPHeaderField:@"Authorization"];
        [request setHTTPBody:data];
        
        requestHandler = [[HTTPRequestHandler alloc] initWithRequest:request delegate:self andCallBack:CALL_TYPE_CREATE_TICKETS];
        strCallType = @"createTickets";
    }
}


#pragma mark - API HANDLER

- (void)parserDidFailWithError:(NSError *)error andCallType:(CallTypeEnum)callType{
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

- (void)requestHandler:(HTTPRequestHandler *)requestHandler didFailedWithError:(NSError *)error andCallBack:(CallTypeEnum)callType
{
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"Error"
                                 message:@"Something went wrong!!, Please try again"
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
    self.view.userInteractionEnabled = YES;
    NSString *response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *jsonRes = [response JSONValue];
    
    if ([[jsonRes valueForKey:@"message"] isEqualToString:@"Unauthenticated."]) {
        
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
        if ([strCallType isEqualToString:@"loadcategories"]) {
            [_delegate parserSuccessDelegateDidFinish:jsonRes andCallType:CALL_TYPE_LOAD_CATEGORIES];
            NSLog(@"%@",jsonRes);
            NSString *strStatus = [NSString stringWithFormat:@"%@",[jsonRes valueForKey:@"status"]];
            
            if ([strStatus isEqualToString:@"1"]) {
                arrCategories = [jsonRes valueForKey:@"data"];
                
                [self APILoadTickets];
                
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
        else if ([strCallType isEqualToString:@"loadTickets"]) {
            [_delegate parserSuccessDelegateDidFinish:jsonRes andCallType:CALL_TYPE_LOAD_TICKETS];
            NSLog(@"%@",jsonRes);
            NSString *strStatus = [NSString stringWithFormat:@"%@",[jsonRes valueForKey:@"status"]];
            if ([strStatus isEqualToString:@"1"]) {
                arrTickets = [jsonRes valueForKey:@"data"];
                
                if (arrTickets.count == 0) {
                    _tblTickets.hidden = YES;
                }
                else{
                    _tblTickets.hidden = NO;
                }
                
                [_tblTickets reloadData];
                
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
        else if ([strCallType isEqualToString:@"createTickets"]) {
            [_delegate parserSuccessDelegateDidFinish:jsonRes andCallType:CALL_TYPE_LOAD_TICKETS];
            NSLog(@"%@",jsonRes);
            NSString *strStatus = [NSString stringWithFormat:@"%@",[jsonRes valueForKey:@"status"]];
            if ([strStatus isEqualToString:@"1"]) {
                _viewNotickets.hidden = YES;
                [self APILoadTickets];
                
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
