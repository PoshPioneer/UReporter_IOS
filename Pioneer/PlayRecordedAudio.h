//
//  PlayRecordedAudio.h
//  pioneer
//
//  Created by Cynoteck6 on 12/1/15.
//  Copyright (c) 2015 CYNOTECK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YMCAudioPlayer.h"

@interface PlayRecordedAudio : UIViewController{
    
    
}
@property (weak, nonatomic) IBOutlet UILabel *timeElapsed;
- (IBAction)btnStop:(id)sender;
@property (nonatomic, strong) YMCAudioPlayer *audioPlayer;
@property (weak, nonatomic) IBOutlet UIButton *playButton;

@property (strong, nonatomic) IBOutlet UIButton *btnStop;
- (IBAction)Back_AudioView_Tapped:(id)sender;
@property NSTimer *timer;
@property BOOL isPaused;
@property BOOL scrubbing;
@property (weak, nonatomic) IBOutlet UILabel *showTemperature;

@end
