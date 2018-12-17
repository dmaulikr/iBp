//
//  PlayerViewController.h
//  BrainPower
//
//  Created by nestcode on 1/17/18.
//  Copyright © 2018 nestcode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GUIPlayerView.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "ModuleListTableViewController.h"
#import "CircleTimer.h"
#import "HomeViewController.h"
#import "UIImage+animatedGIF.h"

@interface PlayerViewController : UIViewController<GUIPlayerViewDelegate,AVAudioPlayerDelegate,CircleTimerDelegate>{
    int currMinute, remainMinute;
    int currSeconds, remainSeconds;
}

@property (strong, nonatomic) GUIPlayerView *playerView;

@property(nonatomic, strong) AVAudioPlayer *MainMusic;


@property (weak, nonatomic) IBOutlet UIView *viewVideoPlayer;

@property (weak, nonatomic) IBOutlet UISlider *sliderMusicDuration;

@property (strong, nonatomic) IBOutlet CircleTimer *timeCircle;

@property (weak, nonatomic) IBOutlet UIButton *btnStart;

@property(nonatomic, retain)NSMutableDictionary *dictPartData;

@property(nonatomic)int index;

@property(nonatomic)int arrCount;

@property(nonatomic)NSString *strModuleID;

- (IBAction)onPlayPauseClicked:(id)sender;

@property(nonatomic)int FlagModule;
@property(nonatomic)int ModuleCounts;

@property(nonatomic)int isAirPlaneReq;

@property (weak, nonatomic) IBOutlet UILabel *lblAirPlaneMsgtoParents;
@property (weak, nonatomic) IBOutlet UILabel *lblLiveTime;
@property (weak, nonatomic) IBOutlet UILabel *lblTotalTime;

@property (weak, nonatomic) IBOutlet UIImageView *BackGifImageView;

@property(nonatomic)NSString *strLevelCanOpen;

@end
