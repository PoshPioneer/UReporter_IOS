//
//  RecordAudioView.h
//  TOIAPP
//
//  Created by amit bahuguna on 7/29/14.
//  Copyright (c) 2014 CYNOTECK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface RecordAudioView : UIViewController<AVAudioRecorderDelegate, AVAudioPlayerDelegate>{
    
    BOOL check;
    BOOL checkForPlay;
    NSString *finalTime;
}

@property (strong, nonatomic) AVAudioRecorder *audioRecorder;
@property (strong, nonatomic) AVAudioPlayer *audioPlayer;



- (IBAction)back_Tapped:(id)sender;


- (IBAction)record_audio_btn:(id)sender;
- (IBAction)play_audio_btn:(id)sender;
- (IBAction)back_audio_view_btn:(id)sender;

@property(nonatomic,strong) NSString *final_Time_Recording;

@property(nonatomic,assign)int timerCountInt;
@property(nonatomic,strong)NSTimer *timer;
@property(nonatomic,strong)NSTimer *finalDoneTimer;
@property (weak, nonatomic) IBOutlet UILabel *lbl_selected_File_Outlet;
@property (weak, nonatomic) IBOutlet UILabel *lbl_record_outlet;
@property (weak, nonatomic) IBOutlet UILabel *lbl_finalPicker_Selected;
@property (weak, nonatomic) IBOutlet UIButton *cut_Sec;



@property (weak, nonatomic) IBOutlet UIButton *play_Audio_Outlet;
@property (weak, nonatomic) IBOutlet UIButton *start_End_Recording_Outlet;
@property (weak, nonatomic) IBOutlet UIButton *back_To_Home_Outlet;

- (IBAction)cancel_onSelected_File_Tapped:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *cancel_OnSelected_File_Outlet;
@property (weak, nonatomic) IBOutlet UIImageView *img_Outlet;

@property (weak, nonatomic) IBOutlet UILabel *record_Timer_Outlet;

@property (strong, nonatomic) IBOutlet UIView *darkLable;
@property (weak, nonatomic) IBOutlet UILabel *lightLabel;

- (IBAction)setting_Tapped:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *disable_EnableBack_Outlet;


//////////////////// shifting uppar screee.....
@property (weak, nonatomic) IBOutlet UILabel *uploadupppar_Lbl_outlet;
@property (weak, nonatomic) IBOutlet UIButton *setting_Outlet;


//////////////////// shifting uppar screee.....

@property (weak, nonatomic) IBOutlet UILabel *showTemperature;
- (IBAction)reset_Everything_Button:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *reset_Everything;


@end
