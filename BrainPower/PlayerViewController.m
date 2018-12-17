//
//  PlayerViewController.m
//  BrainPower
//
//  Created by nestcode on 1/17/18.
//  Copyright © 2018 nestcode. All rights reserved.
//

#import "PlayerViewController.h"

@interface PlayerViewController ()

@end

@implementation PlayerViewController{
    NSString *strMusic;
    NSMutableArray *arrMusic;
    NSTimer *timer;
    NSUserDefaults *StepFlag;//, *index;
    NSInteger flag, indexNo;
    NSUserDefaults *ColorCode, *userMusicPath;
    NSString *strColor;
    NSString *strURL;
    SCLAlertView *alert1;
    NSUserDefaults *userSelectedDict;
    NSDictionary *dictSelected;
}

@synthesize FlagModule;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    alert1 = [[SCLAlertView alloc] init];
    
    _BackGifImageView.hidden = YES;
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"AppSplash" withExtension:@"gif"];
    _BackGifImageView.image = [UIImage animatedImageWithAnimatedGIFData:[NSData dataWithContentsOfURL:url]];
    
    _lblAirPlaneMsgtoParents.hidden = YES;
    
    self.timeCircle.delegate = self;
    self.timeCircle.active = YES;
    
    _lblLiveTime.hidden = YES;
    _lblTotalTime.hidden = YES;
    
    ColorCode = [NSUserDefaults standardUserDefaults];
    strColor = [NSString stringWithFormat:@"%@",[ColorCode valueForKey:@"colorcode"]];
    
    userMusicPath = [NSUserDefaults standardUserDefaults];
    
   // [self.timeCircle setActiveColor:[self colorWithHexString:strColor]];
   // [self.timeCircle setPauseColor:[UIColor redColor]];
    
    UIImage *Play = [UIImage imageWithContentsOfFile:[[[NSBundle mainBundle] bundlePath] stringByAppendingString:@"/play.png"]];
    UIImage *Pause = [UIImage imageWithContentsOfFile:[[[NSBundle mainBundle] bundlePath] stringByAppendingString:@"/pause.png"]];
    
    _btnStart.selected = NO;
    [_btnStart setImage:Pause forState:UIControlStateNormal];
    [_btnStart setImage:Play forState:UIControlStateSelected];
    
    userSelectedDict = [NSUserDefaults standardUserDefaults];
    dictSelected = [userSelectedDict objectForKey:@"userSelectedDict"];
    
    arrMusic = [[NSMutableArray alloc]init];
    NSLog(@"Part Data: %@",_dictPartData);
    
    StepFlag = [NSUserDefaults standardUserDefaults];
    flag = [StepFlag integerForKey:@"StepFlag"];
    
  //  index = [NSUserDefaults standardUserDefaults];
  //  indexNo = [index integerForKey:@"indexPath"];
    
    NSLog(@"index: %d",_arrCount);
    
   
    strURL = [NSString stringWithFormat:@"%@",[_dictPartData valueForKey:@"part_file"]];
    
    
    if (_isAirPlaneReq == 1) {
        if (_index == _arrCount-1){
            
            _lblTotalTime.text = [NSString stringWithFormat:@"%d:%d",currMinute,currSeconds];
            _lblLiveTime.text = [NSString stringWithFormat:@"%d:%d",currMinute,currSeconds];
            _lblLiveTime.hidden = NO;
            _lblTotalTime.hidden = NO;
            _btnStart.hidden = YES;
            _lblAirPlaneMsgtoParents.hidden = NO;
            _viewVideoPlayer.hidden = NO;
            _MainMusic.delegate = self;
            
            [[self navigationController] setNavigationBarHidden:YES animated:YES];
            NSURL *MusicPath = [userMusicPath URLForKey:@"UnZipPath"];
            
            _MainMusic = [[AVAudioPlayer alloc] initWithContentsOfURL:MusicPath
                                                                    error:nil];
            
            int seconds = _MainMusic.duration;
            NSString *strTime = [dictSelected valueForKey:@"count"];
            int count = [strTime intValue];
            seconds = seconds * count;
            currSeconds = seconds % 60; //Frequency Last Music
            currMinute = seconds / 60;
            remainMinute = currMinute - 2;
            remainSeconds = 59;
            
            _lblTotalTime.text = [NSString stringWithFormat:@"%d:%d",currMinute,currSeconds];
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioHardwareRouteChanged:)
                                                         name:AVAudioSessionRouteChangeNotification
                                                       object:nil];
            _BackGifImageView.hidden = NO;
            self.MainMusic.numberOfLoops = 7;
            
            
        }else{
            
            if ([[_dictPartData valueForKey:@"part_type"] isEqualToString:@"video"]) {
                _viewVideoPlayer.hidden = YES;
                [[self navigationController] setNavigationBarHidden:NO animated:YES];
                CGFloat width = [UIScreen mainScreen].bounds.size.width;
                _playerView = [[GUIPlayerView alloc] initWithFrame:CGRectMake(0, (self.view.frame.size.height/2)- (width * 9.0f / 32.0f), width, width * 9.0f / 16.0f)];
                [_playerView setDelegate:self];
                [self.view addSubview:_playerView];
                _viewVideoPlayer.hidden = YES;
                NSURL *URL = [NSURL URLWithString:strURL];
                [_playerView setVideoURL:URL];
                [_playerView prepareAndPlayAutomatically:YES];
            }
            else{
                [[self navigationController] setNavigationBarHidden:YES animated:YES];
                _BackGifImageView.hidden = NO;
                _viewVideoPlayer.hidden = NO;
                _MainMusic.delegate = self;
                _lblLiveTime.hidden = NO;
                _lblTotalTime.hidden = NO;
                NSURL *URL = [NSURL URLWithString:strURL];
                NSData *data = [NSData dataWithContentsOfURL:URL];
                NSError *error;
                _MainMusic = [[AVAudioPlayer alloc] initWithData:data error:&error];
                
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioHardwareRouteChanged:)
                                                             name:AVAudioSessionRouteChangeNotification
                                                           object:nil];
                int seconds = _MainMusic.duration;
                currSeconds = seconds % 60;
                currMinute = seconds / 60;
                remainMinute = currMinute - 2;
                remainSeconds = 59;
                _lblTotalTime.text = [NSString stringWithFormat:@"%d:%d",currMinute,currSeconds];
            }
        }
    }
    else{
        if ([[_dictPartData valueForKey:@"part_type"] isEqualToString:@"video"]) {
            _viewVideoPlayer.hidden = YES;
            [[self navigationController] setNavigationBarHidden:NO animated:YES];
            CGFloat width = [UIScreen mainScreen].bounds.size.width;
            _playerView = [[GUIPlayerView alloc] initWithFrame:CGRectMake(0, (self.view.frame.size.height/2)- (width * 9.0f / 32.0f), width, width * 9.0f / 16.0f)];
            [_playerView setDelegate:self];
            [self.view addSubview:_playerView];
            
            _viewVideoPlayer.hidden = YES;
            NSURL *URL = [NSURL URLWithString:strURL];
            [_playerView setVideoURL:URL];
            [_playerView prepareAndPlayAutomatically:YES];
        }
        else{
           [[self navigationController] setNavigationBarHidden:YES animated:YES];
            _BackGifImageView.hidden = NO;
            
            _viewVideoPlayer.hidden = NO;
            _MainMusic.delegate = self;
    
            _lblLiveTime.hidden = NO;
            _lblTotalTime.hidden = NO;
            
            NSURL *URL = [NSURL URLWithString:strURL];
            NSData *data = [NSData dataWithContentsOfURL:URL];
            NSError *error;
            _MainMusic = [[AVAudioPlayer alloc] initWithData:data error:&error];
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioHardwareRouteChanged:)
                                                         name:AVAudioSessionRouteChangeNotification
                                                       object:nil];
            
            int seconds = _MainMusic.duration;
            
            currSeconds = seconds % 60;
            
            currMinute = seconds / 60;
            
            _lblTotalTime.text = [NSString stringWithFormat:@"%d:%d",currMinute,currSeconds];
            
            _lblLiveTime.text = [NSString stringWithFormat:@"%d:%d",currMinute,currSeconds];
            
            
        }
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSString *strMessage = NSLocalizedString(@"Please do not press back button, home button or unplug headphone.", @"");
    
    if (_isAirPlaneReq == 1) {
        if (_index == _arrCount-1){
            SCLAlertView *alert = [[SCLAlertView alloc] init];
            alert.customViewColor = [self colorWithHexString:strColor];
            [alert addButton:@"OK" actionBlock:^(void) {
                timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
                [self TimerStart:(currMinute*60)+17];
                [self.MainMusic play];
            }];
            [alert showWarning:self title:@"iBrainPowers" subTitle:strMessage closeButtonTitle:nil duration:0.0f];
        }
        else{
            if ([[_dictPartData valueForKey:@"part_type"] isEqualToString:@"video"]) {
                
            }
            else{
                SCLAlertView *alert = [[SCLAlertView alloc] init];
                alert.customViewColor = [self colorWithHexString:strColor];
                
                [alert addButton:@"OK" actionBlock:^(void) {
                    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
                    [self TimerStart:(currMinute*60)+currSeconds];
                    [self.MainMusic play];
                }];
                [alert showWarning:self title:@"iBrainPowers" subTitle:strMessage closeButtonTitle:nil duration:0.0f];
            }
        }
    }
    else{
        if ([[_dictPartData valueForKey:@"part_type"] isEqualToString:@"video"]) {
            
        }
        else{
            SCLAlertView *alert = [[SCLAlertView alloc] init];
            //   alert.customViewColor = [self colorWithHexString:strColor];
            
            [alert addButton:@"OK" actionBlock:^(void) {
                timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
                [self TimerStart:(currMinute*60)+currSeconds];
                [self.MainMusic play];
            }];
            [alert showWarning:self title:@"iBrainPowers" subTitle:strMessage closeButtonTitle:nil duration:0.0f];
        }
    }
}

