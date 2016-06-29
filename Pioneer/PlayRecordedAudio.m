//
//  PlayRecordedAudio.m
//  pioneer
//
//  Created by Cynoteck6 on 12/1/15.
//  Copyright (c) 2015 CYNOTECK. All rights reserved.
//

#import "PlayRecordedAudio.h"
#import "AppDelegate.h"
#import "Submission.h"
#import "DataClass.h"



@interface PlayRecordedAudio (){
     NSURL *yourFileURL;
    AppDelegate *app;
    NSArray *reverseArray;
    NSString *finalTime;
    NSTimer *timerCheck;
    YMCAudioPlayer *obj;
    int maxValue;
    int currentValue;
    DataClass * objectDataClass;
    

}

@end

@implementation PlayRecordedAudio

@synthesize timeElapsed;
@synthesize btnStop;
@synthesize playButton;
#pragma mark - viewDidLoad

- (void)viewDidLoad {
    [super viewDidLoad];
    
    objectDataClass = [DataClass getInstance];
    
    // Do any additional setup after loading the view from its nib.
    app=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    reverseArray=[[NSArray alloc]init];
    reverseArray = [[app.myFinalArray reverseObjectEnumerator] allObjects];
    
    self.audioPlayer = [[YMCAudioPlayer alloc] init];
    [self setupAudioPlayer];
        [playButton setExclusiveTouch:YES];
    
   // audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:app.yourFileURL error:nil];
   // timerCheck = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(checkCategoryData) userInfo:nil repeats:YES];
    
 [self playAudioPressed];

}


/*
 * Setup the AudioPlayer with
 * Filename and FileExtension like mp3
 * Loading audioFile and sets the time Labels
 */
- (void)setupAudioPlayer
{
    //insert Filename & FileExtension
  //  NSString *fileExtension = @"caf";
    
    //init the Player to get file properties to set the time labels
    [self.audioPlayer initPlayer:app.yourFileURL];
    maxValue = [self.audioPlayer getAudioDuration];
    
    //init the current timedisplay and the labels. if a current time was stored
    //for this player then take it and update the time display
    self.timeElapsed.text = [NSString stringWithFormat:@"%@",
                             [self.audioPlayer timeFormat:[self.audioPlayer getAudioDuration]]];
    
    
   
    
}



-(void)checkCategoryData{
    
}




-(void)viewWillAppear:(BOOL)animated {

   // self.showTemperature.text = [NSString stringWithFormat:@"%0.0f", objectDataClass.temperature];
    
    
    DLog(@"Audio is playing...");
//    timerCheck = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(checkCategoryData) userInfo:nil repeats:YES];
    DLog(@"path of url is %@",app.yourFileURL);
    
    
    //[btnStop setBackgroundImage:[UIImage imageNamed:@"audio_stop_btn.png"] forState:UIControlStateNormal];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - IBAction

- (IBAction)Back_AudioView_Tapped:(id)sender {
    
    [self.audioPlayer pauseAudio];
    [self.navigationController popViewControllerAnimated:YES];
    
}




-(void)playAudioPressed{
    
    [self.timer invalidate];
    //play audio for the first time or if pause was pressed
    if (!self.isPaused) {
        [self.playButton setBackgroundImage:[UIImage imageNamed:@"icon01@2x.png"]
                                   forState:UIControlStateNormal];
       //start a timer to update the time label display
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                      target:self
                                                    selector:@selector(updateTime:)
                                                    userInfo:nil
                                                     repeats:YES];
        
        [self.audioPlayer playAudio];
        self.isPaused = TRUE;
        
    } else {

        //player is paused and Button is pressed again
        [self.playButton setBackgroundImage:[UIImage imageNamed:@"playimage01@2x.png"]
                                   forState:UIControlStateNormal];
        
        [self.audioPlayer pauseAudio];
        self.isPaused = FALSE;
    }
    

    
}


- (IBAction)btnStop:(id)sender {
    [self playAudioPressed];
}

/*
 * Updates the time label display and
 * the current value of the slider
 * while audio is playing
 */
- (void)updateTime:(NSTimer *)timer {
    //to don't update every second. When scrubber is mouseDown the the slider will not set
    if (!self.scrubbing) {
        currentValue = [self.audioPlayer getCurrentAudioTime];
    }
    self.timeElapsed.text = [NSString stringWithFormat:@"%@",
                                 [self.audioPlayer timeFormat:[self.audioPlayer getAudioDuration] - [self.audioPlayer getCurrentAudioTime]]];
    
   // self.duration.text = [NSString stringWithFormat:@"-%@",
                     //     [self.audioPlayer timeFormat:[self.audioPlayer getAudioDuration] - [self.audioPlayer getCurrentAudioTime]]];
    
    //When resetted/ended reset the playButton
    if (![self.audioPlayer isPlaying]) {
        [self.playButton setBackgroundImage:[UIImage imageNamed:@"playimage01@2x.png"]
                                   forState:UIControlStateNormal];
        [self.audioPlayer pauseAudio];
        self.isPaused = FALSE;
    }
}

/*
 * Sets the current value of the slider/scrubber
 * to the audio file when slider/scrubber is used
 */
- (IBAction)setCurrentTime:(id)scrubber {
    //if scrubbing update the timestate, call updateTime faster not to wait a second and dont repeat it
    [NSTimer scheduledTimerWithTimeInterval:0.01
                                     target:self
                                   selector:@selector(updateTime:)
                                   userInfo:nil
                                    repeats:NO];
    
    [self.audioPlayer setCurrentAudioTime:currentValue];
    self.scrubbing = FALSE;
}

/*
 * Sets if the user is scrubbing right now
 * to avoid slider update while dragging the slider
 */
- (IBAction)userIsScrubbing:(id)sender {
    self.scrubbing = TRUE;
}




@end
