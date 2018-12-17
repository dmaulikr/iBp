//
//  SupportChatViewController.m
//  BrainPower
//
//  Created by nestcode on 10/15/18.
//  Copyright © 2018 nestcode. All rights reserved.
//

#import "SupportChatViewController.h"

static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 162;
CGFloat animatedDistance;

@interface SupportChatViewController ()

@end

@implementation SupportChatViewController{
    NSUserDefaults *userTicketID;
    NSString *strTicketID;
    NSUserDefaults *ColorCode;
    NSString *strColor, *strCategory, *strCategoryID, *strDesc;
    NSArray *data;
    NSInteger rowIndex;
    NSUserDefaults *userLanguage, *UserAuth;
    NSString *strLang, *strCallType;
    NSMutableArray *arrTicketDetails;
    NSArray *arrTicket;
    NSUserDefaults *isLogin, *Userprofileimg;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    arrTicketDetails = [[NSMutableArray alloc]init];
    arrTicket = [[NSArray alloc]init];
    
    ColorCode = [NSUserDefaults standardUserDefaults];
    strColor = [NSString stringWithFormat:@"%@",[ColorCode valueForKey:@"colorcode"]];
    
    userTicketID = [NSUserDefaults standardUserDefaults];
    strTicketID = [NSString stringWithFormat:@"%@",[userTicketID valueForKey:@"userTicketID"]];
    
    isLogin = [NSUserDefaults standardUserDefaults];
    Userprofileimg = [NSUserDefaults standardUserDefaults];
    userLanguage = [NSUserDefaults standardUserDefaults];
    
    _viewCloseTicket.hidden = YES;
    _txtEnterMessage.delegate = self;
    
    _tblSupportChat.estimatedRowHeight = 50;//the estimatedRowHeight but if is more this autoincremented with autolayout
    self.tblSupportChat.rowHeight = UITableViewAutomaticDimension;
    [self.tblSupportChat setNeedsLayout];
    [self.tblSupportChat layoutIfNeeded];
    
    _viewAboutTickets.backgroundColor = [self colorWithHexString:strColor];
    
    [self APILoadTicketDetails];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // [self APILoadCategories];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
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

#pragma mark - keyboard movements
- (void)keyboardWillShow:(NSNotification *)notification
{
  /*  CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect f = self.view.frame;
        f.origin.y = -keyboardSize.height;
        [self.view setFrame:CGRectMake(0,-110,self.view.frame.size.width,self.view.frame.size.height)];
    }];
    _bottomDistanceTextField.constant = -110;*/

}

-(BOOL) textFieldShouldBeginEditing:(UITextField*)textField
{
    CGRect textFieldRect = [self.view.window convertRect:textField.bounds fromView:textField];
    CGRect viewRect = [self.view.window convertRect:self.view.bounds fromView:self.view];
    CGFloat midline = textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
    CGFloat numerator =  midline - viewRect.origin.y  - MINIMUM_SCROLL_FRACTION * viewRect.size.height;
    CGFloat denominator = (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION)
    * viewRect.size.height;
    CGFloat heightFraction = numerator / denominator;
    if (heightFraction < 0.0)
    {
        heightFraction = 0.0;
    }
    else if (heightFraction > 1.0)
    {
        heightFraction = 1.0;
    }
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait ||
        orientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
    }
    else
    {
        animatedDistance = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
    }
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y -= animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    [self.view setFrame:viewFrame];
    [UIView commitAnimations];
    return YES;
}
/*
- (BOOL) textFieldShouldEndEditing:(UITextField*)textField
{
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    [self.view setFrame:viewFrame];
    [UIView commitAnimations];
    return YES;
}
*/

-(void)dismissKeyboard {
    [_txtEnterMessage resignFirstResponder];
    [self keyboardWillHide];
}

- (IBAction)dismissKeyboard:(id)sender;
{
    [_txtEnterMessage resignFirstResponder];
    _bottomDistanceTextField.constant = 0;
}