-(void)timerFired
{
    NSString *strMessage = NSLocalizedString(@"Please disable phone to Airplane Mode.", @"");
    
    _lblLiveTime.text = [NSString stringWithFormat:@"%d:%d",currMinute,currSeconds];
    
    if((currMinute>0 || currSeconds>=0) && currMinute>=0)
    {
        if(currSeconds==0)
        {
            currMinute-=1;
            currSeconds=59;
        }
        else if(currSeconds>0)
        {
            currSeconds-=1;
        }
        if (flag == _ModuleCounts-1 || FlagModule == _ModuleCounts-1) {
        if (currMinute == remainMinute && currSeconds == 59) {
            NSUserDefaults *moduleLock = [NSUserDefaults standardUserDefaults];
          
            NSMutableDictionary *dictLockAPI = [[NSMutableDictionary alloc]init];
            [dictLockAPI setValue:_strModuleID forKey:@"module_id"];
            [dictLockAPI setValue:@"1" forKey:@"moduleLock"];
            
            [moduleLock setObject:dictLockAPI forKey:@"dictLockAPI"];
            [moduleLock synchronize];
            
            [StepFlag setInteger:0 forKey:@"StepFlag"];
            [StepFlag synchronize];
            
            NSLog(@"2 Minutes");
        }}
        
        if (currMinute == 00 && currSeconds == 00) {
            
            _lblLiveTime.text = @"00:00";
           [[self navigationController] setNavigationBarHidden:NO animated:YES];
            if (_isAirPlaneReq == 1){
            if (FlagModule == _ModuleCounts-1) {
                [self.MainMusic stop];
                
                NSUserDefaults *moduleLock = [NSUserDefaults standardUserDefaults];
                
                NSMutableDictionary *dictLockAPI = [[NSMutableDictionary alloc]init];
                [dictLockAPI setValue:_strModuleID forKey:@"module_id"];
                [dictLockAPI setValue:@"1" forKey:@"moduleLock"];
                
                [moduleLock setObject:dictLockAPI forKey:@"dictLockAPI"];
                [moduleLock synchronize];
                
                
                [StepFlag setInteger:0 forKey:@"StepFlag"];
                [StepFlag synchronize];
                
                SCLAlertView *alert = [[SCLAlertView alloc] init];
                [alert addButton:@"OK" actionBlock:^(void) {
                    
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }];
                [alert showWarning:self title:@"iBrainPowers" subTitle:strMessage closeButtonTitle:nil duration:0.0f];
            }
            else{
                [self.MainMusic stop];
                
                NSUserDefaults *moduleLock = [NSUserDefaults standardUserDefaults];
                
                NSMutableDictionary *dictLockAPI = [[NSMutableDictionary alloc]init];
                [dictLockAPI setValue:_strModuleID forKey:@"module_id"];
                [dictLockAPI setValue:@"1" forKey:@"moduleLock"];
                [moduleLock setObject:dictLockAPI forKey:@"dictLockAPI"];
                [moduleLock synchronize];
                
                [StepFlag setInteger:0 forKey:@"StepFlag"];
                [StepFlag synchronize];
                
                SCLAlertView *alert = [[SCLAlertView alloc] init];
                [alert addButton:@"OK" actionBlock:^(void) {
                    
                    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
                }];
                [alert showWarning:self title:@"iBrainPowers" subTitle:strMessage closeButtonTitle:nil duration:0.0f];
            }
        }
            else{
                if (flag == _ModuleCounts-1) {
                    [self.MainMusic stop];
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }
                else if ([[_dictPartData valueForKey:@"part_type"] isEqualToString:@"audio"]){
                    [self.navigationController popViewControllerAnimated:YES];
                }
                else{
                    [self.MainMusic stop];
                    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
                }
            }
        }
    }
    else
    {
        [timer invalidate];
        timer = nil;
    }
}