-(void)keyboardWillHide
{
    _bottomDistanceTextField.constant = 0;
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrTicket.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SupportChatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SupportChatTableViewCell" forIndexPath:indexPath];
    
    NSDictionary *dict = [arrTicket objectAtIndex:indexPath.row];
    NSString *strType = [NSString stringWithFormat:@"%@",[dict valueForKey:@"answer_type"]];
    if ([strType isEqualToString:@"1"]) {
        cell.viewReceived.hidden = NO;
        cell.viewSent.hidden = YES;
        cell.lblReceived.text = [dict valueForKey:@"message"];
        cell.lblTimeReceived.text = [dict valueForKey:@"created_on"];
    }
    else if ([strType isEqualToString:@"0"]) {
        cell.viewReceived.hidden = YES;
        cell.viewSent.hidden = NO;
        cell.lblSent.text = [dict valueForKey:@"message"];
        cell.lblTimeSent.text = [dict valueForKey:@"created_on"];
    }
    
    return cell;
}
/*
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65;
}*/


- (IBAction)onCloseClicked:(id)sender {
    _viewCloseTicket.hidden = NO;
}

- (IBAction)onCloseTicketClicked:(id)sender {
    [self APICloseTickets];
}

- (IBAction)onCancelClicked:(id)sender {
    _viewCloseTicket.hidden = YES;
}

- (IBAction)onSendClicked:(id)sender {
    NSString *strAlert = NSLocalizedString(@"Please Enter Mesage!!", @"");
    if (_txtEnterMessage.text.length == 0) {
        CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
        style.messageColor = [self colorWithHexString:strColor];
        [self.view makeToast:strAlert
                    duration:3.0
                    position:CSToastPositionBottom
                       style:style];
        
        [CSToastManager setSharedStyle:style];
        [CSToastManager setTapToDismissEnabled:YES];
        [CSToastManager setQueueEnabled:NO];
    }
    else{
        [self keyboardWillHide];
        [_txtEnterMessage resignFirstResponder];
        [self APISendMessage];
    }
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
    //  [SVProgressHUD dismiss];
    self.view.userInteractionEnabled = YES;
}


-(void)APILoadTicketDetails{
    
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable)
    {
        [self CheckConnection];
    }
    else
    {
        NSDictionary *tmp = [[NSDictionary alloc]initWithObjectsAndKeys:
                             strTicketID,@"ticket_id",
                             nil];
        NSError* error;
        NSData* data = [NSJSONSerialization dataWithJSONObject:tmp options:0 error:&error];
        
        self.view.userInteractionEnabled = NO;
        UserAuth = [NSUserDefaults standardUserDefaults];
        NSString *strAuth = [UserAuth valueForKey:@"UserAuth"];
        
        NSString *strUrl = [NSString stringWithFormat:@"%@",API_LOAD_TICKET_DETAILS];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]init];
        request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:strUrl]];
        
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
        [request setValue:strAuth forHTTPHeaderField:@"Authorization"];
        [request setHTTPBody:data];
        
        requestHandler = [[HTTPRequestHandler alloc] initWithRequest:request delegate:self andCallBack:CALL_TYPE_LOAD_TICKETS_DETAILS];
        strCallType = @"load";
    }
}

-(void)APISendMessage{
    
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable)
    {
        [self CheckConnection];
    }
    else
    {
        NSDictionary *tmp = [[NSDictionary alloc]initWithObjectsAndKeys:
                             strTicketID,@"ticket_id",
                             _txtEnterMessage.text,@"message",
                             nil];
        NSError* error;
        NSData* data = [NSJSONSerialization dataWithJSONObject:tmp options:0 error:&error];
        self.view.userInteractionEnabled = NO;
        UserAuth = [NSUserDefaults standardUserDefaults];
        NSString *strAuth = [UserAuth valueForKey:@"UserAuth"];
        
        NSString *strUrl = [NSString stringWithFormat:@"%@",API_RESPONSE_TICKETS];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]init];
        request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:strUrl]];
        
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
        [request setValue:strAuth forHTTPHeaderField:@"Authorization"];
        [request setHTTPBody:data];
        
        requestHandler = [[HTTPRequestHandler alloc] initWithRequest:request delegate:self andCallBack:CALL_TYPE_RESPONSE_TICKETS];
        strCallType = @"send";
    }
}

-(void)APICloseTickets{
    
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable)
    {
        [self CheckConnection];
    }
    else
    {
        
        NSDictionary *tmp = [[NSDictionary alloc]initWithObjectsAndKeys:
                             strTicketID,@"ticket_id",
                             nil];
        NSError* error;
        NSData* data = [NSJSONSerialization dataWithJSONObject:tmp options:0 error:&error];
        
        self.view.userInteractionEnabled = NO;
        UserAuth = [NSUserDefaults standardUserDefaults];
        NSString *strAuth = [UserAuth valueForKey:@"UserAuth"];
        
        NSString *strUrl = [NSString stringWithFormat:@"%@",API_DELETE_TICKETS];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]init];
        request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:strUrl]];
        
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
        [request setValue:strAuth forHTTPHeaderField:@"Authorization"];
        [request setHTTPBody:data];
        
        requestHandler = [[HTTPRequestHandler alloc] initWithRequest:request delegate:self andCallBack:CALL_TYPE_DELETE_TICKETS];
        strCallType = @"delete";
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
        if ([strCallType isEqualToString:@"load"]) {
            [_delegate parserSuccessDelegateDidFinish:jsonRes andCallType:CALL_TYPE_LOAD_TICKETS_DETAILS];
            NSLog(@"%@",jsonRes);
            NSString *strStatus = [NSString stringWithFormat:@"%@",[jsonRes valueForKey:@"status"]];
            
            if ([strStatus isEqualToString:@"1"]) {
                self.title = [[jsonRes valueForKey:@"data"] valueForKey:@"title"];
                
                NSString *strStatus = [NSString stringWithFormat:@"%@",[[jsonRes valueForKey:@"data"] valueForKey:@"status"]];
                
                if ([strStatus isEqualToString:@"3"]) {
                    _btnCloseTicket.enabled = NO;
                    _viewEnterMessage.hidden = YES;
                    _bottomHeight.constant = 0.0f;
                    _viewCloseTicket.hidden = YES;
                }
                
                arrTicket = [[jsonRes valueForKey:@"data"]valueForKey:@"message"];
              //  arrTicket = arrTicket.reverseObjectEnumerator.allObjects;
                
                [_tblSupportChat reloadData];
                
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
        else if ([strCallType isEqualToString:@"send"]) {
            [_delegate parserSuccessDelegateDidFinish:jsonRes andCallType:CALL_TYPE_RESPONSE_TICKETS];
             NSString *strPlaceholder = NSLocalizedString(@"Enter Message", @"");
            
            NSLog(@"%@",jsonRes);
            NSString *strStatus = [NSString stringWithFormat:@"%@",[jsonRes valueForKey:@"status"]];
            if ([strStatus isEqualToString:@"1"]) {
                CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
                style.messageColor = [self colorWithHexString:strColor];
                [self.view makeToast:[jsonRes valueForKey:@"message"]
                            duration:3.0
                            position:CSToastPositionBottom
                               style:style];
                
                [CSToastManager setSharedStyle:style];
                [CSToastManager setTapToDismissEnabled:YES];
                [CSToastManager setQueueEnabled:NO];
                _txtEnterMessage.text = @"";
                _txtEnterMessage.placeholder = strPlaceholder;
                [self APILoadTicketDetails];
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
        else if ([strCallType isEqualToString:@"delete"]) {
            [_delegate parserSuccessDelegateDidFinish:jsonRes andCallType:CALL_TYPE_DELETE_TICKETS];
            NSLog(@"%@",jsonRes);
            NSString *strStatus = [NSString stringWithFormat:@"%@",[jsonRes valueForKey:@"status"]];
            if ([strStatus isEqualToString:@"1"]) {
                CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
                style.messageColor = [self colorWithHexString:strColor];
                [self.view makeToast:[jsonRes valueForKey:@"message"]
                            duration:3.0
                            position:CSToastPositionBottom
                               style:style];
                
                [CSToastManager setSharedStyle:style];
                [CSToastManager setTapToDismissEnabled:YES];
                [CSToastManager setQueueEnabled:NO];
                
                _btnCloseTicket.enabled = NO;
                
                _viewEnterMessage.hidden = YES;
                _bottomHeight.constant = 0.0f;
                _viewCloseTicket.hidden = YES;
                
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