-(void)TimerStart:(int )time
{
    self.timeCircle.totalTime = time;
    self.timeCircle.elapsedTime = 0;
    [self.timeCircle start];
}



-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    if ([_strLevelCanOpen isEqualToString:@"1"]){}
    else{
    
    if (flag == _index) {
        if (_index == _arrCount-1) {
            NSUserDefaults *moduleLock = [NSUserDefaults standardUserDefaults];
            
            NSMutableDictionary *dictLockAPI = [[NSMutableDictionary alloc]init];
            [dictLockAPI setValue:_strModuleID forKey:@"module_id"];
            [dictLockAPI setValue:@"1" forKey:@"moduleLock"];
            
            [moduleLock setObject:dictLockAPI forKey:@"dictLockAPI"];
            [moduleLock synchronize];
            
            [StepFlag setInteger:0 forKey:@"StepFlag"];
            [StepFlag synchronize];
            
         //   UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main"bundle:nil];
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
        }
        else{
        flag = flag+1;
        [StepFlag setInteger:flag forKey:@"StepFlag"];
        [StepFlag synchronize];
        }
    }else{
        
    }
    
    if (self.isMovingFromParentViewController) {
        [_playerView stop];
    }
}
    [_playerView stop];
    [_playerView pause];
    [_playerView clean];
    [self.MainMusic stop];
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

- (void)audioHardwareRouteChanged:(NSNotification *)notification
{
    
    NSString *strMessage = NSLocalizedString(@"Please connect HeadPhones to continue!!", @"");
   // SCLAlertView *alert = [[SCLAlertView alloc] init];
    
    UIImage *Play = [UIImage imageWithContentsOfFile:[[[NSBundle mainBundle] bundlePath] stringByAppendingString:@"/play.png"]];
    UIImage *Pause = [UIImage imageWithContentsOfFile:[[[NSBundle mainBundle] bundlePath] stringByAppendingString:@"/pause.png"]];
    
    [_btnStart setImage:Pause forState:UIControlStateNormal];
    [_btnStart setImage:Play forState:UIControlStateSelected];
    
    NSInteger routeChangeReason = [notification.userInfo[AVAudioSessionRouteChangeReasonKey] integerValue];
    if (routeChangeReason == AVAudioSessionRouteChangeReasonOldDeviceUnavailable)
    {
        [_MainMusic stop];
        [self pauseTimer];
        [self.timeCircle stop];
        _btnStart.selected = YES;
        [_btnStart setImage:Play forState:UIControlStateSelected];
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:nil
                                     message:strMessage
                                     preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"OK"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {
                                        //Handle your yes please button action here
                                    }];
        [alert addAction:yesButton];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else if(routeChangeReason == AVAudioSessionRouteChangeReasonRouteConfigurationChange){
        NSLog(@"airpods removed");
    }
    else
    {
        [_MainMusic play];
        [self start];
        [self.timeCircle start];
        _btnStart.selected = NO;
        [_btnStart setImage:Pause forState:UIControlStateNormal];
    }
}

- (void) onAudioSessionEvent: (NSNotification *) notification
{
    if ([notification.name isEqualToString:AVAudioSessionInterruptionNotification]) {
        NSLog(@"Interruption notification received!");
        
        if ([[notification.userInfo valueForKey:AVAudioSessionInterruptionTypeKey] isEqualToNumber:[NSNumber numberWithInt:AVAudioSessionInterruptionTypeBegan]]) {
            NSLog(@"Interruption began!");
            [_MainMusic pause];
        }
        else {
            NSLog(@"Interruption ended!");
            [_MainMusic play];
        }
    }
}

#pragma mark - GUI Player View Delegate Methods

- (void)playerWillEnterFullscreen {
    [[self navigationController] setNavigationBarHidden:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
}

- (void)playerWillLeaveFullscreen {
    [[self navigationController] setNavigationBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
}

- (void)playerDidEndPlaying {
    [_playerView stop];
    [_playerView pause];
    [_playerView clean];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    if (_index == _arrCount) {
        NSUserDefaults *moduleLock = [NSUserDefaults standardUserDefaults];
        [moduleLock setValue:@"1" forKey:@"moduleLock"];
        [moduleLock synchronize];
        NSUserDefaults *goback = [NSUserDefaults standardUserDefaults];
        [goback setValue:@"1" forKey:@"goback"];
        [goback synchronize];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)playerFailedToPlayToEnd {
    NSLog(@"Error: could not play video");
    [_playerView clean];
}

- (IBAction)onPlayPauseClicked:(id)sender {
    if (_btnStart.selected == YES) {
        _btnStart.selected = NO;
        [self.MainMusic play];
        [self start];
        [self.timeCircle start];
    }
    else{
        _btnStart.selected = YES;
        [self.MainMusic pause];
        [self pauseTimer];
        [self.timeCircle stop];
    }
}

-(void)start{
    [_MainMusic play];
    timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
}

-(void) pauseTimer {
    [timer invalidate];
    timer = nil;
    //timerElapsed = [[NSDate date] timeIntervalSinceDate:timerStarted];
}

@end
